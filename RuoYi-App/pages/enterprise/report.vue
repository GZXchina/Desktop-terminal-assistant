<template>
  <view class="report-container">
    <view class="security-badge">
      <text class="badge-icon">🔒</text>
      <text class="badge-text">数据已进行匿名脱敏处理</text>
    </view>

    <view class="report-header">
      <view class="header-left">
        <text class="title">团队健康报表</text>
        <text class="subtitle">实时掌握团队工作状态</text>
      </view>
      <view class="header-right">
        <text class="date-text">{{ currentDate }}</text>
      </view>
    </view>

    <view class="stats-cards">
      <view class="stat-card">
        <view class="stat-icon">
          <text class="icon">⏱️</text>
        </view>
        <view class="stat-content">
          <text class="stat-label">团队平均久坐时长</text>
          <text class="stat-value">{{ avgSittingHours }}h</text>
          <view class="stat-trend" :class="sittingTrend > 0 ? 'up' : 'down'">
            <text class="trend-arrow">{{ sittingTrend > 0 ? '↑' : '↓' }}</text>
            <text class="trend-text">{{ Math.abs(sittingTrend).toFixed(1) }}% 较上周</text>
          </view>
        </view>
      </view>

      <view class="stat-card">
        <view class="stat-icon">
          <text class="icon">🎯</text>
        </view>
        <view class="stat-content">
          <text class="stat-label">团队平均专注度</text>
          <text class="stat-value">{{ avgFocusScore }}%</text>
          <view class="stat-trend" :class="focusTrend > 0 ? 'up' : 'down'">
            <text class="trend-arrow">{{ focusTrend > 0 ? '↑' : '↓' }}</text>
            <text class="trend-text">{{ Math.abs(focusTrend).toFixed(1) }}% 较上周</text>
          </view>
        </view>
      </view>

      <view class="stat-card">
        <view class="stat-icon">
          <text class="icon">👥</text>
        </view>
        <view class="stat-content">
          <text class="stat-label">活跃员工数</text>
          <text class="stat-value">{{ activeUsers }}</text>
          <view class="stat-trend">
            <text class="trend-text">共 {{ totalUsers }} 人</text>
          </view>
        </view>
      </view>

      <view class="stat-card">
        <view class="stat-icon">
          <text class="icon">💚</text>
        </view>
        <view class="stat-content">
          <text class="stat-label">健康指数</text>
          <text class="stat-value">{{ healthIndex }}</text>
          <view class="stat-trend">
            <text class="trend-text" :class="healthLevelClass">{{ healthLevel }}</text>
          </view>
        </view>
      </view>
    </view>

    <view class="charts-section">
      <view class="chart-card">
        <view class="chart-header">
          <text class="chart-title">久坐时长趋势</text>
          <view class="chart-tabs">
            <view v-for="(tab, index) in timeTabs" :key="index"
                  class="chart-tab"
                  :class="{ active: currentTimeTab === tab.value }"
                  @click="currentTimeTab = tab.value">
              <text class="tab-text">{{ tab.label }}</text>
            </view>
          </view>
        </view>
        <view class="sitting-chart">
          <view class="chart-y-axis">
            <text class="y-label">8h</text>
            <text class="y-label">6h</text>
            <text class="y-label">4h</text>
            <text class="y-label">2h</text>
            <text class="y-label">0h</text>
          </view>
          <view class="chart-area">
            <view class="bars-container">
              <view v-for="(bar, index) in sittingBars" :key="index" class="bar-item">
                <view class="bar-wrapper">
                  <view class="bar-fill" :style="{ height: bar.height + '%', background: bar.color }"></view>
                </view>
                <text class="bar-label">{{ bar.label }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <view class="chart-card">
        <view class="chart-header">
          <text class="chart-title">专注度热力图</text>
        </view>
        <view class="heatmap-container">
          <view class="heatmap-y-axis">
            <text v-for="hour in heatmapHours" :key="hour" class="y-label">{{ hour }}</text>
          </view>
          <view class="heatmap-grid">
            <view v-for="(row, rowIndex) in heatmapData" :key="rowIndex" class="heatmap-row">
              <view v-for="(cell, colIndex) in row" :key="colIndex"
                    class="heatmap-cell"
                    :style="{ background: getHeatmapColor(cell) }"
                    :class="{ 'cell-highlight': cell > 70 }">
              </view>
            </view>
          </view>
          <view class="heatmap-x-axis">
            <text v-for="day in heatmapDays" :key="day" class="x-label">{{ day }}</text>
          </view>
        </view>
        <view class="heatmap-legend">
          <text class="legend-label">低</text>
          <view class="legend-colors">
            <view class="legend-color" style="background: #e0f2fe"></view>
            <view class="legend-color" style="background: #7dd3fc"></view>
            <view class="legend-color" style="background: #38bdf8"></view>
            <view class="legend-color" style="background: #0ea5e9"></view>
            <view class="legend-color" style="background: #0284c7"></view>
          </view>
          <text class="legend-label">高</text>
        </view>
      </view>
    </view>

    <view class="care-section">
      <view class="section-header">
        <text class="section-title">关怀下发系统</text>
        <text class="section-subtitle">一键触达全体员工</text>
      </view>
      
      <view class="care-options">
        <view v-for="(option, index) in careOptions" :key="index"
              class="care-option"
              :class="{ active: selectedCare === option.value }"
              @click="selectedCare = option.value">
          <view class="care-icon" :style="{ background: option.bg }">
            <text class="icon-text">{{ option.icon }}</text>
          </view>
          <view class="care-info">
            <text class="care-title">{{ option.title }}</text>
            <text class="care-desc">{{ option.desc }}</text>
          </view>
          <view class="care-check">
            <text v-if="selectedCare === option.value" class="check-icon">✓</text>
          </view>
        </view>
      </view>

      <view class="send-section">
        <view class="send-preview" v-if="selectedCare">
          <text class="preview-label">消息预览：</text>
          <text class="preview-text">{{ getCarePreview() }}</text>
        </view>
        <view class="send-btn" 
              :class="{ disabled: !selectedCare || sending }"
              @click="sendCareNotification">
          <text v-if="sending" class="sending-text">发送中...</text>
          <text v-else class="send-text">发送关怀通知</text>
        </view>
      </view>
    </view>

    <view class="history-section">
      <view class="section-header">
        <text class="section-title">下发记录</text>
      </view>
      <view class="history-list">
        <view v-for="(item, index) in historyList" :key="index" class="history-item">
          <view class="history-left">
            <view class="history-icon" :style="{ background: item.bg }">
              <text class="icon-text">{{ item.icon }}</text>
            </view>
            <view class="history-info">
              <text class="history-title">{{ item.title }}</text>
              <text class="history-time">{{ item.time }}</text>
            </view>
          </view>
          <view class="history-status" :class="item.status">
            <text class="status-text">{{ item.statusText }}</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { getTeamHealthData, sendCareNotification } from '@/api/enterprise'

export default {
  data() {
    return {
      currentDate: '',
      avgSittingHours: 4.8,
      sittingTrend: -5.2,
      avgFocusScore: 78,
      focusTrend: 3.1,
      activeUsers: 42,
      totalUsers: 56,
      healthIndex: 82,
      currentTimeTab: 'week',
      timeTabs: [
        { label: '本周', value: 'week' },
        { label: '本月', value: 'month' },
        { label: '本季度', value: 'quarter' }
      ],
      sittingBars: [],
      heatmapData: [],
      heatmapHours: ['9:00', '11:00', '13:00', '15:00', '17:00'],
      heatmapDays: ['周一', '周二', '周三', '周四', '周五'],
      selectedCare: null,
      sending: false,
      careOptions: [
        { 
          value: 'afternoon', 
          title: '下午茶提醒', 
          desc: '发送下午茶时间到了的温馨提醒',
          icon: '🍵',
          bg: 'linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%)'
        },
        { 
          value: 'nap', 
          title: '午休白噪音', 
          desc: '播放舒缓的白噪音帮助员工午休',
          icon: '🎵',
          bg: 'linear-gradient(135deg, #8b5cf6 0%, #a78bfa 100%)'
        },
        { 
          value: 'stretch', 
          title: '拉伸提醒', 
          desc: '提醒大家起身活动、做拉伸运动',
          icon: '🧘',
          bg: 'linear-gradient(135deg, #10b981 0%, #34d399 100%)'
        }
      ],
      historyList: [
        { 
          title: '下午茶提醒', 
          time: '今天 15:00', 
          status: 'success',
          statusText: '已送达 56 人',
          icon: '🍵',
          bg: 'linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%)'
        },
        { 
          title: '拉伸提醒', 
          time: '昨天 10:30', 
          status: 'success',
          statusText: '已送达 52 人',
          icon: '🧘',
          bg: 'linear-gradient(135deg, #10b981 0%, #34d399 100%)'
        },
        { 
          title: '午休白噪音', 
          time: '3天前 12:30', 
          status: 'success',
          statusText: '已送达 48 人',
          icon: '🎵',
          bg: 'linear-gradient(135deg, #8b5cf6 0%, #a78bfa 100%)'
        }
      ]
    }
  },
  computed: {
    healthLevelClass() {
      if (this.healthIndex >= 80) return 'excellent'
      if (this.healthIndex >= 60) return 'good'
      return 'normal'
    },
    healthLevel() {
      if (this.healthIndex >= 80) return '优秀'
      if (this.healthIndex >= 60) return '良好'
      return '一般'
    }
  },
  onLoad() {
    this.initData()
  },
  methods: {
    initData() {
      const now = new Date()
      this.currentDate = now.toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric' })
      this.generateSittingBars()
      this.generateHeatmapData()
    },
    generateSittingBars() {
      const labels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
      this.sittingBars = labels.map((label, index) => ({
        label,
        height: 40 + Math.random() * 50,
        color: index < 5 ? 'linear-gradient(180deg, #3b82f6 0%, #2563eb 100%)' : 'linear-gradient(180deg, #9ca3af 0%, #6b7280 100%)'
      }))
    },
    generateHeatmapData() {
      this.heatmapData = []
      for (let i = 0; i < 5; i++) {
        const row = []
        for (let j = 0; j < 5; j++) {
          row.push(30 + Math.random() * 60)
        }
        this.heatmapData.push(row)
      }
    },
    getHeatmapColor(value) {
      if (value > 80) return '#0284c7'
      if (value > 65) return '#0ea5e9'
      if (value > 50) return '#38bdf8'
      if (value > 35) return '#7dd3fc'
      return '#e0f2fe'
    },
    getCarePreview() {
      const previews = {
        afternoon: '亲爱的小伙伴们，下午茶时间到啦！来杯咖啡休息一下吧~ ☕',
        nap: '午休时间到啦，戴上耳机听一段舒缓的白噪音吧~ 🎵',
        stretch: '坐了很久了，一起来做个简单的拉伸运动吧！🧘'
      }
      return previews[this.selectedCare] || ''
    },
    sendCareNotification() {
      if (!this.selectedCare || this.sending) return
      
      this.sending = true
      uni.showLoading({ title: '发送中...' })
      
      setTimeout(() => {
        uni.hideLoading()
        this.sending = false
        
        const option = this.careOptions.find(o => o.value === this.selectedCare)
        this.historyList.unshift({
          title: option.title,
          time: '刚刚',
          status: 'success',
          statusText: '已送达 ' + this.totalUsers + ' 人',
          icon: option.icon,
          bg: option.bg
        })
        
        uni.showToast({
          title: '发送成功！',
          icon: 'success'
        })
        
        this.selectedCare = null
      }, 1500)
    }
  }
}
</script>

<style lang="scss" scoped>
.report-container {
  min-height: 100vh;
  background: #f9fafb;
  padding: 16px;
  position: relative;
}

.security-badge {
  position: absolute;
  top: 16px;
  right: 16px;
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 14px;
  background: rgba(16, 185, 129, 0.1);
  border: 1px solid rgba(16, 185, 129, 0.3);
  border-radius: 20px;
  z-index: 10;
  
  .badge-icon {
    font-size: 14px;
  }
  
  .badge-text {
    font-size: 12px;
    font-weight: 500;
    color: #059669;
  }
}

.report-header {
  margin-top: 8px;
  margin-bottom: 24px;
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  
  .header-left {
    .title {
      display: block;
      font-size: 26px;
      font-weight: 700;
      color: #111827;
      margin-bottom: 4px;
    }
    
    .subtitle {
      font-size: 14px;
      color: #6b7280;
    }
  }
  
  .header-right {
    .date-text {
      font-size: 14px;
      color: #6b7280;
    }
  }
}

.stats-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 24px;
  
  @media (max-width: 900px) {
    grid-template-columns: repeat(2, 1fr);
  }
  
  @media (max-width: 600px) {
    grid-template-columns: 1fr;
  }
  
  .stat-card {
    background: #ffffff;
    border-radius: 16px;
    padding: 20px;
    display: flex;
    gap: 16px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    
    .stat-icon {
      width: 56px;
      height: 56px;
      background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
      border-radius: 14px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      
      .icon {
        font-size: 28px;
      }
    }
    
    .stat-content {
      flex: 1;
      
      .stat-label {
        display: block;
        font-size: 13px;
        color: #6b7280;
        margin-bottom: 6px;
      }
      
      .stat-value {
        display: block;
        font-size: 28px;
        font-weight: 700;
        color: #111827;
        margin-bottom: 8px;
      }
      
      .stat-trend {
        display: flex;
        align-items: center;
        gap: 4px;
        
        &.up {
          .trend-arrow {
            color: #10b981;
          }
        }
        
        &.down {
          .trend-arrow {
            color: #ef4444;
          }
        }
        
        .trend-arrow {
          font-size: 14px;
          font-weight: 600;
        }
        
        .trend-text {
          font-size: 12px;
          color: #6b7280;
        }
      }
    }
  }
}

.charts-section {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 24px;
  
  @media (max-width: 900px) {
    grid-template-columns: 1fr;
  }
  
  .chart-card {
    background: #ffffff;
    border-radius: 16px;
    padding: 20px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    
    .chart-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      
      .chart-title {
        font-size: 16px;
        font-weight: 600;
        color: #111827;
      }
      
      .chart-tabs {
        display: flex;
        background: #f3f4f6;
        border-radius: 8px;
        padding: 3px;
        
        .chart-tab {
          padding: 6px 14px;
          border-radius: 6px;
          cursor: pointer;
          transition: all 0.2s ease;
          
          &.active {
            background: #ffffff;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
            
            .tab-text {
              color: #2563eb;
              font-weight: 600;
            }
          }
          
          .tab-text {
            font-size: 13px;
            color: #6b7280;
          }
        }
      }
    }
    
    .sitting-chart {
      display: flex;
      gap: 12px;
      height: 220px;
      
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
        display: flex;
        align-items: flex-end;
        
        .bars-container {
          display: flex;
          justify-content: space-around;
          width: 100%;
          height: 100%;
          padding-bottom: 24px;
          position: relative;
          
          .bar-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            flex: 1;
            height: 100%;
            justify-content: flex-end;
            
            .bar-wrapper {
              width: 36px;
              height: calc(100% - 28px);
              position: relative;
              display: flex;
              align-items: flex-end;
              
              .bar-fill {
                width: 100%;
                border-radius: 8px 8px 0 0;
                transition: height 0.5s ease;
              }
            }
            
            .bar-label {
              font-size: 11px;
              color: #6b7280;
              margin-top: 8px;
            }
          }
        }
      }
    }
    
    .heatmap-container {
      display: flex;
      gap: 12px;
      margin-bottom: 16px;
      
      .heatmap-y-axis {
        display: flex;
        flex-direction: column;
        justify-content: space-around;
        padding: 8px 0;
        
        .y-label {
          font-size: 11px;
          color: #9ca3af;
        }
      }
      
      .heatmap-grid {
        flex: 1;
        display: flex;
        flex-direction: column;
        gap: 8px;
        
        .heatmap-row {
          display: flex;
          gap: 8px;
          flex: 1;
          
          .heatmap-cell {
            flex: 1;
            border-radius: 6px;
            transition: all 0.2s ease;
            
            &.cell-highlight {
              box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.3);
            }
          }
        }
      }
      
      .heatmap-x-axis {
        display: flex;
        justify-content: space-around;
        padding-left: 44px;
        
        .x-label {
          font-size: 11px;
          color: #6b7280;
        }
      }
    }
    
    .heatmap-legend {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      
      .legend-label {
        font-size: 12px;
        color: #6b7280;
      }
      
      .legend-colors {
        display: flex;
        gap: 4px;
        
        .legend-color {
          width: 24px;
          height: 16px;
          border-radius: 4px;
        }
      }
    }
  }
}

.care-section,
.history-section {
  background: #ffffff;
  border-radius: 16px;
  padding: 20px;
  margin-bottom: 16px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  
  .section-header {
    margin-bottom: 20px;
    
    .section-title {
      display: block;
      font-size: 16px;
      font-weight: 600;
      color: #111827;
      margin-bottom: 4px;
    }
    
    .section-subtitle {
      font-size: 13px;
      color: #6b7280;
    }
  }
}

.care-options {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 20px;
  
  .care-option {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 16px;
    background: #f9fafb;
    border: 2px solid transparent;
    border-radius: 12px;
    cursor: pointer;
    transition: all 0.2s ease;
    
    &.active {
      background: rgba(37, 99, 235, 0.05);
      border-color: #2563eb;
    }
    
    .care-icon {
      width: 48px;
      height: 48px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      
      .icon-text {
        font-size: 24px;
      }
    }
    
    .care-info {
      flex: 1;
      
      .care-title {
        display: block;
        font-size: 15px;
        font-weight: 600;
        color: #111827;
        margin-bottom: 4px;
      }
      
      .care-desc {
        font-size: 13px;
        color: #6b7280;
      }
    }
    
    .care-check {
      width: 24px;
      height: 24px;
      border: 2px solid #e5e7eb;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      
      .check-icon {
        font-size: 14px;
        font-weight: bold;
        color: #2563eb;
      }
    }
  }
}

.send-section {
  .send-preview {
    padding: 14px 16px;
    background: #f3f4f6;
    border-radius: 10px;
    margin-bottom: 16px;
    
    .preview-label {
      display: block;
      font-size: 12px;
      color: #6b7280;
      margin-bottom: 6px;
    }
    
    .preview-text {
      font-size: 14px;
      color: #374151;
      line-height: 1.6;
    }
  }
  
  .send-btn {
    width: 100%;
    padding: 16px;
    background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s ease;
    
    &:active {
      transform: scale(0.98);
    }
    
    &.disabled {
      background: #e5e7eb;
      cursor: not-allowed;
      
      .send-text {
        color: #9ca3af;
      }
    }
    
    .sending-text,
    .send-text {
      font-size: 15px;
      font-weight: 600;
      color: #ffffff;
    }
  }
}

.history-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
  
  .history-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px 16px;
    background: #f9fafb;
    border-radius: 10px;
    
    .history-left {
      display: flex;
      align-items: center;
      gap: 12px;
      
      .history-icon {
        width: 40px;
        height: 40px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
        
        .icon-text {
          font-size: 20px;
        }
      }
      
      .history-info {
        .history-title {
          display: block;
          font-size: 14px;
          font-weight: 500;
          color: #111827;
          margin-bottom: 2px;
        }
        
        .history-time {
          font-size: 12px;
          color: #9ca3af;
        }
      }
    }
    
    .history-status {
      padding: 6px 12px;
      border-radius: 8px;
      background: rgba(16, 185, 129, 0.1);
      
      &.success {
        .status-text {
          color: #059669;
        }
      }
      
      .status-text {
        font-size: 12px;
        font-weight: 500;
      }
    }
  }
}
</style>
