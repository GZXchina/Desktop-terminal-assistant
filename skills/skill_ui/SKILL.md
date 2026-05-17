---
name: "skill_ui"
description: "Apply UI design capabilities for creating interfaces, designing components, and building design systems. Invoke when designing UI components, optimizing layouts, or establishing design standards."
---

# UI Design Skill

## 核心定义
专注于创建界面、设计组件、搭建设计系统和提升视觉美感，兼顾可访问性、用户体验、组件一致性和跨平台适配。

## 技能能力
- **组件库设计**：统一按钮、表单等组件，包含多种状态和变体
- **界面优化**：改善布局和视觉层级，提升可用性
- **设计系统建设**：标准化颜色、排版、间距等设计token
- **跨平台适配**：确保界面在不同屏幕和设备上表现一致

## 执行流程
1. **需求分析**：明确设计目标、用户场景和约束条件
2. **设计探索**：探索多种设计方案，评估可行性
3. **组件设计**：定义组件规范、状态变体和交互模式
4. **设计系统**：建立设计token、组件库和文档
5. **实现验证**：与开发协作，确保设计还原度

## 实践要点
1. **一致性**：组件风格、交互模式保持一致
2. **可访问性**：考虑色盲用户、键盘导航、屏幕阅读器
3. **视觉层级**：通过大小、颜色、间距建立清晰层级
4. **反馈及时**：用户操作后及时给出视觉反馈
5. **移动端优先**：触摸区域≥44px，考虑拇指操作

## 使用示例

### 示例 1：按钮组件设计

**场景**：设计一个支持多状态和变体的按钮组件

```tsx
// Button.tsx - 完整的状态和变体支持
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'text' | 'danger';
  size?: 'small' | 'medium' | 'large';
  loading?: boolean;
  disabled?: boolean;
  children: React.ReactNode;
  onClick?: () => void;
}

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'medium',
  loading = false,
  disabled,
  children,
  ...props
}) => {
  return (
    <button
      className={`btn btn--${variant} btn--${size} ${loading ? 'btn--loading' : ''}`}
      disabled={disabled || loading}
      {...props}
    >
      {loading && <span className="btn__spinner" />}
      <span className="btn__text">{children}</span>
    </button>
  );
};

// CSS - 完整的状态覆盖
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--space-2);
  border-radius: var(--radius-md);
  font-weight: var(--font-weight-medium);
  transition: all var(--transition-fast);
  cursor: pointer;
}

/* 主要按钮 */
.btn--primary {
  background: var(--color-primary-500);
  color: white;
  border: 1px solid var(--color-primary-500);
}

.btn--primary:hover:not(:disabled) {
  background: var(--color-primary-600);
}

.btn--primary:focus-visible {
  box-shadow: 0 0 0 3px var(--color-primary-200);
}

.btn--primary:disabled {
  background: var(--color-gray-300);
  cursor: not-allowed;
}

/* 加载状态 */
.btn--loading {
  position: relative;
  color: transparent;
}

.btn__spinner {
  position: absolute;
  width: 16px;
  height: 16px;
  border: 2px solid transparent;
  border-top-color: currentColor;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}
```

### 示例 2：响应式布局设计

**场景**：设计一个响应式卡片网格布局

```css
/* 响应式卡片网格 */
.card-grid {
  display: grid;
  gap: var(--space-4);
  /* 移动端：单列 */
  grid-template-columns: 1fr;
}

@media (min-width: 640px) {
  .card-grid {
    /* 平板：两列 */
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (min-width: 1024px) {
  .card-grid {
    /* 桌面：三列 */
    grid-template-columns: repeat(3, 1fr);
    gap: var(--space-6);
  }
}

/* 卡片组件 */
.card {
  display: flex;
  flex-direction: column;
  background: white;
  border-radius: var(--radius-lg);
  overflow: hidden;
  box-shadow: var(--shadow-md);
}

.card__image {
  width: 100%;
  aspect-ratio: 16 / 9;
  object-fit: cover;
}

.card__content {
  padding: var(--space-4);
  flex: 1;
}

/* 触摸优化 */
@media (pointer: coarse) {
  .card__button {
    min-height: 44px; /* 触摸区域≥44px */
    padding: 12px 24px;
  }
}
```

### 示例 3：设计系统规范

**场景**：建立设计系统的基础规范

```css
/* design-tokens.css */
:root {
  /* 颜色系统 */
  --color-primary-500: #3b82f6;
  --color-primary-600: #2563eb;
  --color-success-500: #22c55e;
  --color-warning-500: #f59e0b;
  --color-error-500: #ef4444;
  
  --color-gray-50: #f9fafb;
  --color-gray-100: #f3f4f6;
  --color-gray-500: #6b7280;
  --color-gray-900: #111827;
  
  /* 字体系统 */
  --font-size-sm: 14px;
  --font-size-base: 16px;
  --font-size-lg: 18px;
  --font-size-xl: 20px;
  
  --font-weight-medium: 500;
  --font-weight-semibold: 600;
  
  --line-height-normal: 1.5;
  --line-height-relaxed: 1.75;
  
  /* 间距系统 */
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-6: 24px;
  
  /* 圆角 */
  --radius-md: 6px;
  --radius-lg: 8px;
  --radius-xl: 12px;
  
  /* 阴影 */
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  
  /* 过渡 */
  --transition-fast: 150ms ease;
  --transition-normal: 250ms ease;
}
```

### 示例 4：表单组件设计

**场景**：设计可访问的表单输入组件

```tsx
// Input.tsx - 可访问的表单输入
interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label: string;
  error?: string;
  helperText?: string;
}

export const Input: React.FC<InputProps> = ({
  label,
  error,
  helperText,
  id,
  required,
  ...props
}) => {
  const inputId = id || `input-${Math.random().toString(36).substr(2, 9)}`;
  const errorId = `${inputId}-error`;
  const helperId = `${inputId}-helper`;
  
  return (
    <div className="form-field">
      <label htmlFor={inputId} className="form-label">
        {label}
        {required && <span className="required" aria-label="required"> *</span>}
      </label>
      
      <input
        id={inputId}
        className={`form-input ${error ? 'form-input--error' : ''}`}
        aria-invalid={!!error}
        aria-describedby={error ? errorId : helperId}
        required={required}
        {...props}
      />
      
      {error && (
        <span id={errorId} className="form-error" role="alert">
          {error}
        </span>
      )}
      
      {helperText && !error && (
        <span id={helperId} className="form-helper">
          {helperText}
        </span>
      )}
    </div>
  );
};

// CSS
.form-field {
  display: flex;
  flex-direction: column;
  gap: var(--space-1);
}

.form-label {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--color-gray-700);
}

.form-input {
  padding: var(--space-2) var(--space-3);
  border: 1px solid var(--color-gray-300);
  border-radius: var(--radius-md);
  font-size: var(--font-size-base);
  transition: border-color var(--transition-fast);
}

.form-input:focus {
  outline: none;
  border-color: var(--color-primary-500);
  box-shadow: 0 0 0 3px var(--color-primary-100);
}

.form-input--error {
  border-color: var(--color-error-500);
}

.form-input--error:focus {
  box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.2);
}

.form-error {
  font-size: var(--font-size-sm);
  color: var(--color-error-500);
}
```

## 结构化分析框架

### 组件设计评估维度

| 维度 | 评估指标 | 目标值 |
|-----|---------|-------|
| 一致性 | 与现有组件风格一致度 | 100% |
| 可访问性 | WCAG合规等级 | AA级 |
| 响应式 | 断点覆盖完整度 | 3+断点 |
| 性能 | 渲染性能影响 | 无感知 |
| 可维护性 | 代码复杂度 | 低 |

### 设计决策矩阵

```
            高影响    低影响
          ┌─────────┬─────────┐
  低成本  │ 立即执行 │ 快速完成 │
          │   ①     │   ②     │
          ├─────────┼─────────┤
  高成本  │ 规划执行 │ 谨慎评估 │
          │   ③     │   ④     │
          └─────────┴─────────┘

① 高影响低成本：立即执行（如添加hover状态）
② 低影响低成本：快速完成（如微调间距）
③ 高影响高成本：规划执行（如重构设计系统）
④ 低影响高成本：谨慎评估（如复杂动画）
```

## 约束与限制
- 颜色对比度≥4.5:1（WCAG AA标准）
- 触摸区域≥44px
- 组件状态必须完整（default/hover/active/disabled）
- 支持键盘导航
- 响应式适配必须完整

## 自检清单
- [ ] 组件状态完整（default/hover/active/disabled）
- [ ] 颜色对比度 ≥ 4.5:1
- [ ] 触摸区域 ≥ 44px
- [ ] 键盘可聚焦（focus-visible样式）
- [ ] 语义化标签（button/input/a）
- [ ] 响应式适配（3+断点）
- [ ] 使用设计token
- [ ] 过渡动画自然（150-300ms）

## 常见陷阱

### 陷阱 1：忽视可访问性

```tsx
// 反例：不可访问的按钮
const DeleteButton = ({ onClick }) => (
  <div 
    onClick={onClick}
    style={{ background: '#ff4444', padding: '10px', cursor: 'pointer' }}
  >
    🗑️
  </div>
);
// 问题：1) div无法键盘聚焦 2) 无aria-label 3) 只有图标色盲用户无法理解

// 正确做法：可访问的按钮
const DeleteButton = ({ onClick, label = 'Delete' }) => (
  <button
    onClick={onClick}
    aria-label={label}
    className="btn btn--danger"
    style={{ minWidth: '44px', minHeight: '44px' }} // 触摸区域≥44px
  >
    <span aria-hidden="true">🗑️</span>
    <span>{label}</span>
  </button>
);
```

### 陷阱 2：硬编码样式值

```tsx
// 反例：硬编码样式
const Card = ({ title }) => (
  <div style={{
    padding: '16px',
    margin: '20px',
    backgroundColor: '#f3f4f6',
    borderRadius: '8px'
  }}>
    <h3 style={{ fontSize: '18px', color: '#1f2937' }}>{title}</h3>
  </div>
);
// 问题：无法统一修改主题，难以维护

// 正确做法：使用设计token
const Card = ({ title }) => (
  <div style={{
    padding: tokens.spacing.md,
    margin: tokens.spacing.lg,
    backgroundColor: tokens.colors.background.secondary,
    borderRadius: tokens.radius.md
  }}>
    <h3 style={{ 
      fontSize: tokens.typography.heading.small,
      color: tokens.colors.text.primary 
    }}>{title}</h3>
  </div>
);
```

### 陷阱 3：不完整的状态覆盖

```css
/* 反例：缺少状态样式 */
.btn {
  background: #3b82f6;
  color: white;
  padding: 8px 16px;
}
/* 问题：缺少hover/focus/disabled状态 */

/* 正确做法：完整的状态覆盖 */
.btn {
  background: var(--color-primary-500);
  color: white;
  padding: var(--space-2) var(--space-4);
  transition: background var(--transition-fast);
}

.btn:hover:not(:disabled) {
  background: var(--color-primary-600);
}

.btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px var(--color-primary-200);
}

.btn:disabled {
  background: var(--color-gray-300);
  cursor: not-allowed;
}
```

### 陷阱 4：忽视响应式适配

```css
/* 反例：固定布局 */
.card-grid {
  display: flex;
  gap: 24px;
}

.card {
  width: 33.333%; /* 移动端溢出 */
}

/* 正确做法：响应式网格 */
.card-grid {
  display: grid;
  gap: var(--space-4);
  grid-template-columns: 1fr; /* 移动端单列 */
}

@media (min-width: 640px) {
  .card-grid {
    grid-template-columns: repeat(2, 1fr); /* 平板两列 */
  }
}

@media (min-width: 1024px) {
  .card-grid {
    grid-template-columns: repeat(3, 1fr); /* 桌面三列 */
    gap: var(--space-6);
  }
}
```
