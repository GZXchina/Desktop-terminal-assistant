---
name: "skill_test"
description: "Apply testing capabilities for functional validation, performance testing, and contract compliance. Invoke when writing tests, designing test strategies, or analyzing test coverage."
---

# Testing Skill

## 核心定义
系统性验证软件质量，包括功能测试、性能测试、负载测试和契约合规检查，确保系统符合预期。

## 技能能力
- **契约测试**：验证API与OpenAPI/Swagger规范一致性
- **功能测试**：有效/无效输入处理、边界情况、业务逻辑验证
- **性能测试**：接口响应时间评估、瓶颈识别、SLA验证
- **负载测试**：并发用户模拟、压力场景、稳定性验证
- **安全测试**：SQL注入、XSS、认证绕过检测

## 执行流程
1. **需求分析**：明确测试目标、范围和验收标准
2. **测试设计**：设计测试用例、测试数据和测试环境
3. **测试实现**：编写测试代码、配置测试框架
4. **测试执行**：运行测试、收集结果、记录缺陷
5. **测试报告**：分析覆盖率、生成测试报告、提出改进建议

## 实践要点
1. **测试先行**：核心业务逻辑先写测试再实现
2. **边界覆盖**：关注空值、越界、极值等边界条件
3. **独立隔离**：测试之间不应相互依赖
4. **有意义的断言**：断言应该验证业务逻辑而非实现细节
5. **自动化**：所有测试都应该能自动运行

## 使用示例

### 示例 1：单元测试设计

**场景**：为用户注册服务编写单元测试

```python
import pytest
from unittest.mock import Mock

class TestUserService:
    @pytest.fixture
    def user_service(self):
        mock_repo = Mock(spec=UserRepository)
        mock_email = Mock(spec=EmailService)
        return UserService(mock_repo, mock_email)
    
    def test_should_create_user_successfully(self, user_service):
        """正常场景：成功创建用户"""
        user_service.repository.exists.return_value = False
        user_service.repository.create.return_value = User(id="u123", username="test")
        
        result = user_service.create_user({"username": "test", "email": "t@e.com"})
        
        assert result.id == "u123"
        user_service.email_service.send_welcome_email.assert_called_once()
    
    def test_should_raise_error_when_user_exists(self, user_service):
        """异常场景：用户已存在"""
        user_service.repository.exists.return_value = True
        
        with pytest.raises(DuplicateUserError):
            user_service.create_user({"username": "test", "email": "t@e.com"})
    
    @pytest.mark.parametrize("invalid_email", [
        "", "invalid", "@example.com", "a" * 250 + "@e.com"
    ])
    def test_should_validate_email_format(self, user_service, invalid_email):
        """边界场景：无效邮箱格式"""
        with pytest.raises(ValidationError):
            user_service.create_user({"username": "test", "email": invalid_email})
```

### 示例 2：API契约测试

**场景**：验证用户API符合OpenAPI规范

```python
import schemathesis
from schemathesis import Case

schema = schemathesis.from_path("openapi.yaml")

@schema.parametrize()
def test_api_contract(case: Case):
    """验证API符合OpenAPI规范"""
    response = case.call()
    case.validate_response(response)

# 自定义验证规则
@schema.parametrize(endpoint="/api/v1/users")
def test_create_user_response_format(case: Case):
    """验证创建用户响应格式"""
    response = case.call()
    
    assert response.status_code == 201
    data = response.json()
    
    # 验证必需字段
    assert "id" in data
    assert "username" in data
    assert "email" in data
    
    # 验证敏感字段不返回
    assert "password" not in data
    assert "password_hash" not in data
```

### 示例 3：性能测试脚本

**场景**：电商系统秒杀场景性能测试

```python
import time
from locust import HttpUser, task, between

class SeckillUser(HttpUser):
    wait_time = between(1, 3)
    
    @task(3)
    def browse_products(self):
        """浏览商品 - 高频操作"""
        self.client.get("/api/products")
    
    @task(1)
    def seckill_order(self):
        """秒杀下单 - 关键场景"""
        start = time.time()
        response = self.client.post("/api/seckill/order", json={
            "product_id": "prod_001",
            "quantity": 1
        })
        duration = time.time() - start
        
        # 记录性能指标
        if response.status_code == 200:
            if duration > 1.0:
                print(f"[警告] 响应时间超过1秒: {duration:.2f}s")
        elif response.status_code == 429:
            print("[信息] 触发限流")

# 压测配置
# locust -f seckill_test.py --host=http://localhost:8000 -u 10000 -r 1000
```

### 示例 4：测试策略设计

**场景**：设计微服务测试策略

```markdown
## 订单服务测试策略

### 测试金字塔
```
        /\
       /  \     E2E (10%)
      /____\    - 下单流程
     /      \   
    /________\  
   /          \ 集成 (30%)
  /____________\ - 订单+支付
 /              \ - 订单+库存
/________________\单元 (60%)
                   - 价格计算
                   - 状态机
```

### 测试分层

**单元测试**（pytest）
- 目标：核心逻辑覆盖率 ≥80%
- 重点：订单金额计算、状态流转、优惠券验证
- 工具：pytest + pytest-mock

**集成测试**（TestContainers）
- 目标：关键流程端到端
- 重点：订单→支付→通知、订单→库存→物流
- 工具：pytest + TestContainers + Kafka容器

**契约测试**（Pact）
- 目标：服务间契约一致性
- 重点：订单服务与支付服务API契约
- 工具：Pact + pact-verifier

**E2E测试**（Playwright）
- 目标：核心用户旅程
- 重点：选品→下单→支付→查看订单
- 工具：Playwright + CI nightly运行
```

## 结构化分析框架

### 测试质量评估维度

| 维度 | 评估指标 | 目标值 |
|-----|---------|-------|
| 覆盖率 | 行覆盖率/分支覆盖率 | ≥80% / ≥70% |
| 稳定性 |  flaky test 比例 | <1% |
| 执行速度 | 单元测试平均耗时 | <100ms |
| 可维护性 | 测试代码重复率 | <10% |
| 有效性 | 缺陷发现率 | 每100测试发现≥2缺陷 |

### 测试类型选择矩阵

```
            快速反馈    集成验证    用户旅程
单元测试        ✓          ✗          ✗
集成测试        ✗          ✓          ✗
E2E测试         ✗          ✗          ✓
契约测试        ✓          ✓          ✗
```

## 约束与限制
- 测试必须独立，不能相互依赖
- 测试数据应该隔离，不影响其他测试
- 单元测试应该快速（<100ms）
- 测试命名应该清晰描述场景
- 断言应该有业务意义

## 自检清单
- [ ] 测试用例命名清晰描述场景
- [ ] 边界条件已覆盖（空值、越界、极值）
- [ ] 断言有意义（验证业务逻辑而非实现细节）
- [ ] 测试数据有代表性
- [ ] 测试之间相互隔离
- [ ] 覆盖率 ≥ 80%
- [ ] 异常场景已测试
- [ ] 测试执行快速（单元测试<100ms）

## 常见陷阱

### 陷阱 1：测试相互依赖

```python
# 反例：测试相互依赖
class TestUserService:
    def test_create_user(self):
        user = UserService.create_user('test@e.com')
        self.user_id = user.id  # 保存状态给下一个测试
    
    def test_get_user(self):
        # 依赖test_create_user的执行结果！
        user = UserService.get_user(self.user_id)  # 单独运行会失败
        assert user is not None

# 正确做法：每个测试独立
class TestUserService:
    @pytest.fixture
    def existing_user(self):
        user = UserService.create_user('test@e.com')
        yield user
        UserService.delete_user(user.id)
    
    def test_get_user(self, existing_user):
        user = UserService.get_user(existing_user.id)
        assert user.username == existing_user.username
```

### 陷阱 2：断言过于宽松

```python
# 反例：无法发现问题的宽松断言
def test_calculate_discount():
    result = calculate_discount(100, 0.2)
    assert result is not None  # 太宽松！
    assert result > 0  # 仍然太宽松！

# 正确做法：精确的断言
def test_calculate_discount():
    # 验证具体业务逻辑
    assert calculate_discount(100, 0.2) == 80.0
    assert calculate_discount(100, 0) == 100.0
    assert calculate_discount(100, 1) == 0.0
    
    # 验证异常情况
    with pytest.raises(ValueError):
        calculate_discount(100, 1.5)  # 折扣率>1
```

### 陷阱 3：测试与实现耦合

```python
# 反例：测试依赖实现细节
def test_user_creation():
    user = create_user("test")
    # 依赖内部实现：数据库ID生成规则
    assert user.id.startswith("USER_")  # 重构时易失败
    # 依赖内部实现：具体的时间格式
    assert user.created_at.strftime("%Y-%m-%d") == "2024-01-01"

# 正确做法：测试行为而非实现
def test_user_creation():
    before = datetime.now()
    user = create_user("test")
    after = datetime.now()
    
    # 验证行为：ID存在且唯一
    assert user.id is not None
    assert len(user.id) > 0
    
    # 验证行为：创建时间在合理范围内
    assert before <= user.created_at <= after
    
    # 验证业务逻辑
    assert user.username == "test"
    assert user.status == "active"
```

### 陷阱 4：忽视测试数据管理

```python
# 反例：共享测试数据导致不稳定
shared_db = TestDatabase()

def test_create_order():
    order = create_order(shared_db, items=[item1])
    assert order.total == 100

def test_update_order():
    # 受test_create_order影响，可能已有数据
    order = create_order(shared_db, items=[item2])
    update_order(shared_db, order.id, items=[item1, item2])
    # 可能因数据污染失败
    assert order.total == 300

# 正确做法：每个测试独立数据
@pytest.fixture
def fresh_db():
    db = TestDatabase()
    db.setup()
    yield db
    db.teardown()

def test_create_order(fresh_db):
    order = create_order(fresh_db, items=[item1])
    assert order.total == 100

def test_update_order(fresh_db):
    order = create_order(fresh_db, items=[item2])
    update_order(fresh_db, order.id, items=[item1, item2])
    assert order.total == 300
```
