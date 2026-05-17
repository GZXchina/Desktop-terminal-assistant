---
name: "skill_performance"
description: "Apply performance optimization capabilities for system, application, and database performance analysis. Invoke when diagnosing performance issues, optimizing code, or tuning databases."
---

# 性能优化技能 (Performance Optimization)

## 核心定义
系统性分析和优化系统、应用和数据库性能，定位瓶颈并提供可量化的改进方案。

## 技能能力
- **性能分析与诊断**：多层级分析定位瓶颈、热点问题发现、性能剖析工具使用
- **系统优化**：代码优化建议、数据库查询优化、基础设施配置优化
- **代码优化**：算法改进、数据结构优化、缓存策略、ORM使用优化
- **基础设施优化**：线程池配置、容器资源配置、负载均衡策略、CDN配置

## 执行流程
```
1. 建立基准 → 测量当前性能指标
2. 瓶颈定位 → 分析找到真正瓶颈
3. 方案设计 → 制定优化策略
4. 实施优化 → 执行优化方案
5. 效果验证 → 对比优化前后指标
6. 持续监控 → 确保优化效果持久
```

## 实践要点
1. **测量先行**：优化前必须有基准数据
2. **定位瓶颈**：找到真正的瓶颈，而非猜测
3. **ROI评估**：评估优化的投入产出比
4. **渐进优化**：小步优化，验证效果
5. **监控闭环**：优化后持续监控效果

## 使用示例

### 示例 1：算法优化

```python
from collections import Counter
from typing import List
import time

# 反例：O(n³) 时间复杂度
def find_duplicates_slow(items):
    """查找重复项 - 低效实现"""
    duplicates = []
    for i in range(len(items)):
        for j in range(i + 1, len(items)):
            if items[i] == items[j] and items[i] not in duplicates:
                duplicates.append(items[i])
    return duplicates

# 正确做法：O(n) 时间复杂度
def find_duplicates_fast(items: List[str]) -> List[str]:
    """查找重复项 - 优化实现"""
    counter = Counter(items)
    return [item for item, count in counter.items() if count > 1]

# 性能对比
items = [f"item_{i % 1000}" for i in range(10000)]

start = time.time()
find_duplicates_slow(items)
print(f"慢版本: {time.time() - start:.2f}s")

start = time.time()
find_duplicates_fast(items)
print(f"快版本: {time.time() - start:.4f}s")
# 性能提升约10000倍
```

### 示例 2：数据库查询优化

```python
# 反例：N+1查询问题
async def get_orders_with_users_slow(user_id: str):
    orders = await db.query("SELECT * FROM orders WHERE user_id = ?", user_id)
    for order in orders:
        # 每条订单都查询用户 - N次查询！
        user = await db.query("SELECT username FROM users WHERE id = ?", order.user_id)
        order.username = user.username
    return orders

# 正确做法：JOIN批量查询
async def get_orders_with_users_fast(user_id: str):
    return await db.query("""
        SELECT o.*, u.username
        FROM orders o
        JOIN users u ON o.user_id = u.id
        WHERE o.user_id = ?
    """, user_id)

# 数据库索引优化
"""
-- 添加复合索引
CREATE INDEX idx_status_created ON orders(status, created_at);

-- 覆盖索引优化
CREATE INDEX idx_status_covering 
ON orders(status, created_at, id, order_no, total_amount);
"""
```

### 示例 3：性能瓶颈定位

```bash
# CPU高占用排查流程

# 1. 找到CPU占用高的进程
top -c
# PID USER  %CPU COMMAND
# 1234 root  98.3 python app.py

# 2. Python性能分析
python -m cProfile -o profile.stats app.py

# 或使用py-spy（无需修改代码）
py-spy top --pid 1234
py-spy record -o profile.svg --pid 1234
```

```python
# 代码性能分析
import cProfile
import pstats
import io

profiler = cProfile.Profile()
profiler.enable()

# 待分析的代码
process_large_dataset()

profiler.disable()

# 输出统计
s = io.StringIO()
ps = pstats.Stats(profiler, stream=s).sort_stats('cumulative')
ps.print_stats(20)
print(s.getvalue())
```

### 示例 4：批量查询优化

```python
from typing import List, Dict, Iterator
import logging

logger = logging.getLogger(__name__)

# 反例：循环单条查询
def get_user_stats_slow(user_ids: List[str]):
    stats = []
    for user_id in user_ids:
        user = db.query(f"SELECT * FROM users WHERE id = {user_id}").fetchone()
        orders = db.query(f"SELECT * FROM orders WHERE user_id = {user_id}").fetchall()
        total_spent = sum(order.amount for order in orders)
        stats.append({
            "user_id": user_id,
            "username": user.username,
            "order_count": len(orders),
            "total_spent": total_spent
        })
    return stats

# 正确做法：批量查询 + 流式返回
def get_user_stats_fast(user_ids: List[str]) -> Iterator[Dict]:
    if not user_ids:
        return
    
    batch_size = 1000
    for i in range(0, len(user_ids), batch_size):
        batch_ids = user_ids[i:i + batch_size]
        placeholders = ','.join(['?' for _ in batch_ids])
        
        query = f"""
            SELECT 
                u.id as user_id,
                u.username,
                COUNT(o.id) as order_count,
                COALESCE(SUM(o.amount), 0) as total_spent
            FROM users u
            LEFT JOIN orders o ON u.id = o.user_id
            WHERE u.id IN ({placeholders})
            GROUP BY u.id, u.username
        """
        
        results = db.query(query, *batch_ids)
        for row in results:
            yield {
                "user_id": row.user_id,
                "username": row.username,
                "order_count": row.order_count,
                "total_spent": float(row.total_spent)
            }

# 性能对比：10000用户
# 慢版本：20000+次查询
# 快版本：10次查询（每批1000）
```

## 结构化分析框架

### 性能瓶颈分析矩阵

| 瓶颈类型 | 识别方法 | 常见原因 | 优化方向 |
|---------|---------|---------|---------|
| CPU密集型 | CPU高、负载高 | 算法复杂、计算密集 | 算法优化、多进程、缓存 |
| IO密集型 | IO等待高 | 磁盘/网络IO | 异步IO、连接池、批量操作 |
| 内存瓶颈 | 内存使用高 | 内存泄漏、大数据集 | 流式处理、分页、缓存 |
| 数据库瓶颈 | 查询慢 | 缺索引、N+1查询 | 索引优化、批量查询 |
| 锁竞争 | 线程阻塞 | 锁粒度过大 | 减少锁粒度、无锁结构 |

### 性能优化ROI评估

```
优化优先级矩阵：

高影响 + 低成本 → 立即执行
高影响 + 高成本 → 规划执行
低影响 + 低成本 → 空闲时执行
低影响 + 高成本 → 不执行
```

## 约束与限制
- 优化必须有数据支撑，避免盲目优化
- 考虑优化带来的复杂度增加
- 关注长期可维护性
- 优化后必须验证效果

## 自检清单
- [ ] 有基准性能数据
- [ ] 瓶颈定位准确
- [ ] 优化方案有数据支撑
- [ ] ROI合理
- [ ] 无副作用
- [ ] 可观测性保障
- [ ] 优化效果已验证

## 常见陷阱

### 陷阱 1：过早优化

```python
# 反例：在不需要的地方进行复杂优化

# 原始代码（清晰、足够快）
def get_user_names(users):
    return [user.name for user in users]

# "优化"后（复杂、难以维护、收益微小）
def get_user_names_optimized(users):
    """使用生成器、map、预分配等"""
    names = []
    names.reserve(len(users))
    return list(map(lambda u: u.name, users))

# 正确做法：先测量，再优化
import time

def benchmark():
    users = [User(name=f"User{i}") for i in range(10000)]
    
    start = time.time()
    for _ in range(1000):
        get_user_names(users)
    duration = time.time() - start
    
    print(f"耗时: {duration:.3f}s")
    # 如果性能足够，不需要优化
```

### 陷阱 2：局部优化损害整体

```python
# 反例：优化查询但增加N+1问题
def get_orders_with_users():
    orders = Order.objects.all()
    for order in orders:
        # 使用缓存但仍有N+1问题
        user = cache.get(f"user:{order.user_id}")
        if not user:
            user = User.objects.get(id=order.user_id)
            cache.set(f"user:{order.user_id}", user, 300)
        order.user = user
    return orders

# 正确做法：使用select_related整体优化
def get_orders_with_users():
    # 1次查询获取所有订单和关联用户
    return Order.objects.select_related('user').all()
```

### 陷阱 3：忽视基准

```python
# 反例：没有测量就优化
def process_data(data):
    # 假设这里性能不好，直接优化
    # ...复杂优化代码...
    pass

# 正确做法：先测量找到瓶颈
def process_data(data):
    # 1. 添加性能测量
    start = time.time()
    
    result = []
    for item in data:
        processed = expensive_operation(item)
        result.append(processed)
    
    duration = time.time() - start
    logger.info(f"process_data耗时: {duration:.3f}s, 数据量: {len(data)}")
    
    # 2. 分析发现expensive_operation是瓶颈
    # 3. 针对性优化expensive_operation
    
    return result
```

### 陷阱 4：过度工程

```python
# 反例：为简单问题设计复杂方案
class DataProcessor:
    """过度设计的处理器"""
    
    def __init__(self):
        self.cache = RedisCache()
        self.queue = TaskQueue()
        self.worker_pool = ThreadPoolExecutor(max_workers=10)
    
    def process(self, data):
        # 简单的数据处理却用了缓存、队列、线程池
        if self.cache.exists(data.id):
            return self.cache.get(data.id)
        
        future = self.worker_pool.submit(self._process, data)
        result = future.result()
        self.cache.set(data.id, result)
        return result

# 正确做法：简单问题简单解决
def process_data(data):
    """简单直接的处理"""
    return transform(data)
```

### 陷阱 5：忽视可读性

```python
# 反例：为性能牺牲代码可读性
def calc(lst):
    return sum(x*y for x,y in zip(lst[:-1],lst[1:]))

# 正确做法：性能与可读性平衡
def calculate_adjacent_products(numbers: List[int]) -> int:
    """计算相邻元素乘积之和"""
    return sum(
        current * next_num 
        for current, next_num in zip(numbers[:-1], numbers[1:])
    )
```
