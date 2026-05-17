---
name: "divide-and-conquer"
description: "Apply divide and conquer thinking to break complex problems into smaller, independent sub-problems. Invoke when facing large complex tasks, debugging intricate issues, or designing modular systems."
---

# 分治思维 (Divide and Conquer)

## 核心定义

分治思维是一种**将复杂问题拆分为独立子问题**的解决策略。通过分解降低复杂度，逐个解决子问题后再组合结果，从而提高可管理性和解决效率。

## 技能能力

- **问题分解**：将大问题拆分为可管理的子问题
- **边界识别**：确保子问题之间边界清晰
- **独立解决**：逐个解决子问题
- **结果整合**：将子问题结果组合为最终方案

## 执行流程

```
1. 理解问题 → 完整理解原问题，明确目标和约束
2. 寻找分解点 → 识别可独立的部分和清晰边界
3. 分解问题 → 拆分为子问题，定义范围和输入输出
4. 识别依赖 → 分析子问题间的依赖关系
5. 逐个解决 → 按优先级或依赖顺序解决子问题
6. 组合验证 → 将结果组合，验证是否解决原问题
```

## 实践要点

1. **子问题独立性**：确保子问题低耦合，可独立解决
2. **可管理粒度**：子问题要足够小，便于理解和解决
3. **高内聚完整**：每个子问题职责完整，不遗漏
4. **可组合还原**：子问题结果能组合还原原问题

## 使用示例

### 示例 1：大函数拆分

**场景**：重构一个500行的处理函数

```python
# 反例：大函数做太多事
class BadOrderProcessor:
    def process_order(self, order_data):
        # 验证（50行）
        if not order_data.get('user_id'):
            raise ValueError("Missing user_id")
        # ... 更多验证代码
        
        # 处理（200行）
        items = order_data['items']
        for item in items:
            # ... 复杂处理逻辑
            pass
        
        # 存储（100行）
        # ... 数据库操作
        
        # 通知（150行）
        # ... 发送各种通知
        
        return result

# 正确做法：按职责分解
class GoodOrderProcessor:
    def process_order(self, order_data):
        # 分解为4个独立步骤
        validated = self._validate(order_data)
        processed = self._process(validated)
        saved = self._save(processed)
        self._notify(saved)
        return saved
    
    def _validate(self, data):
        """验证数据"""
        # 验证逻辑
        return validated_data
    
    def _process(self, data):
        """处理数据"""
        # 处理逻辑
        return processed_data
    
    def _save(self, data):
        """存储数据"""
        # 存储逻辑
        return saved_data
    
    def _notify(self, data):
        """发送通知"""
        # 通知逻辑
```

### 示例 2：二分法调试

**场景**：定位系统偶发崩溃问题

```python
class BinarySearchDebugger:
    """二分法调试器"""
    
    def debug(self, system):
        """二分定位问题"""
        # 步骤1：确定问题范围（代码 vs 环境）
        if self._test_in_clean_env(system):
            return "环境问题"
        
        # 步骤2：定位到模块
        module = self._binary_search_modules(system.modules)
        
        # 步骤3：定位到函数
        function = self._binary_search_functions(module.functions)
        
        # 步骤4：定位到具体代码
        line = self._binary_search_lines(function.lines)
        
        return f"问题在 {module}.{function}:{line}"
    
    def _binary_search_modules(self, modules):
        """二分查找问题模块"""
        if len(modules) == 1:
            return modules[0]
        
        mid = len(modules) // 2
        # 禁用前半部分，测试是否仍有问题
        if self._test_with_disabled(modules[:mid]):
            return self._binary_search_modules(modules[mid:])
        else:
            return self._binary_search_modules(modules[:mid])
```

### 示例 3：微服务拆分

**场景**：将单体应用拆分为微服务

```python
class ServiceDecomposer:
    """服务拆分器"""
    
    def decompose(self, monolith):
        """按业务领域分解"""
        # 识别业务领域
        domains = self._identify_domains(monolith)
        
        services = {}
        for domain in domains:
            # 每个领域独立为服务
            service = self._extract_service(monolith, domain)
            services[domain.name] = service
        
        # 定义服务间接口
        self._define_interfaces(services)
        
        return services
    
    def _identify_domains(self, monolith):
        """识别业务领域"""
        return [
            Domain("user", ["login", "register", "profile"]),
            Domain("order", ["cart", "checkout", "payment"]),
            Domain("product", ["catalog", "inventory", "search"]),
        ]
    
    def _extract_service(self, monolith, domain):
        """提取领域为独立服务"""
        return MicroService(
            name=domain.name,
            code=monolith.extract(domain.components),
            database=monolith.extract_schema(domain.tables)
        )
```

## 结构化分析框架

```
分治分析框架
├── 1. 问题理解
│   ├── 原问题描述
│   ├── 复杂度分析
│   └── 目标明确
│
├── 2. 分解策略
│   ├── 按功能分解
│   ├── 按层级分解
│   ├── 按时间分解
│   └── 按复杂度分解
│
├── 3. 子问题定义
│   ├── 输入定义
│   ├── 输出定义
│   ├── 范围界定
│   └── 验收标准
│
├── 4. 依赖分析
│   ├── 识别依赖关系
│   ├── 消除循环依赖
│   └── 确定解决顺序
│
└── 5. 组合验证
    ├── 组合方式
    ├── 边界处理
    └── 完整性验证
```

## 思考流程

当激活分治思维时，按以下步骤进行深度分析：

**步骤 1：理解问题**
- 完整理解原问题的需求和约束
- 分析问题的复杂度来源
- 明确解决目标和验收标准

**步骤 2：寻找分解点**
- 哪些部分可以独立处理？
- 按什么维度分解最合适？
- 分解后的粒度是否合适？

**步骤 3：分解与定义**
- 拆分为独立的子问题
- 定义每个子问题的输入输出
- 明确子问题的验收标准

**步骤 4：依赖分析**
- 识别子问题间的依赖关系
- 消除或简化循环依赖
- 确定子问题的解决顺序

**步骤 5：解决与组合**
- 逐个解决子问题
- 验证每个子问题的解
- 组合结果并验证完整性

## 约束与限制

1. **过度分解**：子问题太小会增加管理成本
2. **边界模糊**：子问题职责不清会导致混乱
3. **依赖复杂**：子问题间高度耦合会失去分治意义
4. **组合困难**：分解后难以还原原问题
5. **失去整体观**：过度关注子问题可能忽视整体

## 自检清单

- [ ] 问题是否分解到可管理的大小？
- [ ] 子问题之间边界是否清晰？
- [ ] 子问题是否能独立解决？
- [ ] 组合后是否能还原原问题？
- [ ] 依赖关系是否明确且最小化？
- [ ] 是否保持了整体视角？

## 常见陷阱

### 陷阱 1：过度分解

```python
# 反例：过度分解，管理成本剧增
class OverDecomposed:
    def register_user(self, username, password, email):
        # 每个验证都做成独立服务
        UsernameValidationService().validate(username)
        PasswordValidationService().validate(password)
        EmailValidationService().validate(email)
        AvailabilityService().check(username)
        HashingService().hash(password)
        UserCreationService().create(username, password, email)
        EmailService().send_welcome(email)
        # 问题：7个服务，通信开销大，部署复杂

# 正确做法：合理粒度
class ProperlyDecomposed:
    def register_user(self, username, password, email):
        # 内部模块化，但保持合理粒度
        self._validate_input(username, password, email)
        self._check_availability(username)
        user = self._create_user(username, password, email)
        self._send_notification(user)
        return user
```

### 陷阱 2：边界模糊

```python
# 反例：子问题职责不清
class BlurryBoundary:
    def create_order(self, user_id, items):
        # OrderService做了太多领域的事
        user = User.objects.get(id=user_id)  # 应该属于UserService
        for item in items:
            product = Product.objects.get(id=item['id'])
            if product.stock < item['qty']:  # 应该属于InventoryService
                raise OutOfStockError()
            product.stock -= item['qty']  # 越界操作
            product.save()
        total = sum(item['price'] * item['qty'] for item in items)  # 应该属于PricingService
        order = Order.objects.create(user=user, total=total)
        send_email(user.email, 'Order created')  # 应该属于NotificationService
        return order

# 正确做法：清晰边界
class ClearBoundary:
    def __init__(self):
        self.user_service = UserService()
        self.inventory_service = InventoryService()
        self.pricing_service = PricingService()
    
    def create_order(self, user_id, items):
        user = self.user_service.validate(user_id)
        reservation = self.inventory_service.reserve(items)
        total = self.pricing_service.calculate(items)
        order = Order.objects.create(user=user, total=total, reservation=reservation)
        return order
```

### 陷阱 3：依赖复杂

```python
# 反例：子问题高度耦合
class HighCoupling:
    def process_a(self):
        # A依赖B的结果
        result_b = self.process_b()
        return result_b + self.process_c()
    
    def process_b(self):
        # B又依赖A的状态
        return self.state_from_a + self.process_d()
    
    def process_c(self):
        # C依赖B和D
        return self.process_b() + self.process_d()

# 正确做法：消除循环依赖
class LowCoupling:
    def process(self):
        # 按依赖顺序执行
        step1 = self._step1()  # 无依赖
        step2 = self._step2(step1)  # 依赖step1
        step3 = self._step3(step1)  # 依赖step1
        return self._combine(step2, step3)
```

### 陷阱 4：忽视组合成本

```python
# 反例：分解后组合困难
class BadComposition:
    def solve(self, problem):
        # 分解为子问题
        result_a = self.solve_a(problem)
        result_b = self.solve_b(problem)
        result_c = self.solve_c(problem)
        
        # 组合时发现格式不兼容，需要大量转换
        converted_a = self._convert_format_a(result_a)
        converted_b = self._convert_format_b(result_b)
        converted_c = self._convert_format_c(result_c)
        
        return self._merge(converted_a, converted_b, converted_c)

# 正确做法：统一接口设计
class GoodComposition:
    def solve(self, problem):
        # 子问题使用统一接口
        sub_problems = self._decompose(problem)
        results = [sp.solve() for sp in sub_problems]
        
        # 直接组合，无需转换
        return self._combine(results)
```
