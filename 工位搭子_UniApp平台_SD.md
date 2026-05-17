# 工位搭子 —— UniApp平台软件设计文档（SD）

> **文档类型**：软件设计文档（SD）  
> **设计目标**：基于RuoYi-uniapp框架，构建工位搭子移动端应用  
> **技术栈**：UniApp + Vue2 + RuoYi-Vue后端  
> **目标平台**：微信小程序（首发）+ APP  
> **版本**：v1.0  
> **日期**：2026年04月19日

---

## 目录

1. [设计概述](#一设计概述)
2. [架构设计](#二架构设计)
3. [数据设计](#三数据设计)
4. [模块设计](#四模块设计)
5. [接口设计](#五接口设计)
6. [安全设计](#六安全设计)
7. [性能设计](#七性能设计)
8. [开发规范](#八开发规范)

---

## 一、设计概述

### 1.1 设计目标

基于RuoYi-uniapp框架，构建工位搭子系统的移动端应用，实现：
- 设备远程控制与管理
- 记忆数据查看与检索
- 智能体配置与切换
- 环境数据实时监控
- 生产力任务管理

### 1.2 设计原则

| 原则 | 说明 | 实践 |
|------|------|------|
| **复用优先** | 优先使用RuoYi-uniapp现有能力 | 复用登录、权限、请求封装 |
| **渐进增强** | 基础功能先实现，高级功能迭代 | P0功能优先，P1/P2后续迭代 |
| **组件化** | 业务组件独立封装 | 按模块拆分组件 |
| **类型安全** | 关键数据类型定义 | 复杂对象使用JSDoc注释 |

### 1.3 技术约束

- **框架约束**：必须使用Vue2语法（RuoYi-uniapp基于Vue2）
- **平台约束**：微信小程序为主，需兼容H5和APP
- **后端约束**：必须与RuoYi-Vue后端API兼容
- **性能约束**：首屏加载<3s，页面切换<500ms

---

## 二、架构设计

### 2.1 整体架构

```
┌─────────────────────────────────────────────────────────┐
│                    UniApp应用层                          │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   页面层      │  │   组件层      │  │   工具层      │  │
│  │  (pages/)    │  │(components/) │  │  (utils/)    │  │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  │
│         │                 │                 │           │
│         └─────────────────┼─────────────────┘           │
│                           ▼                             │
│              ┌────────────────────────┐                 │
│              │      Store状态层        │                 │
│              │    (Vuex/modules/)     │                 │
│              └───────────┬────────────┘                 │
│                          ▼                              │
│              ┌────────────────────────┐                 │
│              │       API接口层         │                 │
│              │      (api/*/index.js)  │                 │
│              └───────────┬────────────┘                 │
│                          ▼                              │
│              ┌────────────────────────┐                 │
│              │    RuoYi-Vue后端        │                 │
│              └────────────────────────┘                 │
└─────────────────────────────────────────────────────────┘
```

### 2.2 目录结构

```
RuoYi-App/
├── api/                          # API接口层
│   ├── device/                   # 设备相关API
│   │   ├── index.js              # 设备基础接口
│   │   ├── ota.js                # OTA升级接口
│   │   └── plugin.js             # 插件管理接口
│   ├── agent/                    # 智能体相关API
│   │   ├── index.js              # 智能体基础接口
│   │   ├── tag.js                # 标签管理接口
│   │   ├── context.js            # 上下文提供者接口
│   │   └── template.js           # 模板接口
│   ├── memory/                   # 记忆相关API
│   │   ├── index.js              # 记忆基础接口
│   │   └── file.js               # 记忆文件接口
│   ├── chat/                     # 聊天记录API
│   │   ├── index.js              # 聊天基础接口
│   │   └── audio.js              # 音频管理接口
│   ├── knowledge/                # 知识库API
│   │   └── index.js              # 知识库接口
│   ├── productivity/             # 生产力API
│   │   ├── index.js              # 基础接口
│   │   ├── workspace.js          # Workspace接口
│   │   └── task.js               # 任务管理接口
│   ├── model/                    # 模型配置API
│   │   ├── index.js              # 模型基础接口
│   │   └── provider.js           # 提供商接口
│   ├── voice/                    # 声纹/音色API
│   │   ├── voiceprint.js         # 声纹接口
│   │   └── clone.js              # 音色克隆接口
│   └── mcp/                      # MCP工具API
│       └── index.js              # MCP接口
├── components/                   # 业务组件
│   ├── device/                   # 设备组件
│   │   ├── DeviceCard.vue        # 设备卡片
│   │   ├── CloudControl.vue      # 云台控制
│   │   └── ConnectionStatus.vue  # 连接状态
│   ├── agent/                    # 智能体组件
│   │   ├── AgentCard.vue         # 智能体卡片
│   │   ├── AgentSelector.vue     # 智能体选择器
│   │   └── TagSelector.vue       # 标签选择器
│   ├── memory/                   # 记忆组件
│   │   ├── MemoryTimeline.vue    # 记忆时间轴
│   │   ├── MemoryCard.vue        # 记忆卡片
│   │   └── FileEditor.vue        # 文件编辑器
│   ├── env/                      # 环境组件
│   │   ├── EnvCard.vue           # 环境卡片
│   │   └── FocusIndicator.vue    # 专注度指示器
│   └── common/                   # 通用组件
│       ├── EmptyState.vue        # 空状态
│       ├── LoadingState.vue      # 加载状态
│       └── ErrorState.vue        # 错误状态
├── pages/                        # 页面
│   ├── index/                    # 首页
│   │   └── index.vue             # 首页
│   ├── device/                   # 设备模块
│   │   ├── index.vue             # 设备列表
│   │   ├── detail.vue            # 设备详情
│   │   ├── control.vue           # 云台控制
│   │   ├── plugin.vue            # 插件管理
│   │   └── ota.vue               # OTA管理
│   ├── agent/                    # 智能体模块
│   │   ├── index.vue             # 智能体列表
│   │   ├── form.vue              # 智能体表单
│   │   ├── config.vue            # 智能体配置
│   │   ├── tag.vue               # 标签管理
│   │   └── template.vue          # 模板列表
│   ├── memory/                   # 记忆模块
│   │   ├── index.vue             # 记忆首页
│   │   ├── timeline.vue          # 时间轴
│   │   ├── search.vue            # 搜索
│   │   └── file.vue              # 文件管理
│   ├── chat/                     # 聊天记录模块
│   │   ├── index.vue             # 会话列表
│   │   ├── detail.vue            # 聊天详情
│   │   └── audio.vue             # 音频管理
│   ├── knowledge/                # 知识库模块
│   │   ├── index.vue             # 知识库列表
│   │   ├── detail.vue            # 知识库详情
│   │   └── test.vue              # 检索测试
│   ├── productivity/             # 生产力模块
│   │   ├── index.vue             # 生产力首页
│   │   ├── workspace.vue         # Workspace管理
│   │   ├── task.vue              # 任务管理
│   │   └── config.vue            # 配置管理
│   ├── model/                    # 模型配置模块
│   │   ├── index.vue             # 模型列表
│   │   ├── provider.vue          # 提供商管理
│   │   └── config.vue            # 参数配置
│   ├── voice/                    # 声纹/音色模块
│   │   ├── voiceprint.vue        # 声纹管理
│   │   └── clone.vue             # 音色克隆
│   ├── mcp/                      # MCP工具模块
│   │   ├── index.vue             # 工具列表
│   │   └── config.vue            # 接入点配置
│   └── mine/                     # 我的模块（复用现有）
│       └── ...                   # 复用RuoYi现有页面
├── store/                        # 状态管理
│   ├── modules/                  # 状态模块
│   │   ├── device.js             # 设备状态
│   │   ├── agent.js              # 智能体状态
│   │   ├── memory.js             # 记忆状态
│   │   ├── env.js                # 环境状态
│   │   ├── chat.js               # 聊天状态
│   │   ├── productivity.js       # 生产力状态
│   │   └── connection.js         # 连接状态
│   ├── getters.js                # 全局getters
│   └── index.js                  # Store入口
├── utils/                        # 工具函数
│   ├── websocket.js              # WebSocket封装
│   ├── bluetooth.js              # 蓝牙配网封装
│   ├── constants.js              # 常量定义
│   └── helpers.js                # 辅助函数
├── static/                       # 静态资源
│   └── images/                   # 图片资源
│       ├── device/               # 设备相关
│       ├── agent/                # 智能体相关
│       └── tabbar/               # Tab图标
└── config.js                     # 全局配置
```

### 2.3 状态管理设计

#### Store模块划分

```javascript
// store/modules/device.js
export default {
  state: {
    deviceList: [],           // 设备列表
    currentDevice: null,      // 当前设备
    deviceStatus: {},         // 设备状态
    connectionStatus: 'disconnected', // 连接状态
    otaProgress: 0            // OTA进度
  },
  mutations: {
    SET_DEVICE_LIST(state, list) { state.deviceList = list },
    SET_CURRENT_DEVICE(state, device) { state.currentDevice = device },
    SET_CONNECTION_STATUS(state, status) { state.connectionStatus = status },
    SET_OTA_PROGRESS(state, progress) { state.otaProgress = progress }
  },
  actions: {
    fetchDeviceList({ commit }) { /* ... */ },
    bindDevice({ commit }, deviceInfo) { /* ... */ },
    controlCloud({ commit }, { deviceId, direction }) { /* ... */ }
  }
}

// store/modules/agent.js
export default {
  state: {
    agentList: [],            // 智能体列表
    currentAgent: null,       // 当前智能体
    tagList: [],              // 标签列表
    templateList: []          // 模板列表
  },
  mutations: {
    SET_AGENT_LIST(state, list) { state.agentList = list },
    SET_CURRENT_AGENT(state, agent) { state.currentAgent = agent },
    SET_TAG_LIST(state, list) { state.tagList = list }
  },
  actions: {
    fetchAgentList({ commit }) { /* ... */ },
    switchAgent({ commit }, agentId) { /* ... */ },
    createAgent({ commit }, agentData) { /* ... */ }
  }
}

// store/modules/memory.js
export default {
  state: {
    memoryList: [],           // 记忆列表
    memoryDetail: null,       // 记忆详情
    searchResults: [],        // 搜索结果
    fileContent: ''           // 文件内容
  },
  mutations: {
    SET_MEMORY_LIST(state, list) { state.memoryList = list },
    SET_SEARCH_RESULTS(state, results) { state.searchResults = results }
  },
  actions: {
    fetchMemoryList({ commit }, params) { /* ... */ },
    searchMemory({ commit }, keyword) { /* ... */ },
    exportMemory({ commit }, options) { /* ... */ }
  }
}

// store/modules/env.js
export default {
  state: {
    envData: {                // 环境数据
      temperature: null,
      humidity: null,
      co2: null,
      voc: null
    },
    focusScore: 0,            // 专注度评分
    focusHistory: [],         // 专注度历史
    todayStats: {}            // 今日统计
  },
  mutations: {
    SET_ENV_DATA(state, data) { state.envData = data },
    SET_FOCUS_SCORE(state, score) { state.focusScore = score }
  },
  actions: {
    fetchEnvData({ commit }) { /* ... */ },
    fetchFocusData({ commit }) { /* ... */ }
  }
}

// store/modules/connection.js - WebSocket连接状态
export default {
  state: {
    wsStatus: 'disconnected', // disconnected/connecting/connected/weak
    wsLatency: 0,             // 延迟(ms)
    wsPacketLoss: 0,          // 丢包率
    lastHeartbeat: null,      // 最后心跳时间
    reconnectCount: 0         // 重连次数
  },
  mutations: {
    SET_WS_STATUS(state, status) { state.wsStatus = status },
    SET_WS_LATENCY(state, latency) { state.wsLatency = latency }
  },
  actions: {
    initWebSocket({ commit }) { /* ... */ },
    reconnectWebSocket({ commit }) { /* ... */ }
  }
}
```

---

## 三、数据设计

### 3.1 核心数据模型

#### 设备数据模型

```javascript
/**
 * @typedef {Object} Device
 * @property {string} id - 设备ID
 * @property {string} name - 设备名称
 * @property {string} mac - MAC地址
 * @property {string} status - 状态(online/offline)
 * @property {Object} cloudPosition - 云台位置
 * @property {number} cloudPosition.horizontal - 水平角度
 * @property {number} cloudPosition.vertical - 垂直角度
 * @property {string} mode - 模式(single/hall)
 * @property {string} theme - 当前主题
 * @property {string} firmwareVersion - 固件版本
 * @property {string} bindTime - 绑定时间
 */

/**
 * @typedef {Object} DeviceStatus
 * @property {boolean} isOnline - 是否在线
 * @property {string} scene - 当前场景
 * @property {boolean} cameraEnabled - 摄像头是否启用
 * @property {Object} voice - 语音设置
 * @property {string} voice.voiceId - 音色ID
 * @property {number} voice.volume - 音量(0-100)
 * @property {number} voice.speed - 语速(50-200)
 */
```

#### 智能体数据模型

```javascript
/**
 * @typedef {Object} Agent
 * @property {string} id - 智能体ID
 * @property {string} name - 智能体名称
 * @property {string} avatar - 头像URL
 * @property {string} systemPrompt - 角色设定
 * @property {string} language - 语言
 * @property {Object} models - 模型配置
 * @property {string} models.vad - VAD模型
 * @property {string} models.asr - ASR模型
 * @property {string} models.llm - LLM模型
 * @property {string} models.tts - TTS模型
 * @property {string} models.memory - 记忆模型
 * @property {string} models.intent - 意图模型
 * @property {Array<Tag>} tags - 标签列表
 * @property {boolean} isDefault - 是否默认
 * @property {boolean} isActive - 是否当前活跃
 */

/**
 * @typedef {Object} Tag
 * @property {string} id - 标签ID
 * @property {string} name - 标签名称
 * @property {string} color - 标签颜色
 * @property {number} sort - 排序权重
 */

/**
 * @typedef {Object} ContextProvider
 * @property {string} id - 提供者ID
 * @property {string} name - 名称
 * @property {string} type - 类型(weather/calendar/news/stock/todo/custom)
 * @property {Object} config - 配置参数
 * @property {number} refreshInterval - 刷新间隔(分钟)
 * @property {boolean} enabled - 是否启用
 * @property {string} lastRefresh - 上次刷新时间
 */
```

#### 记忆数据模型

```javascript
/**
 * @typedef {Object} Memory
 * @property {string} id - 记忆ID
 * @property {string} content - 记忆内容
 * @property {string} date - 日期
 * @property {string} time - 时间
 * @property {string} scene - 场景标签
 * @property {string} emotion - 情绪线索
 * @property {Array<string>} keywords - 关键词
 * @property {number} importance - 重要程度(1-5)
 */

/**
 * @typedef {Object} MemoryFile
 * @property {string} name - 文件名
 * @property {string} type - 类型(soul/user/memory)
 * @property {string} content - 文件内容
 * @property {number} size - 文件大小
 * @property {string} lastModified - 最后修改时间
 */
```

#### 环境数据模型

```javascript
/**
 * @typedef {Object} EnvData
 * @property {number} temperature - 温度(摄氏度)
 * @property {number} humidity - 湿度(%)
 * @property {number} co2 - CO2浓度(ppm)
 * @property {string} voc - VOC等级(优/良/差)
 * @property {number} iaq - IAQ指数
 * @property {string} timestamp - 数据时间戳
 */

/**
 * @typedef {Object} FocusData
 * @property {number} score - 专注度评分(0-100)
 * @property {string} level - 等级(深度专注/一般专注/轻度分心/严重分心)
 * @property {Array<Object>} history - 历史数据
 * @property {string} history[].time - 时间
 * @property {number} history[].score - 评分
 */

/**
 * @typedef {Object} TodayStats
 * @property {string} sitTime - 久坐时长
 * @property {number} activityCount - 活动次数
 * @property {string} sleepTime - 睡眠时长
 * @property {number} interruptCount - 被打扰次数
 */
```

#### 生产力数据模型

```javascript
/**
 * @typedef {Object} WorkspaceConfig
 * @property {string} mode - 算力模式(cloud/local)
 * @property {string} cloudTier - 云服务等级(basic/standard/pro/enterprise)
 * @property {Object} localConfig - 本地算力配置
 * @property {string} localConfig.address - 地址
 * @property {string} localConfig.token - Token
 * @property {string} localConfig.workspacePath - Workspace路径
 * @property {string} connectionStatus - 连接状态
 */

/**
 * @typedef {Object} Task
 * @property {string} id - 任务ID
 * @property {string} name - 任务名称
 * @property {string} type - 类型(document/code/data/ai)
 * @property {string} status - 状态(queued/running/completed/failed/cancelled)
 * @property {string} createTime - 创建时间
 * @property {string} startTime - 开始时间
 * @property {string} endTime - 结束时间
 * @property {Object} result - 执行结果
 * @property {string} error - 错误信息
 */

/**
 * @typedef {Object} WorkspaceFile
 * @property {string} name - 文件名
 * @property {string} path - 路径
 * @property {string} type - 类型(file/folder)
 * @property {number} size - 大小
 * @property {string} modifyTime - 修改时间
 */
```

---

## 四、模块设计

### 4.1 首页模块

#### 功能描述
- 环境数据展示（温度、湿度、CO2、VOC）
- 专注度评分展示
- 今日统计展示
- 消息中心入口

#### 组件设计

```vue
<!-- pages/index/index.vue -->
<template>
  <view class="home-container">
    <!-- 连接状态指示器 -->
    <ConnectionStatus />
    
    <!-- 环境卡片 -->
    <EnvCard 
      :data="envData" 
      @refresh="fetchEnvData"
      @click="navigateToEnvDetail"
    />
    
    <!-- 专注度指示器 -->
    <FocusIndicator 
      :score="focusScore" 
      :history="focusHistory"
      @changeRange="handleRangeChange"
    />
    
    <!-- 今日统计 -->
    <TodayStats :stats="todayStats" />
    
    <!-- 消息中心入口 -->
    <MessageEntry :unreadCount="unreadCount" @click="navigateToMessages" />
  </view>
</template>

<script>
import { mapState, mapActions } from 'vuex'
import EnvCard from '@/components/env/EnvCard.vue'
import FocusIndicator from '@/components/env/FocusIndicator.vue'
import TodayStats from '@/components/env/TodayStats.vue'
import MessageEntry from '@/components/common/MessageEntry.vue'
import ConnectionStatus from '@/components/device/ConnectionStatus.vue'

export default {
  components: { EnvCard, FocusIndicator, TodayStats, MessageEntry, ConnectionStatus },
  computed: {
    ...mapState('env', ['envData', 'focusScore', 'focusHistory', 'todayStats']),
    ...mapState('chat', ['unreadCount'])
  },
  onShow() {
    this.fetchEnvData()
    this.fetchFocusData()
    this.initWebSocket()
  },
  methods: {
    ...mapActions('env', ['fetchEnvData', 'fetchFocusData']),
    ...mapActions('connection', ['initWebSocket'])
  }
}
</script>
```

### 4.2 设备模块

#### 功能描述
- 设备列表展示
- 设备绑定/解绑
- 云台控制
- 模式切换
- 主题切换
- 插件管理
- OTA升级

#### 关键组件

```vue
<!-- components/device/CloudControl.vue -->
<template>
  <view class="cloud-control">
    <view class="direction-pad">
      <button class="btn-up" @touchstart="startMove('up')" @touchend="stopMove">
        <uni-icons type="arrow-up" size="24" />
      </button>
      <button class="btn-left" @touchstart="startMove('left')" @touchend="stopMove">
        <uni-icons type="arrow-left" size="24" />
      </button>
      <button class="btn-center" @click="resetPosition">
        <text>复位</text>
      </button>
      <button class="btn-right" @touchstart="startMove('right')" @touchend="stopMove">
        <uni-icons type="arrow-right" size="24" />
      </button>
      <button class="btn-down" @touchstart="startMove('down')" @touchend="stopMove">
        <uni-icons type="arrow-down" size="24" />
      </button>
    </view>
    <view class="position-info">
      <text>水平: {{ horizontal }}° 垂直: {{ vertical }}°</text>
    </view>
  </view>
</template>

<script>
export default {
  props: {
    deviceId: { type: String, required: true },
    initialPosition: { type: Object, default: () => ({ h: 0, v: 0 }) }
  },
  data() {
    return {
      horizontal: this.initialPosition.h,
      vertical: this.initialPosition.v,
      moving: false
    }
  },
  methods: {
    startMove(direction) {
      this.moving = true
      this.$emit('control', { deviceId: this.deviceId, direction, action: 'start' })
    },
    stopMove() {
      this.moving = false
      this.$emit('control', { deviceId: this.deviceId, action: 'stop' })
    },
    resetPosition() {
      this.$emit('reset', { deviceId: this.deviceId })
    }
  }
}
</script>
```

### 4.3 智能体模块

#### 功能描述
- 智能体列表展示
- 智能体创建/编辑/删除
- 智能体切换
- 标签管理
- 上下文提供者配置
- 模板应用

#### 关键组件

```vue
<!-- components/agent/AgentCard.vue -->
<template>
  <view class="agent-card" :class="{ active: agent.isActive }" @click="handleClick">
    <image class="avatar" :src="agent.avatar || defaultAvatar" />
    <view class="info">
      <text class="name">{{ agent.name }}</text>
      <text class="prompt">{{ truncatedPrompt }}</text>
      <view class="tags">
        <uni-tag v-for="tag in displayTags" :key="tag.id" :text="tag.name" :type="tag.color" size="small" />
        <text v-if="agent.tags.length > 3" class="more-tags">+{{ agent.tags.length - 3 }}</text>
      </view>
    </view>
    <view class="actions">
      <uni-icons v-if="agent.isDefault" type="star-filled" color="#f0ad4e" size="20" />
      <uni-icons v-if="agent.isActive" type="checkmarkempty" color="#007aff" size="20" />
    </view>
  </view>
</template>

<script>
export default {
  props: {
    agent: { type: Object, required: true }
  },
  computed: {
    truncatedPrompt() {
      return this.agent.systemPrompt?.substring(0, 50) + '...' || '暂无角色设定'
    },
    displayTags() {
      return this.agent.tags?.slice(0, 3) || []
    }
  },
  methods: {
    handleClick() {
      this.$emit('select', this.agent)
    }
  }
}
</script>
```

### 4.4 记忆模块

#### 功能描述
- 记忆时间轴展示
- 记忆搜索
- 记忆导出
- 记忆文件管理（SOUL.md/USER.md/MEMORY.md）

#### 关键组件

```vue
<!-- components/memory/MemoryTimeline.vue -->
<template>
  <view class="memory-timeline">
    <view v-for="group in groupedMemories" :key="group.date" class="date-group">
      <text class="date-header">{{ formatDate(group.date) }}</text>
      <view class="timeline-items">
        <view v-for="memory in group.items" :key="memory.id" class="timeline-item" @click="viewDetail(memory)">
          <text class="time">{{ memory.time }}</text>
          <view class="content">
            <text class="scene-tag">{{ memory.scene }}</text>
            <text class="summary">{{ memory.content }}</text>
          </view>
        </view>
      </view>
    </view>
    <uni-load-more :status="loadStatus" @clickLoadMore="loadMore" />
  </view>
</template>

<script>
export default {
  props: {
    memories: { type: Array, default: () => [] },
    loadStatus: { type: String, default: 'more' }
  },
  computed: {
    groupedMemories() {
      const groups = {}
      this.memories.forEach(memory => {
        const date = memory.date
        if (!groups[date]) groups[date] = { date, items: [] }
        groups[date].items.push(memory)
      })
      return Object.values(groups).sort((a, b) => new Date(b.date) - new Date(a.date))
    }
  },
  methods: {
    formatDate(date) {
      // 格式化日期显示
      const today = new Date().toDateString()
      const yesterday = new Date(Date.now() - 86400000).toDateString()
      const dateStr = new Date(date).toDateString()
      if (dateStr === today) return '今天'
      if (dateStr === yesterday) return '昨天'
      return date
    },
    viewDetail(memory) {
      this.$emit('detail', memory)
    },
    loadMore() {
      this.$emit('loadMore')
    }
  }
}
</script>
```

### 4.5 生产力模块

#### 功能描述
- 算力模式选择
- Workspace文件管理
- 任务进度查看
- 任务取消/重试

#### 关键组件

```vue
<!-- components/productivity/TaskList.vue -->
<template>
  <view class="task-list">
    <view v-for="task in tasks" :key="task.id" class="task-item">
      <checkbox :checked="selectedTasks.includes(task.id)" @click="toggleSelect(task.id)" />
      <view class="task-info">
        <text class="name">{{ task.name }}</text>
        <text class="type">{{ taskTypeText(task.type) }}</text>
        <uni-tag :text="statusText(task.status)" :type="statusType(task.status)" size="small" />
      </view>
      <view class="task-actions">
        <button v-if="canCancel(task.status)" size="mini" @click="cancelTask(task.id)">取消</button>
        <button v-if="canRetry(task.status)" size="mini" type="primary" @click="retryTask(task.id)">重试</button>
      </view>
    </view>
    <view v-if="selectedTasks.length > 0" class="batch-actions">
      <button size="mini" @click="batchCancel">批量取消</button>
      <button size="mini" type="primary" @click="batchRetry">批量重试</button>
    </view>
  </view>
</template>

<script>
export default {
  props: {
    tasks: { type: Array, default: () => [] }
  },
  data() {
    return {
      selectedTasks: []
    }
  },
  methods: {
    canCancel(status) {
      return ['queued', 'running'].includes(status)
    },
    canRetry(status) {
      return ['failed', 'cancelled'].includes(status)
    },
    statusText(status) {
      const map = { queued: '排队中', running: '执行中', completed: '已完成', failed: '失败', cancelled: '已取消' }
      return map[status] || status
    },
    statusType(status) {
      const map = { queued: 'warning', running: 'primary', completed: 'success', failed: 'error', cancelled: 'default' }
      return map[status] || 'default'
    },
    cancelTask(id) {
      this.$emit('cancel', [id])
    },
    retryTask(id) {
      this.$emit('retry', [id])
    },
    batchCancel() {
      this.$emit('cancel', this.selectedTasks)
      this.selectedTasks = []
    },
    batchRetry() {
      this.$emit('retry', this.selectedTasks)
      this.selectedTasks = []
    }
  }
}
</script>
```

---

## 五、接口设计

### 5.1 API模块结构

```javascript
// api/device/index.js
import request from '@/utils/request'

export function getDeviceList() {
  return request({ url: '/device/list', method: 'get' })
}

export function getDeviceDetail(deviceId) {
  return request({ url: `/device/${deviceId}`, method: 'get' })
}

export function bindDevice(data) {
  return request({ url: '/device/bind', method: 'post', data })
}

export function unbindDevice(deviceId) {
  return request({ url: `/device/unbind/${deviceId}`, method: 'post' })
}

export function controlCloud(deviceId, direction, action) {
  return request({ 
    url: `/device/${deviceId}/cloud/control`, 
    method: 'post', 
    data: { direction, action } 
  })
}

export function switchMode(deviceId, mode) {
  return request({ 
    url: `/device/${deviceId}/mode`, 
    method: 'post', 
    data: { mode } 
  })
}

export function switchTheme(deviceId, theme) {
  return request({ 
    url: `/device/${deviceId}/theme`, 
    method: 'post', 
    data: { theme } 
  })
}

// api/agent/index.js
export function getAgentList() {
  return request({ url: '/agent/list', method: 'get' })
}

export function createAgent(data) {
  return request({ url: '/agent', method: 'post', data })
}

export function updateAgent(agentId, data) {
  return request({ url: `/agent/${agentId}`, method: 'put', data })
}

export function deleteAgent(agentId) {
  return request({ url: `/agent/${agentId}`, method: 'delete' })
}

export function switchAgent(agentId) {
  return request({ url: `/agent/${agentId}/switch`, method: 'post' })
}

export function setDefaultAgent(agentId) {
  return request({ url: `/agent/${agentId}/default`, method: 'post' })
}

// api/memory/index.js
export function getMemoryList(params) {
  return request({ url: '/memory/list', method: 'get', params })
}

export function searchMemory(keyword) {
  return request({ url: '/memory/search', method: 'get', params: { keyword } })
}

export function exportMemory(data) {
  return request({ url: '/memory/export', method: 'post', data })
}

export function getMemoryFile(fileType) {
  return request({ url: `/memory/file/${fileType}`, method: 'get' })
}

export function updateMemoryFile(fileType, content) {
  return request({ url: `/memory/file/${fileType}`, method: 'put', data: { content } })
}

// api/env/index.js
export function getEnvData() {
  return request({ url: '/env/current', method: 'get' })
}

export function getFocusData(range = 'today') {
  return request({ url: '/env/focus', method: 'get', params: { range } })
}

export function getTodayStats() {
  return request({ url: '/env/stats/today', method: 'get' })
}
```

### 5.2 WebSocket设计

```javascript
// utils/websocket.js
class WebSocketManager {
  constructor() {
    this.ws = null
    this.reconnectCount = 0
    this.maxReconnect = 5
    this.reconnectInterval = [1000, 2000, 5000, 10000, 30000]
    this.listeners = new Map()
  }

  connect(url) {
    return new Promise((resolve, reject) => {
      this.ws = uni.connectSocket({ url })
      
      this.ws.onOpen(() => {
        console.log('WebSocket connected')
        this.reconnectCount = 0
        this.emit('connected')
        resolve()
      })
      
      this.ws.onMessage((res) => {
        try {
          const data = JSON.parse(res.data)
          this.handleMessage(data)
        } catch (e) {
          console.error('WebSocket message parse error:', e)
        }
      })
      
      this.ws.onClose(() => {
        console.log('WebSocket closed')
        this.emit('disconnected')
        this.attemptReconnect(url)
      })
      
      this.ws.onError((err) => {
        console.error('WebSocket error:', err)
        this.emit('error', err)
        reject(err)
      })
    })
  }

  handleMessage(data) {
    // 处理不同类型的消息
    switch (data.type) {
      case 'env_update':
        this.emit('envUpdate', data.payload)
        break
      case 'focus_update':
        this.emit('focusUpdate', data.payload)
        break
      case 'device_status':
        this.emit('deviceStatus', data.payload)
        break
      case 'task_progress':
        this.emit('taskProgress', data.payload)
        break
      case 'ping':
        this.send({ type: 'pong', timestamp: Date.now() })
        break
      default:
        this.emit('message', data)
    }
  }

  attemptReconnect(url) {
    if (this.reconnectCount >= this.maxReconnect) {
      this.emit('reconnectFailed')
      return
    }
    
    const delay = this.reconnectInterval[this.reconnectCount] || 30000
    this.reconnectCount++
    
    setTimeout(() => {
      console.log(`Reconnecting... attempt ${this.reconnectCount}`)
      this.emit('reconnecting', this.reconnectCount)
      this.connect(url)
    }, delay)
  }

  send(data) {
    if (this.ws && this.ws.readyState === 1) {
      this.ws.send({ data: JSON.stringify(data) })
    }
  }

  on(event, callback) {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, [])
    }
    this.listeners.get(event).push(callback)
  }

  emit(event, data) {
    const callbacks = this.listeners.get(event) || []
    callbacks.forEach(cb => cb(data))
  }

  close() {
    if (this.ws) {
      this.ws.close()
    }
  }
}

export default new WebSocketManager()
```

---

## 六、安全设计

### 6.1 认证授权

- **Token机制**：使用JWT Token，存储在本地缓存
- **Token刷新**：自动刷新机制，避免过期
- **权限控制**：基于RuoYi的权限体系，按钮级权限控制

```javascript
// permission.js
import { getToken } from '@/utils/auth'

// 白名单
const whiteList = ['/pages/login', '/pages/register']

// 路由拦截
uni.addInterceptor('navigateTo', {
  invoke(args) {
    const token = getToken()
    const url = args.url
    
    if (!token && !whiteList.some(path => url.includes(path))) {
      uni.reLaunch({ url: '/pages/login' })
      return false
    }
    return args
  }
})
```

### 6.2 数据安全

- **敏感信息脱敏**：API Key等敏感信息只显示前4位
- **本地存储加密**：使用uni.getStorage/setStorage，平台自动加密
- **HTTPS通信**：所有API请求强制HTTPS

### 6.3 输入校验

```javascript
// utils/validate.js
export function validateDeviceName(name) {
  if (!name || name.length < 2) return '设备名称至少2个字符'
  if (name.length > 20) return '设备名称最多20个字符'
  return null
}

export function validateAgentPrompt(prompt) {
  if (!prompt || prompt.length < 10) return '角色设定至少10个字符'
  if (prompt.length > 2000) return '角色设定最多2000个字符'
  return null
}

export function validateWorkspacePath(path) {
  if (!path) return 'Workspace路径不能为空'
  if (path.includes('..')) return '路径不能包含..'
  if (!path.startsWith('/')) return '路径必须以/开头'
  return null
}
```

---

## 七、性能设计

### 7.1 加载优化

- **分包加载**：按模块分包，减少首包体积
- **图片优化**：使用WebP格式，懒加载
- **数据缓存**：API响应缓存，减少重复请求

```javascript
// pages.json 分包配置
{
  "subPackages": [
    {
      "root": "pages/device",
      "pages": [
        { "path": "index" },
        { "path": "detail" },
        { "path": "control" }
      ]
    },
    {
      "root": "pages/agent",
      "pages": [
        { "path": "index" },
        { "path": "form" },
        { "path": "config" }
      ]
    }
  ],
  "preloadRule": {
    "pages/index/index": {
      "network": "all",
      "packages": ["pages/device"]
    }
  }
}
```

### 7.2 渲染优化

- **列表虚拟滚动**：大数据列表使用虚拟滚动
- **防抖节流**：搜索输入防抖，滚动事件节流
- **条件渲染**：使用v-show替代v-if，减少重渲染

```javascript
// utils/optimize.js
export function debounce(fn, delay = 300) {
  let timer = null
  return function(...args) {
    clearTimeout(timer)
    timer = setTimeout(() => fn.apply(this, args), delay)
  }
}

export function throttle(fn, interval = 100) {
  let lastTime = 0
  return function(...args) {
    const now = Date.now()
    if (now - lastTime >= interval) {
      lastTime = now
      fn.apply(this, args)
    }
  }
}
```

### 7.3 网络优化

- **请求合并**：短时间内相同请求合并
- **失败重试**：网络错误自动重试3次
- **超时控制**：API请求设置合理超时时间

---

## 八、开发规范

### 8.1 代码规范

- **命名规范**：
  - 组件名：PascalCase（如 `AgentCard.vue`）
  - 文件名：kebab-case（如 `agent-card.vue`）
  - 变量名：camelCase（如 `agentList`）
  - 常量名：UPPER_SNAKE_CASE（如 `MAX_RETRY`）

- **注释规范**：
  - 文件头注释：说明文件用途
  - 函数注释：说明参数和返回值
  - 复杂逻辑注释：说明实现思路

### 8.2 组件规范

```vue
<!-- 标准组件模板 -->
<template>
  <view class="component-name">
    <!-- 组件内容 -->
  </view>
</template>

<script>
/**
 * 组件名称
 * @description 组件描述
 * @property {String} prop1 属性1说明
 * @property {Object} prop2 属性2说明
 * @event {Function} event1 事件1说明
 */
export default {
  name: 'ComponentName',
  props: {
    prop1: {
      type: String,
      default: ''
    },
    prop2: {
      type: Object,
      default: () => ({})
    }
  },
  data() {
    return {
      // 内部状态
    }
  },
  computed: {
    // 计算属性
  },
  methods: {
    // 方法
  }
}
</script>

<style lang="scss" scoped>
.component-name {
  /* 样式 */
}
</style>
```

### 8.3 提交规范

```
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式调整
refactor: 重构
test: 测试相关
chore: 构建/工具相关
```

---

## 附录

### A. 开发环境配置

```javascript
// config.js
module.exports = {
  // 开发环境
  dev: {
    baseUrl: 'http://localhost:8080',
    wsUrl: 'ws://localhost:8080/ws'
  },
  // 测试环境
  test: {
    baseUrl: 'https://test-api.gongwei.com',
    wsUrl: 'wss://test-api.gongwei.com/ws'
  },
  // 生产环境
  prod: {
    baseUrl: 'https://api.gongwei.com',
    wsUrl: 'wss://api.gongwei.com/ws'
  }
}
```

### B. 常用命令

```bash
# 安装依赖
npm install

# 运行到微信小程序
npm run dev:mp-weixin

# 运行到H5
npm run dev:h5

# 构建生产环境
npm run build:mp-weixin
npm run build:h5
```

### C. 目录映射

| PRD模块 | 页面路径 | 组件路径 | API路径 |
|---------|----------|----------|---------|
| 首页 | pages/index/index.vue | components/env/ | api/env/ |
| 设备 | pages/device/ | components/device/ | api/device/ |
| 智能体 | pages/agent/ | components/agent/ | api/agent/ |
| 记忆 | pages/memory/ | components/memory/ | api/memory/ |
| 聊天记录 | pages/chat/ | components/chat/ | api/chat/ |
| 知识库 | pages/knowledge/ | components/knowledge/ | api/knowledge/ |
| 生产力 | pages/productivity/ | components/productivity/ | api/productivity/ |
| 模型配置 | pages/model/ | components/model/ | api/model/ |
| 声纹/音色 | pages/voice/ | components/voice/ | api/voice/ |
| MCP工具 | pages/mcp/ | components/mcp/ | api/mcp/ |
