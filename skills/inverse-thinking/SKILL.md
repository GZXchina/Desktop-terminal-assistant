---
name: "inverse-thinking"
description: "Apply inverse thinking to identify failure paths and risks before building. Invoke when dealing with security/financial tasks, bug investigation, or designing fault recovery mechanisms."
---

# 逆向思维 (Inverse Thinking)

## 核心定义

逆向思维是一种**从排雷到构建**的思维方法。先问"怎样做一定会失败"，列出所有失败路径和风险点，主动设计防御措施，避免盲目乐观导致的失误。

## 技能能力

- **失败路径识别**：系统性地列出所有可能的失败场景
- **风险分类评估**：对风险进行分类和优先级排序
- **防御措施设计**：针对风险设计预防和缓解策略
- **故障预演**：通过假设失败来验证系统韧性

## 执行流程

```
1. 假设失败 → 假设项目/功能已经失败
2. 逆向推理 → 为什么会失败？列出所有可能原因
3. 风险分类 → 按类型分类，评估概率和影响
4. 防御设计 → 预防、检测、缓解、恢复
5. 优先级排序 → 高概率高影响必须解决
6. 验证测试 → 故障注入、灾难恢复演练
```

## 实践要点

1. **逆向提问**：不问"如何成功"，先问"怎样一定会失败"
2. **最坏情况**：考虑最坏的结果是什么
3. **风险分类**：技术、操作、安全、业务、人员风险
4. **预演失败**：假设明天就要出问题，最可能因为什么

## 使用示例

### 示例 1：支付系统设计

**场景**：设计支付系统

```python
class InversePaymentDesign:
    """逆向思维设计支付系统"""
    
    def identify_failure_modes(self):
        """识别失败模式"""
        failures = {
            'lost_order': '网络超时、数据库故障、重复提交',
            'duplicate_charge': '幂等性缺失、超时重试',
            'data_inconsistency': '分布式事务失败',
            'security_attack': '参数篡改、重放攻击'
        }
        return failures
    
    def design_defenses(self):
        """设计防御措施"""
        defenses = {
            'idempotency': '唯一订单号，防止重复扣款',
            'reconciliation': '定时对账+差异处理',
            'distributed_transaction': 'TCC模式保证一致性',
            'signature': '签名验证+防重放（时间戳+随机数）',
            'circuit_breaker': '限流熔断，防止攻击'
        }
        return defenses
```

### 示例 2：防御式编程

**场景**：用户输入处理

```python
class DefensiveInputHandler:
    """防御式输入处理"""
    
    def process_input(self, user_input):
        # 逆向思考：输入为空会怎样？
        if not user_input:
            return None
        
        # 逆向思考：输入超长会怎样？
        if len(user_input) > 1000:
            raise ValueError("Input too long")
        
        # 逆向思考：输入包含特殊字符会怎样？
        if not re.match(r'^[\w\s]+$', user_input):
            raise ValueError("Invalid characters")
        
        # 逆向思考：输入是恶意构造的会怎样？
        # 使用参数化查询防止SQL注入
        return db.query("SELECT * FROM users WHERE name = ?", user_input)
```

### 示例 3：容错设计

**场景**：第三方服务调用

```python
class ResilientServiceClient:
    """容错服务客户端"""
    
    def call_third_party(self, request):
        # 逆向思考：第三方服务挂了会怎样？
        # → 添加熔断降级
        
        # 逆向思考：响应超时会怎样？
        # → 添加超时控制
        
        # 逆向思考：返回数据格式异常会怎样？
        # → 添加数据校验
        
        # 逆向思考：调用次数超限会怎样？
        # → 添加限流和缓存
        
        try:
            with circuit_breaker:
                response = requests.post(
                    self.endpoint,
                    json=request,
                    timeout=3,
                    retries=3
                )
                return self.validate_response(response)
        except CircuitBreakerOpen:
            return self.fallback_response()
        except Timeout:
            return self.cached_response(request)
```

## 结构化分析框架

```
逆向思维分析框架
├── 1. 假设失败
│   ├── 场景
│   └── 失败表现
│
├── 2. 逆向推理
│   ├── 失败原因
│   ├── 触发条件
│   └── 薄弱环节
│
├── 3. 风险分类
│   ├── 技术风险
│   ├── 操作风险
│   ├── 安全风险
│   ├── 业务风险
│   └── 人员风险
│
├── 4. 防御措施
│   ├── 预防
│   ├── 检测
│   ├── 缓解
│   └── 恢复
│
└── 5. 优先级
    ├── 必须解决
    ├── 准备预案
    └── 接受风险
```

## 思考流程

当激活逆向思维时，按以下步骤进行深度分析：

**步骤 1：假设失败**
- 假设项目/功能已经失败
- 假设系统已经崩溃
- 假设数据已经丢失

**步骤 2：逆向推理**
- 为什么会失败？列出所有可能原因
- 什么条件会导致失败？
- 哪些环节最脆弱？

**步骤 3：风险分类**
- 按类型分类（技术/操作/安全/业务/人员）
- 评估概率（高/中/低）
- 评估影响（灾难/严重/一般/轻微）

**步骤 4：防御设计**
- 预防：如何防止风险发生
- 检测：如何及时发现风险
- 缓解：风险发生后如何降低影响
- 恢复：如何从失败中恢复

**步骤 5：优先级排序**
- 高概率高影响：必须解决
- 高概率低影响：考虑解决
- 低概率高影响：准备预案
- 低概率低影响：接受风险

## 约束与限制

1. **乐观偏见**：低估失败的可能性
2. **事后诸葛亮**：失败后才知道哪里错了
3. **防御过度**：为极低概率风险投入过多成本
4. **忽视级联**：单个故障引发连锁反应
5. **假设用户不会**：低估用户的"创造力"

## 自检清单

- [ ] 我列出了至少3种失败场景吗？
- [ ] 最坏情况下的损失是什么？可接受吗？
- [ ] 每个风险都有对应的防御措施吗？
- [ ] 我测试过失败场景吗？
- [ ] 监控和告警能及时发现这些问题吗？

## 常见陷阱

### 陷阱 1：乐观偏见

```python
# 反例：低估失败的可能性
class OptimisticFileUpload:
    def handle_upload(self, file):
        """
        乐观假设：
        - "用户会上传正常文件"
        - "网络不会中断"
        - "磁盘不会满"
        """
        file_path = f"/uploads/{file.name}"
        with open(file_path, 'wb') as f:
            f.write(file.read())
        return {"status": "success"}

# 可能的失败：上传可执行文件、上传超大文件、路径遍历攻击

# 正确做法：考虑各种失败场景
class SecureFileUploadHandler:
    ALLOWED_EXTENSIONS = {'jpg', 'jpeg', 'png', 'gif', 'pdf'}
    MAX_FILE_SIZE = 10 * 1024 * 1024  # 10MB
    
    def handle_upload(self, file, user_id):
        # 验证文件类型（白名单）
        ext = self._get_extension(file.name)
        if ext not in self.ALLOWED_EXTENSIONS:
            raise InvalidFileTypeError()
        
        # 验证文件大小
        if file.size > self.MAX_FILE_SIZE:
            raise FileTooLargeError()
        
        # 安全的文件名（使用随机ID）
        safe_filename = f"{uuid.uuid4()}.{ext}"
        file_path = os.path.join(self.UPLOAD_DIR, str(user_id), safe_filename)
        
        # 检查磁盘空间
        if not self._has_enough_disk_space(file.size):
            raise InsufficientDiskSpaceError()
        
        # 原子写入
        temp_path = file_path + ".tmp"
        try:
            with open(temp_path, 'wb') as f:
                for chunk in file.chunks():
                    f.write(chunk)
            os.rename(temp_path, file_path)
        except Exception:
            if os.path.exists(temp_path):
                os.remove(temp_path)
            raise
        
        return {"status": "success", "path": file_path}
```

### 陷阱 2：忽视级联故障

```python
# 反例：单个故障引发连锁反应
class OrderService:
    def create_order(self, user_id, items):
        # 扣减库存
        for item in items:
            inventory_service.deduct(item['id'], item['qty'])  # 如果失败？
        
        # 创建订单
        order = db.orders.create(user_id=user_id, items=items)  # 如果失败？
        
        # 扣款
        payment_service.charge(user_id, order.total)  # 如果失败？
        
        # 发送通知
        notification_service.send(user_id, "Order created")  # 如果失败？
        
        return order

# 问题：如果扣款失败，订单已创建，库存已扣减，但用户没付款

# 正确做法：考虑级联故障，设计补偿机制
class RobustOrderService:
    def create_order(self, user_id, items):
        order = None
        inventory_reserved = False
        
        try:
            # 1. 预留库存（可释放）
            reservation_id = inventory_service.reserve(items)
            inventory_reserved = True
            
            # 2. 创建订单（状态：pending）
            order = db.orders.create(
                user_id=user_id,
                items=items,
                status='pending',
                reservation_id=reservation_id
            )
            
            # 3. 扣款
            payment_result = payment_service.charge(user_id, order.total)
            
            if payment_result.success:
                # 4. 确认库存扣减
                inventory_service.confirm_reservation(reservation_id)
                order.update(status='confirmed')
                notification_service.send_async(user_id, "Order confirmed")
            else:
                raise PaymentFailedError()
                
        except Exception as e:
            # 补偿操作
            if inventory_reserved:
                inventory_service.release_reservation(reservation_id)
            if order:
                order.update(status='cancelled', error=str(e))
            alert_ops_team(f"Order creation failed: {e}")
            raise
        
        return order
```
