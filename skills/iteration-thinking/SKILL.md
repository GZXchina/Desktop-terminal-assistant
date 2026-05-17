---
name: "iteration-thinking"
description: "Apply iteration thinking to deliver value through small, frequent increments. Invoke when planning projects, breaking down large features, or managing product development."
---

# 迭代思维 (Iteration Thinking)

## 核心定义

迭代思维是一种**通过小步快跑、持续交付**来降低风险和快速验证的思维方式。它强调将大目标拆解为可独立交付的小版本，通过频繁反馈快速调整方向，避免一次性大规模投入带来的风险。

## 技能能力

- **需求拆分**：将大需求拆分为可独立交付的迭代版本
- **MVP 设计**：设计最小可行产品快速验证假设
- **发布规划**：制定渐进式发布策略
- **反馈整合**：基于用户反馈快速调整优先级
- **技术演进**：规划技术的渐进式升级路径

## 执行流程

```
1. 目标拆解 → 将大目标拆分为独立小目标
2. 优先级排序 → 按价值和风险排序
3. 迭代规划 → 定义每个迭代的交付范围
4. 快速交付 → 完成开发并发布
5. 收集反馈 → 获取用户和数据反馈
6. 调整方向 → 基于反馈调整后续计划
```

## 实践要点

1. **小步快跑**：每次迭代都有明确交付物
2. **快速反馈**：尽早获得真实用户反馈
3. **方向可调**：根据反馈随时调整优先级
4. **风险前置**：高风险项优先验证
5. **持续集成**：保持代码随时可发布状态

## 使用示例

### 示例 1：功能迭代开发

**场景**：电商系统开发规划

```python
from dataclasses import dataclass
from typing import List
from enum import Enum

class Priority(Enum):
    P0 = "核心功能"
    P1 = "重要功能"
    P2 = "增值功能"

@dataclass
class Feature:
    name: str
    priority: Priority
    effort_days: int
    dependencies: List[str]
    
    def can_start(self, completed: set) -> bool:
        """检查依赖是否满足"""
        return all(dep in completed for dep in self.dependencies)

class IterationPlanner:
    """迭代规划器"""
    
    def __init__(self, velocity: int = 10):
        self.velocity = velocity  # 团队速度：每迭代人天
        self.features: List[Feature] = []
    
    def add_feature(self, feature: Feature):
        self.features.append(feature)
    
    def plan(self) -> List[dict]:
        """规划迭代"""
        # 按优先级排序
        sorted_features = sorted(
            self.features,
            key=lambda f: (f.priority.value, -f.effort_days)
        )
        
        iterations = []
        current = {"features": [], "effort": 0}
        completed = set()
        
        for f in sorted_features:
            if not f.can_start(completed):
                continue
            
            if current["effort"] + f.effort_days <= self.velocity:
                current["features"].append(f)
                current["effort"] += f.effort_days
            else:
                iterations.append(current)
                completed.update(f.name for f in current["features"])
                current = {"features": [f], "effort": f.effort_days}
        
        if current["features"]:
            iterations.append(current)
        
        return iterations


# 使用示例
planner = IterationPlanner(velocity=14)

features = [
    Feature("用户注册登录", Priority.P0, 5, []),
    Feature("商品浏览", Priority.P0, 4, []),
    Feature("购物车", Priority.P0, 5, ["商品浏览"]),
    Feature("下单支付", Priority.P0, 8, ["用户注册登录", "购物车"]),
    Feature("订单管理", Priority.P1, 4, ["下单支付"]),
    Feature("商品搜索", Priority.P1, 5, ["商品浏览"]),
]

for f in features:
    planner.add_feature(f)

iterations = planner.plan()
for i, it in enumerate(iterations, 1):
    print(f"迭代{i}: {[f.name for f in it['features']]}")
```

### 示例 2：MVP 设计

**场景**：社交APP最小可行产品设计

```python
class MVPDesigner:
    """MVP设计师"""
    
    def __init__(self):
        self.core_hypotheses = [
            "用户愿意分享生活瞬间",
            "用户喜欢浏览朋友动态",
            "简单的互动能提升留存"
        ]
        
        self.mvp_features = [
            "发布图文动态",
            "关注好友",
            "浏览动态流",
            "点赞"
        ]
        
        self.post_mvp_features = [
            "视频功能", "直播", "私信",
            "推荐算法", "商业化"
        ]
    
    def get_iteration_roadmap(self) -> List[dict]:
        """获取迭代路线图"""
        return [
            {
                "version": "MVP",
                "goal": "验证核心需求",
                "features": self.mvp_features,
                "metrics": {"dau": 100, "post_rate": 0.2}
            },
            {
                "version": "v1.1",
                "goal": "提升互动",
                "features": ["评论", "@提及", "通知"],
                "metrics": {"engagement_rate": 0.3}
            },
            {
                "version": "v1.2",
                "goal": "内容丰富",
                "features": ["图片滤镜", "位置标签"],
                "metrics": {"content_quality": "improved"}
            }
        ]
```

### 示例 3：渐进式性能优化

**场景**：系统性能问题分阶段解决

```python
class ProgressiveOptimizer:
    """渐进式优化器"""
    
    def __init__(self):
        self.optimization_plan = [
            {
                "iteration": 1,
                "duration": "1周",
                "actions": [
                    "添加数据库索引",
                    "启用查询缓存",
                    "优化Nginx配置"
                ],
                "expected_improvement": "30%",
                "risk": "低"
            },
            {
                "iteration": 2,
                "duration": "2周",
                "actions": [
                    "慢查询优化",
                    "引入Redis缓存热点数据",
                    "静态资源CDN化"
                ],
                "expected_improvement": "50%",
                "risk": "中"
            },
            {
                "iteration": 3,
                "duration": "1月",
                "actions": [
                    "异步化处理非关键路径",
                    "数据库读写分离",
                    "接口响应压缩"
                ],
                "expected_improvement": "70%",
                "risk": "中"
            }
        ]
    
    def get_current_iteration(self, completed: int) -> dict:
        """获取当前迭代计划"""
        if completed < len(self.optimization_plan):
            return self.optimization_plan[completed]
        return None
```

### 示例 4：增量重构

**场景**：遗留代码渐进式重构

```python
# 原始代码（需要重构）
class OrderManager:
    def process_order(self, order_data):
        # 验证（内嵌）
        if not order_data.get('user_id'):
            raise ValueError("No user")
        
        # 计算价格（内嵌）
        total = sum(item['price'] * item['qty'] 
                   for item in order_data['items'])
        
        # 保存订单（内嵌）
        db.execute("INSERT INTO orders ...", total)
        
        return {"order_id": 123, "total": total}

# 迭代1：提取验证逻辑
class OrderValidator:
    @staticmethod
    def validate(order_data):
        if not order_data.get('user_id'):
            raise ValueError("No user")

class OrderManager:
    def process_order(self, order_data):
        OrderValidator.validate(order_data)
        # ... 其余逻辑

# 迭代2：提取价格计算
class PriceCalculator:
    @staticmethod
    def calculate(order_data):
        return sum(item['price'] * item['qty'] 
                  for item in order_data['items'])

class OrderManager:
    def process_order(self, order_data):
        OrderValidator.validate(order_data)
        total = PriceCalculator.calculate(order_data)
        # ... 其余逻辑

# 迭代3：提取存储逻辑
class OrderRepository:
    def save(self, total: float) -> int:
        return db.execute("INSERT INTO orders ...", total)

class OrderManager:
    def __init__(self):
        self.validator = OrderValidator()
        self.calculator = PriceCalculator()
        self.repository = OrderRepository()
    
    def process_order(self, order_data):
        self.validator.validate(order_data)
        total = self.calculator.calculate(order_data)
        order_id = self.repository.save(total)
        return {"order_id": order_id, "total": total}
```

## 结构化分析框架

### 迭代规划速记

```markdown
## 迭代规划速记

### 目标拆解
- 大目标：
- 可交付子目标：
  1. 
  2. 
  3. 

### 迭代安排
| 迭代 | 周期 | 目标 | 交付物 | 成功标准 |
|-----|-----|-----|-------|---------|
| 1 | | | | |
| 2 | | | | |

### 风险项
- 高风险：
- 应对措施：

### 反馈机制
- 数据指标：
- 用户反馈：
- 调整触发条件：
```

## 思考流程

```
┌─────────────────────────────────────────────────────────────┐
│  1. 理解目标                                                  │
│     - 明确大目标是什么                                        │
│     - 成功的标准是什么                                        │
│     - 关键里程碑是什么                                        │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  2. 拆解任务                                                  │
│     - 将大目标拆分为可独立交付的小任务                        │
│     - 确保每个任务有价值且可验证                              │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  3. 评估依赖                                                  │
│     - 分析任务间的依赖关系                                    │
│     - 识别关键路径                                            │
│     - 寻找可以并行化的任务                                    │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  4. 优先级排序                                                │
│     - 按用户价值排序                                          │
│     - 按风险排序（高风险优先）                                │
│     - 按依赖关系排序                                          │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  5. 规划迭代                                                  │
│     - 将任务分配到各迭代                                      │
│     - 确保每个迭代可独立交付                                  │
│     - 平衡迭代粒度（2-4周）                                   │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  6. 定义反馈                                                  │
│     - 为每个迭代定义成功标准                                  │
│     - 建立反馈收集机制                                        │
│     - 确定反馈处理流程                                        │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  7. 识别风险                                                  │
│     - 识别高风险项                                            │
│     - 安排在早期迭代验证                                      │
│     - 准备风险应对计划                                        │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  8. 制定调整策略                                              │
│     - 定义什么情况下需要调整迭代计划                          │
│     - 确定调整触发条件                                        │
│     - 建立调整决策流程                                        │
└─────────────────────────────────────────────────────────────┘
```

## 约束与限制

- 迭代粒度需要平衡（太小 overhead 高，太大风险高）
- 频繁交付需要完善的 CI/CD 支持
- 用户反馈收集需要时间
- 技术债务可能在迭代中累积

## 自检清单

- [ ] 每个迭代都有明确的交付物和成功标准
- [ ] 迭代间依赖最小化
- [ ] 反馈收集机制已建立
- [ ] 技术债务有记录和偿还计划
- [ ] 团队速度已估算并用于规划
- [ ] 风险项已识别并有应对计划
- [ ] 利益相关者了解迭代计划

## 常见陷阱

### 陷阱 1：过度拆分的迭代

**反例**：迭代间高度耦合，无法独立交付

```python
# 反例：迭代1直接调用迭代2的功能
class UserService:
    def create_user(self, user_data):
        user = User.objects.create(**user_data)
        # 错误：直接调用尚未实现的订单模块
        OrderService.create_default_order(user.id)
        return user

# 正确做法：使用事件解耦
class UserService:
    def create_user(self, user_data):
        user = User.objects.create(**user_data)
        # 发布事件，不直接依赖
        EventBus.publish('user.created', {'user_id': user.id})
        return user

# 迭代2实现事件监听
class OrderEventHandler:
    @EventBus.subscribe('user.created')
    def on_user_created(self, event):
        OrderService.create_default_order(event['user_id'])
```

**正确做法**：迭代间通过接口或事件解耦，确保每个迭代可独立交付。

### 陷阱 2：忽视质量的快速交付

**反例**：为赶进度而牺牲代码质量

```python
# 反例：没有验证、错误处理和事务管理
class PaymentProcessor:
    def process(self, amount, user_id):
        user = db.query(f"SELECT * FROM users WHERE id = {user_id}")  # SQL注入
        if user.balance >= amount:
            user.balance -= amount
            db.execute(f"UPDATE users SET balance = {user.balance}")
            return True
        return False

# 正确做法：保证基本质量
class PaymentProcessor:
    def process(self, amount: Decimal, user_id: str) -> PaymentResult:
        if amount <= 0:
            raise ValueError("Amount must be positive")
        
        with transaction.atomic():
            user = User.objects.select_for_update().get(id=user_id)
            if user.balance < amount:
                return PaymentResult.insufficient_funds()
            
            user.balance -= amount
            user.save()
            return PaymentResult.success()
```

**正确做法**：即使快速迭代，也要保证输入验证、错误处理、事务管理等基本质量。

### 陷阱 3：反馈缺失

**反例**：发布后不收集反馈，变成小瀑布

```python
# 反例：没有反馈收集机制
class FeatureReleaser:
    def release(self, feature):
        deploy(feature)
        print(f"{feature} 已发布")
        # 没有收集反馈，直接进入下一迭代

# 正确做法：建立反馈收集机制
class FeatureReleaser:
    def release(self, feature):
        deploy(feature)
        
        # 收集数据反馈
        metrics = {
            'usage': Analytics.get_usage(feature),
            'error_rate': Monitoring.get_error_rate(feature),
            'performance': Monitoring.get_latency(feature)
        }
        
        # 收集用户反馈
        feedback = UserFeedback.collect(feature, duration_days=7)
        
        # 评估是否继续
        if metrics['error_rate'] > 0.01:
            self.rollback(feature)
            return "需要修复后重新发布"
        
        return f"反馈良好，继续下一迭代"
```

**正确做法**：每个迭代发布后必须收集数据指标和用户反馈，用于指导下一迭代。

### 陷阱 4：范围蔓延

**反例**：迭代中随意添加需求

```python
# 反例：迭代中随意加需求
class IterationManager:
    def __init__(self):
        self.planned_features = ["登录", "注册"]
    
    def add_feature_mid_iteration(self, feature):
        # 错误：迭代中随意添加功能
        self.planned_features.append(feature)
        print(f"添加 {feature} 到当前迭代")

# 正确做法：严格范围控制
class IterationManager:
    def __init__(self):
        self.planned_features = ["登录", "注册"]
        self.locked = False
    
    def start_iteration(self):
        self.locked = True
    
    def request_new_feature(self, feature):
        if self.locked:
            return f"{feature} 已记录到下一迭代"
        self.planned_features.append(feature)
```

**正确做法**：迭代开始后锁定范围，新需求放入下一迭代，避免范围蔓延。
