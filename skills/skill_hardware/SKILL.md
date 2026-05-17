---
name: "skill_hardware"
description: "Apply hardware engineering capabilities for HAL development, resource-constrained optimization, and hardware integration. Invoke when working with embedded systems, hardware abstraction layers, or IoT devices."
---

# Hardware Engineering Skill

## 核心定义
负责硬件抽象层(HAL)、资源受限优化及第三方硬件集成，确保软件与硬件的高效协同。

## 技能能力
- **HAL/驱动适配器**：资源受限环境优化、内存池管理、低功耗设计、RTOS开发
- **集成评估**：第三方组件兼容性、认证支持、故障注入测试
- **数据流管理**：传感器数据实时处理、执行器控制、固件OTA安全

## 执行流程
1. **硬件分析**：了解硬件规格、接口、限制
2. **HAL设计**：抽象硬件接口，定义驱动API
3. **驱动开发**：实现硬件初始化、读写、中断处理
4. **资源优化**：内存管理、功耗优化、性能调优
5. **集成测试**：硬件在环测试、故障注入
6. **OTA支持**：固件升级、回滚机制、安全验证

## 实践要点
1. **资源受限意识**：内存、CPU、功耗都是稀缺资源
2. **实时性保证**：关键操作必须有确定性的响应时间
3. **容错设计**：硬件故障是常态，软件需容错
4. **低功耗优先**：移动/IoT设备功耗是关键指标
5. **安全启动**：固件安全从启动开始

## 使用示例

### 示例 1：传感器HAL设计

**场景**：设计支持多种传感器的硬件抽象层

```c
// sensor_hal.h - 传感器硬件抽象层接口
#ifndef SENSOR_HAL_H
#define SENSOR_HAL_H

#include <stdint.h>
#include <stdbool.h>

typedef enum {
    SENSOR_OK = 0,
    SENSOR_ERROR_INIT = -1,
    SENSOR_ERROR_READ = -2,
    SENSOR_ERROR_TIMEOUT = -3,
} sensor_error_t;

typedef enum {
    SENSOR_TYPE_TEMPERATURE,
    SENSOR_TYPE_HUMIDITY,
    SENSOR_TYPE_PRESSURE,
} sensor_type_t;

typedef struct {
    float values[3];
    uint32_t timestamp_ms;
} sensor_data_t;

// 驱动接口
typedef struct {
    const char *name;
    sensor_type_t type;
    sensor_error_t (*init)(void);
    sensor_error_t (*read)(sensor_data_t *data);
    sensor_error_t (*sleep)(void);
    uint32_t power_consumption_uw;
} sensor_driver_t;

// HAL管理器
sensor_error_t sensor_hal_init(void);
sensor_error_t sensor_hal_register(const sensor_driver_t *driver);
sensor_error_t sensor_hal_read(sensor_type_t type, sensor_data_t *data);

#endif
```

```c
// sensor_hal.c - HAL实现
#include "sensor_hal.h"
#include <string.h>

#define MAX_SENSORS 8

static struct {
    const sensor_driver_t *drivers[MAX_SENSORS];
    uint8_t count;
    bool initialized;
} hal_context;

sensor_error_t sensor_hal_init(void) {
    memset(&hal_context, 0, sizeof(hal_context));
    hal_context.initialized = true;
    return SENSOR_OK;
}

sensor_error_t sensor_hal_register(const sensor_driver_t *driver) {
    if (!hal_context.initialized) return SENSOR_ERROR_INIT;
    if (hal_context.count >= MAX_SENSORS) return SENSOR_ERROR_INIT;
    
    hal_context.drivers[hal_context.count++] = driver;
    return SENSOR_OK;
}

sensor_error_t sensor_hal_read(sensor_type_t type, sensor_data_t *data) {
    if (!hal_context.initialized || !data) return SENSOR_ERROR_INIT;
    
    for (uint8_t i = 0; i < hal_context.count; i++) {
        if (hal_context.drivers[i]->type == type) {
            return hal_context.drivers[i]->read(data);
        }
    }
    return SENSOR_ERROR_READ;
}
```

### 示例 2：低功耗设计

**场景**：设计电池供电设备的功耗管理策略

```c
// power_manager.h
typedef enum {
    POWER_MODE_ACTIVE,      // 全速运行
    POWER_MODE_SLEEP,       // CPU睡眠
    POWER_MODE_DEEP_SLEEP,  // 大部分外设关闭
    POWER_MODE_HIBERNATE    // 仅保留RAM
} power_mode_t;

typedef struct {
    power_mode_t current_mode;
    uint32_t sleep_duration_ms;
} power_manager_t;

// 实现
void power_manager_enter_mode(power_manager_t *pm, power_mode_t mode) {
    switch (mode) {
        case POWER_MODE_ACTIVE:
            system_clock_config(48000000);
            peripheral_enable(PERIPH_ALL);
            break;
            
        case POWER_MODE_SLEEP:
            peripheral_disable(PERIPH_UART | PERIPH_SPI);
            rtc_set_wakeup(pm->sleep_duration_ms);
            __WFI();  // Wait For Interrupt
            break;
            
        case POWER_MODE_DEEP_SLEEP:
            peripheral_disable(PERIPH_ALL);
            peripheral_enable(PERIPH_RTC);
            enter_stop_mode();
            break;
    }
    pm->current_mode = mode;
}

// 应用场景：传感器数据采集
void sensor_task(power_manager_t *pm) {
    while (1) {
        // 唤醒，读取传感器
        power_manager_enter_mode(pm, POWER_MODE_ACTIVE);
        sensor_data_t data;
        sensor_hal_read(SENSOR_TYPE_TEMPERATURE, &data);
        
        // 处理并发送
        process_sensor_data(&data);
        if (should_transmit()) transmit_data(&data);
        
        // 进入低功耗模式
        power_manager_enter_mode(pm, POWER_MODE_DEEP_SLEEP);
    }
}
```

### 示例 3：传感器数据读取与校验

**场景**：安全地读取传感器数据并进行校验

```c
// 反例：不安全的传感器读取
void read_sensors_unsafe() {
    char buffer[100];
    int temp = read_temperature();  // 未检查错误
    int hum = read_humidity();      // 未检查错误
    sprintf(buffer, "Temp:%d,Hum:%d", temp, hum);  // 栈使用过大
    uart_send(buffer);
}

// 正确做法：安全的传感器读取
static char tx_buffer[128];  // 静态分配

typedef struct {
    int16_t temperature;
    int16_t humidity;
    bool valid;
} sensor_reading_t;

sensor_error_t read_sensors_safe(sensor_reading_t *reading) {
    // 1. 上电传感器
    sensor_power_on(SENSOR_TEMP_HUM);
    delay_ms(10);
    
    // 2. 读取温度并校验
    int16_t temp;
    sensor_error_t err = sensor_read_temperature(&temp);
    if (err != SENSOR_OK) {
        sensor_power_off(SENSOR_TEMP_HUM);
        return err;
    }
    
    // 3. 数据范围校验
    if (temp < -400 || temp > 850) {  // -40.0 to 85.0 Celsius
        sensor_power_off(SENSOR_TEMP_HUM);
        return SENSOR_ERROR_READ;
    }
    reading->temperature = temp;
    
    // 4. 读取湿度并校验
    int16_t hum;
    err = sensor_read_humidity(&hum);
    if (err != SENSOR_OK) {
        sensor_power_off(SENSOR_TEMP_HUM);
        return err;
    }
    
    if (hum < 0 || hum > 1000) {
        sensor_power_off(SENSOR_TEMP_HUM);
        return SENSOR_ERROR_READ;
    }
    reading->humidity = hum / 10;
    reading->valid = true;
    
    // 5. 关闭传感器（低功耗）
    sensor_power_off(SENSOR_TEMP_HUM);
    
    return SENSOR_OK;
}
```

### 示例 4：OTA固件升级

**场景**：实现安全的固件OTA升级机制

```c
// ota_manager.h
typedef enum {
    OTA_OK = 0,
    OTA_ERROR_VERIFY = -1,
    OTA_ERROR_WRITE = -2,
    OTA_ERROR_ROLLBACK = -3,
} ota_error_t;

// OTA实现
ota_error_t ota_update(const uint8_t *firmware_data, size_t size, 
                       const uint8_t *signature) {
    // 1. 验证签名
    if (!verify_signature(firmware_data, size, signature)) {
        return OTA_ERROR_VERIFY;
    }
    
    // 2. 验证固件格式
    if (!verify_firmware_header(firmware_data)) {
        return OTA_ERROR_VERIFY;
    }
    
    // 3. 写入备份区
    if (!flash_write(BACKUP_REGION, firmware_data, size)) {
        return OTA_ERROR_WRITE;
    }
    
    // 4. 验证写入
    if (!verify_flash_write(BACKUP_REGION, firmware_data, size)) {
        return OTA_ERROR_WRITE;
    }
    
    // 5. 标记待更新
    set_ota_pending_flag();
    
    // 6. 重启并切换
    system_reboot();
    
    return OTA_OK;
}

// 启动时检查
void bootloader_check_ota(void) {
    if (is_ota_pending()) {
        // 尝试启动新固件
        if (verify_firmware(ACTIVE_REGION)) {
            clear_ota_pending_flag();
            jump_to_application(ACTIVE_REGION);
        } else {
            // 回滚到旧版本
            rollback_firmware();
            jump_to_application(ACTIVE_REGION);
        }
    }
}
```

## 结构化分析框架

### 资源使用评估

| 资源类型 | 限制 | 当前使用 | 状态 |
|---------|-----|---------|-----|
| RAM | 64KB | 45KB | ✓ 正常 |
| Flash | 512KB | 380KB | ✓ 正常 |
| 栈空间 | 8KB | 6KB | ⚠️ 接近上限 |
| 功耗 | 10mA avg | 8mA | ✓ 正常 |

### 功耗预算分析

```
CR2032纽扣电池（225mAh）功耗预算：

工作模式          电流        占比      日耗电
─────────────────────────────────────────────
深度睡眠          2μA        99%       48μAh
传感器读取        500μA      0.5%      60μAh
数据传输(LoRa)    50mA       0.5%      600μAh
─────────────────────────────────────────────
日总耗电                                708μAh
理论续航                                317天

优化建议：
1. 降低传输频率可延长续航至2年
2. 使用更大容量电池（如CR2450）
3. 增加能量收集（太阳能）
```

## 约束与限制
- 嵌入式资源受限，需严格控制内存使用
- 实时性要求高的场景避免动态内存分配
- 硬件故障是常态，软件需容错设计
- 低功耗设计需权衡响应速度

## 自检清单
- [ ] 资源使用在限制范围内
- [ ] 错误处理完善
- [ ] 功耗管理到位
- [ ] 实时性满足要求
- [ ] 硬件故障有容错
- [ ] OTA安全机制
- [ ] 文档完整

## 常见陷阱

### 陷阱 1：栈溢出

```c
// 反例：大数组在栈上分配
void process_data(void) {
    uint8_t buffer[8192];  // 8KB在栈上，可能超出栈限制
    read_sensor(buffer, sizeof(buffer));
}

// 正确做法：使用静态分配
static uint8_t sensor_buffer[8192];  // 静态存储区

void process_data(void) {
    read_sensor(sensor_buffer, sizeof(sensor_buffer));
}
```

### 陷阱 2：竞态条件

```c
// 反例：中断和主循环访问共享资源无保护
volatile uint32_t sensor_value = 0;

void TIM2_IRQHandler(void) {
    sensor_value = read_adc();  // 32位写入可能不是原子的
}

void main_loop(void) {
    uint32_t value = sensor_value;  // 可能读到半更新的值
}

// 正确做法：使用中断保护
volatile uint32_t sensor_value = 0;
volatile bool data_ready = false;

void TIM2_IRQHandler(void) {
    uint32_t new_value = read_adc();
    __disable_irq();
    sensor_value = new_value;
    data_ready = true;
    __enable_irq();
}

void main_loop(void) {
    if (data_ready) {
        __disable_irq();
        uint32_t value = sensor_value;
        data_ready = false;
        __enable_irq();
        process(value);
    }
}
```

### 陷阱 3：内存泄漏

```c
// 反例：动态分配未释放
void process_message(void) {
    uint8_t *buffer = malloc(256);  // 分配内存
    receive_data(buffer, 256);
    // 忘记释放！
}

// 正确做法：使用内存池或确保释放
// 方案1：内存池
static uint8_t message_pool[256];

void process_message(void) {
    receive_data(message_pool, sizeof(message_pool));
    process(message_pool);
    // 自动复用，无泄漏
}

// 方案2：确保释放
void process_message(void) {
    uint8_t *buffer = malloc(256);
    if (!buffer) return;
    
    receive_data(buffer, 256);
    process(buffer);
    
    free(buffer);  // 确保释放
}
```

### 陷阱 4：未处理硬件故障

```c
// 反例：假设硬件总是正常工作
void read_temperature(void) {
    i2c_write(TEMP_SENSOR_ADDR, READ_CMD, 1);
    i2c_read(TEMP_SENSOR_ADDR, buffer, 2);  // 可能失败
    return (buffer[0] << 8) | buffer[1];
}

// 正确做法：完善的错误处理
sensor_error_t read_temperature_safe(int16_t *temp) {
    if (!temp) return SENSOR_ERROR_INIT;
    
    // 1. 检查传感器是否就绪
    if (!is_sensor_ready()) {
        return SENSOR_ERROR_INIT;
    }
    
    // 2. 发送命令并检查
    if (i2c_write(TEMP_SENSOR_ADDR, READ_CMD, 1) != I2C_OK) {
        return SENSOR_ERROR_READ;
    }
    
    // 3. 等待转换完成（带超时）
    if (!wait_for_conversion(100)) {  // 100ms超时
        return SENSOR_ERROR_TIMEOUT;
    }
    
    // 4. 读取数据并检查
    uint8_t buffer[2];
    if (i2c_read(TEMP_SENSOR_ADDR, buffer, 2) != I2C_OK) {
        return SENSOR_ERROR_READ;
    }
    
    // 5. 数据校验
    int16_t raw = (buffer[0] << 8) | buffer[1];
    if (raw == 0xFFFF) {  // 错误码
        return SENSOR_ERROR_READ;
    }
    
    *temp = raw;
    return SENSOR_OK;
}
```
