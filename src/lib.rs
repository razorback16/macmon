use std::ffi::c_void;
mod metrics;
mod sources;

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
