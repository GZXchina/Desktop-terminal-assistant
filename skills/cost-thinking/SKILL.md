---
name: "cost-thinking"
description: "Apply cost thinking to comprehensively evaluate resource consumption and TCO. Invoke when making technology choices, architecture decisions, or project planning."
---

# 成本思维 (Cost Thinking)

## 核心定义

成本思维是一种**全面评估资源消耗**的决策思维。它不仅关注直接的开发成本，还包括运维成本、学习成本、机会成本和隐性成本。通过量化分析，帮助在技术选型、架构设计和项目规划中做出更经济高效的决策。

## 技能能力

- **技术选型成本分析**：评估不同技术方案的总体拥有成本(TCO)
- **架构设计成本评估**：权衡性能与成本、复杂度与可维护性
- **云资源成本优化**：分析计算、存储、网络的资源消耗
- **人力成本估算**：评估开发、运维、学习的时间成本
- **债务成本量化**：评估技术债务的累积和偿还成本

## 执行流程

```
1. 识别成本项 → 列出所有直接和间接成本
2. 量化估算 → 为每个成本项赋予数值
3. 时间维度 → 考虑短期和长期成本变化
4. 对比分析 → 对比不同方案的成本结构
5. 敏感性分析 → 评估关键变量变化的影响
6. 决策建议 → 基于成本效益给出建议
```

## 实践要点

1. **全生命周期成本**：考虑开发、部署、运维、退役全过程
2. **隐性成本显性化**：将学习成本、沟通成本、风险成本量化
3. **边际成本分析**：评估规模扩大时的成本变化
4. **沉没成本陷阱**：避免因为已投入而继续错误决策
5. **成本效益平衡**：最低成本不等于最优选择

## 使用示例

### 示例 1：技术选型成本分析

**场景**：数据库选型（MySQL vs PostgreSQL vs MongoDB）

```python
from dataclasses import dataclass
from enum import Enum
from typing import List, Dict

class CostCategory(Enum):
    INITIAL = "初始成本"
    RECURRING = "周期成本"
    HUMAN = "人力成本"
    RISK = "风险成本"

@dataclass
class CostItem:
    name: str
    category: CostCategory
    amount: float
    unit: str
    recurring: bool = False

class DatabaseCostAnalyzer:
    """数据库选型成本分析器"""
    
    def analyze(self, db_name: str, time_months: int = 12) -> Dict:
        costs = self._get_costs(db_name)
        total = sum(c.amount * time_months if c.recurring else c.amount 
                   for c in costs)
        return {"db": db_name, "tco": total, "costs": costs}
    
    def _get_costs(self, db_name: str) -> List[CostItem]:
        scenarios = {
            "MySQL": [
                CostItem("部署", CostCategory.HUMAN, 2, "人天"),
                CostItem("服务器", CostCategory.RECURRING, 300, "元/月", True),
                CostItem("运维", CostCategory.HUMAN, 0.3, "人/月", True),
            ],
            "PostgreSQL": [
                CostItem("部署", CostCategory.HUMAN, 3, "人天"),
                CostItem("服务器", CostCategory.RECURRING, 300, "元/月", True),
                CostItem("运维", CostCategory.HUMAN, 0.4, "人/月", True),
            ],
            "MongoDB": [
                CostItem("部署", CostCategory.HUMAN, 4, "人天"),
                CostItem("服务器", CostCategory.RECURRING, 900, "元/月", True),
                CostItem("运维", CostCategory.HUMAN, 0.5, "人/月", True),
            ]
        }
        return scenarios.get(db_name, [])

# 使用
analyzer = DatabaseCostAnalyzer()
for db in ["MySQL", "PostgreSQL", "MongoDB"]:
    result = analyzer.analyze(db)
    print(f"{db}: 1年TCO = ¥{result['tco']}")
```

### 示例 2：架构方案成本对比

**场景**：单体架构 vs 微服务架构

```python
@dataclass
class ArchitectureCost:
    """架构成本模型"""
    name: str
    dev_cost: int          # 开发成本（人天）
    monthly_cost: int      # 月度运营成本（元）
    monthly_human: float   # 月度人力（人/月）
    risk_factor: float     # 风险系数

def compare_architectures():
    """对比单体和微服务架构成本"""
    architectures = {
        "单体": ArchitectureCost(
            name="单体架构",
            dev_cost=60,
            monthly_cost=5000,
            monthly_human=0.2,
            risk_factor=1.0
        ),
        "微服务": ArchitectureCost(
            name="微服务架构",
            dev_cost=150,
            monthly_cost=12000,
            monthly_human=0.8,
            risk_factor=0.8
        )
    }
    
    daily_rate = 2000  # 人天成本
    
    for name, arch in architectures.items():
        dev = arch.dev_cost * daily_rate
        monthly = arch.monthly_cost + arch.monthly_human * daily_rate * 22
        tco_3year = dev + monthly * 36
        
        print(f"{name}架构:")
        print(f"  初始成本: ¥{dev:,}")
        print(f"  月度成本: ¥{monthly:,.0f}")
        print(f"  3年TCO: ¥{tco_3year:,.0f}")
```

### 示例 3：性能优化成本效益分析

**场景**：评估性能优化的投入产出

```python
class PerformanceROIAnalyzer:
    """性能优化ROI分析器"""
    
    def analyze(self, current_metrics: Dict, optimization_cost: int) -> Dict:
        """分析性能优化的ROI"""
        # 计算性能问题造成的业务损失
        monthly_loss = self._calculate_business_loss(current_metrics)
        
        # 优化后预期收益（假设提升50%）
        expected_gain = monthly_loss * 0.5
        
        # 回收期
        payback_months = optimization_cost / expected_gain if expected_gain > 0 else float('inf')
        
        return {
            "monthly_loss": monthly_loss,
            "optimization_cost": optimization_cost,
            "expected_gain": expected_gain,
            "payback_months": payback_months,
            "roi_1year": (expected_gain * 12 - optimization_cost) / optimization_cost * 100
        }
    
    def _calculate_business_loss(self, metrics: Dict) -> float:
        """计算业务损失"""
        # 转化率损失
        conversion_loss = metrics.get("monthly_revenue", 0) * 0.02
        # 用户流失
        churn_loss = metrics.get("monthly_revenue", 0) * 0.05 * 0.3
        return conversion_loss + churn_loss

# 使用
analyzer = PerformanceROIAnalyzer()
metrics = {"monthly_revenue": 1000000}
result = analyzer.analyze(metrics, optimization_cost=50000)
print(f"回收期: {result['payback_months']:.1f}个月")
```

## 结构化分析框架

```
成本分析框架
├── 1. 成本识别
│   ├── 初始成本（一次性投入）
│   ├── 周期成本（持续支出）
│   ├── 人力成本（时间投入）
│   ├── 风险成本（潜在损失）
│   └── 机会成本（放弃的选择）
│
├── 2. 成本量化
│   ├── 货币化（转换为金额）
│   ├── 时间化（转换为时间）
│   └── 概率化（风险加权）
│
├── 3. 时间维度
│   ├── 短期成本（< 6个月）
│   ├── 中期成本（6-24个月）
│   └── 长期成本（> 24个月）
│
├── 4. 对比分析
│   ├── 总拥有成本(TCO)
│   ├── 边际成本分析
│   └── 成本效益比
│
└── 5. 敏感性分析
    ├── 关键变量识别
    ├── 场景模拟
    └── 风险调整
```

## 思考流程

当激活成本思维时，按以下步骤进行深度分析：

**步骤 1：成本识别**
- 列出所有可见成本
- 挖掘隐性成本（学习、沟通、风险）
- 考虑机会成本

**步骤 2：成本量化**
- 为每个成本项赋予数值
- 统一单位（货币或时间）
- 区分一次性 vs 周期性

**步骤 3：时间维度分析**
- 短期成本（开发、部署）
- 中期成本（运维、优化）
- 长期成本（重构、迁移）

**步骤 4：对比与决策**
- 计算总拥有成本(TCO)
- 进行敏感性分析
- 考虑非成本因素
- 给出决策建议

## 约束与限制

1. **量化难度**：部分成本难以精确量化（如风险成本）
2. **动态变化**：成本会随时间和规模变化
3. **隐性成本**：容易被忽视的成本项
4. **沉没成本谬误**：已投入不应影响未来决策
5. **过度优化**：追求最低成本可能牺牲质量

## 自检清单

- [ ] 是否考虑了全生命周期成本？
- [ ] 隐性成本是否已识别和量化？
- [ ] 是否进行了多方案对比？
- [ ] 时间维度是否考虑充分？
- [ ] 是否评估了关键变量的敏感性？
- [ ] 非成本因素是否纳入考量？
- [ ] 是否存在沉没成本谬误？

## 常见陷阱

### 陷阱 1：只考虑初始成本

```python
# 反例：只考虑购买成本
class BadDecision:
    def choose_database(self):
        # 只看初始价格
        if mysql.price < postgres.price:
            return "MySQL"  # 忽视了运维、学习、扩展成本

# 正确做法：全面评估TCO
class GoodDecision:
    def choose_database(self):
        costs = {
            "MySQL": self._calculate_tco("MySQL"),      # 包含所有成本
            "PostgreSQL": self._calculate_tco("PostgreSQL"),
        }
        return min(costs, key=costs.get)  # 选择TCO最低的
```

### 陷阱 2：忽视隐性成本

```python
# 反例：忽视学习成本
class BadPlanning:
    def adopt_new_tech(self):
        # 只看到技术优势
        return "采用Kubernetes"
        # 忽视了：团队需要2个月学习，期间生产力下降50%

# 正确做法：显性化隐性成本
class GoodPlanning:
    def adopt_new_tech(self):
        costs = [
            ("培训费用", 50000),
            ("学习期间生产力损失", 100000),  # 2个月 * 50% * 团队成本
            ("外部顾问", 80000),
        ]
        total = sum(c[1] for c in costs)
        return f"总隐性成本: ¥{total}"
```

### 陷阱 3：沉没成本谬误

```python
# 反例：因为已投入而继续错误决策
class BadDecision:
    def continue_project(self):
        spent = 1000000  # 已投入100万
        remaining_cost = 500000
        expected_value = 300000
        
        if spent > 0:  # 因为已经投入了，所以继续
            return "继续项目"  # 错误！应该看未来收益

# 正确做法：只考虑未来成本和收益
class GoodDecision:
    def continue_project(self):
        spent = 1000000  # 沉没成本，不应影响决策
        remaining_cost = 500000
        expected_value = 300000
        
        if expected_value > remaining_cost:
            return "继续项目"
        else:
            return "及时止损"  # 正确的决策
```

### 陷阱 4：忽视边际成本

```python
# 反例：线性估算成本
class BadEstimation:
    def estimate_cost(self, users):
        # 假设成本线性增长
        return users * 0.1  # 每个用户0.1元

# 正确做法：考虑边际成本递减
class GoodEstimation:
    def estimate_cost(self, users):
        # 规模效应：用户越多，边际成本越低
        base_cost = 1000
        if users < 10000:
            return base_cost + users * 0.1
        elif users < 100000:
            return base_cost + 1000 + (users - 10000) * 0.05
        else:
            return base_cost + 5500 + (users - 100000) * 0.02
```
