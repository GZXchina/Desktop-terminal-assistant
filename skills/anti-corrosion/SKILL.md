---
name: "anti-corrosion"
description: "Apply anti-corrosion thinking to prevent technical debt accumulation and code decay. Invoke when integrating legacy systems, managing technical debt, or establishing code quality gates."
---

# 防腐思维 (Anti-Corrosion Thinking)

## 核心定义
防腐思维是一种**防止技术债务累积和代码腐化**的主动防御思维。通过持续重构、边界隔离和质量门禁，保持代码库健康，防止"破窗效应"导致的系统质量下降。

## 技能能力
- **技术债务管理**：识别、量化和规划偿还技术债务
- **代码腐化预防**：建立防止代码质量下降的机制
- **防腐层设计**：隔离外部依赖和遗留系统的影响
- **重构策略制定**：规划安全、渐进式的代码重构
- **质量门禁建立**：设置代码提交的自动质量检查

## 执行流程
```
1. 识别腐化点 → 代码审查、静态分析、指标监控
2. 评估影响 → 判断腐化范围和严重程度
3. 制定策略 → 重构、隔离或重写
4. 建立防护 → 添加测试、门禁、文档
5. 持续监控 → 防止再次腐化
```

## 实践要点
1. **预防优于修复**：建立机制防止腐化发生
2. **童子军规则**：离开代码时要比发现时更干净
3. **持续小规模重构**：避免大规模重构的风险
4. **自动化防护**：用工具代替人工检查
5. **隔离污染**：防止腐化扩散到健康代码

## 使用示例

### 示例 1：防腐层设计

**场景**：集成老旧第三方系统，接口设计糟糕

**反例**：直接耦合遗留系统
```python
# 反例：直接调用遗留系统，数据格式混乱
class OrderService:
    def create_order(self, order_data):
        # 直接调用遗留API，字段命名混乱
        response = legacy_api.post("/api/v1/ord", {
            "cust_ref": order_data["customer_id"],
            "tot_amt": int(order_data["amount"] * 100),
            "ord_dt": order_data["date"].replace("-", "")
        })
        return response["ord_ref_nbr"]
```

**正例**：使用防腐层隔离
```python
# 正例：防腐层隔离遗留系统复杂性
@dataclass
class Order:
    customer_id: str
    amount: Decimal
    created_at: datetime

class LegacySystemACL:
    """遗留系统防腐层"""
    
    def create_order(self, order: Order) -> str:
        # 转换数据格式
        payload = {
            "cust_ref": order.customer_id,
            "tot_amt": int(order.amount * 100),  # 转分
            "ord_dt": order.created_at.strftime("%Y%m%d")
        }
        
        response = self._call_legacy_api("/api/v1/ord", payload)
        return response["ord_ref_nbr"]  # 字段名转换
    
    def _call_legacy_api(self, endpoint: str, data: dict) -> dict:
        # 统一错误处理、日志、熔断逻辑
        ...

class OrderService:
    def __init__(self, legacy_acl: LegacySystemACL):
        self.legacy = legacy_acl
    
    def create_order(self, order: Order) -> str:
        return self.legacy.create_order(order)
```

### 示例 2：技术债务管理

**场景**：系统性管理技术债务

```python
@dataclass
class TechnicalDebt:
    id: str
    title: str
    debt_type: str  # 'code', 'architecture', 'test', 'doc'
    severity: str   # 'critical', 'high', 'medium', 'low'
    estimated_hours: float
    created_at: datetime

class DebtManager:
    """技术债务管理器"""
    
    def __init__(self):
        self.debts: List[TechnicalDebt] = []
    
    def add_debt(self, debt: TechnicalDebt):
        """登记技术债务"""
        self.debts.append(debt)
    
    def get_priority_list(self) -> List[TechnicalDebt]:
        """获取优先级排序的债务列表"""
        severity_order = {'critical': 0, 'high': 1, 'medium': 2, 'low': 3}
        return sorted(
            self.debts,
            key=lambda d: (severity_order[d.severity], d.created_at)
        )
    
    def plan_repayment(self, hours_per_sprint: float = 40) -> List[Dict]:
        """制定还债计划"""
        plan = []
        remaining = hours_per_sprint
        sprint = 1
        
        for debt in self.get_priority_list():
            if remaining < debt.estimated_hours:
                sprint += 1
                remaining = hours_per_sprint
            
            plan.append({
                "sprint": sprint,
                "debt_id": debt.id,
                "title": debt.title,
                "hours": debt.estimated_hours
            })
            remaining -= debt.estimated_hours
        
        return plan

# 使用示例
manager = DebtManager()
manager.add_debt(TechnicalDebt(
    id="DEBT-001",
    title="订单模块缺少单元测试",
    debt_type="test",
    severity="high",
    estimated_hours=16,
    created_at=datetime.now()
))

plan = manager.plan_repayment(hours_per_sprint=40)
```

### 示例 3：代码腐化识别与重构

**场景**：识别腐化代码并制定重构方案

**反例**：混合职责、缺乏抽象的腐化代码
```python
# 反例：混合职责、SQL注入、硬编码
class UserManager:
    def process(self, data):
        if data.get('type') == 'vip' and not data.get('vip_code'):
            return {'error': 'no code'}
        
        # SQL注入风险
        cursor = db.cursor()
        cursor.execute(f"INSERT INTO users (name) VALUES ('{data['name']}')")
        
        # 硬编码配置
        import smtplib
        server = smtplib.SMTP('smtp.gmail.com')
        server.sendmail('admin@site.com', [data['email']], 'Welcome!')
        
        return {'success': True}
```

**正例**：职责分离、依赖注入的防腐代码
```python
# 正例：职责分离、依赖注入
@dataclass
class User:
    name: str
    email: str
    user_type: str
    vip_code: Optional[str] = None

class UserValidator:
    """用户验证 - 单一职责"""
    
    @staticmethod
    def validate(data: dict) -> tuple[bool, Optional[str]]:
        if not data.get('name'):
            return False, "Name required"
        if data.get('type') == 'vip' and not data.get('vip_code'):
            return False, "VIP code required"
        return True, None

class UserRepository:
    """用户存储 - 隔离数据库"""
    
    def save(self, user: User) -> int:
        cursor = db.cursor()
        cursor.execute(
            "INSERT INTO users (name, email) VALUES (?, ?)",
            (user.name, user.email)  # 参数化查询防注入
        )
        return cursor.lastrowid

class NotificationService:
    """通知服务 - 可替换实现"""
    
    def __init__(self, config: dict):
        self.smtp_host = config['smtp_host']
        self.sender = config['sender']
    
    def send_welcome(self, email: str):
        ...

class UserService:
    """用户服务 - 协调各组件"""
    
    def __init__(self, repo: UserRepository, notifier: NotificationService):
        self.repo = repo
        self.notifier = notifier
    
    def create_user(self, data: dict) -> dict:
        # 验证
        is_valid, error = UserValidator.validate(data)
        if not is_valid:
            return {'success': False, 'error': error}
        
        # 保存
        user = User(**data)
        user_id = self.repo.save(user)
        
        # 通知（非关键路径）
        self.notifier.send_welcome(user.email)
        
        return {'success': True, 'user_id': user_id}
```

## 结构化分析框架

### 技术债务评估框架

| 维度 | 评估项 | 评分标准 |
|-----|-------|---------|
| **影响范围** | 影响模块数 | 1-3:低, 4-7:中, 8+:高 |
| **修复成本** | 预估工时 | <4h:低, 4-16h:中, >16h:高 |
| **累积速度** | 恶化速度 | 慢:每月, 中:每周, 快:每天 |
| **业务影响** | 对业务的影响 | 无:低, 效率:中, 故障:高 |

### 代码腐化识别清单

- [ ] 圈复杂度 > 10
- [ ] 函数长度 > 50 行
- [ ] 重复代码块
- [ ] 魔法数字/字符串
- [ ] 深层嵌套 (>3层)
- [ ] 混合职责
- [ ] 缺乏单元测试
- [ ] 硬编码配置

## 约束与限制
- 防腐层会增加一定的开发 overhead
- 技术债务的利息难以精确量化
- 重构可能引入新的风险
- 团队需要认同代码质量文化

## 自检清单
- [ ] 新代码遵循团队编码规范
- [ ] 关键路径有单元测试覆盖
- [ ] 外部依赖有防腐层隔离
- [ ] 技术债务已登记并定期 review
- [ ] 代码提交前通过质量门禁
- [ ] 每次迭代分配时间还债
- [ ] 代码审查关注架构腐化

## 常见陷阱

### 陷阱 1：破窗效应
**问题**：看到烂代码就随意添加更多烂代码

```python
# 反例：看到烂代码，继续添加更多烂代码
class OrderManager:
    def process_order(self, order_data):
        # 已有烂代码：直接SQL注入
        result = db.execute(f"SELECT * FROM products WHERE id = {order_data['product_id']}")
        # 新代码也遵循坏模式（破窗效应）
        user = db.execute(f"SELECT * FROM users WHERE id = {order_data['user_id']}")
        ...

# 正确做法：不要让它更糟，逐步改善
class OrderManager:
    def process_order(self, order_data):
        # 使用ORM替代SQL注入
        product = Product.objects.filter(id=order_data['product_id']).first()
        user = User.objects.filter(id=order_data['user_id']).first()
        ...
```

### 陷阱 2：过度设计的防腐层
**问题**：只有一个支付网关，却引入复杂抽象

```python
# 反例：过度复杂的抽象
class PaymentGatewayInterface(ABC):
    @abstractmethod
    def connect(self): pass
    @abstractmethod
    def process_payment(self, amount): pass

class PaymentGatewayFactory:
    def create(self, gateway_type): ...

class StripeAdapter(PaymentGatewayInterface):
    def connect(self): ...
    def authenticate(self): ...
    def process_payment(self, amount): ...

# 正确做法：简单直接的防腐层
class PaymentService:
    def __init__(self):
        self.stripe = stripe.Client(api_key=settings.STRIPE_KEY)
    
    def charge(self, amount: Decimal) -> PaymentResult:
        try:
            response = self.stripe.charge.create(amount=int(amount * 100))
            return PaymentResult.success(response.id)
        except stripe.error.CardError as e:
            return PaymentResult.failed(str(e))
```

### 陷阱 3：忽视测试的重构
**问题**：重构时不写测试，导致回归

```python
# 反例：无测试直接重构
class Calculator:
    def calculate(self, a, b):
        # 直接修改实现，无测试保障
        return a * b  # 原来是 a + b，改错了！

# 正确做法：先写测试，再重构
class Calculator:
    def calculate(self, a: int, b: int) -> int:
        return a + b

def test_calculator():
    calc = Calculator()
    assert calc.calculate(2, 3) == 5  # 测试保障
    assert calc.calculate(-1, 1) == 0  # 边界情况
```

### 陷阱 4：一次性大重构
**问题**：试图一次性解决所有债务，风险高

```python
# 反例：一次性重写整个模块
# 风险：引入大量bug，难以回滚

# 正确做法：小步快跑，渐进式重构
# Sprint 1: 提取验证逻辑
# Sprint 2: 分离数据访问层
# Sprint 3: 引入依赖注入
# Sprint 4: 添加单元测试
```
