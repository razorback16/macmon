#ifndef MACMON_H
#define MACMON_H

#include <stdint.h>

#ifdef __cplusplus
extern "C"
{
#endif

    typedef struct
    {
        uint8_t mac_model[64]; // Fixed size buffer for C string
        uint8_t chip_name[64]; // Fixed size buffer for C string
        uint8_t memory_gb;
        uint8_t ecpu_cores;
        uint8_t pcpu_cores;
        uint32_t ecpu_freqs[32]; // Fixed size array for frequencies
        uint32_t pcpu_freqs[32];
        uint8_t gpu_cores;
        uint32_t gpu_freqs[32];
        uint8_t ecpu_freqs_count; // Actual number of frequencies
        uint8_t pcpu_freqs_count;
        uint8_t gpu_freqs_count;
    } SocInfo;

    typedef struct
    {
        float cpu_temp_avg;
        float gpu_temp_avg;
    } Temperature;

    typedef struct
    {
        uint64_t ram_total;
        uint64_t ram_usage;
        uint64_t swap_total;
        uint64_t swap_usage;
    } Memory;

    typedef struct
    {
        uint32_t frequency;
        float usage;
    } Usage;

    typedef struct
    {
        Temperature temp;
        Memory memory;
        Usage ecpu_usage;
        Usage pcpu_usage;
        Usage gpu_usage;
        float cpu_power;
        float gpu_power;
        float ane_power;
        float all_power;
        float sys_power;
        float ram_power;
        float gpu_ram_power;
    } Metrics;

    // Create a new sampler instance
    void *sampler_new(void);

    // Get metrics from the sampler
    // Returns NULL on error
    Metrics *sampler_get_metrics(void *sampler);

    // Free the sampler instance
    void sampler_free(void *sampler);

    // Free the metrics instance
    void metrics_free(Metrics *metrics);

    // Get SOC information
    SocInfo *get_soc_info(void);

    // Free the SOC information
    void soc_info_free(SocInfo *info);

#ifdef __cplusplus
}
#endif

#endif // MACMON_H
