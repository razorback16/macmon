import Foundation

@main
struct MacMonExample {
    static func main() throws {
        // Create MacMon instance
        let monitor = try MacMon()
        
        // Get metrics
        let metrics = try monitor.getMetrics()
        
        // Convert to JSON and print
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        
        if let jsonData = try? encoder.encode(metrics),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
        }
    }
}
