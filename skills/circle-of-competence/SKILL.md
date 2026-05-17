---
name: "circle-of-competence"
description: "Apply circle of competence thinking to clearly define boundaries of expertise and make decisions within your domain. Invoke when evaluating technology choices, assessing team capabilities, or deciding build vs buy."
---

# 能力圈思维 (Circle of Competence)

## 核心定义
清晰界定自己/团队的能力边界，圈内深耕，圈外谨慎。不盲目追逐新技术，也不固步自封。在能力圈内做决策，在能力圈外寻求帮助。

## 技能能力
- **能力评估**：客观评估当前技术能力和经验
- **边界识别**：明确区分熟悉和陌生的领域
- **学习规划**：制定扩展能力圈的计划
- **风险识别**：识别能力圈外的风险

## 执行流程
```
1. 技术盘点 → 列出所有相关技术，评估熟练程度
2. 诚实评估 → 对每个技术问自己4个问题
3. 边界划定 → 核心圈/熟悉圈/学习圈/圈外
4. 决策制定 → 圈内自主决策，圈外寻求帮助
5. 学习计划 → 优先级排序，渐进扩展
6. 定期回顾 → 能力圈变化，学习成果验证
```

## 思考流程

### Step 1: 技术盘点
- 列出所有相关技术
- 评估熟练程度
- 标注使用经验

### Step 2: 诚实评估
问自己4个问题：
- 我真正理解这个技术的原理吗？
- 我经历过它的生产环境问题吗？
- 我能独立排查它的故障吗？
- 我知道它的边界和陷阱吗？

### Step 3: 边界划定
| 层次 | 特征 | 行动 |
|------|------|------|
| **核心圈** | 精通，能指导他人 | 继续深耕，建立壁垒 |
| **熟悉圈** | 用过，能独立完成 | 保持，适度扩展 |
| **学习圈** | 了解，需要指导 | 小范围试点 |
| **圈外** | 不了解 | 谨慎，寻求专家 |

### Step 4: 决策制定
- 核心圈/熟悉圈：自主决策
- 学习圈：小范围试点，预留学习时间
- 圈外：寻求专家、购买服务、或放弃

### Step 5: 学习计划
- 从熟悉圈边缘开始扩展
- 通过实际项目学习
- 向专家学习
- 预留学习时间

### Step 6: 定期回顾
- 能力圈变化
- 新技术评估
- 学习成果验证

## 实践要点
1. **诚实评估**：区分真正理解和表面了解
2. **圈内决策**：在能力圈内做关键决策
3. **渐进扩展**：从熟悉圈边缘开始学习
4. **承认无知**：不知道时勇于承认
5. **寻求帮助**：能力圈外寻求专家帮助

## 使用示例

### 示例 1：技术选型能力匹配

```markdown
## 消息队列选型 - 能力圈分析

### 团队能力盘点
| 技术 | 层次 | 经验 | 信心度 |
|------|------|------|--------|
| RabbitMQ | 核心圈 | 2年生产使用 | 高 |
| Kafka | 学习圈 | 了解概念，POC过 | 中 |
| Pulsar | 圈外 | 完全不了解 | 低 |

### 需求分析
- 吞吐量：中等（<1万/秒）
- 可靠性：高（不能丢消息）
- 延迟：毫秒级

### 决策
- 选用 RabbitMQ（核心圈）
- 理由：
  1. 团队熟悉，风险可控
  2. 需求简单，RabbitMQ完全满足
  3. 可以专注业务，不折腾技术
  4. 后续需要更高吞吐时再考虑Kafka
```

### 示例 2：达克效应代码示例

```python
# 反例：无知者无畏，高估自己的能力
# 开发者："区块链很简单，我自己实现一个"

class DIYBlockchain:
    def add_block(self, data):
        block = {
            'data': data,
            'prev_hash': self.chain[-1]['hash'] if self.chain else '0',
            'timestamp': time.time()
        }
        block['hash'] = hashlib.md5(str(block).encode()).hexdigest()  # MD5不安全！
        self.chain.append(block)

# 问题：使用不安全的MD5、没有共识机制、无数安全问题

# 正确做法：承认能力边界，使用成熟方案
from web3 import Web3

class BlockchainClient:
    """使用成熟的区块链库"""
    def __init__(self, provider_url):
        self.w3 = Web3(Web3.HTTPProvider(provider_url))
    
    def send_transaction(self, to, value):
        # 使用经过安全审计的库
        return self.w3.eth.send_transaction({
            'to': to, 'value': value, 'gas': 21000,
            'gasPrice': self.w3.toWei('50', 'gwei')
        })
```

### 示例 3：项目评估风险识别

```python
# 反例：接手遗留项目时不评估能力圈
class LegacyProjectTaker:
    def take_project(self, project):
        # 不评估就直接承诺
        return "没问题，3个月完成"
        # 结果：项目延期6个月，质量差

# 正确做法：能力圈评估
class CompetenceAwareTaker:
    def assess_project(self, project):
        assessment = {
            'core': ['业务逻辑', 'Java后端'],  # 核心圈
            'familiar': ['数据库优化'],        # 熟悉圈
            'learning': ['原有架构'],          # 学习圈
            'outside': ['特定领域算法']        # 圈外
        }
        
        # 圈外部分需要额外支持
        if assessment['outside']:
            return {
                'decision': '有条件接受',
                'conditions': [
                    '聘请领域专家顾问',
                    '预留2个月学习时间',
                    '核心圈部分自主完成'
                ]
            }
```

### 示例 4：学习规划渐进扩展

```python
# 反例：急于求成，直接上生产
class RushLearner:
    def learn_k8s(self):
        # 看完文档就直接在生产部署
        deploy_to_production(kubernetes_cluster)
        # 结果：生产故障，回滚

# 正确做法：渐进式扩展能力圈
class GradualLearner:
    def learn_k8s_plan(self):
        return [
            {'stage': 1, 'tech': 'Docker Compose', 'duration': '2周', 'env': '本地'},
            {'stage': 2, 'tech': '单节点K8s', 'duration': '1月', 'env': '测试'},
            {'stage': 3, 'tech': '小集群试点', 'duration': '2月', 'env': '预发布'},
            {'stage': 4, 'tech': '生产使用', 'duration': '3月+', 'env': '生产'},
        ]
```

## 结构化分析框架

### 能力圈评估表

| 技术 | 核心圈 | 熟悉圈 | 学习圈 | 圈外 | 决策 |
|------|--------|--------|--------|------|------|
| | ✓ | | | | 自主使用 |
| | | ✓ | | | 可以使用 |
| | | | ✓ | | 小范围试点 |
| | | | | ✓ | 寻求帮助 |

### 决策矩阵

```
能力层次
    高 │  自主决策      
       │
    中 │  试点验证
       │
    低 │  寻求帮助
       └───────────
       低        高  业务重要性
```

## 约束与限制
- 不能高估自己的能力（达克效应）
- 不能为了"先进"选择圈外技术
- 不能固步自封，拒绝学习
- 扩展能力圈需要时间，不能急于求成

## 自检清单
- [ ] 我诚实评估了自己的能力吗？
- [ ] 这个技术在哪个能力圈层次？
- [ ] 我有足够的经验做这个决策吗？
- [ ] 如果出问题，我能解决吗？
- [ ] 我需要寻求专家帮助吗？

## 常见陷阱

### 陷阱 1：达克效应

```python
# 反例：无知者无畏
class OverconfidentDeveloper:
    def implement_crypto(self):
        # "加密算法很简单，我自己实现"
        return self.diy_encryption()  # 安全漏洞百出

# 正确做法：承认能力边界
class HumbleDeveloper:
    def implement_crypto(self):
        # "加密超出我的能力圈，使用成熟库"
        return bcrypt.hashpw(password, bcrypt.gensalt())
```

### 陷阱 2：盲目追逐新技术

```python
# 反例：为了新而新
class TechChaser:
    def choose_stack(self):
        # 团队熟悉Django，但新项目用Go
        return "Go + Microservices"  # 开发效率下降50%

# 正确做法：能力匹配
class PragmaticChooser:
    def choose_stack(self, team_skills):
        if 'Django' in team_skills['core']:
            return "Django"  # 风险低，效率高
```

### 陷阱 3：固步自封

```python
# 反例：拒绝学习
class StaticDeveloper:
    def __init__(self):
        self.skills = ['jQuery', 'PHP']  # 2010年的技能
    
    def new_project(self):
        return "用jQuery吧，我熟悉"  # 技术债务累积

# 正确做法：渐进学习
class GrowingDeveloper:
    def expand_competence(self):
        # 每年学习1-2个新技术
        self.learning_plan = ['React', 'TypeScript']
```

### 陷阱 4：过度自信

```python
# 反例：以为懂其实不懂
class OverconfidentArchitect:
    def design_microservices(self):
        # "微服务很简单，拆就行了"
        return self.split_monolith()  # 分布式事务、数据一致性问题

# 正确做法：谨慎评估
class CautiousArchitect:
    def design_microservices(self):
        if self.competence_level('microservices') < 'familiar':
            return "先小范围试点，或请专家指导"
```
