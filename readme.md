# `macmon` – Mac Metrics Monitor Library

<div align="center">

Sudoless performance monitoring library for Apple Silicon processors.

[<img src="https://badgen.net/github/license/vladkens/macmon" />](https://github.com/vladkens/macmon/blob/main/LICENSE)

</div>

## Motivation

Apple Silicon processors don't provide an easy way to see live power consumption. This library uses a private macOS API to gather metrics (essentially the same as `powermetrics`) but runs without sudo privileges. 🎉

## 🌟 Features

- 🚫 Works without sudo
- ⚡ Real-time CPU / GPU / ANE power usage
- 📊 CPU utilization per cluster
- 💾 RAM / Swap usage
- 🌡️ CPU / GPU temperature monitoring
- 🦀 Written in Rust with Swift and C bindings

## 📦 Installation

1. Clone the repo:
```sh
git clone https://github.com/razorback16/macmon.git && cd macmon
```

2. Build the library:
```sh
cargo build --release
```

## 🚀 Usage

### Swift

```swift
import Foundation

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
```

### C

```c
#include <stdio.h>
#include "macmon.h"

int main() {
    // Create a new sampler
    void *sampler = sampler_new();
    if (!sampler) {
        printf("Failed to create sampler\n");
        return 1;
    }

    // Get metrics
    Metrics *metrics = sampler_get_metrics(sampler);
    if (!metrics) {
        printf("Failed to get metrics\n");
        sampler_free(sampler);
        return 1;
    }

    // Access metrics
    printf("CPU Temperature: %.2f°C\n", metrics->temp.cpu_temp_avg);
    printf("GPU Temperature: %.2f°C\n", metrics->temp.gpu_temp_avg);
    printf("CPU Power: %.2f W\n", metrics->cpu_power);
    printf("GPU Power: %.2f W\n", metrics->gpu_power);

    // Cleanup
    metrics_free(metrics);
    sampler_free(sampler);

    return 0;
}
```

## 📊 Metrics Structure

The library provides the following metrics:

```jsonc
{
  "temp": {
    "cpu_temp_avg": 43.73614,         // Celsius
    "gpu_temp_avg": 36.95167          // Celsius
  },
  "memory": {
    "ram_total": 25769803776,         // Bytes
    "ram_usage": 20985479168,         // Bytes
    "swap_total": 4294967296,         // Bytes
    "swap_usage": 2602434560          // Bytes
  },
  "ecpu_usage": [1181, 0.082656614],  // (Frequency MHz, Usage %)
  "pcpu_usage": [1974, 0.015181795],  // (Frequency MHz, Usage %)
  "gpu_usage": [461, 0.021497859],    // (Frequency MHz, Usage %)
  "cpu_power": 0.20486385,            // Watts
  "gpu_power": 0.017451683,           // Watts
  "ane_power": 0.0,                   // Watts
  "all_power": 0.22231553,            // Watts
  "sys_power": 5.876533,              // Watts
  "ram_power": 0.11635789,            // Watts
  "gpu_ram_power": 0.0009615385       // Watts
}
```

## 🤝 Contributing
We love contributions! Whether you have ideas, suggestions, or bug reports, feel free to open an issue or submit a pull request.

## 📝 License
`macmon` is distributed under the MIT License. See LICENSE for more details.

## 🔍 See also
- [vladkens/macmon](https://github.com/vladkens/macmon) – The main project from which it's forked
- [tlkh/asitop](https://github.com/tlkh/asitop) – Performance monitoring tool written in Python
- [dehydratedpotato/socpowerbud](https://github.com/dehydratedpotato/socpowerbud) – ObjectiveC performance monitor
- [op06072/NeoAsitop](https://github.com/op06072/NeoAsitop) – Performance monitor written in Swift
- [graelo/pumas](https://github.com/graelo/pumas) – Performance monitor written in Rust
- [context-labs/mactop](https://github.com/context-labs/mactop) – Performance monitor written in Go
