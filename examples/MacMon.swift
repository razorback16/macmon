import Foundation

// MARK: - Data Structures

struct MacMonSocInfo: Codable {
    let macModel: String
    let chipName: String
    let memoryGb: UInt8
    let ecpuCores: UInt8
    let pcpuCores: UInt8
    let ecpuFreqs: [UInt32]
    let pcpuFreqs: [UInt32]
    let gpuCores: UInt8
    let gpuFreqs: [UInt32]
    
    enum CodingKeys: String, CodingKey {
        case macModel = "mac_model"
        case chipName = "chip_name"
        case memoryGb = "memory_gb"
        case ecpuCores = "ecpu_cores"
        case pcpuCores = "pcpu_cores"
        case ecpuFreqs = "ecpu_freqs"
        case pcpuFreqs = "pcpu_freqs"
        case gpuCores = "gpu_cores"
        case gpuFreqs = "gpu_freqs"
    }
}

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

private struct SocInfo {
    var mac_model: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                   UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                   UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                   UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                   UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                   UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                   UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                   UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
    var chip_name: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                   UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                   UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                   UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                   UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                   UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                   UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8,
                   UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
    var memory_gb: UInt8
    var ecpu_cores: UInt8
    var pcpu_cores: UInt8
    var ecpu_freqs: (UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
                    UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
                    UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
                    UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32)
    var pcpu_freqs: (UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
                    UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
                    UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
                    UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32)
    var gpu_cores: UInt8
    var gpu_freqs: (UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
                   UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
                   UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
                   UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32)
    var ecpu_freqs_count: UInt8
    var pcpu_freqs_count: UInt8
    var gpu_freqs_count: UInt8
}

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
    private typealias GetSocInfoFunc = @convention(c) () -> OpaquePointer?
    private typealias SocInfoFreeFunc = @convention(c) (OpaquePointer?) -> Void
    
    private var sampler_new: SamplerNewFunc?
    private var sampler_get_metrics: SamplerGetMetricsFunc?
    private var sampler_free: SamplerFreeFunc?
    private var metrics_free: MetricsFreeFunc?
    private var get_soc_info: GetSocInfoFunc?
    private var soc_info_free: SocInfoFreeFunc?
    
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
              let metrics_free_ptr = dlsym(handle, "metrics_free"),
              let get_soc_info_ptr = dlsym(handle, "get_soc_info"),
              let soc_info_free_ptr = dlsym(handle, "soc_info_free") else {
            dlclose(handle)
            throw NSError(domain: "MacMon", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to load functions from libmacmon.dylib"])
        }
        
        // Create function references
        sampler_new = unsafeBitCast(sampler_new_ptr, to: SamplerNewFunc.self)
        sampler_get_metrics = unsafeBitCast(sampler_get_metrics_ptr, to: SamplerGetMetricsFunc.self)
        sampler_free = unsafeBitCast(sampler_free_ptr, to: SamplerFreeFunc.self)
        metrics_free = unsafeBitCast(metrics_free_ptr, to: MetricsFreeFunc.self)
        get_soc_info = unsafeBitCast(get_soc_info_ptr, to: GetSocInfoFunc.self)
        soc_info_free = unsafeBitCast(soc_info_free_ptr, to: SocInfoFreeFunc.self)
        
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
    
    func getSocInfo() throws -> MacMonSocInfo {
        guard let get_soc_info = get_soc_info,
              let soc_info_free = soc_info_free,
              let infoPtr = get_soc_info() else {
            throw NSError(domain: "MacMon", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to get SOC info"])
        }
        
        // Get info and convert to our format
        let info = UnsafeMutablePointer<SocInfo>(infoPtr).pointee
        
        // Convert C strings to Swift strings
        let macModel = withUnsafeBytes(of: info.mac_model) { ptr -> String in
            let buf = ptr.bindMemory(to: UInt8.self)
            return String(bytes: buf.prefix(while: { $0 != 0 }), encoding: .utf8) ?? ""
        }
        
        let chipName = withUnsafeBytes(of: info.chip_name) { ptr -> String in
            let buf = ptr.bindMemory(to: UInt8.self)
            return String(bytes: buf.prefix(while: { $0 != 0 }), encoding: .utf8) ?? ""
        }
        
        // Convert frequency tuples to arrays
        let ecpuFreqs = withUnsafeBytes(of: info.ecpu_freqs) { ptr -> [UInt32] in
            Array(ptr.bindMemory(to: UInt32.self)[..<Int(info.ecpu_freqs_count)])
        }
        
        let pcpuFreqs = withUnsafeBytes(of: info.pcpu_freqs) { ptr -> [UInt32] in
            Array(ptr.bindMemory(to: UInt32.self)[..<Int(info.pcpu_freqs_count)])
        }
        
        let gpuFreqs = withUnsafeBytes(of: info.gpu_freqs) { ptr -> [UInt32] in
            Array(ptr.bindMemory(to: UInt32.self)[..<Int(info.gpu_freqs_count)])
        }
        
        // Create our Codable struct
        let result = MacMonSocInfo(
            macModel: macModel,
            chipName: chipName,
            memoryGb: info.memory_gb,
            ecpuCores: info.ecpu_cores,
            pcpuCores: info.pcpu_cores,
            ecpuFreqs: Array(ecpuFreqs),
            pcpuFreqs: Array(pcpuFreqs),
            gpuCores: info.gpu_cores,
            gpuFreqs: Array(gpuFreqs)
        )
        
        // Free the info
        soc_info_free(infoPtr)
        
        return result
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
