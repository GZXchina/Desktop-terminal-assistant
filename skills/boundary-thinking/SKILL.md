---
name: "boundary-thinking"
description: "Apply boundary thinking to handle edge cases, validate inputs, and manage resource limits. Invoke when designing input validation, error handling, or dealing with concurrency and async operations."
---

# 边界思维 (Boundary Thinking)

## 核心定义
主动识别和处理系统的边界情况、异常输入和资源限制。在设计阶段就考虑"最坏情况"，通过前置验证、优雅降级和完整错误处理来提升系统的鲁棒性。

## 技能能力
- **输入边界处理**：验证用户输入、API参数、外部数据的边界值
- **资源边界管理**：处理内存、时间、并发数等资源限制
- **异常场景防御**：设计错误处理路径和降级策略
- **竞态条件防护**：处理并发、异步场景下的边界情况
- **接口契约边界**：明确接口的输入输出边界和约束

## 执行流程
```
1. 识别边界 → 找出所有可能的边界点和限制条件
2. 定义约束 → 明确每个边界的合法范围和违规后果
3. 设计验证 → 在边界点设置验证和防护机制
4. 错误处理 → 为边界违规设计处理路径
5. 测试边界 → 针对边界值进行专项测试
```

## 思考流程

### Step 1: 识别边界
- 输入边界：空值、类型、格式、长度、范围
- 资源边界：内存、CPU、存储、网络、时间
- 并发边界：线程安全、竞态条件、死锁
- 业务边界：权限、配额、状态、流程

### Step 2: 定义约束
- 明确合法范围的上下界
- 定义违规的后果（错误/降级/拒绝）
- 确定约束的优先级（安全>功能>性能）

### Step 3: 设计验证
- 前置验证优于后置修复
- 多层验证（客户端→网关→服务→数据层）
- Fail Fast，快速失败避免资源浪费

### Step 4: 错误处理
- 边界错误有明确的错误码和消息
- 错误信息不泄露敏感信息
- 提供降级方案或重试机制

### Step 5: 测试边界
- 最小值、最大值、空值、非法值
- 边界组合测试
- 并发边界压力测试

## 实践要点
1. **前置验证优于后置修复**：在数据进入系统前进行边界检查
2. **Fail Fast, Fail Safe**：快速失败，但保证系统安全状态
3. **防御性编程假设**：假设所有外部输入都可能是恶意的
4. **边界即契约**：清晰的边界定义是系统稳定的基础
5. **优雅降级**：当边界被突破时，系统应提供有限但可用的功能

## 使用示例

### 示例 1：API输入验证

```python
# 反例：缺乏边界防护
class UnsafeRegistration:
    def register(self, username, password, age):
        user = User()
        user.username = username  # 可能为None、空字符串
        user.password = password  # 可能过短
        user.age = age            # 可能为负数
        db.save(user)
        return {"success": True}

# 正确做法：完整边界验证
class BoundaryValidator:
    @staticmethod
    def validate_username(username: str) -> None:
        if not username or len(username) < 3 or len(username) > 20:
            raise ValidationError("username", "长度必须在3-20字符之间")
        if not re.match(r"^[a-zA-Z0-9_]+$", username):
            raise ValidationError("username", "只能包含字母、数字和下划线")
    
    @staticmethod
    def validate_password(password: str) -> None:
        if len(password) < 8:
            raise ValidationError("password", "长度至少8位")
        checks = [
            (any(c.isupper() for c in password), "需要大写字母"),
            (any(c.islower() for c in password), "需要小写字母"),
            (any(c.isdigit() for c in password), "需要数字"),
        ]
        for passed, msg in checks:
            if not passed:
                raise ValidationError("password", msg)
    
    @staticmethod
    def validate_age(age: Any) -> int:
        try:
            age_int = int(age)
        except (ValueError, TypeError):
            raise ValidationError("age", "必须是有效的整数")
        if age_int < 13 or age_int > 120:
            raise ValidationError("age", "必须在13-120岁之间")
        return age_int
```

### 示例 2：文件上传边界设计

```python
class FileUploadService:
    MAX_FILE_SIZE = 100 * 1024 * 1024  # 100MB
    ALLOWED_EXTENSIONS = {'.jpg', '.png', '.pdf'}
    
    def upload(self, file_stream, filename: str, user_id: str) -> UploadResult:
        try:
            # 1. 文件名边界检查
            safe_filename = self._sanitize_filename(filename)
            
            # 2. 文件类型边界检查
            self._validate_file_type(file_stream, safe_filename)
            
            # 3. 文件大小边界检查
            file_size = self._check_file_size(file_stream)
            
            # 4. 存储空间边界检查
            self._check_storage_quota(user_id, file_size)
            
            # 5. 并发限流检查
            self._acquire_upload_slot(user_id)
            
            return UploadResult.success(file_hash, safe_filename)
            
        except FileTooLargeError:
            return UploadResult.failed("文件大小超过限制(100MB)")
        except InvalidFileTypeError:
            return UploadResult.failed("不支持的文件类型")
        except StorageQuotaExceededError:
            return UploadResult.failed("存储空间不足")
        finally:
            self._cleanup_temp_files()
    
    def _sanitize_filename(self, filename: str) -> str:
        # 移除路径分隔符防止路径遍历
        filename = Path(filename).name
        # 限制长度
        if len(filename) > 255:
            name, ext = Path(filename).stem, Path(filename).suffix
            filename = name[:250] + ext
        return filename
```

### 示例 3：分页查询边界问题

```python
# 反例：分页边界处理不当
def get_users(page: int, size: int):
    offset = page * size  # 问题：page从0还是1开始？
    return db.query(User).offset(offset).limit(size).all()

# 正确做法：明确的边界处理
def get_users(page: int, size: int) -> PaginationResult:
    # 参数边界检查
    if page < 1:
        page = 1
    if size < 1 or size > 100:
        size = 20
    
    # 计算偏移量（页码从1开始）
    offset = (page - 1) * size
    
    # 查询总数
    total = db.query(User).count()
    
    # 计算总页数
    total_pages = (total + size - 1) // size
    
    # 页码边界检查
    if page > total_pages:
        page = total_pages if total_pages > 0 else 1
        offset = (page - 1) * size
    
    # 查询数据
    items = db.query(User).offset(offset).limit(size).all()
    
    return PaginationResult(
        items=items,
        total=total,
        page=page,
        size=size,
        total_pages=total_pages
    )
```

### 示例 4：除法函数边界防护

```python
# 反例：无边界检查
def divide(a, b):
    return a / b  # 可能除零、类型错误

# 正确做法：完整边界防护
def safe_divide(a: Union[int, float], b: Union[int, float]) -> float:
    # 类型边界检查
    if not isinstance(a, (int, float)) or not isinstance(b, (int, float)):
        raise TypeError("参数必须是数字类型")
    
    # 除零边界检查
    if b == 0:
        raise ValueError("除数不能为零")
    
    result = a / b
    
    # 后置条件检查
    if result < 0 and a > 0 and b > 0:
        raise RuntimeError("计算错误：结果异常")
    
    return result
```

## 结构化分析框架

### 边界分析速记表

| 边界类型 | 检查项 | 防护策略 |
|---------|-------|---------|
| 输入边界 | 空值、类型、格式、长度、范围 | 前置验证、类型转换 |
| 资源边界 | 内存、CPU、存储、网络 | 配额限制、超时控制 |
| 并发边界 | 线程安全、竞态条件 | 锁、信号量、原子操作 |
| 业务边界 | 权限、配额、状态 | 权限检查、状态机 |

### 边界测试矩阵

```
测试类型
    正常 │  ①      
    边界 │  ②  ③
    异常 │  ④  
       └───────────
       最小值   最大值  输入值

① 正常值测试：验证功能正确性
② 边界值测试：最小值、最大值
③ 边界附近：最小值+1、最大值-1
④ 异常值：空值、负数、超大值
```

## 约束与限制
- 过度边界检查可能影响性能，需要在安全与性能间权衡
- 边界定义需要与业务需求对齐，避免过度设计
- 边界处理代码本身也需要测试
- 外部依赖的边界可能变化，需要持续监控

## 自检清单
- [ ] 所有外部输入都有验证
- [ ] 边界错误有明确的错误信息
- [ ] 资源使用有上限控制
- [ ] 并发操作有竞态防护
- [ ] 超时场景有处理逻辑
- [ ] 边界测试用例已覆盖
- [ ] 错误处理不会泄露敏感信息
- [ ] 降级策略已定义

## 常见陷阱

### 陷阱 1：假设输入总是合法的

```python
# 反例：假设用户输入总是合法的
def calculate_discount(price, discount_rate):
    return price * (1 - discount_rate)

# 问题：calculate_discount(100, 1.5) 返回负数
def calculate_discount(100, -0.1)  # 负折扣，价格反而增加

# 正确做法：严格的边界检查
def calculate_discount(price: float, discount_rate: float) -> float:
    if price < 0:
        raise ValueError(f"Price must be non-negative, got {price}")
    if not 0 <= discount_rate <= 1:
        raise ValueError(f"Discount rate must be between 0 and 1, got {discount_rate}")
    return price * (1 - discount_rate)
```

### 陷阱 2：错误信息泄露

```python
# 反例：边界错误提示暴露系统内部信息
@app.errorhandler(Exception)
def handle_error(error):
    return jsonify({
        'error': str(error),  # 可能包含SQL、文件路径
        'traceback': traceback.format_exc()  # 绝对不应该暴露！
    }), 500

# 攻击者可能看到："Connection to postgres://admin:secret@db.internal.com failed"

# 正确做法：安全的错误处理
@app.errorhandler(Exception)
def handle_error(error):
    logger.error(f"Unhandled exception: {error}", exc_info=True)
    error_id = generate_error_id()
    return jsonify({
        'error': 'Internal server error',
        'error_id': error_id,
        'message': 'An unexpected error occurred. Please try again later.'
    }), 500
```

### 陷阱 3：只检查正常路径

```python
# 反例：只处理正常路径
def get_user(user_id):
    return db.query(User).filter(User.id == user_id).first()

# 问题：user_id为None、用户不存在、数据库连接失败都未处理

# 正确做法：完整的边界处理
def get_user(user_id: Optional[Union[int, str]]) -> Optional[User]:
    # 空值边界
    if user_id is None:
        raise ValueError("user_id cannot be None")
    
    # 类型转换边界
    try:
        user_id_int = int(user_id)
    except (ValueError, TypeError):
        raise ValueError(f"Invalid user_id: {user_id}")
    
    # 查询边界
    user = db.query(User).filter(User.id == user_id_int).first()
    
    # 结果边界
    if user is None:
        raise UserNotFoundError(f"User not found: {user_id}")
    
    return user
```

### 陷阱 4：静默失败

```python
# 反例：边界违规没有明确报错
def parse_config(config_str):
    try:
        return json.loads(config_str)
    except:
        return {}  # 静默返回空配置，问题被隐藏

# 正确做法：明确处理边界错误
def parse_config(config_str: str) -> dict:
    if not config_str or not config_str.strip():
        raise ValueError("Config string cannot be empty")
    
    try:
        config = json.loads(config_str)
    except json.JSONDecodeError as e:
        raise ValueError(f"Invalid JSON config: {e}")
    
    if not isinstance(config, dict):
        raise ValueError("Config must be a JSON object")
    
    return config
```
