---
name: "skill_review"
description: "Apply code review capabilities for systematic quality checks, identifying potential issues, and sharing knowledge. Invoke when conducting code reviews, PR reviews, or managing technical debt."
---

# 代码审查技能 (Code Review)

## 核心定义
系统性检查代码质量、发现潜在问题、分享知识，确保代码符合团队规范和质量标准。

## 技能能力
- **功能正确性**：逻辑是否符合需求、边界条件覆盖、异常处理
- **可读性**：命名清晰、函数长度适中、注释完整
- **安全性**：SQL注入、XSS、认证授权、敏感信息泄露
- **性能**：N+1查询、大循环、不必要的数据加载
- **技术债务管理**：债务标识、评估、偿还策略

## 执行流程
```
1. 理解上下文 → 需求背景、设计决策、变更范围
2. 整体浏览 → 文件结构、代码组织、架构合理性
3. 详细审查 → 逐行检查、逻辑验证、规范符合度
4. 安全扫描 → 注入风险、权限控制、敏感信息
5. 性能评估 → 算法复杂度、数据库查询、资源使用
6. 输出反馈 → 分类评论、优先级标注、改进建议
```

## 实践要点
1. **对事不对人**：评论代码而非开发者
2. **解释原因**：不仅指出问题，还要解释为什么
3. **提供方案**：给出改进建议或示例代码
4. **区分优先级**：区分必须修改和建议优化
5. **知识共享**：利用Review机会分享最佳实践

## 使用示例

### 示例 1：审查评论

```markdown
## 代码审查意见

### 🔴 必须修改（阻塞性问题）

**1. SQL注入风险 [L2]**
```python
# 当前代码（不安全）
user = db.query(f"SELECT * FROM users WHERE id = {user_id}")

# 建议修改
user = db.query("SELECT * FROM users WHERE id = ?", (user_id,))
```
**原因**：直接拼接SQL字符串存在SQL注入风险。

**2. 敏感信息泄露 [L5-8]**
当前返回完整的用户对象，可能包含密码哈希、手机号等敏感信息。

建议：
```python
return {
    "user": {
        "id": user.id,
        "username": user.username,
        "email": mask_email(user.email)
    }
}
```

### 🟡 建议优化

**3. 缺少错误处理**
建议添加对`user_id`的校验和数据库异常处理。

**4. N+1查询风险**
如果需要在订单中显示商品信息，当前实现可能导致N+1查询。

### 🟢 做得好的点
- 函数职责单一，只做一件事
- 返回数据结构清晰
```

### 示例 2：技术债务评估

```markdown
## 技术债务评估与重构计划

### 债务识别

| 文件 | 债务类型 | 严重程度 | 影响范围 |
|-----|---------|---------|---------|
| user_service.py | 函数过长（200+行） | 高 | 用户模块 |
| order_service.py | 重复代码 | 中 | 订单模块 |
| utils.py | 无单元测试 | 高 | 全局 |
| api/routes.py | 缺少错误处理 | 高 | API层 |

### 债务评估矩阵

```
影响范围
    高 │  ②      ①
       │
    中 │  ④  ③
       │
    低 └───────────
       低   中   高  修复成本
```

- ① 优先处理：高影响、高成本但必须先做
- ② 尽快处理：高影响、低成本，收益明显
- ③ 计划处理：中影响，安排进迭代
- ④ 日常处理：低影响，顺手修改
```

### 示例 3：问题代码识别

```python
# 反例：问题代码
class OrderService:
    def process_order(self, order_id):
        order = db.get_order(order_id)
        if order.status == "pending":
            order.status = "processing"
            db.save(order)
            items = db.get_items(order_id)
            for item in items:
                inventory = db.get_inventory(item.product_id)
                if inventory.stock >= item.quantity:
                    inventory.stock -= item.quantity
                    db.save(inventory)
                else:
                    raise Exception("库存不足")
            order.status = "completed"
            db.save(order)

# 问题分析：
# 1. 事务管理缺失 - 多个操作无事务保护
# 2. 异常处理不当 - 使用通用Exception
# 3. 竞态条件 - 检查库存和扣减之间有间隙
# 4. 日志缺失 - 关键流程无日志
# 5. 魔法字符串 - 状态硬编码

# 正确做法：
class OrderService:
    @transaction.atomic
    def process_order(self, order_id: str) -> None:
        logger.info(f"开始处理订单 | order_id={order_id}")
        
        order = self._get_order(order_id)
        self._validate_order_status(order)
        
        self._update_order_status(order, OrderStatus.PROCESSING)
        
        try:
            self._deduct_inventory(order_id)
            self._update_order_status(order, OrderStatus.COMPLETED)
            logger.info(f"订单处理完成 | order_id={order_id}")
        except InsufficientStockError as e:
            logger.error(f"库存不足 | order_id={order_id}, error={e}")
            self._update_order_status(order, OrderStatus.FAILED)
            raise
```

### 示例 4：审查检查清单

```markdown
## 代码审查检查清单

### 功能正确性
- [ ] 逻辑是否符合需求
- [ ] 边界条件是否覆盖（空值、越界、极值）
- [ ] 异常处理是否完善
- [ ] 是否存在死代码
- [ ] 并发场景是否安全

### 可读性
- [ ] 命名是否清晰表达意图
- [ ] 函数长度是否适中（<50行）
- [ ] 嵌套深度是否可控（<3层）
- [ ] 复杂逻辑是否有注释
- [ ] 代码结构是否清晰

### 安全性
- [ ] 是否存在SQL注入风险
- [ ] 是否存在XSS漏洞
- [ ] 认证/授权是否正确
- [ ] 敏感信息是否泄露
- [ ] 是否有越权访问

### 性能
- [ ] 是否存在N+1查询
- [ ] 是否有大循环低效操作
- [ ] 是否有不必要的数据加载
- [ ] 缓存使用是否合理
- [ ] 算法复杂度是否可接受

### 可维护性
- [ ] 是否违反DRY原则
- [ ] 是否可测试（依赖是否可Mock）
- [ ] 配置是否外置（无硬编码）
- [ ] 是否有技术债务标识（TODO/FIXME）
- [ ] 文档是否更新

### Review评论规范
```
🔴 必须修改 - 阻塞性问题，必须修复才能合并
🟡 建议优化 - 建议修改，但不阻塞合并
🟢 做得好 - 肯定好的实践
❓ 疑问 - 需要澄清的问题
```
```

## 结构化分析框架

### 代码质量评估维度

| 维度 | 权重 | 评估要点 |
|-----|------|---------|
| 功能正确性 | 30% | 逻辑正确、边界覆盖、异常处理 |
| 安全性 | 25% | 注入防护、权限控制、敏感信息 |
| 可读性 | 20% | 命名清晰、结构合理、注释充分 |
| 性能 | 15% | 算法效率、查询优化、资源使用 |
| 可维护性 | 10% | 测试覆盖、文档完整、低耦合 |

### 技术债务评估矩阵

| 债务类型 | 识别方法 | 修复成本 | 风险等级 |
|---------|---------|---------|---------|
| 代码重复 | 代码扫描 | 低 | 低 |
| 函数过长 | 静态检查 | 中 | 中 |
| 缺少测试 | 覆盖率报告 | 高 | 高 |
| 架构腐化 | 架构评审 | 高 | 高 |

## 约束与限制
- 审查应及时，避免阻塞开发
- 评论应建设性，避免攻击性语言
- 严重问题必须修复，建议可讨论
- 知识共享是Review的重要目的

## 自检清单
- [ ] 理解需求背景和变更范围
- [ ] 识别阻塞性问题
- [ ] 标注建议优化项
- [ ] 肯定好的实践
- [ ] 提供改进方案
- [ ] 评论清晰有建设性

## 常见陷阱

### 陷阱 1：忽视上下文

```python
# Reviewer评论："这个函数太长，应该拆分"

# 被审查的代码（退款流程，需要原子性）
def process_refund(self, order_id, amount, reason):
    # 1. 验证订单
    order = Order.objects.get(id=order_id)
    # 2. 验证金额
    if amount <= 0 or amount > order.paid_amount:
        raise InvalidAmountError()
    # 3. 检查退款窗口
    if timezone.now() - order.created_at > timedelta(days=30):
        raise RefundWindowExpiredError()
    # 4. 创建退款记录
    refund = Refund.objects.create(order=order, amount=amount)
    # 5. 调用支付网关
    result = payment_gateway.refund(order.transaction_id, amount)
    # 6. 更新状态
    refund.status = 'completed' if result.success else 'failed'
    refund.save()
    return refund

# Reviewer的问题：
# - 没有了解这是退款流程，需要原子性
# - 拆分可能导致事务边界问题

# 更好的Review方式：
"""
✅ 优点：
- 完整的验证链（订单、金额、时间窗口）
- 清晰的错误处理
- 退款状态追踪完善

🟡 建议：
- 考虑使用事务包装整个流程，确保原子性
- 支付网关调用可以考虑异步化
- 建议添加幂等性检查

整体评价：代码质量良好，逻辑清晰。
"""
```

### 陷阱 2：过度追求完美

```python
# Reviewer要求："这个函数需要支持所有可能的边界情况"

# 原始代码（足够满足需求）
def calculate_discount(price, user_type):
    if user_type == 'vip':
        return price * 0.9
    return price

# Reviewer的过度要求：
# - 支持多种货币
# - 支持动态折扣率
# - 支持组合折扣
# - 支持时间窗口折扣

# 过度设计的结果：100行复杂的折扣逻辑

# 正确的Review方式：
"""
当前代码满足需求。建议：
1. 添加参数类型检查
2. 考虑负数价格的处理
3. 使用常量替代魔法数字0.9

不需要过度设计，保持简单。
"""
```

### 陷阱 3：只挑错不肯定

```python
# 反例：只指出问题，不肯定好的实践

# Reviewer评论：
# - "这里命名不好"
# - "缺少异常处理"
# - "这里有性能问题"

# 更好的Review方式：
"""
✅ 做得好的：
- 函数职责单一，只做一件事
- 使用了类型注解，提高可读性
- 日志记录完整

🟡 建议优化：
- 命名可以更有描述性
- 建议添加参数校验
- 考虑边界情况处理
"""
```

### 陷阱 4：延迟Review

```markdown
# 反例：PR堆积，审查质量下降

场景：
- 开发者提交PR后等待3天才有Review
- Reviewer匆忙浏览，遗漏问题
- 问题在上线后才发现

正确做法：
- 设定SLA：PR提交后24小时内必须Review
- 控制WIP：每人同时进行的PR不超过3个
- 优先处理：阻塞他人的PR优先Review
```

### 陷阱 5：只审代码不审设计

```python
# 反例：只关注代码细节，忽视架构问题

# Reviewer只关注：
# - 命名是否规范
# - 是否有注释
# - 是否符合PEP8

# 但忽视了：
# - 这个服务职责是否清晰
# - 与其他服务的耦合是否合理
# - 是否违反了架构原则

# 正确的Review方式：
"""
🟡 架构层面的建议：
- 这个服务同时处理订单和支付，职责过重
- 建议拆分为OrderService和PaymentService
- 通过事件总线进行通信

🔴 代码层面的问题：
- 直接访问其他服务的数据库，违反服务边界
- 建议通过API或消息进行服务间通信
"""
```
