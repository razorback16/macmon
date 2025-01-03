use std::ffi::c_void;
mod metrics;
mod sources;

#[repr(C)]
pub struct SocInfo {
  pub mac_model: [u8; 64], // Fixed size buffer for C string
  pub chip_name: [u8; 64], // Fixed size buffer for C string
  pub memory_gb: u8,
  pub ecpu_cores: u8,
  pub pcpu_cores: u8,
  pub ecpu_freqs: [u32; 32], // Fixed size array for frequencies
  pub pcpu_freqs: [u32; 32],
  pub gpu_cores: u8,
  pub gpu_freqs: [u32; 32],
  pub ecpu_freqs_count: u8, // Actual number of frequencies
  pub pcpu_freqs_count: u8,
  pub gpu_freqs_count: u8,
}

#[repr(C)]
pub struct Temperature {
  cpu_temp_avg: f32,
  gpu_temp_avg: f32,
}

#[repr(C)]
pub struct Memory {
  ram_total: u64,
  ram_usage: u64,
  swap_total: u64,
  swap_usage: u64,
}

#[repr(C)]
pub struct Usage {
  frequency: u32,
  usage: f32,
}

#[repr(C)]
pub struct Metrics {
  temp: Temperature,
  memory: Memory,
  ecpu_usage: Usage,
  pcpu_usage: Usage,
  gpu_usage: Usage,
  cpu_power: f32,
  gpu_power: f32,
  ane_power: f32,
  all_power: f32,
  sys_power: f32,
  ram_power: f32,
  gpu_ram_power: f32,
}

pub struct Sampler {
  inner: metrics::Sampler,
}

impl Sampler {
  pub fn new() -> Result<Self, Box<dyn std::error::Error>> {
    Ok(Self { inner: metrics::Sampler::new()? })
  }

  pub fn get_metrics(&mut self) -> Result<Metrics, Box<dyn std::error::Error>> {
    let metrics = self.inner.get_metrics(500)?;

    Ok(Metrics {
      temp: Temperature {
        cpu_temp_avg: metrics.temp.cpu_temp_avg,
        gpu_temp_avg: metrics.temp.gpu_temp_avg,
      },
      memory: Memory {
        ram_total: metrics.memory.ram_total,
        ram_usage: metrics.memory.ram_usage,
        swap_total: metrics.memory.swap_total,
        swap_usage: metrics.memory.swap_usage,
      },
      ecpu_usage: Usage { frequency: metrics.ecpu_usage.0, usage: metrics.ecpu_usage.1 },
      pcpu_usage: Usage { frequency: metrics.pcpu_usage.0, usage: metrics.pcpu_usage.1 },
      gpu_usage: Usage { frequency: metrics.gpu_usage.0, usage: metrics.gpu_usage.1 },
      cpu_power: metrics.cpu_power,
      gpu_power: metrics.gpu_power,
      ane_power: metrics.ane_power,
      all_power: metrics.all_power,
      sys_power: metrics.sys_power,
      ram_power: metrics.ram_power,
      gpu_ram_power: metrics.gpu_ram_power,
    })
  }
}

// FFI exports
#[no_mangle]
pub extern "C" fn sampler_new() -> *mut c_void {
  match Sampler::new() {
    Ok(sampler) => Box::into_raw(Box::new(sampler)) as *mut c_void,
    Err(_) => std::ptr::null_mut(),
  }
}

#[no_mangle]
pub extern "C" fn sampler_get_metrics(sampler: *mut c_void) -> *mut Metrics {
  if sampler.is_null() {
    return std::ptr::null_mut();
  }

  let sampler = unsafe { &mut *(sampler as *mut Sampler) };
  match sampler.get_metrics() {
    Ok(metrics) => Box::into_raw(Box::new(metrics)),
    Err(_) => std::ptr::null_mut(),
  }
}

#[no_mangle]
pub extern "C" fn sampler_free(sampler: *mut c_void) {
  if !sampler.is_null() {
    unsafe {
      drop(Box::from_raw(sampler as *mut Sampler));
    }
  }
}

#[no_mangle]
pub extern "C" fn metrics_free(metrics: *mut Metrics) {
  if !metrics.is_null() {
    unsafe {
      drop(Box::from_raw(metrics));
    }
  }
}

#[no_mangle]
pub extern "C" fn get_soc_info() -> *mut SocInfo {
  match sources::get_soc_info() {
    Ok(src_info) => {
      let mut info = Box::new(SocInfo {
        mac_model: [0; 64],
        chip_name: [0; 64],
        memory_gb: src_info.memory_gb,
        ecpu_cores: src_info.ecpu_cores,
        pcpu_cores: src_info.pcpu_cores,
        ecpu_freqs: [0; 32],
        pcpu_freqs: [0; 32],
        gpu_cores: src_info.gpu_cores,
        gpu_freqs: [0; 32],
        ecpu_freqs_count: src_info.ecpu_freqs.len() as u8,
        pcpu_freqs_count: src_info.pcpu_freqs.len() as u8,
        gpu_freqs_count: src_info.gpu_freqs.len() as u8,
      });

      // Copy strings with truncation if needed
      let mac_model = src_info.mac_model.as_bytes();
      let chip_name = src_info.chip_name.as_bytes();
      info.mac_model[..mac_model.len().min(63)]
        .copy_from_slice(&mac_model[..mac_model.len().min(63)]);
      info.chip_name[..chip_name.len().min(63)]
        .copy_from_slice(&chip_name[..chip_name.len().min(63)]);

      // Copy frequency arrays
      info.ecpu_freqs[..src_info.ecpu_freqs.len().min(32)]
        .copy_from_slice(&src_info.ecpu_freqs[..src_info.ecpu_freqs.len().min(32)]);
      info.pcpu_freqs[..src_info.pcpu_freqs.len().min(32)]
        .copy_from_slice(&src_info.pcpu_freqs[..src_info.pcpu_freqs.len().min(32)]);
      info.gpu_freqs[..src_info.gpu_freqs.len().min(32)]
        .copy_from_slice(&src_info.gpu_freqs[..src_info.gpu_freqs.len().min(32)]);

      Box::into_raw(info)
    }
    Err(_) => std::ptr::null_mut(),
  }
}

#[no_mangle]
pub extern "C" fn soc_info_free(info: *mut SocInfo) {
  if !info.is_null() {
    unsafe {
      drop(Box::from_raw(info));
    }
  }
}
