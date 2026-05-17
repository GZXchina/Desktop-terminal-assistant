---
name: "dual-speed-dev"
description: "Apply dual-speed development strategy combining rapid validation with careful expansion. Invoke when starting new features, validating technical assumptions, or deciding between quick experiments and production-ready solutions."
---

# 双速开发 (Dual-Speed Development)

## 核心定义

双速开发是一种**结合高速验证与低速扩展**的开发策略。通过快速原型验证核心假设，确认方向正确后再逐步完善为生产级实现，避免过早优化和无效投入。

## 技能能力

- **假设识别**：明确需要验证的核心假设
- **MVP设计**：设计最小可行产品验证假设
- **验证指标设定**：定义验证成功/失败的标准
- **阶段转换决策**：判断何时从高速切换到低速

## 执行流程

```
1. 识别假设 → 明确要验证的核心假设
2. 设计MVP → 最小功能集验证假设
3. 高速开发 → 快速实现，接受技术债
4. 验证假设 → 收集数据/反馈，对比指标
5. 阶段转换 → 成功则进入低速扩展，失败则放弃
6. 低速完善 → 重构、补测试、完善文档
```

## 实践要点

1. **高速阶段**：用最小成本验证核心假设，能跑通即可
2. **低速阶段**：稳定、可维护、可扩展，生产级质量
3. **时间盒**：高速阶段通常1-2周，强制结束
4. **技术债记录**：高速阶段产生的技术债必须记录
5. **数据驱动**：基于验证数据做决策，非主观判断

## 使用示例

### 示例 1：新功能验证

**场景**：开发新推荐算法

```python
class DualSpeedFeature:
    """双速开发示例"""
    
    def phase1_rapid_validation(self):
        """阶段1：高速验证（1周）"""
        # 核心假设：新算法能提升点击率10%
        # MVP：Python脚本离线验证，mock数据
        
        result = self.offline_test_with_mock_data()
        
        if result.click_rate_improvement > 0.10:
            return "验证成功，进入阶段2"
        else:
            return "验证失败，放弃或调整"
    
    def phase2_careful_expansion(self):
        """阶段2：低速扩展（2周）"""
        # 验证成功后，生产级实现
        # - 重构为Java服务
        # - 添加A/B测试框架
        # - 完善监控告警
        # - 补充单元测试
        pass
```

### 示例 2：技术方案验证

**场景**：数据库选型验证

```python
class DatabaseValidation:
    """数据库选型双速验证"""
    
    def rapid_test(self):
        """快速验证（3天）"""
        # 搭建测试环境
        # 导入真实数据
        # 跑性能测试
        
        results = {
            "mysql": self.test_mysql(),
            "postgres": self.test_postgres(),
        }
        
        # 验证指标：查询性能提升>50%
        best = max(results, key=lambda x: x.performance)
        
        if best.performance_improvement > 0.50:
            return f"选择{best.name}，进入生产级实施"
        return "继续评估其他方案"
```

### 示例 3：性能优化验证

**场景**：验证性能优化方案

```python
class PerformanceValidation:
    """性能优化双速验证"""
    
    def quick_validation(self):
        """快速验证（1天）"""
        # 临时调整连接池参数
        # 观察是否改善
        
        before_error_rate = self.get_error_rate()
        self.temporarily_adjust_connection_pool()
        after_error_rate = self.get_error_rate()
        
        # 验证指标：错误率下降>80%
        if before_error_rate * 0.20 > after_error_rate:
            return "验证成功，制定永久方案"
        return "假设错误，排查其他原因"
```

## 结构化分析框架

```
双速开发分析框架
├── 1. 假设识别
│   ├── 核心假设
│   ├── 验证成本
│   └── 错误成本
│
├── 2. MVP设计
│   ├── 最小功能集
│   ├── 可mock部分
│   └── 验证指标
│
├── 3. 高速阶段
│   ├── 时间盒
│   ├── 质量标准
│   └── 技术债记录
│
├── 4. 验证结果
│   ├── 数据/反馈
│   ├── 对比指标
│   └── 决策：go/no-go/pivot
│
└── 5. 低速阶段（如进入）
    ├── 重构清单
    ├── 测试覆盖
    ├── 文档完善
    └── 技术债清理
```

## 思考流程

当激活双速开发思维时，按以下步骤进行深度分析：

**步骤 1：识别核心假设**
- 我们要验证什么？
- 如果假设错了，会有什么后果？
- 验证成本 vs 错误成本？

**步骤 2：设计MVP**
- 最小功能集是什么？
- 哪些可以mock/简化？
- 验证指标是什么？

**步骤 3：高速开发**
- 快速实现核心流程
- 忽略非核心功能
- 记录所有技术债

**步骤 4：验证与决策**
- 收集数据/反馈
- 对比验证指标
- 做出 go/no-go/pivot 决策

**步骤 5：低速完善（如进入）**
- 重构代码
- 补充测试
- 完善文档
- 清理技术债

## 约束与限制

1. **永远原型**：验证成功后不进入低速阶段
2. **过早优化**：在验证前就追求完美
3. **沉没成本**：验证失败后因为投入太多而不愿放弃
4. **验证偏差**：只收集支持假设的数据
5. **时间盒失效**：高速阶段无限延长

## 自检清单

- [ ] 我要验证的核心假设是什么？
- [ ] 验证成功/失败的标准是什么？
- [ ] 时间盒设定了吗？
- [ ] 技术债记录了吗？
- [ ] 验证成功后，有计划进入低速阶段吗？
- [ ] 是否有意收集反面证据？

## 常见陷阱

### 陷阱 1：永远原型

```python
# 反例：验证成功后不进入低速阶段
class ForeverPrototype:
    def __init__(self):
        # 硬编码配置（原型阶段可以接受）
        self.api_key = "sk_test_123456"
    
    def charge(self, amount):
        # 没有错误处理（原型阶段）
        response = requests.post(self.endpoint, data={'amount': amount})
        return response.json()
    # 3个月后：还在使用硬编码密钥，没有错误处理，没有日志

# 正确做法：验证成功后进入低速阶段
class ProductionReady:
    def __init__(self, config):
        self.api_key = config.API_KEY  # 配置外置
        self.max_retries = config.MAX_RETRIES
        self.logger = logging.getLogger(__name__)
    
    def charge(self, amount, idempotency_key=None):
        # 完整的错误处理、重试、日志
        for attempt in range(self.max_retries):
            try:
                return self._make_request(amount, idempotency_key)
            except requests.Timeout:
                self.logger.warning(f"Timeout, attempt {attempt + 1}")
        raise PaymentTimeoutError()
```

### 陷阱 2：验证偏差

```python
# 反例：只收集支持假设的数据
class BiasedValidator:
    def validate(self):
        # 只选择表现好的用户群体
        test_users = self.select_high_engagement_users()
        
        results = []
        for user in test_users:
            result = self.test(user)
            if result.conversion > 0.1:  # 只记录高转化
                results.append(result)
        
        # 忽略负面反馈
        return "验证成功！"

# 正确做法：客观收集所有数据
class ObjectiveValidator:
    def validate(self):
        # 随机抽样，A/B测试
        test_group = self.random_sample(n=1000)
        control_group = self.random_sample(n=1000)
        
        results = {
            'test': [self.test(u) for u in test_group],
            'control': [self.test(u) for u in control_group],
            'feedback': self.analyze_all_feedback()
        }
        
        # 统计显著性检验
        p_value = self.calculate_significance(results)
        return f"统计显著性: p={p_value:.4f}"
```

### 陷阱 3：沉没成本谬误

```python
# 反例：验证失败后不愿放弃
class SunkCostFallacy:
    def continue_project(self):
        spent = 100  # 已投入100人天
        remaining_cost = 50
        expected_value = 30
        
        if spent > 0:  # 因为已经投入了，所以继续
            return "继续项目"  # 错误！

# 正确做法：只考虑未来成本和收益
class RationalDecision:
    def continue_project(self):
        spent = 100  # 沉没成本，不影响决策
        remaining_cost = 50
        expected_value = 30
        
        if expected_value > remaining_cost:
            return "继续项目"
        else:
            return "及时止损"  # 正确决策
```
