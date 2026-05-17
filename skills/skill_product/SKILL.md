---
name: "skill_product"
description: "Apply product and requirement analysis capabilities for translating business goals into technical metrics and SLI/SLO functions. Invoke when analyzing requirements, clarifying constraints, or prioritizing features."
---

# 需求分析技能 (Product & Requirements)

## 核心定义
将模糊业务目标转化为精准的技术指标与SLI/SLO函数，识别约束并制定优先级。

## 技能能力
- **需求澄清**：利用故事板、用户路径图、契约反推明确目标
- **约束识别**：识别合规要求、地域法规、供应链约束、技术限制
- **优先级评估**：价值-复杂度矩阵、MoSCoW方法
- **验收标准定义**：明确的成功标准、测试场景
- **用户故事编写**：As a... I want... So that...

## 执行流程
```
1. 需求收集 → 用户访谈、文档分析、竞品研究
2. 需求澄清 → 消除歧义、明确边界、识别约束
3. 价值评估 → 业务价值、用户价值、技术价值
4. 优先级排序 → 价值-复杂度矩阵、MoSCoW
5. 验收定义 → 验收标准、测试场景、完成定义
6. 技术转化 → 用户故事、技术任务、SLI/SLO
```

## 实践要点
1. **主动提问**：面对模糊需求必须主动澄清
2. **用户视角**：从用户价值出发，而非技术实现
3. **验收先行**：先定义验收标准，再开始开发
4. **约束识别**：尽早识别技术、业务、合规约束
5. **价值导向**：优先做高价值、低成本的需求

## 使用示例

### 示例 1：需求澄清对话

```markdown
用户输入：帮我做个用户管理功能

需求澄清对话：

【功能范围】
1. 用户管理包含哪些操作？
   □ 用户注册/登录
   □ 用户信息查看/编辑
   □ 用户权限管理
   □ 用户状态管理（启用/禁用）
   □ 用户删除

2. 用户角色体系如何设计？
   - 单角色（普通用户/管理员）
   - 多角色（RBAC权限模型）
   - 自定义角色

【技术约束】
3. 技术栈偏好？
   - 前端：React / Vue / Angular
   - 后端：Node.js / Python / Java / Go
   - 数据库：MySQL / PostgreSQL / MongoDB

4. 安全要求？
   - 密码策略（长度、复杂度）
   - 登录安全（验证码、多因素认证）
   - 会话管理（JWT / Session）

【验收标准】
5. 成功的标准是什么？
   - 并发用户数？
   - 响应时间要求？
   - 可用性要求（SLA）？
```

### 示例 2：用户故事编写

```markdown
## 用户故事

### 买家端
作为 买家
我希望 能够查看我的订单列表和详情
以便 了解订单状态和物流信息

验收标准：
- [ ] 订单列表展示订单号、商品、金额、状态
- [ ] 订单详情展示完整商品信息和物流轨迹
- [ ] 支持按状态筛选订单
- [ ] 支持取消未发货订单

### 商家端
作为 商家
我希望 能够管理订单和处理退款
以便 高效完成交易和售后服务

验收标准：
- [ ] 订单列表支持分页和筛选
- [ ] 可修改订单状态（发货、完成）
- [ ] 可处理退款申请
- [ ] 可导出订单数据
```

### 示例 3：优先级排序（MoSCoW）

```markdown
## 优先级（MoSCoW）

### Must Have（必须有）
- 订单创建和支付
- 订单状态管理
- 基础订单查询

### Should Have（应该有）
- 订单搜索和筛选
- 退款流程
- 订单导出

### Could Have（可以有）
- 批量操作
- 高级统计报表
- 自动退款

### Won't Have（暂不做）
- 预售功能
- 拼团功能
- 分期付款
```

### 示例 4：需求冲突解决

```markdown
## 冲突解决框架

场景：产品经理要求3天上线，技术评估需要2周

### 1. 理解双方立场
- 产品：市场竞争压力、用户痛点、商业机会
- 技术：质量风险、技术债务、团队负荷

### 2. 量化分析
- 延迟上线的成本：用户流失、收入损失、竞争劣势
- 匆忙上线的风险：Bug修复成本、声誉损失、技术债务

### 3. 寻找中间方案
- MVP方案：核心功能3天上线，后续迭代完善
- 分期交付：每3天交付一个可用版本
- 资源调整：增加人手或调整其他优先级

### 4. 制定决策
- 明确范围：MVP包含什么，不包含什么
- 设定标准：MVP的最低质量要求
- 规划后续：MVP后的迭代计划
```

## 结构化分析框架

### 价值-复杂度矩阵

```
      高价值
         │
  低复杂度 │ 高复杂度
    ┌─────┼─────┐
    │  ②  │  ①  │
    │快赢  │规划  │
────┼─────┼─────┼────
    │  ④  │  ③  │
    │放弃  │谨慎  │
    └─────┼─────┘
         │
      低价值
```

- ① 高价值高复杂度：规划执行
- ② 高价值低复杂度：立即执行
- ③ 低价值高复杂度：谨慎评估
- ④ 低价值低复杂度：放弃或空闲时做

### 需求评估检查表

| 维度 | 检查项 | 通过标准 |
|-----|-------|---------|
| 完整性 | 需求描述 | 清晰无歧义 |
| 可测试性 | 验收标准 | 明确可验证 |
| 可行性 | 技术评估 | 可实现 |
| 价值性 | 用户价值 | 明确的价值 |
| 约束性 | 依赖关系 | 已理清 |

## 约束与限制
- 需求必须可验收、可测试
- 技术约束需尽早识别
- 优先级需与业务方确认
- 变更需走变更流程

## 自检清单
- [ ] 需求描述清晰无歧义
- [ ] 验收标准明确可测试
- [ ] 依赖关系已理清
- [ ] 优先级合理
- [ ] 风险已识别
- [ ] 约束已确认
- [ ] 用户价值明确
- [ ] 技术可行性已评估

## 常见陷阱

### 陷阱 1：需求蔓延（镀金）

```python
# 反例：实现超出需求的额外功能
class UserRegistration:
    def register(self, data):
        user = self.create_user(data)
        
        # 镀金：用户可能不需要的功能
        self.send_welcome_email(user)  # 需求没说
        self.create_default_avatar(user)  # 需求没说
        self.subscribe_to_newsletter(user)  # 需求没说
        self.analyze_user_behavior(user)  # 需求没说
        
        return user

# 正确做法：严格遵循需求
class UserRegistration:
    def register(self, data):
        user = self.create_user(data)
        
        # 只实现需求明确的功能
        if data.get('require_email_verification'):
            self.send_verification_email(user)
        
        return user
```

### 陷阱 2：验收标准模糊

```python
# 反例：模糊的需求实现
# 需求："实现用户搜索功能"
class UserSearch:
    def search(self, query):
        # 模糊：搜索什么字段？如何排序？返回多少结果？
        return User.objects.filter(name__contains=query)

# 正确做法：明确的验收标准
# 需求文档：
"""
用户搜索功能验收标准：
1. 支持按用户名、邮箱搜索
2. 支持模糊匹配（前缀匹配）
3. 结果按用户名字母顺序排序
4. 默认返回20条结果
5. 支持分页（page, page_size参数）
6. 响应时间 < 200ms
"""

class UserSearch:
    def search(self, query, page=1, page_size=20):
        """搜索用户 - 明确实现"""
        users = User.objects.filter(
            Q(username__istartswith=query) | 
            Q(email__istartswith=query)
        ).order_by('username')
        
        return users.paginate(page=page, per_page=min(page_size, 100))
```

### 陷阱 3：忽视非功能需求

```python
# 反例：只关注功能，忽视性能、安全
class OrderService:
    def get_orders(self, user_id):
        # 功能正确但性能差
        orders = Order.objects.all()  # 加载所有订单！
        return [o for o in orders if o.user_id == user_id]

# 正确做法：考虑非功能需求
class OrderService:
    def get_orders(self, user_id):
        # 功能正确 + 性能优化
        orders = Order.objects.filter(user_id=user_id).select_related('items')
        
        # 添加缓存
        cache_key = f"orders:{user_id}"
        if cached := cache.get(cache_key):
            return cached
        
        result = list(orders)
        cache.set(cache_key, result, timeout=300)
        return result
```

### 陷阱 4：忽视用户价值

```python
# 反例：从系统角度出发，而非用户价值
class ReportGenerator:
    def generate_daily_report(self):
        # 生成技术细节报告，用户看不懂
        return {
            "db_query_count": 15000,
            "cache_hit_rate": 0.95,
            "thread_pool_size": 50
        }

# 正确做法：从用户价值出发
class ReportGenerator:
    def generate_daily_report(self):
        # 生成用户关心的业务指标
        return {
            "total_orders": 1250,
            "total_revenue": 50000.00,
            "average_order_value": 40.00,
            "top_selling_products": [...]
        }
```

### 陷阱 5：忽视约束识别

```python
# 反例：未识别合规约束
class UserService:
    def delete_user(self, user_id):
        # 直接删除，违反数据保留法规
        User.objects.get(id=user_id).delete()

# 正确做法：识别并遵守约束
class UserService:
    def delete_user(self, user_id):
        # 合规约束：用户数据需保留3年
        user = User.objects.get(id=user_id)
        user.status = "deleted"
        user.deleted_at = timezone.now()
        user.personal_data = None  # 脱敏
        user.save()
        
        # 记录删除操作
        AuditLog.record("user_deleted", user_id=user_id)
```
