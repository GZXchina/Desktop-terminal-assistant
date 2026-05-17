---
name: "minimalism-thinking"
description: "Apply minimalism thinking to reduce unnecessary complexity and improve system quality. Invoke when simplifying code, removing dead code, or preventing over-engineering."
---

# 极简思维 (Minimalism Thinking)

## 核心定义

极简思维是一种**通过减少不必要的复杂性来提升系统质量**的设计思维。它强调"少即是多"，通过移除冗余功能、简化架构、精简代码，使系统更易于理解、维护和演进。

## 技能能力

- **功能精简**：识别并移除不必要的功能
- **架构简化**：消除过度设计和冗余层次
- **代码精简**：删除无用代码，简化复杂逻辑
- **依赖精简**：减少不必要的外部依赖
- **流程简化**：优化开发和部署流程

## 执行流程

```
1. 识别冗余 → 找出不必要的功能、代码、依赖
2. 评估价值 → 判断每个部分的实际价值
3. 制定移除计划 → 安全地删除或简化
4. 验证影响 → 确保移除后系统正常
5. 持续保持 → 建立防止膨胀的机制
```

## 实践要点

1. **如无必要，勿增实体**：新功能必须有明确价值
2. **YAGNI**：不要实现现在不需要的功能
3. **删除的勇气**：敢于删除无用代码和功能
4. **简单优于复杂**：在简单和复杂方案间优先选简单
5. **聚焦核心价值**：只做最重要的事

## 使用示例

### 示例 1：代码精简

**场景**：简化过度复杂的代码

```python
# 反例：过度设计，参数过于灵活
class DataProcessor:
    def process(self, data, options=None):
        if options is None:
            options = {}
        
        result = []
        if not data:
            return result
        
        # 预处理
        if options.get('filter'):
            temp = []
            for item in data:
                if item.get('active'):
                    temp.append(item)
            data = temp
        
        # 转换
        for i in range(len(data)):
            item = data[i]
            transformed = {}
            
            if 'name' in item:
                transformed['name'] = item['name'].upper()
            
            if 'value' in item:
                val = item['value']
                if isinstance(val, (int, float)):
                    transformed['value'] = val * 2
                else:
                    transformed['value'] = val
            
            if options.get('include_id'):
                transformed['id'] = i
            
            result.append(transformed)
        
        if options.get('sort'):
            result.sort(key=lambda x: x.get('name', ''))
        
        return result

# 正确做法：明确需求，移除未使用的选项
from dataclasses import dataclass
from typing import List, Dict, Any

@dataclass
class Item:
    name: str
    value: Any
    active: bool = True

def process_items(items: List[Item]) -> List[Dict[str, Any]]:
    """处理数据项 - 极简版本"""
    return [
        {
            'name': item.name.upper(),
            'value': item.value * 2 if isinstance(item.value, (int, float)) else item.value
        }
        for item in items
        if item.active
    ]

# 需要排序时单独提供
def sort_by_name(items: List[Dict]) -> List[Dict]:
    return sorted(items, key=lambda x: x.get('name', ''))
```

### 示例 2：架构简化

**场景**：微服务架构过度拆分，运维复杂

```python
class ArchitectureSimplifier:
    """架构简化器"""
    
    def __init__(self):
        # 当前：20+ 服务
        self.current_services = [
            "API Gateway", "User Service", "Auth Service", "Profile Service",
            "Order Service", "Payment Service", "Inventory Service",
            "Shipping Service", "Notification Service", "Analytics Service"
        ]
        
        # 简化后：8个服务
        self.simplified_services = {
            "User Service": ["User", "Auth", "Profile"],  # 用户相关合并
            "Commerce Service": ["Order", "Payment", "Inventory"],  # 交易核心
            "Fulfillment Service": ["Shipping", "Notification"],  # 履约相关
            "Analytics Service": ["Analytics"],  # 保持独立
        }
    
    def analyze_merge_benefits(self) -> dict:
        """分析合并收益"""
        return {
            "deployment_units": "20 → 8 (减少60%)",
            "call_chains": "简化",
            "dev_environment": "易于搭建",
            "debugging": "故障排查简化"
        }
    
    def get_merge_plan(self) -> List[dict]:
        """获取合并计划"""
        return [
            {
                "phase": 1,
                "action": "服务合并",
                "target": "20个 → 8个",
                "risk": "需要重构服务间调用"
            },
            {
                "phase": 2,
                "action": "模块化单体（可选）",
                "target": "一个部署单元，内部模块化",
                "risk": "团队需要适应新边界"
            }
        ]
```

### 示例 3：依赖精简

**场景**：项目依赖过多，构建缓慢

```python
# 反例：依赖过多
# package.json
{
  "dependencies": {
    "lodash": "^4.17.21",        # 只用了 debounce
    "moment": "^2.29.4",          # 体积大
    "jquery": "^3.6.0",           # 现代浏览器不需要
    "axios": "^1.4.0",            # 可用 fetch
    "uuid": "^9.0.0",             # 可用 crypto.randomUUID
    "classnames": "^2.3.2",       # 简单函数替代
  }
}

# 正确做法：精简依赖，使用原生能力
class DependencySimplifier:
    """依赖精简器"""
    
    def __init__(self):
        self.replacements = {
            "lodash.debounce": {
                "replacement": "原生实现",
                "code": """
const debounce = (fn, delay) => {
    let timer;
    return (...args) => {
        clearTimeout(timer);
        timer = setTimeout(() => fn(...args), delay);
    };
};
"""
            },
            "moment": {
                "replacement": "Intl.DateTimeFormat",
                "code": "const formatDate = (date) => new Intl.DateTimeFormat('zh-CN').format(date);"
            },
            "jquery": {
                "replacement": "原生 DOM",
                "code": "document.getElementById('app').classList.add('active');"
            },
            "axios": {
                "replacement": "fetch",
                "code": "const api = { get: (url) => fetch(url).then(r => r.json()) };"
            },
            "uuid": {
                "replacement": "crypto.randomUUID",
                "code": "const generateId = () => crypto.randomUUID();"
            },
            "classnames": {
                "replacement": "简单函数",
                "code": "const cx = (...classes) => classes.filter(Boolean).join(' ');"
            }
        }
    
    def get_simplified_package_json(self) -> dict:
        """获取精简后的 package.json"""
        return {
            "dependencies": {
                "react": "^18.2.0",
                "react-dom": "^18.2.0",
                "react-router-dom": "^6.14.0",
                "zustand": "^4.3.8",  # 轻量级状态管理
                "zod": "^3.21.4"  # 验证
            }
        }
```

### 示例 4：过度设计识别

**场景**：识别并简化过度设计的代码

```python
# 反例：过度抽象，只有一个实现
from abc import ABC, abstractmethod
from typing import Protocol

class DataSource(ABC):
    @abstractmethod
    def connect(self): pass
    
    @abstractmethod
    def fetch(self): pass

class Cacheable(Protocol):
    def cache_key(self) -> str: ...

class DatabaseSource(DataSource):
    def __init__(self, config):
        self.config = config
    
    def connect(self):
        self.connection = create_connection(self.config)
    
    def fetch(self):
        cursor = self.connection.cursor()
        cursor.execute("SELECT * FROM data")
        return cursor.fetchall()

class DataSourceFactory:
    @staticmethod
    def create(source_type, config):
        if source_type == 'database':
            return DatabaseSource(config)
        raise ValueError(f"Unknown source: {source_type}")

# 使用
factory = DataSourceFactory()
source = factory.create('database', config)
source.connect()
data = source.fetch()

# 正确做法：移除不必要的抽象层
from contextlib import contextmanager

def fetch_data(connection_string: str):
    """获取数据 - 简化版本"""
    with create_connection(connection_string) as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM data")
        return cursor.fetchall()

# 需要多种数据源时，简单函数即可
def fetch_from_database(connection_string: str):
    with create_connection(connection_string) as conn:
        return conn.execute("SELECT * FROM data").fetchall()

def fetch_from_api(url: str):
    import requests
    return requests.get(url).json()

# 使用
data = fetch_data("postgresql://localhost/db")
```

## 结构化分析框架

### 简化评估速记

```markdown
## 简化评估速记

### 功能清单
| 功能 | 使用频率 | 用户价值 | 维护成本 | 建议 |
|-----|---------|---------|---------|-----|
| | | | | 保留/移除/合并 |

### 代码简化
- 冗余代码位置：
- 可内联的函数：
- 可移除的抽象：

### 依赖审查
| 依赖 | 使用程度 | 替代方案 | 建议 |
|-----|---------|---------|-----|
| | | | 保留/替换/移除 |
```

## 思考流程

```
┌─────────────────────────────────────────────────────────────┐
│  1. 识别复杂度                                                │
│     - 分析当前系统/代码的复杂度来源                           │
│     - 找出冗余功能、代码、依赖                                │
│     - 识别过度设计                                            │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  2. 评估必要性                                                │
│     - 判断每个功能的实际使用频率                              │
│     - 判断每个抽象的必要性                                    │
│     - 判断每个依赖的价值                                      │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  3. 寻找简化点                                                │
│     - 识别可以移除的功能                                      │
│     - 识别可以合并的代码                                      │
│     - 识别可以替换的依赖                                      │
│     - 识别可以内联的抽象                                      │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  4. 平衡取舍                                                  │
│     - 在简洁性和功能性之间找到平衡                            │
│     - 在简单性和可扩展性之间找到平衡                          │
│     - 在精简和可读性之间找到平衡                              │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  5. 制定计划                                                  │
│     - 制定安全的简化实施计划                                  │
│     - 确定优先级和风险                                        │
│     - 准备回滚方案                                            │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  6. 验证影响                                                  │
│     - 确保简化不会破坏现有功能                                │
│     - 运行完整测试套件                                        │
│     - 监控生产环境                                            │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  7. 持续维护                                                  │
│     - 建立防止复杂度再次膨胀的机制                            │
│     - 定期审查新增加的功能和依赖                              │
│     - 培养团队的极简文化                                      │
└─────────────────────────────────────────────────────────────┘
```

## 约束与限制

- 过度简化可能导致功能缺失
- 某些复杂性是业务必需的
- 团队需要认同极简文化
- 简化过程需要测试保障

## 自检清单

- [ ] 每个功能都有明确的使用场景
- [ ] 没有"以防万一"的代码
- [ ] 依赖都是必需的
- [ ] 抽象有多个实现
- [ ] 代码自解释，注释说明"为什么"而非"做什么"
- [ ] 定期清理死代码
- [ ] 新功能经过"是否真的需要"的审视

## 常见陷阱

### 陷阱 1：过度简化

**反例**：为了简化而删除必要的错误处理

```python
# 反例：删除了必要的错误处理
def divide(a, b):
    return a / b  # 会抛出ZeroDivisionError

# 正确做法：保留必要的错误处理
def divide(a: float, b: float) -> float:
    if b == 0:
        raise ValueError("Division by zero")
    return a / b
```

**正确做法**：简化不等于删除所有检查，保留必要的错误处理和边界检查。

### 陷阱 2：为了简化而失去可读性

**反例**：过度使用列表推导式，失去可读性

```python
# 反例：难以理解的过度简化
def process_orders(orders):
    return [{'id': o.id, 'amount': o.amount * 0.9, 'customer': o.customer.name} 
            for o in orders if o.status == 'completed' and o.amount > 100]

# 正确做法：平衡简洁和可读性
def process_orders(orders):
    completed_large_orders = [
        order for order in orders 
        if order.status == 'completed' and order.amount > 100
    ]
    
    return [
        {
            'id': order.id,
            'amount': apply_discount(order.amount, 0.1),
            'customer': order.customer.name
        }
        for order in completed_large_orders
    ]

def apply_discount(amount: float, rate: float) -> float:
    return amount * (1 - rate)
```

**正确做法**：简洁性服务于可读性，不要为了缩短代码行数而牺牲理解性。

### 陷阱 3：过早优化

**反例**：在不需要时追求极简

```python
# 反例：为了"极简"而使用晦涩的位运算
# 假设需求只是简单的权限检查

def has_permission(user, permission):
    # 过度设计：使用位运算存储权限
    PERMISSION_READ = 1 << 0   # 0001
    PERMISSION_WRITE = 1 << 1  # 0010
    PERMISSION_DELETE = 1 << 2 # 0100
    
    permission_map = {
        'read': PERMISSION_READ,
        'write': PERMISSION_WRITE,
        'delete': PERMISSION_DELETE
    }
    
    return user.permissions & permission_map[permission] != 0

# 正确做法：简单明了的实现
def has_permission(user, permission):
    return permission in user.permissions  # permissions 是列表或集合
```

**正确做法**：根据实际需求选择复杂度，不要为了展示技巧而增加复杂性。

### 陷阱 4：一刀切简化

**反例**：不考虑场景差异，强制统一简化

```python
# 反例：所有API都强制使用相同的简单响应格式
class SimpleAPIResponse:
    """强制所有API使用此格式"""
    def __init__(self, data):
        self.data = data  # 没有错误码、没有分页信息

# 正确做法：根据场景选择合适的复杂度
from typing import Generic, TypeVar, Optional

T = TypeVar('T')

class APIResponse(Generic[T]):
    """标准API响应"""
    code: int
    message: str
    data: T
    pagination: Optional[dict] = None

# 简单场景使用简单格式
class SimpleResponse:
    data: any

# 根据场景选择
def get_user_simple(user_id: str) -> SimpleResponse:
    """简单场景"""
    return SimpleResponse(data=get_user(user_id))

def list_users_complex(filters: dict, page: int, size: int) -> APIResponse:
    """复杂场景需要分页和错误处理"""
    users, total = query_users(filters, page, size)
    return APIResponse(
        code=200,
        message="success",
        data=users,
        pagination={"page": page, "size": size, "total": total}
    )
```

**正确做法**：根据场景复杂度选择合适的实现，不要强制所有场景使用同一简化级别。
