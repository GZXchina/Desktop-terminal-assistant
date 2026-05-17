---
name: "opportunity-cost"
description: "Apply opportunity cost thinking to evaluate the value of alternatives foregone when making a decision. Invoke when prioritizing tasks, allocating resources, or deciding build vs buy."
---

# 机会成本思维 (Opportunity Cost Thinking)

## 核心定义

做A意味着不能做B。评估被放弃选项的价值，确保选择的选项价值更高。机会成本是决策时必须考虑的核心因素。

## 技能能力

1. **选项识别**：列出所有可行选项
2. **价值评估**：评估每个选项的收益
3. **成本对比**：比较显性成本和隐性成本
4. **最优决策**：选择净收益最高的选项

## 执行流程

1. **识别选项**
   - 有哪些可行方案？
   - 有没有被忽视的选项？
   - 默认选项是什么？

2. **评估收益**
   - 每个选项的直接收益
   - 长期收益
   - 战略收益

3. **评估成本**
   - 显性成本（时间、金钱）
   - 隐性成本（维护、学习）
   - 机会成本（放弃的其他选项）

4. **计算净收益**
   - 净收益 = 总收益 - 总成本 - 机会成本

5. **做出决策**
   - 选择净收益最高的
   - 记录决策理由
   - 设定回顾点

6. **定期回顾**
   - 决策是否正确？
   - 机会成本评估是否准确？
   - 需要调整吗？

## 实践要点

### 1. 机会成本公式
```
机会成本 = 被放弃选项中的最高价值

决策 = 选择收益 - 机会成本 > 0
```

### 2. 常见隐性成本
| 类型 | 示例 | 影响 |
|------|------|------|
| **时间成本** | 做这个就不能做那个 | 机会流失 |
| **学习成本** | 学新技术的时间 | 短期效率下降 |
| **维护成本** | 长期维护投入 | 资源占用 |
| **认知成本** | 心智负担 | 决策疲劳 |

### 3. 决策框架
```
1. 列出所有可行选项
2. 评估每个选项的收益
3. 评估每个选项的成本
4. 计算机会成本
5. 选择净收益最高的
```

## 使用示例

### 示例 1：技术选型决策

**场景**：选择框架开发方案

```python
from dataclasses import dataclass
from typing import Dict, List

@dataclass
class Option:
    """决策选项"""
    name: str
    benefits: Dict[str, float]  # 收益项
    explicit_costs: Dict[str, float]  # 显性成本
    implicit_costs: Dict[str, float]  # 隐性成本
    
    def total_benefit(self) -> float:
        return sum(self.benefits.values())
    
    def total_cost(self) -> float:
        return sum(self.explicit_costs.values()) + sum(self.implicit_costs.values())
    
    def net_value(self) -> float:
        return self.total_benefit() - self.total_cost()

class TechnologyDecision:
    """技术选型决策器"""
    
    def __init__(self):
        self.options = []
    
    def add_option(self, option: Option):
        self.options.append(option)
    
    def calculate_opportunity_cost(self, chosen: Option) -> float:
        """计算选择某选项的机会成本"""
        other_values = [
            opt.net_value() 
            for opt in self.options 
            if opt != chosen
        ]
        return max(other_values) if other_values else 0
    
    def decide(self) -> Dict:
        """做出决策"""
        # 计算每个选项的净收益和机会成本
        results = []
        for opt in self.options:
            opportunity_cost = self.calculate_opportunity_cost(opt)
            true_net_value = opt.net_value() - opportunity_cost
            results.append({
                "option": opt.name,
                "net_value": opt.net_value(),
                "opportunity_cost": opportunity_cost,
                "true_net_value": true_net_value
            })
        
        # 选择真实净收益最高的
        best = max(results, key=lambda x: x["true_net_value"])
        return best


# 使用示例：框架选型
decision = TechnologyDecision()

# 选项A：自研框架
decision.add_option(Option(
    name="自研框架",
    benefits={
        "完全可控": 100,
        "定制化": 80,
        "技术积累": 50
    },
    explicit_costs={
        "开发时间": 90,  # 3人月
        "测试时间": 30
    },
    implicit_costs={
        "维护成本": 60,  # 每年
        "学习成本": 20,
        "机会成本": 100  # 放弃使用成熟框架的时间
    }
))

# 选项B：使用开源框架
decision.add_option(Option(
    name="开源框架",
    benefits={
        "快速启动": 120,
        "社区支持": 60,
        "成熟稳定": 80
    },
    explicit_costs={
        "学习成本": 20
    },
    implicit_costs={
        "定制限制": 30,
        "依赖风险": 20
    }
))

# 选项C：购买商业方案
decision.add_option(Option(
    name="商业方案",
    benefits={
        "即开即用": 150,
        "技术支持": 70,
        "SLA保障": 60
    },
    explicit_costs={
        "授权费用": 100  # 10万/年
    },
    implicit_costs={
        "供应商锁定": 40,
        "定制受限": 50
    }
))

result = decision.decide()
print(f"最优选择: {result['option']}")
print(f"真实净收益: {result['true_net_value']}")
```

### 示例 2：任务优先级决策

**场景**：多个需求，资源只能做一个

```python
class TaskPriorityDecision:
    """任务优先级决策"""
    
    def __init__(self):
        self.tasks = []
    
    def add_task(self, name: str, benefit: float, cost: float):
        """添加任务
        
        Args:
            benefit: 收益值
            cost: 成本值
        """
        self.tasks.append({
            "name": name,
            "benefit": benefit,
            "cost": cost,
            "net_value": benefit - cost
        })
    
    def prioritize(self) -> List[Dict]:
        """按真实净收益排序"""
        # 计算每个任务的机会成本（放弃的其他任务中的最高净收益）
        for task in self.tasks:
            other_nets = [
                t["net_value"] 
                for t in self.tasks 
                if t != task
            ]
            opportunity_cost = max(other_nets) if other_nets else 0
            task["opportunity_cost"] = opportunity_cost
            task["true_net_value"] = task["net_value"] - opportunity_cost
        
        # 按真实净收益排序
        return sorted(
            self.tasks, 
            key=lambda x: x["true_net_value"], 
            reverse=True
        )


# 使用示例
decision = TaskPriorityDecision()
decision.add_task("需求A", benefit=100, cost=50)
decision.add_task("需求B", benefit=80, cost=20)
decision.add_task("需求C", benefit=60, cost=10)

prioritized = decision.prioritize()
for task in prioritized:
    print(f"{task['name']}: 净收益={task['net_value']}, "
          f"机会成本={task['opportunity_cost']}, "
          f"真实净收益={task['true_net_value']}")

# 输出：
# 需求B: 净收益=60, 机会成本=50, 真实净收益=10
# 需求C: 净收益=50, 机会成本=60, 真实净收益=-10
# 需求A: 净收益=50, 机会成本=60, 真实净收益=-10
```

### 示例 3：重构决策

**场景**：是否投入时间重构

```python
class RefactoringDecision:
    """重构决策分析器"""
    
    def __init__(self):
        self.current_state = {}
        self.refactoring_option = {}
        self.continue_option = {}
    
    def analyze_refactoring(self, 
                           time_investment: int,
                           efficiency_gain: float,
                           current_efficiency: float) -> Dict:
        """分析重构决策
        
        Args:
            time_investment: 重构投入时间（周）
            efficiency_gain: 重构后效率提升（%）
            current_efficiency: 当前效率（功能点/周）
        """
        # 重构选项
        refactoring_benefit = efficiency_gain * current_efficiency * 52  # 年度收益
        refactoring_cost = time_investment * current_efficiency  # 投入的机会成本
        
        # 继续堆功能选项
        continue_benefit = time_investment * current_efficiency  # 短期内能完成的功能
        continue_cost = 0  # 显性成本为0
        
        # 隐性成本：技术债累积
        tech_debt_cost = current_efficiency * 0.1 * 52  # 每年效率下降10%
        
        return {
            "refactoring": {
                "benefit": refactoring_benefit,
                "cost": refactoring_cost,
                "net_value": refactoring_benefit - refactoring_cost,
                "description": "投入时间重构，长期效率提升"
            },
            "continue": {
                "benefit": continue_benefit,
                "cost": tech_debt_cost,
                "net_value": continue_benefit - tech_debt_cost,
                "description": "继续堆功能，技术债累积"
            },
            "recommendation": "refactoring" if (refactoring_benefit - refactoring_cost) > 
                                               (continue_benefit - tech_debt_cost) else "continue"
        }


# 使用示例
analyzer = RefactoringDecision()
result = analyzer.analyze_refactoring(
    time_investment=2,  # 投入2周
    efficiency_gain=0.3,  # 效率提升30%
    current_efficiency=10  # 当前每周10个功能点
)

print(f"重构净收益: {result['refactoring']['net_value']}")
print(f"继续净收益: {result['continue']['net_value']}")
print(f"建议: {result['recommendation']}")
```

### 示例 4：会议参与决策

**场景**：决定是否参加会议

```python
class MeetingDecision:
    """会议参与决策"""
    
    def __init__(self, hourly_value: float):
        """
        Args:
            hourly_value: 每小时工作价值
        """
        self.hourly_value = hourly_value
    
    def evaluate_meeting(self, 
                        duration: float,
                        information_value: float,
                        alternatives: List[str]) -> Dict:
        """评估是否参加会议
        
        Args:
            duration: 会议时长（小时）
            information_value: 会议信息价值（0-100）
            alternatives: 可替代的信息获取方式
        """
        # 参加会议的成本
        meeting_cost = duration * self.hourly_value
        
        # 参加会议的收益
        meeting_benefit = information_value
        
        # 替代方案
        alternatives_analysis = []
        for alt in alternatives:
            if alt == "async_document":
                # 异步文档：成本低，但信息可能不全
                alt_cost = 0.5 * self.hourly_value  # 30分钟阅读
                alt_benefit = information_value * 0.8  # 80%信息获取
                alternatives_analysis.append({
                    "method": "异步文档",
                    "cost": alt_cost,
                    "benefit": alt_benefit,
                    "net": alt_benefit - alt_cost
                })
            elif alt == "recording":
                # 录像：时间灵活，但耗时
                alt_cost = 1.5 * self.hourly_value  # 1.5倍时间看录像
                alt_benefit = information_value * 0.9
                alternatives_analysis.append({
                    "method": "观看录像",
                    "cost": alt_cost,
                    "benefit": alt_benefit,
                    "net": alt_benefit - alt_cost
                })
        
        # 参加会议的净收益
        meeting_net = meeting_benefit - meeting_cost
        
        # 最佳替代方案的净收益
        best_alternative = max(alternatives_analysis, key=lambda x: x["net"]) if alternatives_analysis else None
        
        return {
            "meeting_net": meeting_net,
            "best_alternative": best_alternative,
            "should_attend": meeting_net > (best_alternative["net"] if best_alternative else 0),
            "reason": "参加会议净收益更高" if meeting_net > (best_alternative["net"] if best_alternative else 0) 
                     else f"使用{best_alternative['method']}更优"
        }


# 使用示例
decision = MeetingDecision(hourly_value=100)  # 每小时价值100
result = decision.evaluate_meeting(
    duration=1,
    information_value=80,
    alternatives=["async_document", "recording"]
)

print(f"是否参加会议: {result['should_attend']}")
print(f"理由: {result['reason']}")
```

## 结构化分析框架

### 机会成本速记

```markdown
## 机会成本速记

### 选项清单
| 选项 | 收益 | 显性成本 | 隐性成本 |
|------|------|----------|----------|
| A | | | |
| B | | | |
| C | | | |

### 机会成本计算
- 选择A的机会成本 = B和C中的最高净收益
- 选择B的机会成本 = A和C中的最高净收益
- ...

### 净收益对比
| 选项 | 净收益 | 排名 |
|------|--------|------|
| | | |

### 决策
- 选择：
- 理由：
- 回顾时间：
```

## 思考流程

```
┌─────────────────────────────────────────────────────────────┐
│  1. 识别所有选项                                              │
│     - 列出所有可行的选择                                      │
│     - 包括"什么都不做"的选项                                  │
│     - 考虑创新的替代方案                                      │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  2. 评估收益                                                  │
│     - 直接收益                                                │
│     - 长期收益                                                │
│     - 战略收益                                                │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  3. 评估成本                                                  │
│     - 显性成本（时间、金钱）                                  │
│     - 隐性成本（维护、学习）                                  │
│     - 机会成本（放弃的其他选项）                              │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  4. 计算净收益                                                │
│     - 净收益 = 总收益 - 总成本                                │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  5. 计算机会成本                                              │
│     - 选择A的机会成本 = B和C中的最高净收益                    │
│     - 对每个选项重复计算                                      │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  6. 计算真实净收益                                            │
│     - 真实净收益 = 净收益 - 机会成本                          │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  7. 做出决策                                                  │
│     - 选择真实净收益最高的选项                                │
│     - 记录决策理由                                            │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  8. 设定回顾点                                                │
│     - 决策后定期回顾                                          │
│     - 验证决策是否正确                                        │
│     - 必要时调整                                              │
└─────────────────────────────────────────────────────────────┘
```

## 约束与限制

### 红线（绝对不能）
- 不能忽视隐性成本
- 不能只看绝对收益不看净收益
- 不能忽视时间价值

### 偏好（建议遵循）
- 优先列出所有可行选项
- 优先量化成本和收益
- 优先考虑长期影响
- 优先保护核心资源（时间、注意力）

### 风险提示
- **沉没成本谬误**：因为已经投入所以继续
- **忽视隐性成本**：只看显性成本
- **过度分析**：花费过多时间分析小决策
- **完美主义**：追求最优而迟迟不决策

## 自检清单

- [ ] 我列出了所有可行选项吗？
- [ ] 我评估了被放弃选项的价值吗？
- [ ] 我考虑了隐性成本吗？
- [ ] 我计算了净收益吗？
- [ ] 我的时间资源被最优利用了吗？

## 常见陷阱

### 陷阱 1：沉没成本谬误

**反例**：因为已经投入所以继续

```python
# 反例：考虑已投入成本
class MigrationProject:
    def __init__(self):
        self.spent_months = 0
    
    def should_continue(self):
        # 错误：因为已经投入3个月，所以继续
        if self.spent_months > 3:
            return True  # 错误决策
        
    def continue_migration(self):
        self.spent_months += 1
        # 继续投入...

# 正确做法：理性决策，不考虑沉没成本
class MigrationProject:
    def should_continue(self):
        # 只考虑未来的成本和收益
        remaining_cost = self.estimate_remaining_cost()
        future_benefit = self.estimate_future_benefit()
        
        # 不考虑已投入的成本
        if future_benefit > remaining_cost:
            return True
        else:
            # 即使已投入很多，也应该止损
            return False
```

**正确做法**：决策时只考虑未来的成本和收益，不考虑已经投入的成本。

### 陷阱 2：忽视隐性成本

**反例**：只看显性成本

```python
# 反例：只看显性成本
def choose_solution():
    # 开源方案：$0
    # 商业方案：$10,000/年
    return "open_source"  # 只看授权费用

# 正确做法：全面评估所有成本
def choose_solution():
    open_source_cost = {
        'license': 0,
        'learning': 5000,      # 学习成本
        'maintenance': 1200,   # 维护成本
        'support_risk': 5000,  # 故障风险
        'opportunity': 3000    # 机会成本
    }
    
    commercial_cost = {
        'license': 10000,
        'learning': 1000,
        'maintenance': 0,
        'support_risk': 0,
        'opportunity': 0
    }
    
    open_source_total = sum(open_source_cost.values())
    commercial_total = sum(commercial_cost.values())
    
    # 隐性成本使开源方案可能更贵
    return "commercial" if commercial_total < open_source_total else "open_source"
```

**正确做法**：全面评估显性成本、隐性成本和机会成本。

### 陷阱 3：过度分析

**反例**：花费过多时间分析小决策

```python
# 反例：为小决策花费大量时间
class OverAnalyzer:
    def decide_lunch(self):
        # 花费1小时分析午餐选择
        options = self.research_all_restaurants()
        self.create_comparison_matrix(options)
        self.calculate_nutritional_value(options)
        self.calculate_cost_benefit(options)
        # ... 1小时后
        return "sandwich"  # 价值10元的决策花了1小时

# 正确做法：根据决策重要性分配分析时间
class PragmaticDecider:
    def decide(self, options, importance):
        """根据重要性决定分析深度"""
        if importance == "low":
            # 小决策：5分钟决定
            return random.choice(options)
        elif importance == "medium":
            # 中等决策：30分钟分析
            return self.quick_analysis(options, time_limit=30)
        else:
            # 重要决策：深入分析
            return self.deep_analysis(options)
```

**正确做法**：根据决策的重要性分配分析时间，避免过度分析小决策。

### 陷阱 4：完美主义

**反例**：追求最优而迟迟不决策

```python
# 反例：追求完美方案
class Perfectionist:
    def select_framework(self):
        # 研究所有可能的框架
        frameworks = self.research_all_frameworks()
        
        # 不断寻找更好的
        while True:
            new_framework = self.find_new_framework()
            if new_framework:
                frameworks.append(new_framework)
            else:
                break
        
        # 永远在选择中...
        return self.compare_all(frameworks)

# 正确做法：设定决策截止时间
class PragmaticSelector:
    def select_framework(self, deadline):
        """在截止日期前做出足够好的选择"""
        candidates = self.research_top_candidates()
        
        while datetime.now() < deadline:
            # 持续收集信息，但有时间限制
            self.gather_more_info(candidates)
        
        # 时间到，选择当前最优
        return max(candidates, key=lambda x: x.score)
```

**正确做法**：设定决策截止时间，选择"足够好"的方案，而非追求"最优"。
