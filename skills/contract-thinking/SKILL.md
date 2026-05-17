---
name: "contract-thinking"
description: "Apply contract thinking to define clear interfaces and boundaries between components. Invoke when designing APIs, service boundaries, or cross-team collaborations."
---

# 契约思维 (Contract Thinking)

## 核心定义
接口优先的设计思维，强调在设计阶段就明确定义组件、服务或模块之间的契约（输入、输出、行为约束）。通过清晰的契约定义，降低系统耦合度，提高可维护性和可测试性。

## 技能能力
- **API 契约设计**：定义清晰的接口输入输出规范
- **模块边界划分**：明确模块职责和交互方式
- **契约测试编写**：基于契约编写自动化测试
- **版本兼容性管理**：设计向后兼容的接口演进策略
- **错误契约定义**：规范错误码和异常处理契约

## 执行流程
```
1. 识别参与者 → 明确契约的提供方和消费方
2. 定义契约内容 → 输入、输出、错误、性能约束
3. 形式化表达 → 使用类型、Schema、OpenAPI 等
4. 契约验证 → 编写测试验证契约遵守情况
5. 文档化 → 生成人类可读的契约文档
6. 版本管理 → 规划契约的演进和兼容性
```

## 思考流程

### Step 1: 识别参与者
- 明确契约的提供方（服务实现者）
- 明确契约的消费方（服务调用者）
- 识别多方依赖关系

### Step 2: 定义契约内容
- **输入契约**：参数类型、必填字段、取值范围
- **输出契约**：返回类型、成功/失败格式
- **错误契约**：错误码定义、异常类型
- **性能契约**：响应时间、吞吐量、可用性

### Step 3: 形式化表达
- 使用类型系统（TypeScript、Python类型注解）
- 使用Schema定义（JSON Schema、Protobuf）
- 使用接口定义语言（OpenAPI、gRPC IDL）

### Step 4: 契约验证
- 前置条件验证
- 后置条件验证
- 不变式验证
- 契约测试

### Step 5: 文档化
- 生成API文档
- 记录契约变更历史
- 提供调用示例

### Step 6: 版本管理
- 定义版本策略
- 保证向后兼容
- 规划弃用和迁移

## 实践要点
1. **契约即文档**：清晰的契约就是最好的文档
2. **前置条件严格**：对输入的要求要明确且可验证
3. **后置条件保证**：承诺的输出必须可靠交付
4. **不变式约束**：维护对象或系统的核心不变条件
5. **版本契约**：接口变更需考虑兼容性承诺

## 使用示例

### 示例 1：API契约设计

```python
# 反例：契约模糊的代码
class OrderService:
    def create_order(self, data):
        """问题：契约不明确
        - 输入data是什么结构？
        - 返回什么格式？
        - 会抛出什么异常？
        """
        order = Order()
        order.user_id = data.get('user_id')  # 可能为None
        order.total = data.get('total')      # 可能为负数
        db.save(order)
        return order  # 返回对象还是ID？

# 正确做法：清晰的契约设计
from typing import Protocol
from dataclasses import dataclass
from decimal import Decimal
from uuid import UUID

@dataclass(frozen=True)
class CreateOrderRequest:
    """创建订单请求契约
    
    前置条件：
    - user_id: 有效的用户UUID
    - items: 非空列表，最多100项
    - total: 正数，与items计算一致
    """
    user_id: UUID
    items: list[OrderItem]
    total: Decimal
    
    def __post_init__(self):
        if not self.items:
            raise ValueError("items不能为空")
        if len(self.items) > 100:
            raise ValueError("items不能超过100项")
        if self.total <= 0:
            raise ValueError("total必须大于0")

@dataclass(frozen=True)
class CreateOrderResponse:
    """创建订单响应契约"""
    order_id: UUID
    status: OrderStatus
    total: Decimal
    created_at: datetime

class OrderService:
    """订单服务 - 清晰契约"""
    
    def create_order(self, request: CreateOrderRequest) -> CreateOrderResponse:
        """
        创建订单
        
        前置条件：request已通过验证
        后置条件：返回的order_id唯一且可查询
        异常契约：
        - InventoryError: 库存不足
        - PaymentError: 支付失败
        - ValidationError: 请求无效
        性能契约：P99 < 200ms
        """
        # 实现...
        pass
```

### 示例 2：服务间契约接口

```python
from abc import ABC, abstractmethod
from typing import Protocol

# 用户服务契约
class IUserService(Protocol):
    """用户服务契约 - 版本v1.0 - 稳定"""
    
    @abstractmethod
    async def get_user(self, user_id: UUID) -> UserDTO:
        """
        获取用户信息
        
        前置条件：user_id 必须是有效的UUID
        后置条件：返回的用户对象 id 与请求一致
        错误契约：UserNotFoundError, ServiceUnavailableError
        """
        ...

@dataclass(frozen=True)
class UserDTO:
    """用户数据传输对象契约"""
    id: UUID
    username: str
    email: str
    status: Literal["ACTIVE", "INACTIVE", "SUSPENDED"]
    schema_version: str = "1.0"

# 库存服务契约
class IInventoryService(Protocol):
    """库存服务契约"""
    
    @abstractmethod
    async def reserve(
        self,
        reservation_id: UUID,
        items: List[ReservationItem],
        ttl_seconds: int = 900
    ) -> ReservationResult:
        """
        预留库存
        
        前置条件：
        - reservation_id 全局唯一
        - items 中每个产品的库存充足
        
        后置条件：
        - 成功：库存被预留，预留记录可查询
        - 失败：库存不变，返回具体原因
        
        不变式：预留库存 + 可用库存 = 总库存
        """
        ...
```

### 示例 3：事件契约定义

```python
@dataclass
class OrderCreatedEvent:
    """订单创建事件契约
    
    事件类型：order.created
    版本：v1
    """
    event_id: UUID
    event_type: str = "order.created"
    schema_version: str = "1.0"
    timestamp: datetime
    
    # 事件载荷
    order_id: UUID
    user_id: UUID
    total_amount: Decimal
    items: List[OrderItemDTO]
    
    # 幂等性键
    idempotency_key: str

@dataclass
class PaymentCompletedEvent:
    """支付完成事件契约
    
    事件类型：payment.completed
    版本：v1
    """
    event_id: UUID
    event_type: str = "payment.completed"
    schema_version: str = "1.0"
    timestamp: datetime
    
    order_id: UUID
    payment_id: UUID
    amount: Decimal
    payment_method: str
    transaction_id: str
```

### 示例 4：契约测试

```python
import pytest

class TestOrderContract:
    """订单契约测试"""
    
    def test_order_item_invariant(self):
        """测试订单项不变式"""
        # 合法契约
        item = OrderItem(
            product_id=UUID("12345678-1234-1234-1234-123456789012"),
            quantity=5,
            price=Decimal("10.00")
        )
        assert item.subtotal == Decimal("50.00")
        
        # 违反不变式：quantity <= 0
        with pytest.raises(ValueError):
            OrderItem(
                product_id=UUID("12345678-1234-1234-1234-123456789012"),
                quantity=0,
                price=Decimal("10.00")
            )
    
    def test_create_order_precondition(self):
        """测试创建订单前置条件"""
        # 违反前置条件：空items
        with pytest.raises(ValueError):
            CreateOrderRequest(
                user_id=UUID("12345678-1234-1234-1234-123456789012"),
                items=[],
                total=Decimal("10.00")
            )
    
    def test_order_status_transition_contract(self):
        """测试状态转换契约"""
        order = create_test_order(status=OrderStatus.PENDING_PAYMENT)
        
        # 合法转换
        assert order.can_transition_to(OrderStatus.PAID)
        paid_order = order.transition_to(OrderStatus.PAID)
        assert paid_order.status == OrderStatus.PAID
        
        # 非法转换
        assert not order.can_transition_to(OrderStatus.SHIPPED)
        with pytest.raises(ValueError):
            order.transition_to(OrderStatus.SHIPPED)
```

## 结构化分析框架

### 契约设计检查表

| 契约要素 | 检查项 | 通过标准 |
|---------|-------|---------|
| 输入契约 | 参数类型 | 有类型注解/Schema |
| 输入契约 | 必填字段 | 明确标注required |
| 输入契约 | 取值范围 | 有min/max/pattern |
| 输出契约 | 返回类型 | 明确定义 |
| 输出契约 | 成功格式 | 有示例 |
| 输出契约 | 错误格式 | 统一错误结构 |
| 性能契约 | 响应时间 | 有P99指标 |
| 版本契约 | 兼容性 | 向后兼容策略 |

### 服务契约矩阵

| 服务 | 提供契约 | 消费契约 | 稳定性 |
|-----|---------|---------|--------|
| User Service | 用户信息、认证 | - | 高 |
| Order Service | 订单CRUD、状态 | 用户验证、库存检查 | 高 |
| Payment Service | 支付处理、退款 | 订单查询 | 中 |
| Inventory Service | 库存查询、扣减 | - | 高 |

## 约束与限制
- 契约变更需要严格版本管理
- 过度契约化会增加开发成本
- 契约需要持续维护和更新
- 跨团队契约需要充分沟通

## 自检清单
- [ ] 输入参数有类型定义
- [ ] 必填字段明确标注
- [ ] 返回值类型明确
- [ ] 错误码定义清晰
- [ ] 有契约测试覆盖
- [ ] 文档与代码一致
- [ ] 版本策略已定义
- [ ] 向后兼容性已考虑

## 常见陷阱

### 陷阱 1：契约模糊

```python
# 反例：契约不明确
def process_data(data):
    """处理数据"""
    return data.process()

# 问题：data是什么类型？返回什么？会抛出什么异常？

# 正确做法：明确契约
from typing import Protocol

class DataProcessor(Protocol):
    def process(self) -> ProcessResult:
        ...

def process_data(data: DataProcessor) -> ProcessResult:
    """
    处理数据
    
    前置条件：data已实现DataProcessor接口
    后置条件：返回ProcessResult包含处理结果
    异常：ProcessingError当处理失败时
    """
    return data.process()
```

### 陷阱 2：契约破坏

```python
# 反例：违反契约承诺
class PaymentService:
    def process_payment(self, amount: Decimal) -> PaymentResult:
        # 违反契约：amount<=0时应该抛出异常，但返回了错误结果
        if amount <= 0:
            return PaymentResult(success=False)  # 应该抛出异常
        # ...

# 正确做法：严格遵守契约
class PaymentService:
    def process_payment(self, amount: Decimal) -> PaymentResult:
        if amount <= 0:
            raise ValueError(f"amount必须大于0: {amount}")
        # ...
        return PaymentResult(success=True, transaction_id=tx_id)
```

### 陷阱 3：版本不兼容

```python
# 反例：破坏性变更
class UserServiceV2:
    def get_user(self, user_id: str) -> dict:
        # V1返回的是User对象，V2返回dict，破坏兼容性
        return {"id": user_id, "name": "..."}

# 正确做法：保持向后兼容
class UserServiceV2:
    def get_user(self, user_id: str) -> User:
        # 保持返回类型一致
        return User(id=user_id, name="...")
    
    def get_user_v2(self, user_id: str) -> UserV2:
        # 新功能用新版本接口
        return UserV2(id=user_id, name="...", email="...")
```

### 陷阱 4：缺失不变式

```python
# 反例：不维护不变式
class BankAccount:
    def __init__(self):
        self.balance = 0
        self.transactions = []
    
    def withdraw(self, amount):
        self.balance -= amount  # 可能变负数！
        self.transactions.append(Transaction(-amount))

# 正确做法：维护不变式
class BankAccount:
    def __init__(self):
        self._balance = 0
        self._transactions = []
    
    @property
    def balance(self):
        # 不变式：balance == sum(t.amount for t in transactions)
        assert self._balance == sum(t.amount for t in self._transactions)
        return self._balance
    
    def withdraw(self, amount):
        if amount > self.balance:
            raise InsufficientFundsError()
        self._balance -= amount
        self._transactions.append(Transaction(-amount))
```
