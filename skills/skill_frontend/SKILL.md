---
name: "skill_frontend"
description: "Apply frontend development capabilities for React/Vue/Angular applications, state management, and component architecture. Invoke when building UI components, managing complex state, or optimizing frontend performance."
---

# 前端开发技能 (Frontend Development)

## 核心定义
构建高性能、可扩展的前端界面，涵盖组件架构、状态管理、性能优化和跨框架开发。

## 技能能力
- **界面开发**：响应式UI、动画交互、可访问性
- **组件架构**：可复用组件体系、Props接口、生命周期管理
- **状态管理**：Redux/Zustand/Vuex/NgRx复杂状态逻辑
- **性能优化**：代码拆分、懒加载、虚拟滚动、缓存策略
- **质量保证**：构建工具配置、CI/CD、测试体系

## 执行流程
```
1. 需求分析 → 页面结构、交互逻辑、数据流
2. 组件设计 → 拆分组件、定义Props、确定状态
3. 状态管理 → 选择方案、设计数据结构
4. 编码实现 → 遵循规范、添加测试
5. 性能优化 → 懒加载、缓存、代码拆分
6. 测试验证 → 单元测试、集成测试、E2E测试
```

## 实践要点
1. **组件单一职责**：一个组件只做一件事
2. **Props接口清晰**：类型定义完整，默认值合理
3. **状态分层管理**：页面级、组件级、应用级分离
4. **性能优先**：避免不必要的重渲染
5. **可访问性**：语义化标签、键盘导航、屏幕阅读器

## 使用示例

### 示例 1：组件设计

**场景**：设计用户卡片组件，支持多种状态

```tsx
// UserCard.tsx
import React, { useState, useCallback } from 'react';
import classNames from 'classnames';

interface User {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  role: 'admin' | 'user' | 'guest';
  status: 'active' | 'inactive' | 'banned';
}

interface UserCardProps {
  user: User;
  variant?: 'default' | 'compact' | 'detailed';
  showActions?: boolean;
  onEdit?: (userId: string) => void;
  onDelete?: (userId: string) => void;
  className?: string;
}

export const UserCard: React.FC<UserCardProps> = ({
  user,
  variant = 'default',
  showActions = true,
  onEdit,
  onDelete,
  className
}) => {
  const [isLoading, setIsLoading] = useState(false);

  const handleDelete = useCallback(async () => {
    if (!window.confirm(`确定删除用户 ${user.name}？`)) return;
    setIsLoading(true);
    try {
      await onDelete?.(user.id);
    } finally {
      setIsLoading(false);
    }
  }, [onDelete, user.id, user.name]);

  return (
    <div className={classNames('user-card', `user-card--${variant}`, className)}>
      <div className="user-card__avatar">
        <img src={user.avatar || '/default-avatar.png'} alt={user.name} />
        <span className={`status-badge status-badge--${user.status}`} />
      </div>
      
      <div className="user-card__info">
        <h3 className="user-card__name">{user.name}</h3>
        <p className="user-card__email">{user.email}</p>
        <span className={`role-badge role-badge--${user.role}`}>
          {user.role}
        </span>
      </div>
      
      {showActions && (
        <div className="user-card__actions">
          <button onClick={() => onEdit?.(user.id)} disabled={isLoading}>
            编辑
          </button>
          <button onClick={handleDelete} disabled={isLoading}>
            {isLoading ? '删除中...' : '删除'}
          </button>
        </div>
      )}
    </div>
  );
};
```

### 示例 2：状态管理（Zustand）

**场景**：购物车状态管理

```typescript
// store/cartStore.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface CartItem {
  productId: string;
  name: string;
  price: number;
  quantity: number;
}

interface CartState {
  items: CartItem[];
  isLoading: boolean;
  error: string | null;
  
  // Actions
  addItem: (item: CartItem) => void;
  removeItem: (productId: string) => void;
  updateQuantity: (productId: string, quantity: number) => void;
  clearCart: () => void;
  
  // Computed
  totalItems: () => number;
  totalPrice: () => number;
}

export const useCartStore = create<CartState>()(
  persist(
    (set, get) => ({
      items: [],
      isLoading: false,
      error: null,
      
      addItem: (item) => {
        const { items } = get();
        const existingItem = items.find(i => i.productId === item.productId);
        
        if (existingItem) {
          set({
            items: items.map(i =>
              i.productId === item.productId
                ? { ...i, quantity: i.quantity + item.quantity }
                : i
            )
          });
        } else {
          set({ items: [...items, item] });
        }
      },
      
      removeItem: (productId) => {
        set({ items: get().items.filter(i => i.productId !== productId) });
      },
      
      updateQuantity: (productId, quantity) => {
        if (quantity <= 0) {
          get().removeItem(productId);
          return;
        }
        set({
          items: get().items.map(i =>
            i.productId === productId ? { ...i, quantity } : i
          )
        });
      },
      
      clearCart: () => set({ items: [] }),
      
      totalItems: () => get().items.reduce((sum, i) => sum + i.quantity, 0),
      totalPrice: () => get().items.reduce((sum, i) => sum + i.price * i.quantity, 0)
    }),
    {
      name: 'cart-storage', // localStorage key
    }
  )
);

// 使用示例
function Cart() {
  const { items, totalPrice, removeItem } = useCartStore();
  
  return (
    <div>
      <h2>购物车 ({items.length})</h2>
      {items.map(item => (
        <div key={item.productId}>
          <span>{item.name} x {item.quantity}</span>
          <button onClick={() => removeItem(item.productId)}>删除</button>
        </div>
      ))}
      <p>总计: ¥{totalPrice()}</p>
    </div>
  );
}
```

### 示例 3：性能优化

**场景**：大数据列表虚拟滚动

```tsx
// VirtualList.tsx
import React, { useRef, useState, useCallback, useEffect } from 'react';

interface VirtualListProps<T> {
  items: T[];
  itemHeight: number;
  renderItem: (item: T, index: number) => React.ReactNode;
  containerHeight: number;
}

export function VirtualList<T>({
  items,
  itemHeight,
  renderItem,
  containerHeight
}: VirtualListProps<T>) {
  const [scrollTop, setScrollTop] = useState(0);
  const containerRef = useRef<HTMLDivElement>(null);
  
  // 计算可见区域
  const visibleCount = Math.ceil(containerHeight / itemHeight);
  const totalHeight = items.length * itemHeight;
  
  const startIndex = Math.floor(scrollTop / itemHeight);
  const endIndex = Math.min(startIndex + visibleCount + 1, items.length);
  
  const visibleItems = items.slice(startIndex, endIndex);
  const offsetY = startIndex * itemHeight;
  
  const handleScroll = useCallback((e: React.UIEvent<HTMLDivElement>) => {
    setScrollTop(e.currentTarget.scrollTop);
  }, []);
  
  return (
    <div
      ref={containerRef}
      style={{ height: containerHeight, overflow: 'auto' }}
      onScroll={handleScroll}
    >
      <div style={{ height: totalHeight, position: 'relative' }}>
        <div style={{ transform: `translateY(${offsetY}px)` }}>
          {visibleItems.map((item, index) => (
            <div key={startIndex + index} style={{ height: itemHeight }}>
              {renderItem(item, startIndex + index)}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

// 使用示例
function UserList({ users }: { users: User[] }) {
  return (
    <VirtualList
      items={users}
      itemHeight={60}
      containerHeight={400}
      renderItem={(user) => (
        <div className="user-item">
          <img src={user.avatar} alt={user.name} />
          <span>{user.name}</span>
        </div>
      )}
    />
  );
}
```

### 示例 4：自定义Hook

**场景**：数据获取Hook

```typescript
// hooks/useApi.ts
import { useState, useEffect, useCallback } from 'react';

interface UseApiOptions {
  immediate?: boolean;
  onError?: (error: Error) => void;
}

interface UseApiResult<T> {
  data: T | null;
  loading: boolean;
  error: Error | null;
  execute: (...args: any[]) => Promise<T>;
  refetch: () => Promise<T>;
}

export function useApi<T>(
  apiFunction: (...args: any[]) => Promise<T>,
  options: UseApiOptions = {}
): UseApiResult<T> {
  const { immediate = true, onError } = options;
  
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(immediate);
  const [error, setError] = useState<Error | null>(null);
  const [args, setArgs] = useState<any[]>([]);
  
  const execute = useCallback(async (...callArgs: any[]) => {
    setLoading(true);
    setError(null);
    setArgs(callArgs);
    
    try {
      const result = await apiFunction(...callArgs);
      setData(result);
      return result;
    } catch (err) {
      const error = err instanceof Error ? err : new Error(String(err));
      setError(error);
      onError?.(error);
      throw error;
    } finally {
      setLoading(false);
    }
  }, [apiFunction, onError]);
  
  const refetch = useCallback(() => execute(...args), [execute, args]);
  
  useEffect(() => {
    if (immediate) {
      execute();
    }
  }, []);
  
  return { data, loading, error, execute, refetch };
}

// 使用示例
function UserProfile({ userId }: { userId: string }) {
  const { data: user, loading, error, refetch } = useApi(
    () => fetchUser(userId),
    { immediate: true }
  );
  
  if (loading) return <div>加载中...</div>;
  if (error) return <div>错误: {error.message} <button onClick={refetch}>重试</button></div>;
  if (!user) return null;
  
  return (
    <div>
      <h1>{user.name}</h1>
      <p>{user.email}</p>
    </div>
  );
}
```

## 结构化分析框架

### 组件设计检查清单

| 检查项 | 要求 | 示例 |
|-------|------|-----|
| **单一职责** | 一个组件只做一件事 | UserCard只展示用户信息 |
| **Props设计** | 类型完整，有默认值 | variant?: 'default' \| 'compact' |
| **状态管理** | 区分受控/非受控 | 表单组件支持value+onChange |
| **事件处理** | 回调函数命名规范 | onEdit, onDelete, onSubmit |
| **样式隔离** | CSS Modules或CSS-in-JS | 避免全局样式污染 |
| **可访问性** | ARIA属性，键盘支持 | role, aria-label, tabIndex |

### 性能优化检查清单

- [ ] 使用 React.memo 避免不必要重渲染
- [ ] 使用 useMemo/useCallback 缓存计算和函数
- [ ] 路由懒加载（React.lazy + Suspense）
- [ ] 图片懒加载（loading="lazy"）
- [ ] 大数据列表使用虚拟滚动
- [ ] 避免在渲染中创建新对象/数组
- [ ] 使用 Chrome DevTools Profiler 分析性能

## 约束与限制
- 浏览器兼容性需考虑（IE11已停止支持）
- 包体积影响首屏加载速度
- 客户端渲染不利于SEO
- 状态管理过度设计增加复杂度
- 第三方库更新可能带来breaking changes

## 自检清单
- [ ] 组件Props有完整的TypeScript类型定义
- [ ] 组件有清晰的文档注释
- [ ] 关键交互有单元测试覆盖
- [ ] 组件支持键盘导航
- [ ] 错误状态有友好提示
- [ ] 加载状态有loading指示
- [ ] 响应式布局适配移动端
- [ ] 性能关键路径有优化

## 常见陷阱

### 陷阱 1：状态提升过度
**问题**：所有状态都放在顶层，导致不必要的重渲染

```tsx
// 反例：所有状态都在顶层
function App() {
  const [user, setUser] = useState(null);
  const [theme, setTheme] = useState('light');
  const [sidebarOpen, setSidebarOpen] = useState(false);
  // ... 更多状态
  
  return (
    <div>
      <Sidebar open={sidebarOpen} onToggle={setSidebarOpen} />
      <Header theme={theme} onThemeChange={setTheme} />
      <Main user={user} />
    </div>
  );
}

// 正确做法：状态放在最近的使用者
function App() {
  return (
    <ThemeProvider>
      <SidebarProvider>
        <UserProvider>
          <Layout />
        </UserProvider>
      </SidebarProvider>
    </ThemeProvider>
  );
}
```

### 陷阱 2：useEffect依赖缺失
**问题**：依赖数组不完整导致闭包陷阱

```tsx
// 反例：依赖缺失
function Counter() {
  const [count, setCount] = useState(0);
  
  useEffect(() => {
    const timer = setInterval(() => {
      console.log(count); // 始终是0（闭包陷阱）
      setCount(count + 1); // 永远只增加到1
    }, 1000);
    return () => clearInterval(timer);
  }, []); // 缺少count依赖！
  
  return <div>{count}</div>;
}

// 正确做法：使用函数式更新
function Counter() {
  const [count, setCount] = useState(0);
  
  useEffect(() => {
    const timer = setInterval(() => {
      setCount(c => c + 1); // 函数式更新，不依赖count
    }, 1000);
    return () => clearInterval(timer);
  }, []); // 空依赖正确
  
  return <div>{count}</div>;
}
```

### 陷阱 3：不必要的重渲染
**问题**：对象/函数在渲染中创建，导致子组件重渲染

```tsx
// 反例：每次渲染都创建新对象
function Parent() {
  const [count, setCount] = useState(0);
  
  return (
    <Child 
      config={{ theme: 'dark', size: 'large' }} // 每次都是新对象！
      onClick={() => console.log('clicked')} // 每次都是新函数！
    />
  );
}

// 正确做法：使用useMemo和useCallback
function Parent() {
  const [count, setCount] = useState(0);
  
  const config = useMemo(() => ({ 
    theme: 'dark', 
    size: 'large' 
  }), []);
  
  const handleClick = useCallback(() => {
    console.log('clicked');
  }, []);
  
  return (
    <Child config={config} onClick={handleClick} />
  );
}
```

### 陷阱 4：忽视错误边界
**问题**：组件错误导致整个应用崩溃

```tsx
// 反例：没有错误处理
function UserProfile({ userId }) {
  const user = useUser(userId); // 可能抛出错误
  return <div>{user.name}</div>; // 错误导致白屏
}

// 正确做法：使用错误边界
class ErrorBoundary extends React.Component {
  state = { hasError: false, error: null };
  
  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }
  
  componentDidCatch(error, errorInfo) {
    console.error('Error caught by boundary:', error, errorInfo);
    // 上报错误到监控系统
  }
  
  render() {
    if (this.state.hasError) {
      return <div>出错了，请刷新页面重试</div>;
    }
    return this.props.children;
  }
}

// 使用
<ErrorBoundary>
  <UserProfile userId={userId} />
</ErrorBoundary>
```

### 陷阱 5：硬编码样式
**问题**：样式写死在组件中，难以主题化

```tsx
// 反例：硬编码样式
function Button({ children }) {
  return (
    <button 
      style={{ 
        backgroundColor: '#1890ff', 
        color: 'white',
        padding: '8px 16px'
      }}
    >
      {children}
    </button>
  );
}

// 正确做法：使用CSS变量或主题系统
function Button({ children, variant = 'primary' }) {
  return (
    <button className={`btn btn--${variant}`}>
      {children}
    </button>
  );
}

// CSS
.btn {
  padding: var(--spacing-sm) var(--spacing-md);
  border-radius: var(--border-radius);
}
.btn--primary {
  background-color: var(--color-primary);
  color: var(--color-white);
}
.btn--secondary {
  background-color: var(--color-secondary);
  color: var(--color-text);
}
```
