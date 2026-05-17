---
name: "closed-loop-thinking"
description: "Apply closed-loop thinking to ensure every operation has a response and every request has feedback. Invoke when designing async operations, resource management, or transaction handling."
---

# 闭环思维 (Closed-Loop Thinking)

## 核心定义
确保每个操作都有响应、每个请求都有反馈的设计思维。在异步系统、资源管理和用户交互中建立完整的反馈回路，避免"请求发出后无响应"的悬置状态，确保系统行为的可预测性和可靠性。

## 技能能力
- **异步操作闭环**：设计回调、Promise、Future 等异步结果处理机制
- **资源管理闭环**：确保资源申请-使用-释放的完整生命周期
- **事务闭环**：设计事务的开始-执行-提交/回滚完整流程
- **用户交互闭环**：确保用户操作有明确的反馈和状态更新
- **消息队列闭环**：处理消息的生产-消费-确认完整链路

## 执行流程
```
1. 识别开环点 → 找出可能无反馈的操作
2. 设计反馈机制 → 确定如何接收响应
3. 定义超时策略 → 设置合理的等待上限
4. 规划补偿措施 → 失败时的回滚或重试
5. 验证闭环完整性 → 确保所有路径都有响应
```

## 思考流程

### Step 1: 识别开环点
- 异步操作：任务提交后无结果追踪
- 资源管理：申请后未释放
- 事务处理：开始但未提交/回滚
- 消息队列：生产后未确认消费

### Step 2: 设计反馈机制
- 同步响应：立即返回任务ID或状态
- 异步回调：通过回调函数通知结果
- 状态查询：提供状态查询接口
- 事件通知：通过事件总线广播状态变更

### Step 3: 定义超时策略
- 设置合理的超时时间
- 超时后触发补偿机制
- 防止无限等待导致资源泄漏

### Step 4: 规划补偿措施
- 失败时回滚已执行的操作
- 提供重试机制
- 记录失败日志用于审计

### Step 5: 验证闭环完整性
- 检查所有成功路径是否有响应
- 检查所有失败路径是否有处理
- 检查超时场景是否有补偿

## 实践要点
1. **每个操作必须有响应**：成功、失败或超时
2. **资源必须成对管理**：申请对应释放，打开对应关闭
3. **状态变更必须可追踪**：从初始状态到最终状态的完整路径
4. **超时机制不可少**：防止无限等待
5. **补偿机制兜底**：当正常闭环失败时的补救措施

## 使用示例

### 示例 1：异步任务闭环

```python
# 反例：开环的异步代码
class TaskManager:
    def submit_task(self, task_func, *args):
        """问题：提交后无反馈，形成开环"""
        asyncio.create_task(task_func(*args))
        return {"status": "submitted"}  # 只是提交，无法追踪结果

# 问题：
# - 提交后无法知道任务是否开始执行
# - 无法知道任务执行结果（成功/失败）
# - 任务异常时无声失败，无错误通知

# 正确做法：完整的闭环设计
from enum import Enum
from dataclasses import dataclass

class TaskStatus(Enum):
    PENDING = "pending"
    RUNNING = "running"
    SUCCESS = "success"
    FAILED = "failed"
    TIMEOUT = "timeout"

@dataclass
class TaskResult:
    task_id: str
    status: TaskStatus
    result: Any = None
    error: Optional[str] = None

class ClosedLoopTaskManager:
    """闭环任务管理器 - 每个任务都有最终状态"""
    
    def __init__(self, default_timeout: int = 300):
        self.tasks: dict[str, TaskResult] = {}
        self.default_timeout = default_timeout
    
    async def submit_task(self, task_func, *args, callback=None, timeout=None) -> str:
        """提交任务 - 返回task_id用于追踪"""
        task_id = str(uuid.uuid4())
        timeout = timeout or self.default_timeout
        
        self.tasks[task_id] = TaskResult(task_id=task_id, status=TaskStatus.PENDING)
        
        # 启动异步执行
        asyncio.create_task(
            self._execute_with_closure(task_id, task_func, timeout, *args)
        )
        
        return task_id
    
    async def _execute_with_closure(self, task_id, task_func, timeout, *args):
        """执行任务并确保闭环"""
        try:
            self.tasks[task_id].status = TaskStatus.RUNNING
            result = await asyncio.wait_for(task_func(*args), timeout=timeout)
            self.tasks[task_id].status = TaskStatus.SUCCESS
            self.tasks[task_id].result = result
        except asyncio.TimeoutError:
            self.tasks[task_id].status = TaskStatus.TIMEOUT
            self.tasks[task_id].error = f"执行超时（{timeout}秒）"
        except Exception as e:
            self.tasks[task_id].status = TaskStatus.FAILED
            self.tasks[task_id].error = str(e)
    
    def get_status(self, task_id: str) -> Optional[TaskResult]:
        """查询任务状态 - 闭环查询"""
        return self.tasks.get(task_id)
```

### 示例 2：资源管理闭环

```python
# 反例：资源未释放
class ResourceUser:
    def process_file(self, filepath):
        f = open(filepath, 'r')  # 打开资源
        data = f.read()
        # 如果这里抛出异常，文件永远不会关闭！
        result = self.process(data)
        f.close()  # 可能执行不到
        return result

# 正确做法：上下文管理器确保闭环
class ResourceManager:
    def process_file(self, filepath):
        with open(filepath, 'r') as f:  # 确保关闭
            data = f.read()
            return self.process(data)
    
    async def use_connection_pool(self):
        """数据库连接池闭环"""
        conn = None
        try:
            conn = await pool.acquire()
            result = await conn.execute("SELECT * FROM users")
            return result
        finally:
            if conn:
                await pool.release(conn)  # 确保归还连接
```

### 示例 3：分布式事务闭环（Saga模式）

```python
@dataclass
class SagaStep:
    name: str
    action: Callable
    compensation: Callable
    executed: bool = False

class SagaOrchestrator:
    """Saga编排器 - 分布式事务闭环"""
    
    def __init__(self, saga_id: str):
        self.saga_id = saga_id
        self.steps: List[SagaStep] = []
    
    def add_step(self, name: str, action: Callable, compensation: Callable):
        self.steps.append(SagaStep(name=name, action=action, compensation=compensation))
        return self
    
    async def execute(self) -> Dict[str, Any]:
        """执行Saga - 要么全部成功，要么全部补偿"""
        executed_steps = []
        
        try:
            for i, step in enumerate(self.steps):
                print(f"[Saga {self.saga_id}] 执行步骤: {step.name}")
                await step.action()
                step.executed = True
                executed_steps.append(i)
            
            return {"status": "completed", "saga_id": self.saga_id}
            
        except Exception as e:
            # 闭环：失败时触发补偿
            print(f"[Saga {self.saga_id}] 步骤失败，开始补偿")
            await self._compensate(executed_steps)
            return {"status": "compensated", "error": str(e), "saga_id": self.saga_id}
    
    async def _compensate(self, executed_steps: List[int]):
        """按相反顺序补偿已执行的步骤"""
        for i in reversed(executed_steps):
            step = self.steps[i]
            try:
                print(f"[Saga {self.saga_id}] 补偿步骤: {step.name}")
                await step.compensation()
            except Exception as e:
                print(f"补偿失败，需要人工介入: {e}")
```

### 示例 4：消息队列闭环

```python
# 反例：消息消费无确认
class SimpleConsumer:
    def consume(self, message):
        result = self.process(message)  # 如果处理失败，消息丢失
        # 没有确认机制

# 正确做法：完整的消息闭环
class ClosedLoopConsumer:
    def __init__(self, max_retries=3):
        self.max_retries = max_retries
    
    def consume(self, message):
        delivery_tag = message.delivery_tag
        
        try:
            # 1. 处理消息
            result = self.process(message.body)
            
            # 2. 成功闭环：确认消息
            self.channel.basic_ack(delivery_tag=delivery_tag)
            
        except RetryableError as e:
            # 3. 可重试错误：拒绝并重新入队
            if message.retry_count < self.max_retries:
                self.channel.basic_nack(delivery_tag=delivery_tag, requeue=True)
            else:
                # 4. 超过重试：转入死信队列
                self.channel.basic_nack(delivery_tag=delivery_tag, requeue=False)
                self.send_to_dlq(message, str(e))
                
        except Exception as e:
            # 5. 不可恢复错误：转入死信队列
            self.channel.basic_nack(delivery_tag=delivery_tag, requeue=False)
            self.send_to_dlq(message, str(e))
```

## 结构化分析框架

### 闭环检查清单

| 场景 | 开环风险 | 闭环策略 |
|------|---------|---------|
| 异步任务 | 提交后无结果 | 任务ID+状态查询+回调 |
| 资源管理 | 泄漏 | 上下文管理器+try/finally |
| 分布式事务 | 部分成功 | Saga模式+补偿机制 |
| 消息队列 | 消息丢失 | 确认机制+死信队列 |
| API调用 | 超时无响应 | 超时设置+重试+熔断 |

### 闭环设计模式

```
同步闭环：请求 → 立即响应 → 结束
异步闭环：请求 → 任务ID → 回调/查询 → 结果
资源闭环：申请 → 使用 → 释放（无论成功与否）
事务闭环：开始 → 执行 → 提交/回滚 → 确认
```

## 约束与限制
- 闭环机制会增加系统复杂度
- 补偿操作可能无法完全回滚（如发送的邮件无法撤回）
- 超时时间设置需要权衡用户体验和资源占用
- 闭环监控需要额外的存储和计算资源

## 自检清单
- [ ] 所有异步操作都有结果追踪机制
- [ ] 所有资源都有释放保证
- [ ] 所有事务都有补偿方案
- [ ] 所有操作都有超时设置
- [ ] 失败场景都有处理路径
- [ ] 消息消费都有确认机制
- [ ] 闭环状态都可查询

## 常见陷阱

### 陷阱 1：开环异步

```python
# 反例：提交后无反馈
class FireAndForget:
    def send_notification(self, user_id, message):
        asyncio.create_task(self._send(user_id, message))
        return "已发送"  # 实际上可能失败

# 正确做法：闭环追踪
class TrackedNotification:
    def send_notification(self, user_id, message):
        notification_id = self.generate_id()
        self.status_store[notification_id] = "pending"
        
        async def send_with_closure():
            try:
                await self._send(user_id, message)
                self.status_store[notification_id] = "delivered"
            except Exception as e:
                self.status_store[notification_id] = f"failed: {e}"
        
        asyncio.create_task(send_with_closure())
        return {"id": notification_id, "status": "pending"}
```

### 陷阱 2：资源泄漏

```python
# 反例：异常时资源未释放
class LeakyResource:
    def process(self):
        conn = db.get_connection()
        result = conn.query("SELECT * FROM data")  # 可能异常
        conn.close()  # 异常时不会执行
        return result

# 正确做法：确保释放
class SafeResource:
    def process(self):
        conn = db.get_connection()
        try:
            return conn.query("SELECT * FROM data")
        finally:
            conn.close()  # 无论成功与否都释放
```

### 陷阱 3：无补偿的事务

```python
# 反例：部分失败无补偿
class NoCompensation:
    async def transfer(self, from_user, to_user, amount):
        await self.deduct(from_user, amount)  # 成功
        await self.add(to_user, amount)       # 失败！钱已扣但未到账

# 正确做法：Saga补偿
class WithCompensation:
    async def transfer(self, from_user, to_user, amount):
        saga = SagaOrchestrator("transfer")
        saga.add_step(
            "deduct",
            action=lambda: self.deduct(from_user, amount),
            compensation=lambda: self.add(from_user, amount)  # 回滚
        ).add_step(
            "add",
            action=lambda: self.add(to_user, amount),
            compensation=lambda: self.deduct(to_user, amount)
        )
        return await saga.execute()
```

### 陷阱 4：消息消费无确认

```python
# 反例：自动确认导致消息丢失
class AutoAckConsumer:
    def on_message(self, ch, method, properties, body):
        # 消息已自动确认
        process(body)  # 如果处理失败，消息丢失且不会重试

# 正确做法：手动确认
class ManualAckConsumer:
    def on_message(self, ch, method, properties, body):
        try:
            process(body)
            ch.basic_ack(delivery_tag=method.delivery_tag)  # 成功才确认
        except Exception:
            ch.basic_nack(delivery_tag=method.delivery_tag, requeue=True)
```
