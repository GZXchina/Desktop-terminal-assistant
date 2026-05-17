---
name: "skill_architecture"
description: "Apply architecture design capabilities for system architecture, technology selection, and evolution planning. Invoke when designing system architecture, selecting technologies, or planning architecture refactoring."
---

# 架构设计技能 (Architecture Design)

## 核心定义
设计系统整体结构，包括技术选型、模块划分、接口定义和演进规划，确保系统满足功能性需求和非功能性需求。

## 技能能力
- **系统架构设计**：单体/微服务/Serverless架构选择
- **技术选型**：框架、数据库、中间件评估与选择
- **模块划分**：职责分离、依赖管理、接口设计
- **非功能性设计**：性能、可用性、安全性、可扩展性
- **架构演进**：遗留系统改造、渐进式重构

## 执行流程
```
1. 需求分析 → 功能需求 + 非功能性需求
2. 架构选型 → 单体/微服务/Serverless
3. 模块设计 → 划分边界、定义接口
4. 技术选型 → 评估框架、数据库、中间件
5. 验证评审 → 架构评审、原型验证
6. 演进规划 → 分期实施、风险管控
```

## 实践要点
1. **合适优于先进**：选择适合团队能力的技术
2. **演进式设计**：支持未来扩展，避免过度设计
3. **接口优先**：清晰的契约是协作基础
4. **关注非功能性**：性能、安全、可用性同等重要
5. **文档驱动**：架构决策记录（ADR）

## 使用示例

### 示例 1：微服务拆分

**场景**：电商平台从单体拆分为微服务

**反例**：过度拆分导致复杂度爆炸
```python
# 反例：过度拆分，服务间调用链过长
# 订单服务 → 库存服务 → 仓库服务 → 货位服务 → 商品服务
# 一次下单涉及10+次RPC调用，延迟高、故障点多

# 问题：
# - 分布式事务复杂
# - 调试困难
# - 部署依赖多
```

**正例**：合理的服务边界
```python
# 正例：按业务领域拆分，减少跨服务调用
# 订单服务（包含订单、支付、退款）
# 商品服务（包含商品、库存、分类）
# 用户服务（包含用户、地址、会员）
# 物流服务（包含物流、配送、跟踪）

# 设计原则：
# - 高内聚：相关功能放在同一服务
# - 低耦合：服务间通过MQ异步通信
# - 独立部署：每个服务可独立发布
```

### 示例 2：分层架构设计

**场景**：设计清晰的分层架构

```python
# 分层架构示例

# ============ 表现层（Presentation） ============
class OrderController:
    """处理HTTP请求，参数校验"""
    def __init__(self, order_service: OrderService):
        self.service = order_service
    
    def create_order(self, request: CreateOrderRequest) -> OrderResponse:
        # 参数校验
        if not request.items:
            raise ValidationError("订单不能为空")
        
        # 调用业务层
        order = self.service.create_order(request)
        return OrderResponse.from_domain(order)

# ============ 业务层（Business Logic） ============
class OrderService:
    """核心业务逻辑，事务管理"""
    def __init__(
        self,
        order_repo: OrderRepository,
        inventory_service: InventoryService,
        payment_service: PaymentService
    ):
        self.order_repo = order_repo
        self.inventory = inventory_service
        self.payment = payment_service
    
    @transactional
    def create_order(self, request: CreateOrderRequest) -> Order:
        # 1. 检查库存
        for item in request.items:
            if not self.inventory.check_stock(item.product_id, item.quantity):
                raise InsufficientStockError(item.product_id)
        
        # 2. 创建订单
        order = Order.create(request)
        self.order_repo.save(order)
        
        # 3. 扣减库存
        for item in request.items:
            self.inventory.deduct(item.product_id, item.quantity)
        
        return order

# ============ 数据访问层（Data Access） ============
class OrderRepository:
    """数据持久化，隔离数据库细节"""
    def __init__(self, db_session):
        self.db = db_session
    
    def save(self, order: Order) -> None:
        self.db.add(order)
        self.db.commit()
    
    def find_by_id(self, order_id: str) -> Optional[Order]:
        return self.db.query(Order).filter_by(id=order_id).first()
```

### 示例 3：技术选型决策

**场景**：选择消息队列中间件

```python
# 技术选型评估框架

def evaluate_message_queue(requirements: Requirements) -> Decision:
    """
    消息队列选型决策
    
    候选方案：
    1. RabbitMQ - 成熟稳定，功能丰富
    2. Kafka - 高吞吐，持久化
    3. RocketMQ - 阿里开源，事务消息
    4. Redis Pub/Sub - 简单，轻量
    """
    
    # 评估维度
    criteria = {
        'throughput': {  # 吞吐量
            'Kafka': 10,
            'RocketMQ': 9,
            'RabbitMQ': 7,
            'Redis': 5
        },
        'latency': {  # 延迟
            'RabbitMQ': 9,
            'Redis': 9,
            'RocketMQ': 8,
            'Kafka': 7
        },
        'reliability': {  # 可靠性
            'Kafka': 10,
            'RocketMQ': 9,
            'RabbitMQ': 8,
            'Redis': 5
        },
        'complexity': {  # 复杂度（越低越好）
            'Redis': 9,
            'RabbitMQ': 7,
            'RocketMQ': 6,
            'Kafka': 5
        },
        'ecosystem': {  # 生态
            'Kafka': 10,
            'RabbitMQ': 9,
            'Redis': 8,
            'RocketMQ': 7
        }
    }
    
    # 根据需求权重计算得分
    weights = {
        'throughput': requirements.needs_high_throughput and 0.3 or 0.1,
        'latency': requirements.needs_low_latency and 0.3 or 0.1,
        'reliability': 0.2,
        'complexity': 0.1,
        'ecosystem': 0.1
    }
    
    # 计算总分
    scores = {}
    for option in ['Kafka', 'RabbitMQ', 'RocketMQ', 'Redis']:
        score = sum(
            criteria[criterion][option] * weight
            for criterion, weight in weights.items()
        )
        scores[option] = score
    
    # 选择得分最高的
    best_option = max(scores, key=scores.get)
    
    return Decision(
        choice=best_option,
        scores=scores,
        reasoning=f"基于需求权重计算，{best_option}得分最高"
    )
```

## 结构化分析框架

### 架构评估维度

| 维度 | 评估项 | 关键问题 |
|-----|-------|---------|
| **性能** | 吞吐量、延迟、资源占用 | 能否支撑峰值流量？ |
| **可用性** | SLA、故障恢复、降级策略 | 故障时如何保障核心功能？ |
| **安全性** | 认证授权、数据加密、审计 | 如何防止数据泄露？ |
| **可扩展性** | 水平扩展、数据分区 | 用户增长10倍怎么办？ |
| **可维护性** | 代码复杂度、文档、监控 | 新人多久能上手？ |
| **成本** | 开发成本、运维成本 | 总拥有成本（TCO）多少？ |

### 技术选型决策矩阵

- [ ] 列出所有候选方案
- [ ] 定义评估维度和权重
- [ ] 收集各方案数据（基准测试、社区活跃度）
- [ ] 团队能力匹配度评估
- [ ] 记录决策理由（ADR）

## 约束与限制
- 架构决策一旦实施，修改成本高
- 技术选型受团队能力约束
- 遗留系统改造风险大
- 微服务增加运维复杂度
- 过度设计增加不必要的复杂性

## 自检清单
- [ ] 架构满足所有功能性需求
- [ ] 非功能性需求有量化指标
- [ ] 模块边界清晰，接口契约明确
- [ ] 有明确的错误处理和降级策略
- [ ] 考虑了安全性和数据隐私
- [ ] 有监控和可观测性方案
- [ ] 架构决策已记录（ADR）
- [ ] 团队有能力实施和维护

## 常见陷阱

### 陷阱 1：过度设计
**问题**：为不存在的需求设计复杂架构

```python
# 反例：为"可能"的千万级用户设计复杂分布式架构
# 实际只有1万用户，单体应用完全够用

# 当前：1万用户，单体应用足够
# 错误做法：直接上微服务 + Kubernetes + 服务网格
# 结果：开发效率降低，运维成本增加

# 正确做法：渐进式演进
# 阶段1：单体应用（1-10万用户）
# 阶段2：拆分核心服务（10-100万用户）
# 阶段3：全面微服务（100万+用户）
```

### 陷阱 2：忽视非功能性需求
**问题**：只关注功能，忽视性能、安全、可用性

```python
# 反例：只实现功能，不考虑性能和安全
class UserService:
    def get_user(self, user_id):
        # 问题1：没有缓存，每次都查数据库
        return db.query(User).filter_by(id=user_id).first()
    
    def login(self, username, password):
        # 问题2：明文存储密码
        user = db.query(User).filter_by(username=username).first()
        if user.password == password:  # 明文比较！
            return user
        return None

# 正确做法：考虑非功能性需求
class UserService:
    def __init__(self, cache: Cache, hasher: PasswordHasher):
        self.cache = cache
        self.hasher = hasher
    
    def get_user(self, user_id):
        # 先查缓存
        user = self.cache.get(f"user:{user_id}")
        if user:
            return user
        
        # 缓存未命中，查数据库
        user = db.query(User).filter_by(id=user_id).first()
        if user:
            self.cache.set(f"user:{user_id}", user, ttl=3600)
        return user
    
    def login(self, username, password):
        user = db.query(User).filter_by(username=username).first()
        # 使用安全的方式验证密码
        if user and self.hasher.verify(password, user.password_hash):
            return user
        return None
```

### 陷阱 3：紧耦合
**问题**：模块间直接依赖，难以独立演进

```python
# 反例：服务间直接调用，紧耦合
class OrderService:
    def create_order(self, user_id, items):
        # 直接调用用户服务
        user = user_service_client.get_user(user_id)
        
        # 直接调用库存服务
        for item in items:
            inventory_service_client.deduct(item.product_id, item.quantity)
        
        # 直接调用支付服务
        payment_service_client.charge(user.card_token, total_amount)
        
        # 问题：
        # - 任一服务故障，订单服务不可用
        # - 无法独立部署
        # - 测试困难

# 正确做法：通过消息队列解耦
class OrderService:
    def create_order(self, user_id, items):
        # 1. 创建订单（本地事务）
        order = Order.create(user_id, items)
        self.order_repo.save(order)
        
        # 2. 发送事件，异步处理
        self.event_bus.publish('OrderCreated', {
            'order_id': order.id,
            'user_id': user_id,
            'items': items,
            'total': order.total
        })
        
        # 库存服务、支付服务订阅事件，独立处理
        return order
```

### 陷阱 4：忽视数据一致性
**问题**：分布式系统中数据不一致

```python
# 反例：分布式事务处理不当
class OrderService:
    def create_order(self, user_id, items):
        # 先创建订单
        order = self.order_repo.create(user_id, items)
        
        # 再扣减库存（可能失败）
        try:
            self.inventory_service.deduct(items)
        except Exception:
            # 问题：订单已创建，库存未扣减，数据不一致！
            pass

# 正确做法：Saga模式或TCC事务
class OrderService:
    def create_order(self, user_id, items):
        # 使用Saga模式
        saga = SagaOrchestrator()
        
        # 步骤1：创建订单
        saga.add_step(
            action=lambda: self.order_repo.create(user_id, items),
            compensate=lambda order_id: self.order_repo.cancel(order_id)
        )
        
        # 步骤2：扣减库存
        saga.add_step(
            action=lambda: self.inventory_service.deduct(items),
            compensate=lambda: self.inventory_service.add_back(items)
        )
        
        # 步骤3：处理支付
        saga.add_step(
            action=lambda: self.payment_service.charge(user_id, total),
            compensate=lambda: self.payment_service.refund(user_id, total)
        )
        
        # 执行Saga，任一步骤失败自动补偿
        return saga.execute()
```

### 陷阱 5：架构腐化
**问题**：没有代码审查，架构逐渐偏离设计

```python
# 反例：为了赶进度，绕过架构约束
class OrderService:
    def create_order(self, user_id, items):
        # 应该通过UserService获取用户信息
        # 但为了"方便"，直接查询用户表
        user = db.query(User).filter_by(id=user_id).first()  # 违反分层！
        
        # 应该通过事件通知库存服务
        # 但为了"性能"，直接调用库存表
        for item in items:
            db.execute("UPDATE inventory SET count = count - ? WHERE id = ?", 
                      (item.quantity, item.product_id))  # 违反服务边界！

# 正确做法：坚持架构约束，通过重构解决问题
class OrderService:
    def __init__(self, user_service: UserService, event_bus: EventBus):
        self.user_service = user_service
        self.event_bus = event_bus
    
    def create_order(self, user_id, items):
        # 通过服务接口获取用户
        user = self.user_service.get_user(user_id)
        
        # 创建订单
        order = Order.create(user, items)
        self.order_repo.save(order)
        
        # 通过事件通知库存服务
        self.event_bus.publish('OrderCreated', {
            'order_id': order.id,
            'items': items
        })
        
        return order
```
