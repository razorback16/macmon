import Foundation

// MARK: - Data Structures

struct MacMonTemp: Codable {
    let cpuTempAvg: Float
    let gpuTempAvg: Float
    
    enum CodingKeys: String, CodingKey {
        case cpuTempAvg = "cpu_temp_avg"
        case gpuTempAvg = "gpu_temp_avg"
    }
}

struct MacMonMemory: Codable {
    let ramTotal: UInt64
    let ramUsage: UInt64
    let swapTotal: UInt64
    let swapUsage: UInt64
    
    enum CodingKeys: String, CodingKey {
        case ramTotal = "ram_total"
        case ramUsage = "ram_usage"
        case swapTotal = "swap_total"
        case swapUsage = "swap_usage"
    }
}

struct MacMonMetrics: Codable {
    let temp: MacMonTemp
    let memory: MacMonMemory
    let ecpuUsage: [Double]
    let pcpuUsage: [Double]
    let gpuUsage: [Double]
    let cpuPower: Float
    let gpuPower: Float
    let anePower: Float
    let allPower: Float
    let sysPower: Float
    let ramPower: Float
    let gpuRamPower: Float
    
    enum CodingKeys: String, CodingKey {
        case temp
        case memory
        case ecpuUsage = "ecpu_usage"
        case pcpuUsage = "pcpu_usage"
        case gpuUsage = "gpu_usage"
        case cpuPower = "cpu_power"
        case gpuPower = "gpu_power"
        case anePower = "ane_power"
        case allPower = "all_power"
        case sysPower = "sys_power"
        case ramPower = "ram_power"
        case gpuRamPower = "gpu_ram_power"
    }
}

// MARK: - Internal C Structs

private struct Temperature {
    var cpu_temp_avg: Float
    var gpu_temp_avg: Float
}

private struct Memory {
    var ram_total: UInt64
    var ram_usage: UInt64
    var swap_total: UInt64
    var swap_usage: UInt64
}

private struct Usage {
    var frequency: UInt32
    var usage: Float
}

private struct Metrics {
    var temp: Temperature
    var memory: Memory
    var ecpu_usage: Usage
    var pcpu_usage: Usage
    var gpu_usage: Usage
    var cpu_power: Float
    var gpu_power: Float
    var ane_power: Float
    var all_power: Float
    var sys_power: Float
    var ram_power: Float
    var gpu_ram_power: Float
}

// MARK: - MacMon Class

class MacMon {
    private var handle: UnsafeMutableRawPointer?
    private var sampler: OpaquePointer?
    
    private typealias SamplerNewFunc = @convention(c) () -> OpaquePointer?
    private typealias SamplerGetMetricsFunc = @convention(c) (OpaquePointer?) -> OpaquePointer?
    private typealias SamplerFreeFunc = @convention(c) (OpaquePointer?) -> Void
    private typealias MetricsFreeFunc = @convention(c) (OpaquePointer?) -> Void
    
    private var sampler_new: SamplerNewFunc?
    private var sampler_get_metrics: SamplerGetMetricsFunc?
    private var sampler_free: SamplerFreeFunc?
    private var metrics_free: MetricsFreeFunc?
    
    init() throws {
        // Load the dylib
        let RTLD_NOW = Int32(0x2)
        // Try to load from different possible locations
        let possiblePaths = [
            "libmacmon.dylib",                    // Current directory
            "@executable_path/libmacmon.dylib",   // Next to executable
            "@loader_path/libmacmon.dylib"        // Relative to this code
        ]
        
        var loadedHandle: UnsafeMutableRawPointer? = nil
        var loadError = ""
        
        for path in possiblePaths {
            if let handle = dlopen(path, RTLD_NOW) {
                loadedHandle = handle
                break
            }
            loadError += "\nTried \(path): \(String(cString: dlerror()))"
        }
        
        guard let handle = loadedHandle else {
            throw NSError(domain: "MacMon", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to load libmacmon.dylib"])
        }
        self.handle = handle
        
        // Get function pointers
        guard let sampler_new_ptr = dlsym(handle, "sampler_new"),
              let sampler_get_metrics_ptr = dlsym(handle, "sampler_get_metrics"),
              let sampler_free_ptr = dlsym(handle, "sampler_free"),
              let metrics_free_ptr = dlsym(handle, "metrics_free") else {
            dlclose(handle)
            throw NSError(domain: "MacMon", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to load functions from libmacmon.dylib"])
        }
        
        // Create function references
        sampler_new = unsafeBitCast(sampler_new_ptr, to: SamplerNewFunc.self)
        sampler_get_metrics = unsafeBitCast(sampler_get_metrics_ptr, to: SamplerGetMetricsFunc.self)
        sampler_free = unsafeBitCast(sampler_free_ptr, to: SamplerFreeFunc.self)
        metrics_free = unsafeBitCast(metrics_free_ptr, to: MetricsFreeFunc.self)
        
        // Create sampler
        guard let sampler = sampler_new?() else {
            dlclose(handle)
            throw NSError(domain: "MacMon", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to create sampler"])
        }
        self.sampler = sampler
    }
    
    deinit {
        if let sampler = sampler {
            sampler_free?(sampler)
        }
        if let handle = handle {
            dlclose(handle)
        }
    }
    
    func getMetrics() throws -> MacMonMetrics {
        guard let sampler = sampler,
              let metricsPtr = sampler_get_metrics?(sampler) else {
            throw NSError(domain: "MacMon", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to get metrics"])
        }
        
        // Get metrics and convert to our format
        let metrics = UnsafeMutablePointer<Metrics>(metricsPtr).pointee
        
        // Create our Codable struct
        let result = MacMonMetrics(
            temp: MacMonTemp(
                cpuTempAvg: metrics.temp.cpu_temp_avg,
                gpuTempAvg: metrics.temp.gpu_temp_avg
            ),
            memory: MacMonMemory(
                ramTotal: metrics.memory.ram_total,
                ramUsage: metrics.memory.ram_usage,
                swapTotal: metrics.memory.swap_total,
                swapUsage: metrics.memory.swap_usage
            ),
            ecpuUsage: [Double(metrics.ecpu_usage.frequency), Double(metrics.ecpu_usage.usage)],
            pcpuUsage: [Double(metrics.pcpu_usage.frequency), Double(metrics.pcpu_usage.usage)],
            gpuUsage: [Double(metrics.gpu_usage.frequency), Double(metrics.gpu_usage.usage)],
            cpuPower: metrics.cpu_power,
            gpuPower: metrics.gpu_power,
            anePower: metrics.ane_power,
            allPower: metrics.all_power,
            sysPower: metrics.sys_power,
            ramPower: metrics.ram_power,
            gpuRamPower: metrics.gpu_ram_power
        )
        
        // Free the metrics
        metrics_free?(metricsPtr)
        
        return result
    }
}
