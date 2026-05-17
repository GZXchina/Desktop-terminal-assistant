<template>
  <view class="portal-container">
    <view class="portal-header">
      <view class="greeting-section">
        <text class="greeting-text">你好，{{ userName }} 👋</text>
        <text class="sub-greeting">今天也是有搭子陪伴的一天</text>
      </view>
      <view class="time-section">
        <text class="current-time">{{ currentTime }}</text>
        <text class="current-date">{{ currentDate }}</text>
      </view>
    </view>

    <view class="portal-content">
      <view class="cards-grid">
        <view class="nav-card card-1" 
              :class="{ 'card-hover': hoveredCard === 0 }"
              @mouseenter="hoveredCard = 0"
              @mouseleave="hoveredCard = null"
              @click="navigateTo('/pages/dashboard/index')">
          <view class="card-icon-wrapper">
            <text class="card-icon">📊</text>
          </view>
          <view class="card-content">
            <text class="card-title">状态监测</text>
            <text class="card-desc">实时监测专注度、心率与环境</text>
          </view>
          <view class="card-arrow">
            <text class="arrow">→</text>
          </view>
        </view>

        <view class="nav-card card-2"
              :class="{ 'card-hover': hoveredCard === 1 }"
              @mouseenter="hoveredCard = 1"
              @mouseleave="hoveredCard = null"
              @click="navigateTo('/pages/device/console')">
          <view class="card-icon-wrapper">
            <text class="card-icon">🎮</text>
          </view>
          <view class="card-content">
            <text class="card-title">设备遥控</text>
            <text class="card-desc">操控云台、切换模式与音效</text>
          </view>
          <view class="card-arrow">
            <text class="arrow">→</text>
          </view>
        </view>

        <view class="nav-card card-3"
              :class="{ 'card-hover': hoveredCard === 2 }"
              @mouseenter="hoveredCard = 2"
              @mouseleave="hoveredCard = null"
              @click="navigateTo('/pages/memory/timeline')">
          <view class="card-icon-wrapper">
            <text class="card-icon">📝</text>
          </view>
          <view class="card-content">
            <text class="card-title">记忆博物馆</text>
            <text class="card-desc">基于 E-RAG 的情感记忆时光轴</text>
          </view>
          <view class="card-arrow">
            <text class="arrow">→</text>
          </view>
        </view>

        <view class="nav-card card-4"
              :class="{ 'card-hover': hoveredCard === 3 }"
              @mouseenter="hoveredCard = 3"
              @mouseleave="hoveredCard = null"
              @click="navigateTo('/pages/enterprise/report')">
          <view class="card-icon-wrapper">
            <text class="card-icon">🏢</text>
          </view>
          <view class="card-content">
            <text class="card-title">企业关怀</text>
            <text class="card-desc">匿名健康报告与团队激励</text>
          </view>
          <view class="card-arrow">
            <text class="arrow">→</text>
          </view>
        </view>
      </view>
    </view>

    <view class="portal-footer">
      <text class="footer-text">工位搭子 · 你的智能职场伙伴</text>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      userName: '职场人',
      currentTime: '',
      currentDate: '',
      hoveredCard: null,
      timer: null
    }
  },
  onLoad() {
    this.updateTime()
    this.timer = setInterval(() => {
      this.updateTime()
    }, 1000)
  },
  onUnload() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  },
  methods: {
    updateTime() {
      const now = new Date()
      this.currentTime = now.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit', second: '2-digit' })
      this.currentDate = now.toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' })
    },
    navigateTo(url) {
      uni.navigateTo({
        url: url,
        fail: (err) => {
          console.error('跳转失败:', err)
          uni.showToast({
            title: '页面跳转失败',
            icon: 'none'
          })
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.portal-container {
  min-height: 100vh;
  background: linear-gradient(180deg, #f8fafc 0%, #f1f5f9 50%, #e2e8f0 100%);
  padding: 24px;
  display: flex;
  flex-direction: column;
}

.portal-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 40px;
  
  .greeting-section {
    .greeting-text {
      display: block;
      font-size: 32px;
      font-weight: 700;
      color: #1e293b;
      margin-bottom: 8px;
      background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    
    .sub-greeting {
      font-size: 16px;
      color: #64748b;
    }
  }
  
  .time-section {
    text-align: right;
    
    .current-time {
      display: block;
      font-size: 28px;
      font-weight: 600;
      color: #475569;
      font-family: 'SF Mono', 'Monaco', monospace;
      margin-bottom: 4px;
    }
    
    .current-date {
      font-size: 14px;
      color: #94a3b8;
    }
  }
}

.portal-content {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}

.cards-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24px;
  max-width: 900px;
  width: 100%;
  
  @media (max-width: 768px) {
    grid-template-columns: 1fr;
  }
}

.nav-card {
  position: relative;
  padding: 28px;
  border-radius: 20px;
  display: flex;
  flex-direction: column;
  gap: 16px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
  
  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(10px);
    z-index: 1;
  }
  
  &.card-1 {
    background: linear-gradient(135deg, #dbeafe 0%, #93c5fd 100%);
  }
  
  &.card-2 {
    background: linear-gradient(135deg, #d1fae5 0%, #6ee7b7 100%);
  }
  
  &.card-3 {
    background: linear-gradient(135deg, #fef3c7 0%, #fcd34d 100%);
  }
  
  &.card-4 {
    background: linear-gradient(135deg, #ede9fe 0%, #c4b5fd 100%);
  }
  
  &.card-hover {
    transform: translateY(-8px);
    
    &.card-1 {
      box-shadow: 0 20px 40px -12px rgba(59, 130, 246, 0.4), 0 0 0 1px rgba(59, 130, 246, 0.1);
    }
    
    &.card-2 {
      box-shadow: 0 20px 40px -12px rgba(16, 185, 129, 0.4), 0 0 0 1px rgba(16, 185, 129, 0.1);
    }
    
    &.card-3 {
      box-shadow: 0 20px 40px -12px rgba(245, 158, 11, 0.4), 0 0 0 1px rgba(245, 158, 11, 0.1);
    }
    
    &.card-4 {
      box-shadow: 0 20px 40px -12px rgba(139, 92, 246, 0.4), 0 0 0 1px rgba(139, 92, 246, 0.1);
    }
    
    .card-arrow {
      transform: translateX(4px);
      
      .arrow {
        opacity: 1;
      }
    }
  }
  
  .card-icon-wrapper {
    position: relative;
    z-index: 2;
    width: 72px;
    height: 72px;
    background: rgba(255, 255, 255, 0.9);
    border-radius: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    
    .card-icon {
      font-size: 36px;
    }
  }
  
  .card-content {
    position: relative;
    z-index: 2;
    flex: 1;
    
    .card-title {
      display: block;
      font-size: 22px;
      font-weight: 700;
      color: #1e293b;
      margin-bottom: 6px;
    }
    
    .card-desc {
      font-size: 14px;
      color: #475569;
      line-height: 1.5;
    }
  }
  
  .card-arrow {
    position: absolute;
    right: 24px;
    bottom: 24px;
    z-index: 2;
    transition: transform 0.3s ease;
    
    .arrow {
      font-size: 28px;
      font-weight: 300;
      color: #64748b;
      opacity: 0.6;
      transition: opacity 0.3s ease;
    }
  }
}

.portal-footer {
  margin-top: 40px;
  text-align: center;
  
  .footer-text {
    font-size: 14px;
    color: #94a3b8;
  }
}
</style>
