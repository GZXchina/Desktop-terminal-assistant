---
name: "probabilistic-thinking"
description: "Apply probabilistic thinking and Bayesian updating to make decisions under uncertainty. Invoke when doing technology selection, risk assessment, or facing uncertain decisions with multiple possible outcomes."
---

# 概率思维与贝叶斯更新 (Probabilistic Thinking)

## 核心定义
遇到不确定的技术选择或架构方案时，不追求绝对正确，追求期望值为正。随着新证据出现，更新判断而非死守旧结论。

## 技能能力
1. **概率量化**：将不确定性转化为可比较的概率区间
2. **期望值计算**：评估决策的期望收益与风险
3. **贝叶斯更新**：根据新证据动态调整判断
4. **置信度校准**：识别过度自信或过度悲观

## 执行流程

```
识别不确定性 → 设定先验概率 → 收集证据 → 评估似然度 → 计算后验概率 → 决策与行动
```

1. **识别不确定性**
   - 列出决策中的不确定因素
   - 区分已知和未知

2. **设定先验概率**
   - 基于现有信息给出初始判断
   - 使用粗略估计（高/中/低 或 具体百分比）

3. **收集证据**
   - 寻找能验证或证伪假设的信息
   - 注意正反两方面的证据

4. **评估似然度**
   - 如果假设成立，证据出现的概率？
   - 如果假设不成立，证据出现的概率？

5. **计算后验概率**
   - 根据贝叶斯公式更新判断
   - 或直接根据新证据调整概率

6. **决策与行动**
   - 比较各选项的期望值
   - 选择期望值最高的方案
   - 制定风险对冲策略

## 实践要点

### 1. 量化概率（即使粗略）
- 不要只说"可能"或"不太可能"
- 给出一个大致概率区间：10%、30%、70%、90%
- 区分"我不知道"和"50%概率"

### 2. 计算期望值
```
期望值 = 成功概率 × 成功收益 - 失败概率 × 失败成本
```
- 即使成功率低，如果收益巨大且成本可控，期望值仍可能为正
- 即使成功率高，如果失败后果灾难性，期望值可能为负

### 3. 贝叶斯更新
- 先验概率：基于当前信息的初始判断
- 新证据：获得的新信息
- 后验概率：更新后的判断

## 使用示例

### 场景1：技术选型时 - 评估可行性
```
正在评估：是否引入新技术

激活概率思维：
- 成功落地的概率？
  → 团队熟悉度30%、生态成熟度70%、社区支持80%
- 综合评估：60%概率成功
- 失败的成本？
  → 时间浪费2个月、团队士气下降
- 成功的收益？
  → 开发效率提升30%

决策：期望值计算后决定小规模试点，而非全面推广
```

### 场景2：项目排期时 - 风险评估
```
正在排期：新功能开发

激活概率思维：
- 最乐观：2周（20%概率）
- 最可能：3周（50%概率）
- 最悲观：5周（30%概率）
- 期望值：3.1周

决策：对外承诺4周，内部按3周执行，留1周缓冲
```

### 场景3：调试时 - 定位根因
```
正在调试：偶发bug

激活概率思维：
- 假设1：数据库连接池问题（概率40%）
- 假设2：缓存一致性问题（概率30%）
- 假设3：代码逻辑问题（概率20%）
- 假设4：网络问题（概率10%）

行动：按概率从高到低排查，先检查连接池配置
```

### 场景4：Code Review时 - 风险评估
```
正在Review：重构方案

激活概率思维：
- 重构成功的概率：70%
- 引入新bug的概率：30%
- 回滚的成本：2天
- 收益：维护性提升

决策：分阶段重构，每阶段都有回滚点，降低风险
```

## 结构化分析框架

```markdown
## 概率思维速记

### 不确定性识别
- 不确定因素：
- 已知：
- 未知：

### 概率评估
- 成功概率：
- 失败概率：
- 置信度：

### 收益与成本
- 成功收益：
- 失败成本：
- 期望值：

### 证据更新
- 新证据：
- 对概率的影响：
- 更新后概率：

### 决策
- 期望值比较：
- 风险对冲：
```

## 思考流程

```
┌─────────────────────────────────────────────────────────────┐
│  1. 识别不确定性                                              │
│     - 这个决策中有哪些不确定因素？                              │
│     - 哪些是已知的，哪些是未知的？                             │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  2. 设定先验概率                                              │
│     - 基于现有信息，成功的概率是多少？                          │
│     - 给出一个粗略估计（高/中/低 或 具体百分比）                │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  3. 收集证据                                                  │
│     - 哪些证据能支持我的假设？                                │
│     - 哪些证据能证伪我的假设？（更重要）                       │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  4. 贝叶斯更新                                                │
│     - 新证据如何改变我的判断？                                │
│     - 更新后的概率是多少？                                    │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  5. 计算期望值                                                │
│     - 成功收益 × 成功概率 - 失败成本 × 失败概率               │
│     - 各选项的期望值比较                                      │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  6. 决策与风险对冲                                            │
│     - 选择期望值最高的方案                                    │
│     - 制定风险对冲策略（Plan B）                              │
└─────────────────────────────────────────────────────────────┘
```

## 约束与限制

### 红线（绝对不能）
- 不能用模糊词汇（"可能"、"大概"）替代概率评估
- 不能忽视小概率高影响事件
- 不能死守初始判断，无视新证据

### 偏好（建议遵循）
- 优先给出粗略概率，而非精确但错误的数字
- 优先记录判断依据，便于后续校准
- 优先寻找能证伪假设的证据

### 风险提示
- **过度自信**：高估自己的预测能力
- **忽视基础概率**：只看新证据，忽略先验概率
- **确认偏误**：只关注支持自己观点的证据
- **结果偏见**：以结果好坏判断决策质量

## 自检清单
- [ ] 我给关键事件分配了大致概率吗？
- [ ] 我考虑了失败的可能性和成本吗？
- [ ] 我的判断是基于证据还是直觉？
- [ ] 如果有新信息，我会更新判断吗？
- [ ] 我是否混淆了"不确定"和"50%概率"？

## 常见陷阱

### 陷阱1：过度自信

**反例**：高估自己的预测能力

```python
# 反例：不给缓冲的估算
class OverconfidentEstimator:
    def estimate(self, tasks):
        total = 0
        for task in tasks:
            total += task.optimistic_days  # 只用乐观估计
        return total  # "我们一定能按时完成"

# 正确做法：概率分布估算
class ProbabilisticEstimator:
    def estimate(self, tasks):
        total_expected = 0
        total_variance = 0
        
        for task in tasks:
            # 三点估算：乐观、最可能、悲观
            o, m, p = task.optimistic, task.most_likely, task.pessimistic
            expected = (o + 4*m + p) / 6
            variance = ((p - o) / 6) ** 2
            
            total_expected += expected
            total_variance += variance
        
        std = total_variance ** 0.5
        return {
            '50%概率完成': total_expected,
            '70%概率完成': total_expected + 0.5 * std,
            '90%概率完成': total_expected + 1.3 * std,
            '95%概率完成': total_expected + 1.6 * std
        }
```

**正确做法**：使用三点估算，给出概率区间而非单点估计

### 陷阱2：忽视基础概率

**反例**：只看新证据，忽略先验概率

```python
# 反例：忽视历史数据
class NaiveBugClassifier:
    def classify(self, description):
        # 只看关键词，不考虑历史分布
        if 'database' in description:
            return 'database'  # 但历史数据80%是后端bug
        return 'backend'

# 正确做法：贝叶斯思维
class BayesianClassifier:
    def __init__(self):
        # 先验概率（历史分布）
        self.prior = {'backend': 0.80, 'frontend': 0.15, 'database': 0.05}
    
    def classify(self, description):
        posteriors = {}
        for module, prior_prob in self.prior.items():
            # 结合先验和新证据
            likelihood = self.calc_likelihood(description, module)
            posteriors[module] = prior_prob * likelihood
        
        # 归一化后返回概率最高的
        total = sum(posteriors.values())
        return {k: v/total for k, v in posteriors.items()}
```

**正确做法**：结合先验概率和新证据，使用贝叶斯更新

### 陷阱3：确认偏误

**反例**：只关注支持自己观点的证据

```python
# 反例：选择性收集证据
class BiasedEvaluator:
    def evaluate_framework(self, framework):
        # 只找正面评价
        reviews = search_positive_reviews(framework)
        return f"{framework} 很好，有 {len(reviews)} 个好评"

# 正确做法：主动寻找反面证据
class BalancedEvaluator:
    def evaluate_framework(self, framework):
        positive = search_reviews(framework, sentiment='positive')
        negative = search_reviews(framework, sentiment='negative')
        
        # 特别关注反面证据
        deal_breakers = [r for r in negative if r.severity == 'high']
        
        return {
            '优点': positive[:5],
            '缺点': negative[:5],
            '致命问题': deal_breakers,
            '建议': '小规模试点' if deal_breakers else '可以使用'
        }
```

**正确做法**：主动寻找反面证据，特别是能证伪假设的证据

### 陷阱4：结果偏见

**反例**：以结果好坏判断决策质量

```python
# 反例：事后诸葛亮
class ResultBiasedReviewer:
    def review_decision(self, decision, outcome):
        if outcome == 'success':
            return "决策很明智"  # 成功了就是明智？
        else:
            return "决策很愚蠢"  # 失败了就是愚蠢？

# 正确做法：基于决策时的信息评估
class ProcessOrientedReviewer:
    def review_decision(self, decision, outcome, context_at_decision_time):
        # 评估决策过程，而非结果
        quality_checks = [
            '是否考虑了多种方案？',
            '是否评估了概率和风险？',
            '是否有明确的判断依据？',
            '是否制定了风险对冲？'
        ]
        
        score = sum(1 for check in quality_checks 
                   if decision.meets_criterion(check))
        
        return {
            '决策质量': 'good' if score >= 3 else 'poor',
            '结果': outcome,  # 结果与决策质量分开
            '教训': '好决策也可能坏结果，关键是过程'
        }
```

**正确做法**：评估决策过程的质量，而非仅以结果论英雄
