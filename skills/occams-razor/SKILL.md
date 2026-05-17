---
name: "occams-razor"
description: "Apply Occam's Razor to prefer the simplest solution that adequately solves the problem. Invoke when evaluating multiple solutions, simplifying code, or making design decisions with competing alternatives."
---

# 奥卡姆剃刀 (Occam's Razor)

## 核心定义

如无必要，勿增实体。在多个方案都能解决问题时，选择最简单的那个。简单意味着更容易理解、维护、调试。

## 技能能力

1. **复杂度识别**：识别方案中的不必要复杂度
2. **简化设计**：去除不必要的抽象和依赖
3. **方案对比**：比较多个方案的复杂度
4. **本质聚焦**：聚焦核心需求，去除镀金

## 执行流程

1. **明确问题**
   - 核心需求是什么？
   - 必须满足什么条件？
   - nice-to-have有哪些？

2. **列出方案**
   - 方案A：简单直接
   - 方案B：适度抽象
   - 方案C：全面设计

3. **评估复杂度**
   - 代码复杂度
   - 依赖复杂度
   - 认知复杂度
   - 维护复杂度

4. **应用剃刀**
   - 哪个方案最简单？
   - 简单方案能满足需求吗？
   - 如果不能，次简单的呢？

5. **验证可行性**
   - 简单方案真的能工作吗？
   - 边界情况能处理吗？
   - 性能可接受吗？

6. **实施与记录**
   - 实施简单方案
   - 记录为什么选择它
   - 记录被剃掉的部分（未来可能需要）

## 实践要点

### 1. 剃刀原则
```
- 能用简单方案，不用复杂方案
- 能少一个依赖，就少一个
- 能少一层抽象，就少一层
- 能用标准库，不引入新库
```

### 2. 复杂度来源
| 来源 | 示例 | 剃刀动作 |
|------|------|----------|
| **过度设计** | 为不存在的需求预留扩展 | 只解决当前问题 |
| **过早抽象** | 只有两处相似就提取公共 | 等待更多重复 |
| **技术堆砌** | 为了用新技术而用 | 用熟悉的简单技术 |
| **镀金需求** | 用户没说要的功能 | 去掉，等用户要再加 |

### 3. 简单性指标
- 代码行数少
- 依赖数量少
- 概念数量少
- 执行路径少

## 使用示例

### 示例 1：认证方案选择

**场景**：内部管理系统用户认证

```python
# 方案A：复杂方案（JWT + Redis + 刷新令牌）
class JWTAuthSystem:
    """JWT认证系统 - 复杂方案"""
    
    def __init__(self):
        self.jwt_secret = generate_secret()
        self.redis_client = Redis()
        self.refresh_token_store = {}
    
    def login(self, username, password):
        # 验证用户
        user = self._verify_user(username, password)
        # 生成访问令牌
        access_token = self._generate_jwt(user, expires=3600)
        # 生成刷新令牌
        refresh_token = self._generate_refresh_token(user)
        # 存储到Redis
        self.redis_client.set(f"token:{access_token}", user.id, ex=3600)
        return {"access_token": access_token, "refresh_token": refresh_token}
    
    def _generate_jwt(self, user, expires):
        # JWT生成逻辑
        pass
    
    def _generate_refresh_token(self, user):
        # 刷新令牌逻辑
        pass

# 方案B：简单方案（Session + Cookie）
class SessionAuthSystem:
    """Session认证系统 - 简单方案"""
    
    def login(self, username, password):
        user = self._verify_user(username, password)
        # 使用框架内置Session
        session['user_id'] = user.id
        return {"success": True}
    
    def logout(self):
        session.pop('user_id', None)

# 奥卡姆剃刀决策
class AuthDecision:
    """认证方案决策"""
    
    def __init__(self):
        self.requirements = {
            "internal_system": True,
            "sso_required": False,
            "user_count": "< 1000",
            "scale": "small"
        }
    
    def decide(self):
        """决策逻辑"""
        if self.requirements["internal_system"] and \
           not self.requirements["sso_required"] and \
           self.requirements["scale"] == "small":
            return {
                "choice": "SessionAuthSystem",
                "reason": "内部系统、无SSO需求、用户量少，Session足够",
                "benefits": ["开发快", "维护简单", "无JWT坑"],
                "development_time": "1天 vs 1周"
            }
        return {"choice": "JWTAuthSystem"}
```

### 示例 2：数据导出功能

**场景**：Excel导出功能实现

```python
# 反例：过度设计
class OverEngineeredExport:
    """过度设计的导出系统"""
    
    def __init__(self):
        self.message_queue = MessageQueue()
        self.distributed_storage = DistributedStorage()
        self.workflow_engine = WorkflowEngine()
    
    def export(self, query):
        # 提交到消息队列
        job_id = self.message_queue.submit({
            "type": "export",
            "query": query
        })
        # 工作流处理
        self.workflow_engine.start_workflow(job_id)
        return {"job_id": job_id, "status": "processing"}

# 正确做法：简单方案
class SimpleExport:
    """简单导出系统"""
    
    def export_to_excel(self, data):
        """直接内存生成Excel"""
        import pandas as pd
        
        # 数据量小，直接处理
        df = pd.DataFrame(data)
        output = BytesIO()
        df.to_excel(output, index=False)
        output.seek(0)
        return output

# 决策分析
class ExportDecision:
    """导出方案决策"""
    
    def analyze(self):
        return {
            "requirements": {
                "data_volume": "< 1万条",
                "frequency": "每天几次",
                "sync_required": True
            },
            "decision": "SimpleExport",
            "reason": "数据量小、频率低，同步处理即可",
            "code_lines": "10行 vs 数百行",
            "maintenance": "简单 vs 复杂"
        }
```

### 示例 3：配置读取功能

**场景**：应用配置管理

```python
# 反例：过度设计
class ConfigCenter:
    """配置中心 - 过度设计"""
    
    def __init__(self):
        self.remote_client = RemoteConfigClient()
        self.cache = LocalCache()
        self.hot_reload = HotReloadManager()
        self.version_manager = VersionManager()
    
    def get_config(self, key):
        # 先查本地缓存
        value = self.cache.get(key)
        if value is None:
            # 远程获取
            value = self.remote_client.get(key)
            self.cache.set(key, value)
        return value

# 正确做法：简单方案
class SimpleConfig:
    """简单配置 - 配置文件"""
    
    def __init__(self, config_file="config.yaml"):
        import yaml
        with open(config_file) as f:
            self.config = yaml.safe_load(f)
    
    def get(self, key, default=None):
        return self.config.get(key, default)

# 决策逻辑
class ConfigDecision:
    """配置方案决策"""
    
    def decide(self, context):
        if context["config_change_frequency"] == "rare" and \
           not context["need_hot_reload"]:
            return {
                "choice": "SimpleConfig",
                "reason": "配置很少变更，不需要热更新，配置文件足够",
                "future": "如果需要热更新，再引入配置中心"
            }
        return {"choice": "ConfigCenter"}
```

### 示例 4：任务调度选型

**场景**：定时任务调度

```python
# 反例：引入重量级框架
class ComplexScheduler:
    """复杂调度 - Quartz/XXL-JOB"""
    
    def __init__(self):
        self.scheduler = QuartzScheduler()
        self.job_store = JDBCJobStore()
        self.thread_pool = ThreadPool(10)
    
    def schedule_job(self, job):
        self.scheduler.schedule(job)

# 正确做法：简单方案
class SimpleScheduler:
    """简单调度 - Spring Scheduler / Crontab"""
    
    # Spring Boot 方式
    @scheduled(cron="0 0 2 * * ?")
    def clean_logs(self):
        """每天凌晨2点清理日志"""
        LogCleaner.run()

# 决策分析
class SchedulerDecision:
    """调度方案决策"""
    
    def analyze(self):
        return {
            "requirements": {
                "task_type": "定时清理日志",
                "distributed": False,
                "complex_scheduling": False
            },
            "decision": "SimpleScheduler",
            "reason": "只是定时清理日志，不需要分布式调度",
            "implementation": "20行代码搞定，不引入新依赖"
        }
```

## 结构化分析框架

### 奥卡姆剃刀速记

```markdown
## 奥卡姆剃刀速记

### 问题
- 核心需求：
- 必须条件：
- nice-to-have：

### 方案对比
| 方案 | 复杂度 | 依赖 | 代码量 | 满足需求？ |
|------|--------|------|--------|-----------|
| A | | | | |
| B | | | | |
| C | | | | |

### 剃刀决策
- 选择方案：
- 理由：
- 被剃掉的部分：

### 未来可能
- 什么情况下需要复杂方案？
- 触发条件：
```

## 思考流程

```
┌─────────────────────────────────────────────────────────────┐
│  1. 明确核心需求                                              │
│     - 必须功能 vs nice-to-have                               │
│     - 区分真正的需求和镀金需求                                │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  2. 列出可行方案                                              │
│     - 从最简单到最复杂排序                                    │
│     - 包括"什么都不做"的选项                                  │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  3. 评估复杂度                                                │
│     - 代码量                                                  │
│     - 依赖数量                                                │
│     - 认知负担                                                │
│     - 维护成本                                                │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  4. 应用剃刀                                                  │
│     - 选择最简单的可行方案                                    │
│     - 如无必要，勿增实体                                      │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  5. 验证可行性                                                │
│     - 简单方案能满足所有必要需求？                            │
│     - 边界情况能处理吗？                                      │
│     - 性能可接受吗？                                          │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  6. 考虑未来                                                  │
│     - 记录被剃掉的部分                                        │
│     - 明确什么情况下需要复杂方案                              │
│     - 设计扩展路径                                            │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  7. 实施与监控                                                │
│     - 实施简单方案                                            │
│     - 保持代码整洁                                            │
│     - 监控是否满足需求                                        │
└─────────────────────────────────────────────────────────────┘
```

## 约束与限制

### 红线（绝对不能）
- 不能为了简单而忽视必要功能
- 不能用简单方案处理复杂需求
- 不能忽视性能、安全等非功能需求

### 偏好（建议遵循）
- 优先选择依赖少的方案
- 优先使用标准库
- 优先延迟引入抽象
- 优先去掉镀金功能

### 风险提示
- **过度简化**：功能缺失
- **忽视扩展**：未来难以修改
- **性能问题**：简单方案性能差
- **维护困难**：过于简单导致重复代码

## 自检清单

- [ ] 这个复杂度是必要的吗？
- [ ] 有更简单的方案吗？
- [ ] 简单方案能满足需求吗？
- [ ] 这个抽象现在就需要吗？
- [ ] 这个依赖能去掉吗？

## 常见陷阱

### 陷阱 1：过度简化

**反例**：为了简单而忽视必要功能

```python
# 反例：明文存储密码
class SimpleAuth:
    def __init__(self):
    self.users = {}  # username -> password (明文)
    
    def register(self, username, password):
        self.users[username] = password  # 明文存储！
    
    def login(self, username, password):
        return self.users.get(username) == password

# 正确做法：必要的安全措施不能简化
import bcrypt

class SecureAuth:
    def __init__(self):
        self.users = {}
        self.failed_attempts = {}
    
    def register(self, username, password):
        # 密码强度检查（必要功能）
        if not self._is_strong_password(password):
            raise WeakPasswordError()
        
        # 哈希存储（必要安全措施）
        hashed = bcrypt.hashpw(password.encode(), bcrypt.gensalt())
        self.users[username] = hashed
    
    def login(self, username, password):
        # 防暴力破解（必要安全措施）
        if self._is_locked_out(username):
            raise AccountLockedError()
        
        stored_hash = self.users.get(username)
        if stored_hash and bcrypt.checkpw(password.encode(), stored_hash):
            self._reset_attempts(username)
            return True
        else:
            self._record_failed_attempt(username)
            return False
```

**正确做法**：安全措施、数据验证等必要功能不能简化。

### 陷阱 2：忽视扩展

**反例**：过于简单，未来难以扩展

```python
# 反例：只支持一种支付方式
class PaymentProcessor:
    def process(self, amount, method):
        if method == 'alipay':
            return self._call_alipay(amount)
        else:
            raise NotSupportedError()

# 正确做法：简单但可扩展
from abc import ABC, abstractmethod

class PaymentMethod(ABC):
    @abstractmethod
    def pay(self, amount): pass

class AlipayPayment(PaymentMethod):
    def pay(self, amount):
        return self._call_alipay_api(amount)

class PaymentProcessor:
    def __init__(self):
        self.methods = {}
    
    def register_method(self, name, method):
        self.methods[name] = method
    
    def process(self, amount, method_name):
        method = self.methods.get(method_name)
        if not method:
            raise NotSupportedError(f"Method {method_name} not supported")
        return method.pay(amount)

# 使用
processor = PaymentProcessor()
processor.register_method('alipay', AlipayPayment())
processor.register_method('wechat', WechatPayment())
# 添加新方式无需修改原有代码
```

**正确做法**：在简单性和可扩展性之间找到平衡，使用插件化等简单扩展机制。

### 陷阱 3：性能陷阱

**反例**：简单方案导致性能问题

```python
# 反例：简单但性能差
class SimpleSearch:
    """简单搜索 - 遍历所有数据"""
    
    def search(self, keyword):
        results = []
        for item in self.all_data:  # 数据量大时性能极差
            if keyword in item.name:
                results.append(item)
        return results

# 正确做法：在简单和性能间平衡
class BalancedSearch:
    """平衡方案 - 简单索引"""
    
    def __init__(self):
        self.data = []
        self.index = {}  # 简单索引
    
    def add(self, item):
        self.data.append(item)
        # 建立简单索引
        for word in item.name.split():
            if word not in self.index:
                self.index[word] = []
            self.index[word].append(item)
    
    def search(self, keyword):
        # 使用索引，但实现简单
        return self.index.get(keyword, [])
```

**正确做法**：评估简单方案的性能影响，必要时引入适度优化。

### 陷阱 4：过早优化

**反例**：为不存在的需求预留扩展

```python
# 反例：为不存在的需求设计
class OverDesignedCache:
    """过度设计的缓存"""
    
    def __init__(self):
        self.distributed_mode = False
        self.cluster_nodes = []
        self.replication_factor = 3
        self.consistency_level = "QUORUM"
        # ... 大量配置
    
    def get(self, key):
        if self.distributed_mode:
            # 复杂的分布式逻辑
            pass
        else:
            return self.local_cache.get(key)

# 正确做法：先简单实现
class SimpleCache:
    """简单缓存"""
    
    def __init__(self):
        self.cache = {}
    
    def get(self, key):
        return self.cache.get(key)
    
    def set(self, key, value):
        self.cache[key] = value

# 当需要分布式时，再扩展
class DistributedCache(SimpleCache):
    """分布式缓存 - 需要时再实现"""
    pass
```

**正确做法**：先解决当前问题，当需求真正出现时再扩展。
