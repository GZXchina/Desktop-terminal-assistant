---
name: "bayesian-updating"
description: "Apply Bayesian updating to revise beliefs and probabilities based on new evidence. Invoke when evaluating hypotheses, adjusting project estimates, or learning from new data."
---

# 贝叶斯更新 (Bayesian Updating)

## 核心定义
根据新证据不断更新判断，而不是死守初始结论。先验概率 + 新证据 = 后验概率。用概率思维替代确定论，持续校准置信度。

## 技能能力
- **先验设定**：基于现有信息建立初始判断
- **证据收集**：寻找验证或证伪的信息
- **概率更新**：根据证据调整判断
- **置信度校准**：量化不确定性

## 执行流程
```
1. 明确假设 → 列出 competing hypotheses
2. 设定先验 → 基于当前信息的初始概率
3. 收集证据 → 寻找能区分假设的证据
4. 评估似然 → 证据在各假设下的概率
5. 更新概率 → 根据贝叶斯规则调整后验
6. 决策行动 → 基于后验概率决策
```

## 思考流程

### Step 1: 明确假设
- 要验证什么？
- 有哪些 competing hypotheses？
- 假设之间是否互斥且完备？

### Step 2: 设定先验
- 基于当前信息的初始判断
- 使用概率区间（避免0%或100%）
- 承认初始判断的不确定性

### Step 3: 收集证据
- 寻找能区分假设的证据
- 注意正反两方面
- 评估证据质量（强/弱证据）

### Step 4: 评估似然
- 如果假设成立，证据出现概率？
- 如果假设不成立，证据出现概率？
- 计算证据的区分度

### Step 5: 更新概率
- 根据贝叶斯规则调整
- 强证据大幅更新，弱证据小幅更新
- 记录更新过程

### Step 6: 决策行动
- 基于后验概率决策
- 继续收集证据
- 设定停止条件

## 实践要点
1. **证据权重**：强证据大幅更新，弱证据小幅更新
2. **正反证据**：既看支持也看反对的证据
3. **避免极端**：避免0%或100%的先验
4. **持续更新**：随着新信息不断调整

## 使用示例

### 示例 1：项目进度动态评估

```markdown
## 贝叶斯更新：项目进度评估

### 假设
- H1: 能按时完成（先验 70%）
- H2: 需要延期（先验 30%）

### 证据收集与更新
| 时间 | 证据 | H1更新 | H2更新 |
|-----|------|--------|--------|
| 初始 | - | 70% | 30% |
| 第1周 | 进度落后10% | 60% | 40% |
| 第2周 | 关键人员请假 | 45% | 55% |
| 第3周 | 需求变更 | 25% | 75% |

### 决策
第3周决定：延期或砍需求，避免最后时刻才发现完不成
```

### 示例 2：调试时假设验证

```python
# 反例：确认偏误，只验证一个假设
class BiasedDebugger:
    def debug(self):
        # 坚信是数据库问题
        self.check_database()  # 找到一些问题
        return "数据库需要优化"

# 正确做法：多假设贝叶斯更新
class BayesianDebugger:
    def __init__(self):
        self.hypotheses = {
            'db_issue': 0.4,
            'cache_issue': 0.3,
            'network_issue': 0.2,
            'code_issue': 0.1
        }
    
    def collect_evidence(self):
        return {
            'db_slow_queries': self.check_db(),
            'cache_hit_rate': self.check_cache(),
            'network_latency': self.check_network(),
            'error_stack': self.check_code()
        }
    
    def update(self, evidence):
        # 根据证据更新各假设概率
        if evidence['cache_hit_rate'] < 0.5:
            self.hypotheses['cache_issue'] *= 2.5
        if evidence['db_slow_queries'] == 0:
            self.hypotheses['db_issue'] *= 0.3
        
        # 归一化
        total = sum(self.hypotheses.values())
        for k in self.hypotheses:
            self.hypotheses[k] /= total
    
    def debug(self):
        evidence = self.collect_evidence()
        self.update(evidence)
        # 优先排查概率最高的假设
        return max(self.hypotheses, key=self.hypotheses.get)
```

### 示例 3：技术选型持续评估

```markdown
## 技术选型贝叶斯评估

### 假设
- H1: 新技术适合项目（先验 60%）
- H2: 现有技术更合适（先验 40%）

### 证据收集
| 证据 | 对H1的支持 | 更新后H1 |
|-----|-----------|---------|
| 社区活跃 | +10% | 70% |
| 学习曲线陡峭 | -15% | 55% |
| POC性能优秀 | +15% | 70% |
| 生产案例少 | -10% | 60% |

### 决策
60%置信度 → 小范围试点，继续收集证据，不急于全面推广
```

### 示例 4：代码质量评估

```python
# 反例：初始印象决定一切
class StaticReviewer:
    def review(self, code):
        # 作者之前代码很好，这次应该也没问题
        return "LGTM"  # 没仔细看

# 正确做法：根据证据更新质量判断
class BayesianReviewer:
    def __init__(self):
        self.quality_score = 0.7  # 先验：70%概率质量OK
    
    def review(self, code):
        issues = []
        
        # 收集证据
        if self.has_bug(code):
            issues.append('bug')
            self.quality_score *= 0.7
        
        if self.missing_tests(code):
            issues.append('no_tests')
            self.quality_score *= 0.8
        
        if self.complex_logic(code):
            issues.append('complex')
            self.quality_score *= 0.85
        
        # 基于更新后的质量分数决策
        if self.quality_score < 0.5:
            return f"需要修改：发现{len(issues)}类问题"
        elif self.quality_score < 0.7:
            return "建议优化，但不阻塞"
        else:
            return "质量良好"
```

## 结构化分析框架

### 贝叶斯更新速记表

| 步骤 | 内容 | 输出 |
|-----|------|-----|
| 假设 | 列出 competing hypotheses | 假设列表 |
| 先验 | 初始概率分布 | P(H) |
| 证据 | 新观察到的事实 | E |
| 似然 | P(E\|H) 各假设下证据的概率 | 似然表 |
| 后验 | 更新后的概率 | P(H\|E) |
| 决策 | 基于后验的行动 | 决策 |

### 概率更新公式

```
后验概率 ∝ 先验概率 × 似然度

P(H|E) = P(E|H) × P(H) / P(E)

通俗理解：
- 先验 P(H)：我原来认为的概率
- 证据 E：新看到的事实
- 似然 P(E|H)：如果假设成立，证据的概率
- 后验 P(H|E)：更新后的概率
```

## 约束与限制
- 避免确认偏误：主动寻找反面证据
- 避免过度反应：单次证据不应大幅改变判断
- 避免反应不足：重要证据需要及时更新
- 避免分析瘫痪：设定合理的停止条件

## 自检清单
- [ ] 我设定了明确的先验概率吗？
- [ ] 我收集了正反两方面证据吗？
- [ ] 我根据证据更新了判断吗？
- [ ] 我的更新幅度合理吗？
- [ ] 我需要继续收集证据吗？

## 常见陷阱

### 陷阱 1：确认偏误

```python
# 反例：只收集支持证据
class ConfirmationBias:
    def evaluate_framework(self, framework):
        # 先验：喜欢这个框架
        self.belief = 0.8
        
        # 只收集支持证据
        evidence = [
            "大公司使用",  # 支持
            "社区活跃",    # 支持
            # 忽视：学习曲线陡峭
            # 忽视：与现有架构不匹配
        ]
        
        # 结论：框架很好
        return "采用"

# 正确做法：收集正反证据
class BalancedEvaluator:
    def evaluate(self, framework):
        hypotheses = {'good': 0.5, 'bad': 0.5}
        
        # 正面证据
        if self.has_strong_community(framework):
            hypotheses['good'] *= 1.5
        
        # 反面证据
        if self.steep_learning_curve(framework):
            hypotheses['bad'] *= 1.8
        
        # 归一化后决策
        total = sum(hypotheses.values())
        good_prob = hypotheses['good'] / total
        
        return "采用" if good_prob > 0.7 else "试点" if good_prob > 0.4 else "放弃"
```

### 陷阱 2：过度反应

```python
# 反例：单次证据大幅改变判断
class OverReactor:
    def estimate_project(self):
        self.days = 30  # 初始估计
    
    def update(self, daily_progress):
        # 某天进度慢，大幅调整估计
        if daily_progress < 0.5:
            self.days = 60  # 翻倍！
        # 某天进度快，又大幅调整
        elif daily_progress > 1.5:
            self.days = 15  # 减半！
        # 估计剧烈波动，无法决策

# 正确做法：平滑更新
class SmoothUpdater:
    def update(self, daily_progress, sample_size=5):
        # 基于多日平均，而非单日
        avg_progress = sum(self.recent_progress) / len(self.recent_progress)
        
        # 小幅调整
        if avg_progress < 0.8:
            self.days *= 1.1  # 增加10%
        elif avg_progress > 1.2:
            self.days *= 0.95  # 减少5%
        # 平滑更新，稳定决策
```

### 陷阱 3：反应不足

```python
# 反例：忽视重要证据
class UnderReactor:
    def __init__(self):
        self.framework_good = True  # 初始判断
    
    def evaluate(self, evidence):
        # 即使看到很多负面证据，也不更新判断
        if evidence['production_bugs'] > 10:
            pass  # 忽视
        if evidence['performance_issues']:
            pass  # 忽视
        if evidence['team_complaints']:
            pass  # 忽视
        
        return "继续使用"  # 始终不变

# 正确做法：及时更新
class ResponsiveEvaluator:
    def evaluate(self, evidence):
        score = 0.5  # 中性先验
        
        # 根据证据更新
        if evidence['production_bugs'] > 10:
            score -= 0.3
        if evidence['performance_issues']:
            score -= 0.2
        if evidence['team_productivity_down']:
            score -= 0.25
        
        if score < 0.3:
            return "立即替换"
        elif score < 0.5:
            return "制定迁移计划"
        else:
            return "继续使用"
```

### 陷阱 4：锚定效应

```python
# 反例：过度依赖初始估计
class AnchoredEstimator:
    def __init__(self):
        self.initial_estimate = 30  # 初始锚点
    
    def adjust_estimate(self, new_evidence):
        # 即使证据充分，调整幅度也很小
        if new_evidence['complexity'] == 'high':
            return self.initial_estimate * 1.2  # 只调整20%
        # 实际需要3倍时间

# 正确做法：根据证据大幅调整
class EvidenceBasedEstimator:
    def estimate(self, evidence):
        # 不预设锚点，根据证据重新计算
        base = evidence['similar_tasks_avg']
        complexity_factor = {
            'low': 0.8,
            'medium': 1.0,
            'high': 2.5,
            'very_high': 4.0
        }
        return base * complexity_factor[evidence['complexity']]
```
