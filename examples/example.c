#include <stdio.h>
#include <unistd.h>
#include "macmon.h"

int main()
{
    // Create a new sampler
    void *sampler = sampler_new();
    if (!sampler)
    {
        printf("Failed to create sampler\n");
        return 1;
    }

    // Get metrics
    Metrics *metrics = sampler_get_metrics(sampler);
    if (!metrics)
    {
        printf("Failed to get metrics\n");
        sampler_free(sampler);
        return 1;
    }

    // Print metrics
    printf("CPU Temperature: %.2f°C\n", metrics->temp.cpu_temp_avg);
    printf("GPU Temperature: %.2f°C\n", metrics->temp.gpu_temp_avg);

    printf("\nMemory:\n");
    printf("RAM Usage: %.2f GB / %.2f GB\n",
           metrics->memory.ram_usage / 1024.0 / 1024.0 / 1024.0,
           metrics->memory.ram_total / 1024.0 / 1024.0 / 1024.0);
    printf("Swap Usage: %.2f GB / %.2f GB\n",
           metrics->memory.swap_usage / 1024.0 / 1024.0 / 1024.0,
           metrics->memory.swap_total / 1024.0 / 1024.0 / 1024.0);

    printf("\nCPU Usage:\n");
    printf("E-Core: %u MHz (%.2f%%)\n",
           metrics->ecpu_usage.frequency,
           metrics->ecpu_usage.usage * 100.0);
    printf("P-Core: %u MHz (%.2f%%)\n",
           metrics->pcpu_usage.frequency,
           metrics->pcpu_usage.usage * 100.0);

    printf("\nGPU Usage: %u MHz (%.2f%%)\n",
           metrics->gpu_usage.frequency,
           metrics->gpu_usage.usage * 100.0);

    printf("\nPower Usage:\n");
    printf("CPU: %.2f W\n", metrics->cpu_power);
    printf("GPU: %.2f W\n", metrics->gpu_power);
    printf("ANE: %.2f W\n", metrics->ane_power);
    printf("RAM: %.2f W\n", metrics->ram_power);
    printf("GPU RAM: %.2f W\n", metrics->gpu_ram_power);
    printf("Total: %.2f W\n", metrics->all_power);
    printf("System: %.2f W\n", metrics->sys_power);

    // Cleanup
    metrics_free(metrics);
    sampler_free(sampler);

    return 0;
}
