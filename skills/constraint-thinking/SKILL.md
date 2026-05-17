---
name: "constraint-thinking"
description: "Apply constraint thinking to embrace limitations as catalysts for creative solutions. Invoke when facing resource limitations, tight deadlines, or when designing within strict requirements."
---

# 约束思维 (Constraint Thinking)

## 核心定义
在限制中寻找最优解。约束不是阻碍，而是创新的催化剂。明确约束边界，在边界内寻找最佳方案。区分硬约束（不可违背）和软约束（可以挑战），将约束转化为设计优势。

## 技能能力
- **约束识别**：明确识别所有约束条件
- **边界划定**：区分硬约束和软约束
- **创新求解**：在约束内寻找创造性方案
- **约束利用**：将约束转化为设计优势

## 执行流程
```
1. 识别约束 → 有哪些限制条件？明确还是隐含？
2. 分类约束 → 硬约束（不可违背）vs 软约束（可以挑战）
3. 验证约束 → 真实存在吗？可以协商吗？
4. 边界划定 → 明确可行解空间和禁区
5. 创新求解 → 在约束内寻找最优，把约束变特色
6. 沟通确认 → 与相关方确认约束，必要时协商调整
```

## 思考流程

### Step 1: 识别约束
- 硬约束：预算、法规、物理极限（不可违背）
- 软约束：偏好、习惯、假设（可以挑战）
- 隐含约束：未明说但实际存在的限制

### Step 2: 分类约束
| 类型 | 示例 | 性质 |
|------|------|------|
| **硬约束** | 预算、法规、物理极限 | 不可违背 |
| **软约束** | 偏好、习惯、假设 | 可以挑战 |
| **时间约束** | 截止日期、里程碑 | 通常硬约束 |
| **资源约束** | 人力、硬件、预算 | 通常硬约束 |
| **技术约束** | 技术栈、兼容性 | 可能可协商 |

### Step 3: 验证约束
- 这个约束真实存在吗？
- 可以协商吗？
- 有变通空间吗？
- 是假设还是事实？

### Step 4: 边界划定
- 明确可行解空间
- 识别禁区
- 找到边界上的机会

### Step 5: 创新求解
- 在约束内寻找最优
- 把约束转化为特色
- 设计多个备选方案

### Step 6: 沟通确认
- 与相关方确认约束
- 说明设计如何在约束内工作
- 必要时协商调整约束

## 实践要点
1. **明确约束边界**：不明确的约束是项目风险
2. **区分软硬约束**：不要把软约束当硬约束
3. **在边界内最大化**：约束内寻找最优解
4. **把约束变特色**：Twitter的140字、Haiku的17音
5. **挑战假设约束**：验证"必须"是否真的是必须

## 使用示例

### 示例 1：文件上传约束设计

```python
# 反例：忽视隐性约束
class FileUploader:
    def upload(self, file, user_id):
        # 只考虑功能，忽视约束
        file_path = f"/uploads/{user_id}/{file.name}"
        with open(file_path, 'wb') as f:
            f.write(file.content)
        return file_path

# 忽视的约束：磁盘空间、文件大小、文件类型、并发限制、存储成本

# 正确做法：明确所有约束
class FileUploader:
    MAX_FILE_SIZE = 100 * 1024 * 1024  # 100MB
    ALLOWED_TYPES = {'jpg', 'png', 'pdf', 'doc'}
    MAX_STORAGE_PER_USER = 1024 * 1024 * 1024  # 1GB
    
    def upload(self, file, user_id):
        # 约束检查
        if file.size > self.MAX_FILE_SIZE:
            raise FileTooLargeError(f"超过{self.MAX_FILE_SIZE}限制")
        
        ext = file.name.split('.')[-1].lower()
        if ext not in self.ALLOWED_TYPES:
            raise InvalidFileTypeError(f"不支持{ext}类型")
        
        current = self.get_user_storage(user_id)
        if current + file.size > self.MAX_STORAGE_PER_USER:
            raise StorageLimitError("用户存储空间不足")
        
        # 在约束内实现功能
        return self.secure_save(file, user_id)
```

### 示例 2：过度约束（RESTful教条）

```python
# 反例：把软约束当硬约束
class OverConstrainedAPI:
    # 为了严格遵守RESTful，设计复杂URL
    @app.route('/api/v1/users/<user_id>/orders/<order_id>/items/<item_id>/status', methods=['PUT'])
    def update_item_status(user_id, order_id, item_id):
        pass  # URL过于复杂

# 正确做法：区分硬约束和软约束
class PragmaticAPI:
    @app.route('/api/v1/orders/<order_id>/items/<item_id>', methods=['PUT'])
    @require_auth()  # 硬约束：必须认证
    @rate_limit()    # 硬约束：必须限流
    def update_item(order_id, item_id):
        """软约束：RESTful风格可以灵活处理"""
        data = request.json
        allowed_fields = ['status', 'price', 'quantity']
        updates = {k: v for k, v in data.items() if k in allowed_fields}
        return order_service.update_item(order_id, item_id, updates)
```

### 示例 3：有限预算系统设计

```markdown
## 约束分析

### 硬约束
- 预算：10万元
- 时间：3个月上线
- 法规：数据必须境内存储

### 软约束
- 技术栈：建议用Java（可协商）
- 部署方式：建议自建（可协商）

### 创新方案
| 传统方案 | 约束内创新方案 | 节省 |
|---------|---------------|------|
| 自建MySQL集群 | 云数据库RDS | 运维成本-80% |
| 自建K8s | Serverless | 基础设施成本-60% |
| 购买商业授权 | 开源框架 | 授权费-100% |
| 全功能自研 | 购买SaaS服务 | 开发时间-50% |

### 结果
- 预算内完成
- 按时上线
- 质量超预期
- 把约束变成了成本优势
```

### 示例 4：移动端性能约束

```python
# 反例：忽视性能约束
class HeavyPage:
    def render(self):
        # 加载所有资源
        return self.load_all_images() + self.load_all_scripts()
    # 结果：首屏5秒，用户流失

# 正确做法：在约束内创新
class PerformanceOptimizedPage:
    MAX_FIRST_SCREEN_SIZE = 500 * 1024  # 500KB
    MAX_LOAD_TIME = 1000  # 1秒
    
    def render(self):
        # 约束内优化
        return {
            'critical_css': self.inline_critical_css(),
            'lazy_images': self.lazy_load_images(),
            'code_split': self.split_by_route(),
            'skeleton': self.show_skeleton_first()
        }
    
    def lazy_load_images(self):
        """首屏只加载视口内图片"""
        return [img for img in self.images if img.in_viewport]
    
    def split_by_route(self):
        """代码分割，按需加载"""
        return self.current_route_chunks_only()
```

## 结构化分析框架

### 约束分析表

| 约束 | 类型 | 可协商？ | 影响 | 应对策略 |
|------|------|----------|------|----------|
| 预算10万 | 硬约束 | 否 | 限制技术选型 | 云服务+开源 |
| 3个月上线 | 硬约束 | 否 | 限制功能范围 | MVP+迭代 |
| 用Java | 软约束 | 是 | 技术栈选择 | 评估后决定 |
| 必须自建 | 假设约束 | 是 | 部署方式 | 挑战假设 |

### 可行解空间

```
        禁区        可行解空间        禁区
    <─────────│─────────────────│─────────>
              │                 │
            硬约束边界        硬约束边界
              │                 │
              │  <──软约束──>   │
              │   (可调整)      │
```

## 约束与限制
- 硬约束不可违背，试图突破会导致项目失败
- 过度约束会限制创新，需要区分软硬约束
- 约束可能变化，需要持续沟通确认
- 约束分析需要时间，但不能跳过

## 自检清单
- [ ] 我列出了所有约束吗？
- [ ] 我区分了硬约束和软约束吗？
- [ ] 我验证了假设约束吗？
- [ ] 我的方案在约束边界内吗？
- [ ] 我利用了约束创造优势吗？
- [ ] 我与相关方确认了约束吗？

## 常见陷阱

### 陷阱 1：约束盲区

```python
# 反例：忽视隐性约束
class QuickFeature:
    def implement(self):
        # 只考虑功能，不考虑约束
        return self.quick_implementation()
        # 上线后发现：不支持高并发、不安全、无法扩展

# 正确做法：约束清单
class ConstrainedFeature:
    CONSTRAINTS = {
        'performance': {'qps': 1000, 'latency': '100ms'},
        'security': {'auth': 'required', 'encrypt': 'tls'},
        'scalability': {'horizontal': True, 'stateless': True}
    }
    
    def implement(self):
        # 在约束内设计
        assert self.meets_constraints(self.CONSTRAINTS)
        return self.implementation
```

### 陷阱 2：过度约束

```python
# 反例：教条主义
class DogmaticDesigner:
    def design(self):
        # "必须"使用微服务
        # "必须"使用事件驱动
        # "必须"使用最新技术
        return self.over_engineered_solution()

# 正确做法：务实设计
class PragmaticDesigner:
    def design(self, constraints):
        # 根据实际约束选择方案
        if constraints['team_size'] < 5:
            return 'monolith'  # 小团队用单体
        return 'microservices'  # 大团队用微服务
```

### 陷阱 3：约束抱怨

```python
# 反例：抱怨而不是利用
class Complainer:
    def __init__(self):
        self.excuses = [
            "预算太少",
            "时间不够",
            "资源不足"
        ]
    
    def deliver(self):
        # 因为约束，交付质量差
        return self.poor_quality_result()

# 正确做法：利用约束创新
class Innovator:
    def __init__(self, constraints):
        self.constraints = constraints
    
    def deliver(self):
        # 把约束变成特色
        # 预算少 → 精简设计
        # 时间紧 → 聚焦核心
        return self.creative_solution_within_constraints()
```

### 陷阱 4：约束忽视

```python
# 反例：试图突破硬约束
class ConstraintBreaker:
    def optimize(self, data):
        # 试图在O(1)空间复杂度内排序
        # 这是不可能的（比较排序下界O(n log n)）
        return self.impossible_solution()

# 正确做法：接受约束，寻找替代方案
class ConstraintAcceptor:
    def optimize(self, data, memory_limit):
        if len(data) * 8 > memory_limit:
            # 约束内选择：外部排序
            return self.external_sort(data)
        # 约束内选择：快速排序
        return self.quick_sort(data)
```
