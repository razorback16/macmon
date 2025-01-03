import Foundation

@main
struct MacMonExample {
    static func main() throws {
        // Create MacMon instance
        let monitor = try MacMon()
        
        // Get SOC info and metrics
        let socInfo = try monitor.getSocInfo()
        let metrics = try monitor.getMetrics()
        
        // Create combined output structure
        struct Output: Codable {
            let soc: MacMonSocInfo
            let metrics: MacMonMetrics
        }
        
        let output = Output(soc: socInfo, metrics: metrics)
        
        // Convert to JSON and print
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        
        if let jsonData = try? encoder.encode(output),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
        }
    }
}
