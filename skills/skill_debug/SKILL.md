---
name: "skill_debug"
description: "Apply debugging capabilities for systematic troubleshooting and root cause analysis. Invoke when diagnosing issues, analyzing logs, or handling exceptions."
---

# 调试技能 (Debugging)

## 核心定义
系统性排查和定位问题，通过日志分析、异常处理、边界检查等手段快速找到根因并修复。

## 技能能力
- **错误处理**：异常分类、捕获策略、错误信息规范
- **防御式编程**：参数校验、边界检查、默认值
- **调试技巧**：断言使用、错误码设计、问题复现
- **日志分析**：时间线梳理、上下文关联、模式识别
- **问题定位**：信息收集、范围缩小、根因分析

## 执行流程
```
1. 信息收集 → 错误日志、复现步骤、环境信息
2. 范围缩小 → 时间/空间维度、二分法、对比法
3. 假设验证 → 提出假设、设计实验、收集证据
4. 根因分析 → 5 Whys、区分症状和根因
5. 修复验证 → 制定方案、测试验证、灰度发布
```

## 实践要点
1. **Fail Fast**：尽早发现问题，避免错误扩散
2. **完整上下文**：异常信息必须包含足够定位问题的信息
3. **分类处理**：业务异常、系统异常、未知异常分别处理
4. **可复现性**：日志必须支持问题复现
5. **防御性**：不信任任何输入，做好边界防护

## 使用示例

### 示例 1：异常处理规范

```python
import logging
from enum import Enum
from typing import Optional, Dict, Any

logger = logging.getLogger(__name__)

class ErrorCode(Enum):
    """统一错误码"""
    PAYMENT_FAILED = ("E3001", "支付失败", 400)
    TIMEOUT_ERROR = ("E5002", "请求超时", 504)
    NETWORK_ERROR = ("E5001", "网络错误", 503)
    
    def __init__(self, code: str, message: str, http_status: int):
        self.code = code
        self.message = message
        self.http_status = http_status

class BusinessError(Exception):
    """业务异常"""
    def __init__(self, error_code: ErrorCode, detail: Optional[str] = None):
        self.error_code = error_code
        self.detail = detail
        super().__init__(error_code.message)

class PaymentAPIClient:
    """支付API客户端 - 完善的错误处理"""
    
    def process_payment(self, order_id: str, amount: float) -> Dict[str, Any]:
        request_id = generate_request_id()
        logger.info(f"[入口] process_payment | request_id={request_id}, order_id={order_id}")
        
        # 参数校验（Fail Fast）
        if amount <= 0:
            logger.warning(f"[过程] 金额无效 | amount={amount}")
            raise BusinessError(ErrorCode.PAYMENT_FAILED, "支付金额必须大于0")
        
        try:
            result = self._call_payment_api(order_id, amount, request_id)
            logger.info(f"[出口] 支付成功 | request_id={request_id}")
            return result
            
        except TimeoutError:
            logger.error(f"[出口] 支付超时 | request_id={request_id}")
            raise BusinessError(ErrorCode.TIMEOUT_ERROR, "支付请求超时")
            
        except ConnectionError as e:
            logger.error(f"[出口] 网络错误 | request_id={request_id}, error={e}")
            raise BusinessError(ErrorCode.NETWORK_ERROR, "网络连接失败")
            
        except Exception as e:
            logger.error(f"[出口] 未知错误 | request_id={request_id}, error={e}", exc_info=True)
            raise BusinessError(ErrorCode.PAYMENT_FAILED, "支付处理失败")
```

### 示例 2：日志分析定位问题

```python
# 日志分析示例
"""
日志片段：
2024-01-15 10:23:45 [INFO] 订单创建成功 order_id=12345
2024-01-15 10:23:46 [INFO] 开始支付 order_id=12345
2024-01-15 10:23:46 [ERROR] 支付失败 order_id=12345 error=Connection timeout
2024-01-15 10:23:47 [INFO] 重试支付 order_id=12345 retry=1
2024-01-15 10:23:48 [ERROR] 支付失败 order_id=12345 error=Connection timeout
2024-01-15 10:23:48 [WARN] 支付重试次数耗尽 order_id=12345

问题识别：
1. 支付服务连接超时（连续两次）
2. 超时时间可能过短（1秒内超时）
3. 网络或服务端可能有问题

根因假设：
- 假设1：支付服务宕机或网络不通
- 假设2：支付服务响应慢，超时时间设置不合理
- 假设3：数据库连接池耗尽

验证建议：
1. 检查支付服务健康状态
2. 查看支付服务日志
3. 检查网络连通性
4. 调整超时时间观察是否改善
"""
```

### 示例 3：防御式编程

```python
from typing import Optional
import logging

logger = logging.getLogger(__name__)

def safe_divide(a: float, b: float, default: float = 0.0) -> float:
    """安全除法"""
    logger.debug(f"[入口] safe_divide | a={a}, b={b}")
    
    # 边界检查
    if b == 0:
        logger.warning(f"[过程] 除数为0，返回默认值 | default={default}")
        return default
    
    try:
        result = a / b
        logger.debug(f"[出口] 除法成功 | result={result}")
        return result
    except Exception as e:
        logger.error(f"[出口] 除法异常 | error={e}")
        return default

def get_user_name(user_id: str) -> Optional[str]:
    """获取用户名（防SQL注入、空值检查）"""
    logger.info(f"[入口] get_user_name | user_id={user_id}")
    
    if not user_id:
        logger.warning("[过程] user_id为空")
        return None
    
    try:
        # 参数化查询防SQL注入
        user = db.query("SELECT name FROM users WHERE id = ?", (user_id,))
        
        if not user:
            logger.info(f"[出口] 用户不存在 | user_id={user_id}")
            return None
        
        logger.info(f"[出口] 获取成功 | user_id={user_id}")
        return user.name
        
    except Exception as e:
        logger.error(f"[出口] 数据库错误 | user_id={user_id}, error={e}")
        return None
```

### 示例 4：问题诊断框架

```
┌─────────────────────────────────────────────────────────┐
│ 系统性问题诊断流程                                       │
├─────────────────────────────────────────────────────────┤
│  1. 信息收集阶段                                         │
│     ├─ 错误日志（时间、堆栈、上下文）                     │
│     ├─ 复现步骤（必现/偶发、触发条件）                    │
│     ├─ 环境信息（版本、配置、依赖）                       │
│     └─ 影响范围（用户量、功能模块）                       │
│                                                         │
│  2. 范围缩小阶段                                         │
│     ├─ 时间维度：错误发生的时间规律                       │
│     ├─ 空间维度：哪些服务/模块受影响                      │
│     ├─ 二分法：注释一半代码看是否复现                     │
│     └─ 对比法：正常环境 vs 异常环境的差异                  │
│                                                         │
│  3. 假设验证阶段                                         │
│     ├─ 提出假设：可能导致问题的原因                       │
│     ├─ 设计实验：验证假设的方法                           │
│     ├─ 执行验证：收集证据                                 │
│     └─ 得出结论：确认或排除假设                           │
│                                                         │
│  4. 根因分析阶段                                         │
│     ├─ 区分症状和根因                                    │
│     ├─ 5 Whys：连续问为什么找到根本原因                    │
│     └─ 影响评估：根因的影响范围和修复成本                  │
└─────────────────────────────────────────────────────────┘
```

## 结构化分析框架

### 问题诊断检查表

| 维度 | 检查项 | 说明 |
|-----|-------|------|
| 信息收集 | 错误日志完整 | 包含时间、堆栈、上下文 |
| 信息收集 | 复现步骤明确 | 必现/偶发、触发条件 |
| 范围缩小 | 时间规律 | 特定时段/随机发生 |
| 范围缩小 | 影响范围 | 用户/模块/服务级别 |
| 根因分析 | 5 Whys分析 | 连续追问找到根本原因 |
| 修复验证 | 测试覆盖 | 单元/集成/回归测试 |

### 异常分类处理策略

| 异常类型 | 处理方式 | 日志级别 | 用户提示 |
|---------|---------|---------|---------|
| 业务异常 | 捕获并转换 | WARNING | 友好的业务提示 |
| 系统异常 | 捕获并记录 | ERROR | 通用错误提示 |
| 未知异常 | 捕获并报警 | CRITICAL | 联系技术支持 |

## 约束与限制
- 异常信息不能暴露敏感数据（密码、密钥等）
- 错误码需要统一规范，便于问题定位
- 日志需要平衡详细程度和性能影响
- 防御式编程不能过度，避免代码臃肿

## 自检清单
- [ ] 异常分类清晰（业务/系统/未知）
- [ ] 错误信息包含足够上下文
- [ ] 参数入口有校验
- [ ] 边界条件已检查
- [ ] 日志足够定位问题
- [ ] 错误码统一规范
- [ ] 能根据日志复现问题
- [ ] 敏感信息已脱敏

## 常见陷阱

### 陷阱 1：异常吞没

```python
# 反例：捕获异常不处理也不记录
def process_payment(user_id, amount):
    try:
        user = get_user(user_id)
        return charge(user, amount)
    except Exception:
        return None  # 异常被吞没！

# 正确做法：记录并适当处理
def process_payment(user_id, amount):
    try:
        user = get_user(user_id)
        result = charge(user, amount)
        logger.info(f"支付成功: user={user_id}")
        return result
    except UserNotFoundError:
        logger.error(f"用户不存在: {user_id}")
        raise PaymentError("无效用户")
    except Exception as e:
        logger.exception(f"支付失败: user={user_id}")
        raise PaymentError("支付处理失败") from e
```

### 陷阱 2：日志泛滥

```python
# 反例：记录过多无用日志
def process_order(order_id):
    logger.info(f"Starting process_order")  # 冗余
    order = get_order(order_id)
    logger.info(f"Got order: {order}")  # 可能含敏感信息
    for item in order.items:
        logger.info(f"Processing item: {item}")  # 循环内日志量太大
    logger.info(f"Finished")  # 冗余
    return order

# 正确做法：精简有意义的日志
def process_order(order_id):
    logger.info(f"Processing order: {order_id}")
    try:
        order = get_order(order_id)
        logger.debug(f"Order items: {len(order.items)}")
        
        for item in order.items:
            process_item(item)
        
        logger.info(f"Order processed: {order_id}, items={len(order.items)}")
        return order
    except OrderNotFoundError:
        logger.error(f"Order not found: {order_id}")
        raise
    except Exception as e:
        logger.exception(f"Failed to process order: {order_id}")
        raise
```

### 陷阱 3：过度捕获

```python
# 反例：捕获所有异常，隐藏真正问题
def fetch_data():
    try:
        return api.call()
    except Exception:  # 捕获所有异常
        return []  # 隐藏了真正的问题

# 正确做法：精确捕获，保留异常信息
def fetch_data():
    try:
        return api.call()
    except APIError as e:
        logger.error(f"API错误: {e}")
        raise ServiceError("服务调用失败") from e
    except TimeoutError:
        logger.warning("API超时")
        return []  # 超时返回默认值是合理的
```

### 陷阱 4：信息不足

```python
# 反例：异常信息缺少上下文
def process_user(user_id):
    user = db.get(user_id)
    if not user:
        raise ValueError("Not found")  # 缺少关键信息

# 正确做法：异常信息包含足够上下文
def process_user(user_id: str) -> User:
    logger.info(f"Processing user: {user_id}")
    user = db.get(user_id)
    if not user:
        raise UserNotFoundError(f"User not found: user_id={user_id}")
    return user
```

### 陷阱 5：防御过度

```python
# 反例：每个函数都添加大量校验，代码臃肿
def add(a, b):
    if a is None:
        raise ValueError("a is None")
    if b is None:
        raise ValueError("b is None")
    if not isinstance(a, (int, float)):
        raise TypeError("a must be number")
    if not isinstance(b, (int, float)):
        raise TypeError("b must be number")
    return a + b

# 正确做法：适度防御，信任类型系统
def add(a: float, b: float) -> float:
    """两数相加"""
    return a + b  # 依赖类型注解和调用方契约
```
