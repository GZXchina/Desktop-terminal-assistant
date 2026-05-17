---
name: "skill_coding"
description: "Apply coding capabilities for writing high-quality, observable, and maintainable code. Invoke when implementing business logic, refactoring code, or establishing coding standards."
---

# 编码技能 (Coding)

## 核心定义
编写高质量、可观测、可维护的代码，遵循命名规范、结构清晰、日志完整、注释充分。

## 技能能力
- **代码可观测性**：入口/出口/过程日志、异常追踪
- **命名规范**：自解释命名、统一风格
- **代码结构**：单一职责、函数拆分、嵌套控制
- **防御式编程**：输入校验、边界检查、默认值
- **代码复用**：DRY原则、公共组件、配置外置

## 执行流程
```
1. 理解需求 → 明确输入输出、边界条件、异常场景
2. 设计接口 → 函数签名、参数类型、返回值
3. 编写代码 → 遵循规范、添加日志、处理异常
4. 自测检查 → 边界条件、异常路径、日志输出
5. 重构优化 → 提取函数、消除重复、简化逻辑
```

## 实践要点
1. **日志完整**：入口、关键节点、出口都必须有日志
2. **命名自解释**：代码应该自文档化，减少注释依赖
3. **防御式编程**：不信任任何输入，Fail Fast
4. **最小可行代码**：先实现核心功能，再逐步完善
5. **测试驱动**：核心业务逻辑必须有单元测试

## 使用示例

### 示例 1：日志规范

```python
# 完整日志示例
class PaymentService:
    def process_payment(self, order_id: str, amount: float) -> PaymentResult:
        request_id = generate_request_id()
        
        # 入口日志：记录请求参数
        logger.info(f"[入口] process_payment | request_id={request_id}, order_id={order_id}, amount={amount}")
        
        try:
            # 过程日志：记录关键节点
            logger.debug(f"[过程] 验证订单 | request_id={request_id}")
            order = self.validate_order(order_id)
            
            logger.debug(f"[过程] 调用支付网关 | request_id={request_id}")
            result = self.gateway.charge(amount)
            
            # 出口日志：记录结果
            logger.info(f"[出口] 支付成功 | request_id={request_id}, transaction_id={result.id}")
            return result
            
        except ValidationError as e:
            # 业务异常
            logger.warning(f"[出口] 参数错误 | request_id={request_id}, error={e}")
            raise
        except Exception as e:
            # 系统异常
            logger.error(f"[出口] 系统错误 | request_id={request_id}, error={e}", exc_info=True)
            raise
```

### 示例 2：防御式编程

```python
# 防御式编程示例
def calculate_discount(user: Optional[User], order: Optional[Order]) -> float:
    # 防御：检查空值
    if not order:
        logger.warning("订单为空，返回0")
        return 0.0
    
    if not user:
        return order.amount  # 无折扣
    
    # 防御：检查金额有效性
    if order.amount < 0:
        raise ValueError(f"订单金额不能为负数: {order.amount}")
    
    # 防御：检查用户类型有效性
    valid_types = {"VIP", "NORMAL", "NEW"}
    if user.type not in valid_types:
        logger.warning(f"未知用户类型: {user.type}")
        return order.amount
    
    # 计算折扣
    discount_map = {"VIP": 0.8, "NEW": 0.95, "NORMAL": 1.0}
    return order.amount * discount_map[user.type]
```

### 示例 3：代码结构优化

```python
# 重构前：深层嵌套
def process_order(order):
    if order:
        if order.status == "pending":
            if order.items:
                for item in order.items:
                    if item.quantity > 0:
                        process_item(item)

# 重构后：卫语句减少嵌套
def process_order(order) -> None:
    if not order:
        logger.warning("订单不存在")
        return
    
    if order.status != "pending":
        logger.warning(f"订单状态不正确: {order.status}")
        return
    
    if not order.items:
        logger.warning("订单为空")
        return
    
    for item in order.items:
        if item.quantity <= 0:
            logger.warning(f"数量无效: {item.quantity}")
            continue
        process_item(item)
```

### 示例 4：命名规范

```python
# 好的命名示例
class OrderProcessor:
    MAX_RETRY_COUNT = 3
    
    def calculate_total_amount(self, items: List[OrderItem]) -> Decimal:
        """计算订单总金额（含税）"""
        subtotal = sum(item.price * item.quantity for item in items)
        tax_rate = self.get_tax_rate()
        return subtotal * (1 + tax_rate)
    
    def is_eligible_for_discount(self, user: User, order: Order) -> bool:
        """检查用户是否符合折扣条件"""
        return user.is_vip and order.amount > 100

# 常量定义
class PaymentStatus:
    PENDING = "pending"
    COMPLETED = "completed"
    FAILED = "failed"
    REFUNDED = "refunded"
```

## 结构化分析框架

### 代码质量评估维度

| 维度 | 评估要点 | 通过标准 |
|-----|---------|---------|
| 可观测性 | 日志完整性 | 入口/出口/关键节点都有日志 |
| 健壮性 | 异常处理 | 所有异常路径都有处理 |
| 可读性 | 命名与结构 | 命名自解释，嵌套≤3层 |
| 可维护性 | 耦合度 | 单一职责，函数≤50行 |
| 安全性 | 输入校验 | 所有输入都经过校验 |

### 代码审查检查表

```markdown
- [ ] 函数命名清晰表达意图
- [ ] 参数有类型注解
- [ ] 返回值类型明确
- [ ] 入口有日志
- [ ] 异常有处理
- [ ] 无魔法数字
- [ ] 无深层嵌套
- [ ] 注释解释"为什么"而非"做什么"
```

## 约束与限制
- 函数长度不超过50行，超过需拆分
- 嵌套深度不超过3层，超过需重构
- 禁止硬编码，配置必须外置
- 核心业务逻辑必须有单元测试
- 敏感信息必须脱敏处理

## 自检清单
- [ ] 入口有日志打印参数
- [ ] 关键节点有过程日志
- [ ] 出口有结果/异常日志
- [ ] 函数有完整注释（参数/返回值/异常）
- [ ] 无硬编码（除明确标注的MOCK数据）
- [ ] 变量命名自解释
- [ ] 函数不过长（≤50行）
- [ ] 嵌套不过深（≤3层）
- [ ] 有异常处理
- [ ] 边界条件已处理

## 常见陷阱

### 陷阱 1：魔法数字

```python
# 反例：硬编码数值无说明
def calculate_price(base_price, user_type):
    if user_type == 'vip':
        return base_price * 0.8  # 0.8是什么？
    return base_price

# 正确做法：使用有意义的常量
class DiscountRate:
    VIP = 0.8
    ENTERPRISE = 0.6
    REGULAR = 1.0

def calculate_price(base_price: float, user_type: str) -> float:
    discount = getattr(DiscountRate, user_type.upper(), DiscountRate.REGULAR)
    return base_price * discount
```

### 陷阱 2：过度注释

```python
# 反例：注释解释"做了什么"
def process_data(data):
    # 获取用户名
    name = data.get('name')
    # 如果名字存在
    if name:
        # 转换为大写
        name = name.upper()
    return name

# 正确做法：注释解释"为什么"，代码自解释"做什么"
def normalize_username(raw_data: dict) -> str:
    """标准化用户名（大写便于搜索）"""
    return raw_data.get('name', '').upper().strip()
```

### 陷阱 3：异常吞没

```python
# 反例：捕获异常不处理
def fetch_data():
    try:
        return api.call()
    except Exception:
        pass  # 异常被吞没，问题难以定位

# 正确做法：记录或抛出异常
def fetch_data():
    try:
        return api.call()
    except APIError as e:
        logger.error(f"API调用失败: {e}")
        raise ServiceError("获取数据失败") from e
```

### 陷阱 4：深层嵌套

```python
# 反例：嵌套过深
def process(data):
    if data:
        if data.valid:
            if data.items:
                for item in data.items:
                    if item.active:
                        process_item(item)

# 正确做法：使用卫语句提前返回
def process(data):
    if not data or not data.valid:
        return
    if not data.items:
        return
    for item in data.items:
        if not item.active:
            continue
        process_item(item)
```

### 陷阱 5：日志缺失

```python
# 反例：关键流程无日志
def transfer_money(from_account, to_account, amount):
    from_account.deduct(amount)
    to_account.add(amount)
    return True

# 正确做法：关键节点添加日志
def transfer_money(from_account, to_account, amount):
    logger.info(f"转账开始: {from_account.id} -> {to_account.id}, 金额: {amount}")
    try:
        from_account.deduct(amount)
        logger.debug(f"扣款成功: {from_account.id}")
        to_account.add(amount)
        logger.debug(f"入账成功: {to_account.id}")
        logger.info("转账完成")
        return True
    except Exception as e:
        logger.error(f"转账失败: {e}")
        raise
```
