<template>
  <view class="dashboard-container page-bg">
    <view class="dashboard-header">
      <text class="greeting-text">下午好，{{ userName }} 👋</text>
      <text class="date-text">{{ currentDate }}</text>
    </view>

    <view class="dashboard-content">
      <view class="left-section">
        <view class="ai-partner-card card-glass">
          <view class="partner-header">
            <text class="partner-title">AI 伙伴</text>
            <view class="partner-status" :class="partnerStatusClass">
              <text class="status-dot"></text>
              <text class="status-text">{{ partnerStatus }}</text>
            </view>
          </view>
          <view class="partner-emotion">
            <view class="emotion-screen">
              <text class="emotion-text">{{ partnerEmotion }}</text>
            </view>
            <text class="emotion-label">{{ partnerMood }}</text>
          </view>
          <view class="partner-message">
            <text class="message-text">{{ partnerMessage }}</text>
          </view>
        </view>
      </view>

      <view class="right-section">
        <view class="status-cards">
          <view class="status-card card-glass" :class="{ 'card-hover': hoveredCard === 'focus' }"
                @mouseenter="hoveredCard = 'focus'" @mouseleave="hoveredCard = null">
            <view class="card-icon focus-icon">
              <text class="icon">🎯</text>
            </view>
            <view class="card-content">
              <text class="card-label">专注度分数</text>
              <text class="card-value">{{ focusScore }}%</text>
              <view class="card-trend">
                <text class="trend-text" :class="focusTrend > 0 ? 'up' : 'down'">
                  {{ focusTrend > 0 ? '↑' : '↓' }}{{ Math.abs(focusTrend) }}%
                </text>
                <text class="trend-label">较昨日</text>
              </view>
            </view>
          </view>

          <view class="status-card card-glass" :class="{ 'card-hover': hoveredCard === 'breath' }"
                @mouseenter="hoveredCard = 'breath'" @mouseleave="hoveredCard = null">
            <view class="card-icon breath-icon">
              <text class="icon">💨</text>
            </view>
            <view class="card-content">
              <text class="card-label">呼吸频率</text>
              <text class="card-value">{{ breathRate }} 次/分</text>
              <view class="card-status">
                <view class="status-indicator normal"></view>
                <text class="status-text">正常</text>
              </view>
            </view>
          </view>

          <view class="status-card card-glass" :class="{ 'card-hover': hoveredCard === 'environment' }"
                @mouseenter="hoveredCard = 'environment'" @mouseleave="hoveredCard = null">
            <view class="card-icon env-icon">
              <text class="icon">🌡️</text>
            </view>
            <view class="card-content">
              <text class="card-label">环境舒适度</text>
              <view class="env-details">
                <text class="env-item">CO₂: {{ co2Level }} ppm</text>
                <text class="env-item">温度: {{ temperature }}°C</text>
                <text class="env-item">湿度: {{ humidity }}%</text>
              </view>
            </view>
          </view>
        </view>

        <view class="charts-section">
          <view class="chart-card card-glass">
            <view class="chart-header">
              <text class="chart-title">久坐时长</text>
              <text class="chart-subtitle">今日累计</text>
            </view>
            <view class="health-gauge">
              <view class="gauge-container">
                <view class="gauge-bg"></view>
                <view class="gauge-fill" :style="{ width: sittingProgress + '%', background: gaugeColor }"></view>
                <view class="gauge-text">
                  <text class="gauge-value">{{ sittingHours }}h {{ sittingMinutes }}m</text>
                  <text class="gauge-label">/ 8h</text>
                </view>
              </view>
              <view class="gauge-warning" v-if="sittingHours >= 1">
                <text class="warning-icon">⚠️</text>
                <text class="warning-text">建议起身活动一下</text>
              </view>
            </view>
          </view>

          <view class="chart-card card-glass emotion-chart">
            <view class="chart-header">
              <text class="chart-title">情绪曲线</text>
              <text class="chart-subtitle">过去 24 小时</text>
            </view>
            <view class="emotion-chart-container">
              <view class="chart-y-axis">
                <text class="y-label">高</text>
                <text class="y-label">中</text>
                <text class="y-label">低</text>
              </view>
              <view class="chart-area">
                <view class="chart-line">
                  <view class="line-bg"></view>
                  <view class="line-fill" :style="lineStyle"></view>
                </view>
                <view class="chart-dots">
                  <view v-for="(point, index) in emotionPoints" :key="index"
                        class="dot" :style="{ left: point.x + '%', bottom: point.y + '%' }"></view>
                </view>
                <view class="chart-x-axis">
                  <text v-for="(label, index) in timeLabels" :key="index" class="x-label">{{ label }}</text>
                </view>
              </view>
            </view>
            <view class="emotion-legend">
              <view class="legend-item">
                <view class="legend-dot stress"></view>
                <text class="legend-text">压力指数</text>
              </view>
            </view>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { getRealtimeStatus, getHealthData, getEmotionData, getAiPartnerStatus } from '@/api/dashboard'

export default {
  data() {
    return {
      userName: '职场人',
      currentDate: '',
      hoveredCard: null,
      focusScore: 85,
      focusTrend: 5,
      breathRate: 16,
      co2Level: 520,
      temperature: 24,
      humidity: 55,
      sittingHours: 1,
      sittingMinutes: 23,
      sittingProgress: 17,
      partnerStatus: '在线',
      partnerEmotion: '😊',
      partnerMood: '开心',
      partnerMessage: '今天状态不错！继续保持专注哦~',
      emotionPoints: [],
      timeLabels: [],
      timer: null
    }
  },
  computed: {
    partnerStatusClass() {
      return this.partnerStatus === '在线' ? 'online' : 'offline'
    },
    gaugeColor() {
      if (this.sittingHours >= 1) {
        return 'linear-gradient(90deg, #f59e0b 0%, #fbbf24 100%)'
      }
      return 'linear-gradient(90deg, #10b981 0%, #34d399 100%)'
    },
    lineStyle() {
      const points = this.emotionPoints.map(p => `${p.x}% ${100 - p.y}%`).join(', ')
      return {
        background: `linear-gradient(135deg, #2563eb 0%, #60a5fa 100%)`,
        clipPath: `polygon(0% 100%, ${points}, 100% 100%)`
      }
    }
  },
  onLoad() {
    this.initData()
    this.startTimer()
  },
  onUnload() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  },
  methods: {
    initData() {
      const now = new Date()
      this.currentDate = now.toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' })
      
      this.generateEmotionData()
      this.loadMockData()
    },
    loadMockData() {
      this.focusScore = 85 + Math.floor(Math.random() * 10)
      this.breathRate = 14 + Math.floor(Math.random() * 6)
      this.co2Level = 450 + Math.floor(Math.random() * 200)
      this.temperature = 22 + Math.floor(Math.random() * 5)
      this.humidity = 45 + Math.floor(Math.random() * 20)
      
      const totalMinutes = 60 + Math.floor(Math.random() * 120)
      this.sittingHours = Math.floor(totalMinutes / 60)
      this.sittingMinutes = totalMinutes % 60
      this.sittingProgress = (totalMinutes / 480) * 100
    },
    generateEmotionData() {
      this.emotionPoints = []
      this.timeLabels = []
      
      for (let i = 0; i < 8; i++) {
        this.emotionPoints.push({
          x: (i / 7) * 100,
          y: 30 + Math.random() * 50
        })
        const hour = (new Date().getHours() - 21 + i * 3 + 24) % 24
        this.timeLabels.push(`${hour}:00`)
      }
    },
    startTimer() {
      this.timer = setInterval(() => {
        this.loadMockData()
      }, 30000)
    }
  }
}
</script>

<style lang="scss" scoped>
.dashboard-container {
  min-height: 100vh;
  padding: 16px;
}

.dashboard-header {
  margin-bottom: 24px;
  
  .greeting-text {
    display: block;
    font-size: 24px;
    font-weight: 600;
    color: #1f2937;
    margin-bottom: 4px;
  }
  
  .date-text {
    font-size: 14px;
    color: #6b7280;
  }
}

.dashboard-content {
  display: flex;
  gap: 16px;
  
  @media (max-width: 768px) {
    flex-direction: column;
  }
}

.left-section {
  width: 280px;
  flex-shrink: 0;
  
  @media (max-width: 768px) {
    width: 100%;
  }
}

.right-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.ai-partner-card {
  padding: 20px;
  
  .partner-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
    
    .partner-title {
      font-size: 16px;
      font-weight: 600;
      color: #1f2937;
    }
    
    .partner-status {
      display: flex;
      align-items: center;
      gap: 4px;
      
      &.online {
        .status-dot {
          background: #10b981;
        }
      }
      
      &.offline {
        .status-dot {
          background: #9ca3af;
        }
      }
      
      .status-dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
      }
      
      .status-text {
        font-size: 12px;
        color: #6b7280;
      }
    }
  }
  
  .partner-emotion {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-bottom: 16px;
    
    .emotion-screen {
      width: 120px;
      height: 120px;
      background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
      border-radius: 24px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 12px;
      box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.1);
      
      .emotion-text {
        font-size: 64px;
        animation: blink 3s infinite;
      }
    }
    
    .emotion-label {
      font-size: 14px;
      color: #374151;
      font-weight: 500;
    }
  }
  
  .partner-message {
    background: linear-gradient(135deg, rgba(37, 99, 235, 0.1) 0%, rgba(96, 165, 250, 0.1) 100%);
    border-radius: 12px;
    padding: 12px;
    
    .message-text {
      font-size: 13px;
      color: #374151;
      line-height: 1.6;
    }
  }
}

.status-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  
  @media (max-width: 768px) {
    grid-template-columns: 1fr;
  }
}

.status-card {
  padding: 20px;
  display: flex;
  gap: 16px;
  transition: all 0.3s ease;
  cursor: pointer;
  
  &.card-hover {
    transform: translateY(-4px);
    box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
  }
  
  .card-icon {
    width: 56px;
    height: 56px;
    border-radius: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    
    .icon {
      font-size: 28px;
    }
  }
  
  .focus-icon {
    background: linear-gradient(135deg, rgba(37, 99, 235, 0.1) 0%, rgba(96, 165, 250, 0.1) 100%);
  }
  
  .breath-icon {
    background: linear-gradient(135deg, rgba(16, 185, 129, 0.1) 0%, rgba(52, 211, 153, 0.1) 100%);
  }
  
  .env-icon {
    background: linear-gradient(135deg, rgba(245, 158, 11, 0.1) 0%, rgba(251, 191, 36, 0.1) 100%);
  }
  
  .card-content {
    flex: 1;
    
    .card-label {
      display: block;
      font-size: 13px;
      color: #6b7280;
      margin-bottom: 4px;
    }
    
    .card-value {
      display: block;
      font-size: 24px;
      font-weight: 700;
      color: #1f2937;
      margin-bottom: 8px;
    }
    
    .card-trend {
      display: flex;
      align-items: center;
      gap: 4px;
      
      .trend-text {
        font-size: 12px;
        font-weight: 500;
        
        &.up {
          color: #10b981;
        }
        
        &.down {
          color: #ef4444;
        }
      }
      
      .trend-label {
        font-size: 12px;
        color: #9ca3af;
      }
    }
    
    .card-status {
      display: flex;
      align-items: center;
      gap: 6px;
      
      .status-indicator {
        width: 8px;
        height: 8px;
        border-radius: 50%;
        
        &.normal {
          background: #10b981;
        }
      }
      
      .status-text {
        font-size: 12px;
        color: #6b7280;
      }
    }
    
    .env-details {
      display: flex;
      flex-direction: column;
      gap: 2px;
      
      .env-item {
        font-size: 12px;
        color: #6b7280;
      }
    }
  }
}

.charts-section {
  display: grid;
  grid-template-columns: 1fr 1.5fr;
  gap: 16px;
  
  @media (max-width: 768px) {
    grid-template-columns: 1fr;
  }
}

.chart-card {
  padding: 20px;
  
  .chart-header {
    margin-bottom: 20px;
    
    .chart-title {
      display: block;
      font-size: 16px;
      font-weight: 600;
      color: #1f2937;
      margin-bottom: 4px;
    }
    
    .chart-subtitle {
      font-size: 13px;
      color: #6b7280;
    }
  }
}

.health-gauge {
  .gauge-container {
    position: relative;
    height: 40px;
    margin-bottom: 16px;
    
    .gauge-bg {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: #f3f4f6;
      border-radius: 20px;
    }
    
    .gauge-fill {
      position: absolute;
      top: 0;
      left: 0;
      bottom: 0;
      border-radius: 20px;
      transition: width 0.5s ease, background 0.5s ease;
    }
    
    .gauge-text {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      display: flex;
      align-items: baseline;
      gap: 4px;
      
      .gauge-value {
        font-size: 20px;
        font-weight: 700;
        color: #1f2937;
      }
      
      .gauge-label {
        font-size: 14px;
        color: #6b7280;
      }
    }
  }
  
  .gauge-warning {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 12px;
    background: linear-gradient(135deg, rgba(245, 158, 11, 0.1) 0%, rgba(251, 191, 36, 0.1) 100%);
    border-radius: 12px;
    
    .warning-icon {
      font-size: 20px;
    }
    
    .warning-text {
      font-size: 13px;
      color: #92400e;
    }
  }
}

.emotion-chart-container {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
  
  .chart-y-axis {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding: 8px 0;
    
    .y-label {
      font-size: 11px;
      color: #9ca3af;
    }
  }
  
  .chart-area {
    flex: 1;
    position: relative;
    height: 160px;
    
    .chart-line {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 24px;
      
      .line-bg {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(180deg, rgba(37, 99, 235, 0.1) 0%, transparent 100%);
        border-radius: 8px;
      }
      
      .line-fill {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        opacity: 0.8;
      }
    }
    
    .chart-dots {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 24px;
      
      .dot {
        position: absolute;
        width: 10px;
        height: 10px;
        background: #2563eb;
        border-radius: 50%;
        transform: translate(-50%, 50%);
        border: 2px solid #fff;
        box-shadow: 0 2px 4px rgba(37, 99, 235, 0.3);
      }
    }
    
    .chart-x-axis {
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      display: flex;
      justify-content: space-between;
      
      .x-label {
        font-size: 11px;
        color: #9ca3af;
      }
    }
  }
}

.emotion-legend {
  display: flex;
  gap: 16px;
  
  .legend-item {
    display: flex;
    align-items: center;
    gap: 6px;
    
    .legend-dot {
      width: 12px;
      height: 12px;
      border-radius: 50%;
      
      &.stress {
        background: linear-gradient(135deg, #2563eb 0%, #60a5fa 100%);
      }
    }
    
    .legend-text {
      font-size: 12px;
      color: #6b7280;
    }
  }
}

@keyframes blink {
  0%, 90%, 100% {
    opacity: 1;
  }
  95% {
    opacity: 0.3;
  }
}
</style>
