---
name: "skill_backend"
description: "Apply backend development capabilities for API design, database architecture, and business logic implementation. Invoke when designing RESTful/GraphQL APIs, optimizing database queries, or building server-side systems."
---

# 后端开发技能 (Backend Development)

## 核心定义
设计高性能、可扩展且安全的服务器端系统，涵盖API设计、数据库架构、业务逻辑实现和运维保障。

## 技能能力
- **API设计**：RESTful规范、GraphQL接口、版本管理、认证授权
- **业务逻辑实现**：服务层设计、复杂规则处理、异步任务、缓存策略
- **数据库架构**：表结构设计、索引优化、查询优化、分库分表
- **高可用与扩展**：负载均衡、自动扩容、熔断降级、监控告警
- **安全与运维**：JWT/OAuth2认证、数据加密、容器化部署、日志审计

## 执行流程
```
1. 需求分析 → 明确功能边界和数据流
2. API设计 → 定义接口契约（OpenAPI/Swagger）
3. 数据库设计 → 表结构、索引、约束
4. 业务实现 → 服务层、数据访问层
5. 测试验证 → 单元测试、集成测试
6. 部署上线 → 容器化、CI/CD、监控
```

## 实践要点
1. **API设计优先**：清晰的接口契约是协作基础
2. **数据一致性**：明确事务边界，处理分布式一致性
3. **防御式编程**：输入校验、异常处理、降级策略
4. **可观测性**：日志、指标、追踪三位一体的监控
5. **安全第一**：认证授权、数据脱敏、防注入攻击

## 使用示例

### 示例 1：RESTful API设计

**场景**：设计用户管理API，包含CRUD操作

```python
from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, Field
from typing import List, Optional

router = APIRouter(prefix="/api/v1/users", tags=["用户管理"])

class UserCreate(BaseModel):
    """创建用户请求"""
    username: str = Field(..., min_length=3, max_length=20)
    email: str = Field(..., regex=r"^[\w\.-]+@[\w\.-]+\.\w+$")
    phone: Optional[str] = Field(None, regex=r"^1[3-9]\d{9}$")

class UserResponse(BaseModel):
    """用户响应"""
    id: str
    username: str
    email: str
    status: str
    created_at: str

@router.post("", response_model=UserResponse, status_code=201)
async def create_user(
    user_data: UserCreate,
    service: UserService = Depends(get_user_service)
):
    """创建用户"""
    try:
        return await service.create_user(user_data)
    except DuplicateError as e:
        raise HTTPException(status_code=409, detail=str(e))

@router.get("", response_model=List[UserResponse])
async def list_users(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    service: UserService = Depends(get_user_service)
):
    """获取用户列表（分页）"""
    return await service.list_users(page=page, page_size=page_size)

@router.get("/{user_id}", response_model=UserResponse)
async def get_user(user_id: str, service: UserService = Depends(get_user_service)):
    """获取用户详情"""
    user = await service.get_user(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    return user

@router.put("/{user_id}", response_model=UserResponse)
async def update_user(
    user_id: str,
    user_data: UserCreate,
    service: UserService = Depends(get_user_service)
):
    """更新用户"""
    user = await service.update_user(user_id, user_data)
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    return user

@router.delete("/{user_id}", status_code=204)
async def delete_user(user_id: str, service: UserService = Depends(get_user_service)):
    """删除用户"""
    success = await service.delete_user(user_id)
    if not success:
        raise HTTPException(status_code=404, detail="用户不存在")
```

### 示例 2：数据库设计与查询优化

**场景**：电商订单系统数据库设计

```python
# 表结构定义（SQLAlchemy）
from sqlalchemy import Column, String, DateTime, Numeric, ForeignKey, Index
from sqlalchemy.orm import relationship

class Order(Base):
    __tablename__ = "orders"
    
    id = Column(String(32), primary_key=True)
    user_id = Column(String(32), ForeignKey("users.id"), nullable=False)
    status = Column(String(20), nullable=False, index=True)  # 状态索引
    total_amount = Column(Numeric(10, 2), nullable=False)
    created_at = Column(DateTime, nullable=False, index=True)  # 时间索引
    
    # 关系定义
    user = relationship("User", back_populates="orders")
    items = relationship("OrderItem", back_populates="order")
    
    # 复合索引：用户+时间（常用查询场景）
    __table_args__ = (
        Index('idx_user_created', 'user_id', 'created_at'),
    )

class OrderItem(Base):
    __tablename__ = "order_items"
    
    id = Column(String(32), primary_key=True)
    order_id = Column(String(32), ForeignKey("orders.id"), nullable=False)
    product_id = Column(String(32), nullable=False)
    quantity = Column(Integer, nullable=False)
    unit_price = Column(Numeric(10, 2), nullable=False)
    
    order = relationship("Order", back_populates="items")

# 查询优化示例
class OrderRepository:
    def __init__(self, db_session):
        self.db = db_session
    
    def get_user_orders_with_items(self, user_id: str, limit: int = 20):
        """
        获取用户订单及详情
        优化：使用joinedload避免N+1查询
        """
        return self.db.query(Order)\
            .options(joinedload(Order.items))\
            .filter(Order.user_id == user_id)\
            .order_by(Order.created_at.desc())\
            .limit(limit)\
            .all()
    
    def get_order_statistics(self, start_date: datetime, end_date: datetime):
        """
        订单统计（使用聚合查询）
        """
        return self.db.query(
            Order.status,
            func.count(Order.id).label('count'),
            func.sum(Order.total_amount).label('total')
        ).filter(
            Order.created_at.between(start_date, end_date)
        ).group_by(Order.status).all()
```

### 示例 3：业务逻辑层设计

**场景**：订单处理服务，包含库存检查、价格计算、优惠券应用

```python
from dataclasses import dataclass
from typing import List, Optional
from decimal import Decimal

@dataclass
class OrderItem:
    product_id: str
    quantity: int
    unit_price: Decimal

@dataclass
class Order:
    user_id: str
    items: List[OrderItem]
    coupon_code: Optional[str] = None

class OrderService:
    """订单服务 - 核心业务逻辑"""
    
    def __init__(
        self,
        inventory_service: InventoryService,
        pricing_service: PricingService,
        coupon_service: CouponService,
        order_repository: OrderRepository
    ):
        self.inventory = inventory_service
        self.pricing = pricing_service
        self.coupon = coupon_service
        self.repo = order_repository
    
    async def create_order(self, order_data: Order) -> dict:
        """创建订单 - 完整业务流程"""
        # 1. 库存检查
        for item in order_data.items:
            available = await self.inventory.check_stock(
                item.product_id, 
                item.quantity
            )
            if not available:
                raise InsufficientStockError(f"商品 {item.product_id} 库存不足")
        
        # 2. 计算价格
        subtotal = sum(
            item.unit_price * item.quantity 
            for item in order_data.items
        )
        
        # 3. 应用优惠券
        discount = Decimal('0')
        if order_data.coupon_code:
            discount = await self.coupon.apply_coupon(
                order_data.coupon_code,
                subtotal
            )
        
        total = subtotal - discount
        
        # 4. 创建订单（事务）
        order = await self.repo.create_order(
            user_id=order_data.user_id,
            items=order_data.items,
            subtotal=subtotal,
            discount=discount,
            total=total
        )
        
        # 5. 扣减库存
        for item in order_data.items:
            await self.inventory.deduct_stock(
                item.product_id,
                item.quantity
            )
        
        return {
            "order_id": order.id,
            "total": total,
            "status": "created"
        }
    
    async def cancel_order(self, order_id: str) -> bool:
        """取消订单 - 回滚库存"""
        order = await self.repo.get_order(order_id)
        if not order or order.status != "created":
            return False
        
        # 1. 更新订单状态
        await self.repo.update_status(order_id, "cancelled")
        
        # 2. 回滚库存
        for item in order.items:
            await self.inventory.add_stock(
                item.product_id,
                item.quantity
            )
        
        return True
```

### 示例 4：认证与授权

**场景**：JWT认证实现

```python
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import JWTError, jwt
from passlib.context import CryptContext

# 密码加密
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
security = HTTPBearer()

class AuthService:
    """认证服务"""
    
    SECRET_KEY = "your-secret-key"
    ALGORITHM = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES = 30
    
    def verify_password(self, plain_password: str, hashed_password: str) -> bool:
        """验证密码"""
        return pwd_context.verify(plain_password, hashed_password)
    
    def hash_password(self, password: str) -> str:
        """哈希密码"""
        return pwd_context.hash(password)
    
    def create_access_token(self, user_id: str) -> str:
        """创建访问令牌"""
        expire = datetime.utcnow() + timedelta(minutes=self.ACCESS_TOKEN_EXPIRE_MINUTES)
        payload = {
            "sub": user_id,
            "exp": expire,
            "type": "access"
        }
        return jwt.encode(payload, self.SECRET_KEY, algorithm=self.ALGORITHM)
    
    async def get_current_user(
        self,
        credentials: HTTPAuthorizationCredentials = Depends(security)
    ) -> User:
        """获取当前用户（依赖注入）"""
        token = credentials.credentials
        
        try:
            payload = jwt.decode(token, self.SECRET_KEY, algorithms=[self.ALGORITHM])
            user_id = payload.get("sub")
            if user_id is None:
                raise HTTPException(status_code=401, detail="Invalid token")
        except JWTError:
            raise HTTPException(status_code=401, detail="Invalid token")
        
        user = await self.user_repo.get_by_id(user_id)
        if user is None:
            raise HTTPException(status_code=401, detail="User not found")
        
        return user

# 使用示例
@router.get("/profile", response_model=UserResponse)
async def get_profile(current_user: User = Depends(auth_service.get_current_user)):
    """获取当前用户信息（需要认证）"""
    return current_user
```

## 结构化分析框架

### API设计检查清单

| 检查项 | 要求 | 示例 |
|-------|------|-----|
| **URL设计** | 资源名词，复数形式 | `/users` 而非 `/getUsers` |
| **HTTP方法** | 符合语义 | GET/POST/PUT/DELETE |
| **状态码** | 准确使用 | 200/201/204/400/401/403/404/500 |
| **请求验证** | 输入校验 | Pydantic模型验证 |
| **错误响应** | 统一格式 | `{error: "message", code: "XXX"}` |
| **分页** | 标准参数 | `page`, `page_size` |
| **版本控制** | URL或Header | `/api/v1/` |

### 数据库设计检查清单

- [ ] 主键使用 UUID 或自增ID
- [ ] 外键建立索引
- [ ] 常用查询字段建立索引
- [ ] 避免过多索引（影响写入）
- [ ] 使用合适的数据类型
- [ ] 敏感数据加密存储
- [ ] 软删除而非硬删除
- [ ] 时间戳字段（created_at, updated_at）

## 约束与限制
- 数据库连接池有上限，需合理配置
- 分布式事务实现复杂，尽量避免
- 缓存一致性难以保证，需设计失效策略
- 异步编程增加调试难度
- 微服务增加运维复杂度

## 自检清单
- [ ] API接口有完整的请求/响应模型
- [ ] 输入参数有校验规则
- [ ] 敏感操作有权限控制
- [ ] 数据库查询有索引支持
- [ ] 关键路径有日志记录
- [ ] 异常有处理机制
- [ ] 有单元测试覆盖
- [ ] 性能关键路径有监控

## 常见陷阱

### 陷阱 1：N+1查询
**问题**：循环中查询关联数据，导致性能灾难

```python
# 反例：N+1查询问题
def get_orders_with_details():
    orders = Order.objects.all()  # 1次查询
    for order in orders:
        user = User.objects.get(id=order.user_id)  # N次查询！
        items = OrderItem.objects.filter(order_id=order.id)  # N次查询！
        ...
# 100个订单 = 1 + 100 + 100 = 201次查询

# 正确做法：使用select_related和prefetch_related
def get_orders_with_details():
    orders = Order.objects.select_related('user').prefetch_related('items').all()
    for order in orders:
        user = order.user  # 已预加载，不触发查询
        items = order.items.all()  # 已预加载
        ...
# 总查询次数：2次
```

### 陷阱 2：忽视安全
**问题**：未做输入校验和权限控制

```python
# 反例：未做输入校验和权限控制
@app.route('/api/users/<user_id>/orders')
def get_user_orders(user_id):
    query = f"SELECT * FROM orders WHERE user_id = {user_id}"
    orders = db.execute(query)  # SQL注入风险！
    return jsonify(orders)

# 正确做法：输入校验 + 权限控制 + 防注入
@app.route('/api/users/<user_id>/orders')
@jwt_required()
def get_user_orders(user_id):
    # 1. 输入校验
    if not is_valid_uuid(user_id):
        return jsonify({'error': 'Invalid user_id'}), 400
    
    # 2. 权限控制
    if str(get_jwt_identity()) != user_id:
        return jsonify({'error': 'Forbidden'}), 403
    
    # 3. 使用ORM防止SQL注入
    orders = Order.objects.filter(user_id=user_id)
    return jsonify([order.to_dict() for order in orders])
```

### 陷阱 3：过度设计
**问题**：为简单功能引入复杂架构

```python
# 反例：简单CRUD却引入复杂抽象
class UserRepositoryInterface(ABC):
    @abstractmethod
    def create(self, user): pass
    @abstractmethod
    def get(self, id): pass

class UserRepositoryFactory:
    def create(self, db_type): ...

class SQLUserRepository(UserRepositoryInterface):
    def __init__(self, connection_pool, query_builder, cache_manager):
        ...

# 正确做法：简单直接的实现
class UserRepository:
    def __init__(self, db_session):
        self.db = db_session
    
    def create(self, user_data: dict) -> User:
        user = User(**user_data)
        self.db.add(user)
        self.db.commit()
        return user
    
    def get(self, user_id: str) -> Optional[User]:
        return self.db.query(User).filter_by(id=user_id).first()
```

### 陷阱 4：硬编码配置
**问题**：配置信息写死在代码中

```python
# 反例：硬编码配置
class Database:
    def connect(self):
        return psycopg2.connect(
            host="localhost",
            port=5432,
            database="mydb",
            user="admin",
            password="secret123"  # 密码硬编码！
        )

# 正确做法：配置外部化
class Database:
    def __init__(self, config: DatabaseConfig):
        self.config = config
    
    def connect(self):
        return psycopg2.connect(
            host=self.config.host,
            port=self.config.port,
            database=self.config.database,
            user=self.config.user,
            password=self.config.password  # 从环境变量读取
        )

# 配置加载
from pydantic import BaseSettings

class DatabaseConfig(BaseSettings):
    host: str = "localhost"
    port: int = 5432
    database: str
    user: str
    password: str
    
    class Config:
        env_prefix = "DB_"  # 从环境变量读取 DB_HOST, DB_PASSWORD 等
```

### 陷阱 5：忽视错误处理
**问题**：异常未处理或处理不当

```python
# 反例：忽视错误处理
def process_payment(order_id: str, amount: Decimal):
    order = order_repo.get(order_id)  # 可能返回None
    order.status = "paid"  # 可能AttributeError
    payment_gateway.charge(order.user.card_token, amount)  # 可能异常
    order_repo.save(order)  # 可能数据库错误
    return {"success": True}

# 正确做法：完善的错误处理
def process_payment(order_id: str, amount: Decimal) -> PaymentResult:
    try:
        # 1. 获取订单
        order = order_repo.get(order_id)
        if not order:
            return PaymentResult.failed("订单不存在")
        
        if order.status != "pending":
            return PaymentResult.failed("订单状态不正确")
        
        # 2. 处理支付
        try:
            charge_result = payment_gateway.charge(
                order.user.card_token, 
                amount
            )
        except PaymentError as e:
            logger.error(f"支付失败: {e}", extra={"order_id": order_id})
            return PaymentResult.failed(f"支付失败: {str(e)}")
        
        # 3. 更新订单状态（事务）
        with transaction():
            order.status = "paid"
            order.payment_id = charge_result.id
            order_repo.save(order)
        
        return PaymentResult.success(charge_result.id)
        
    except Exception as e:
        logger.exception(f"处理支付时发生错误: {e}")
        return PaymentResult.failed("系统错误，请稍后重试")
```
