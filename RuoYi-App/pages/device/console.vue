<template>
  <view class="console-container page-bg">
    <view class="console-header">
      <view class="header-left">
        <view class="device-indicator" :class="deviceStatus">
          <view class="indicator-dot"></view>
        </view>
        <view class="device-info">
          <text class="device-name">工位搭子 Pro</text>
          <text class="device-status-text">{{ deviceStatusText }}</text>
        </view>
      </view>
      <view class="battery-info">
        <text class="battery-icon">🔋</text>
        <text class="battery-text">{{ batteryLevel }}%</text>
      </view>
    </view>

    <view class="console-content">
      <view class="left-panel">
        <view class="joystick-section card-glass">
          <text class="section-title">云台控制</text>
          <view class="joystick-container">
            <view class="joystick-base">
              <view class="joystick-btn up" 
                    :class="{ active: pressedBtn === 'up' }"
                    @touchstart="pressBtn('up')"
                    @touchend="releaseBtn">
                <text class="btn-icon">↑</text>
              </view>
              <view class="joystick-btn left"
                    :class="{ active: pressedBtn === 'left' }"
                    @touchstart="pressBtn('left')"
                    @touchend="releaseBtn">
                <text class="btn-icon">←</text>
              </view>
              <view class="joystick-center"></view>
              <view class="joystick-btn right"
                    :class="{ active: pressedBtn === 'right' }"
                    @touchstart="pressBtn('right')"
                    @touchend="releaseBtn">
                <text class="btn-icon">→</text>
              </view>
              <view class="joystick-btn down"
                    :class="{ active: pressedBtn === 'down' }"
                    @touchstart="pressBtn('down')"
                    @touchend="releaseBtn">
                <text class="btn-icon">↓</text>
              </view>
            </view>
            <text class="joystick-hint">点击控制云台移动</text>
          </view>
        </view>

        <view class="voice-section card-glass">
          <text class="section-title">音色设置</text>
          <view class="voice-preview">
            <view class="voice-wave">
              <view v-for="i in 20" :key="i" class="wave-bar" :style="{ height: waveHeights[i] + '%' }"></view>
            </view>
            <view class="voice-info">
              <text class="voice-name">{{ currentVoice }}</text>
              <text class="voice-desc">克隆音色 · 温暖女声</text>
            </view>
          </view>
          
          <view class="slider-group">
            <view class="slider-item">
              <view class="slider-label">
                <text class="label-text">音量</text>
                <text class="label-value">{{ volume }}%</text>
              </view>
              <view class="slider-track">
                <view class="slider-fill" :style="{ width: volume + '%' }"></view>
                <view class="slider-thumb" 
                      :style="{ left: volume + '%' }"
                      @touchstart="startDrag('volume', $event)"
                      @touchmove="onDrag('volume', $event)"
                      @touchend="endDrag"></view>
              </view>
            </view>
            <view class="slider-item">
              <view class="slider-label">
                <text class="label-text">语速</text>
                <text class="label-value">{{ speed }}x</text>
              </view>
              <view class="slider-track">
                <view class="slider-fill" :style="{ width: ((speed - 0.5) / 1.5) * 100 + '%' }"></view>
                <view class="slider-thumb" 
                      :style="{ left: ((speed - 0.5) / 1.5) * 100 + '%' }"
                      @touchstart="startDrag('speed', $event)"
                      @touchmove="onDrag('speed', $event)"
                      @touchend="endDrag"></view>
              </view>
            </view>
          </view>
          
          <view class="play-btn" @click="playPreview">
            <text class="play-icon">▶</text>
            <text class="play-text">试听预览</text>
          </view>
        </view>
      </view>

      <view class="right-panel">
        <view class="mode-section card-glass">
          <text class="section-title">工作模式</text>
          <view class="mode-switch">
            <view v-for="(mode, index) in modes" :key="index"
                  class="mode-item"
                  :class="{ active: currentMode === mode.value }"
                  @click="switchMode(mode.value)">
              <text class="mode-icon">{{ mode.icon }}</text>
              <text class="mode-label">{{ mode.label }}</text>
            </view>
          </view>
          <view class="mode-desc">{{ currentModeDesc }}</view>
        </view>

        <view class="care-section card-glass">
          <text class="section-title">主动关怀</text>
          <view class="care-list">
            <view v-for="(item, index) in careItems" :key="index" class="care-item">
              <view class="care-info">
                <view class="care-icon" :style="{ background: item.bg }">
                  <text class="icon-text">{{ item.icon }}</text>
                </view>
                <view class="care-text">
                  <text class="care-title">{{ item.title }}</text>
                  <text class="care-desc">{{ item.desc }}</text>
                </view>
              </view>
              <view class="care-toggle" 
                    :class="{ active: item.enabled }"
                    @click="toggleCare(index)">
                <view class="toggle-knob"></view>
              </view>
            </view>
          </view>
        </view>

        <view class="action-buttons">
          <view class="action-btn secondary" @click="resetDevice">
            <text class="btn-icon">🔄</text>
            <text class="btn-text">重置</text>
          </view>
          <view class="action-btn primary" @click="saveSettings">
            <text class="btn-icon">💾</text>
            <text class="btn-text">保存设置</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { controlDevice, setDeviceMode, updateCareSettings, updateVoiceSettings } from '@/api/device'

export default {
  data() {
    return {
      deviceStatus: 'online',
      deviceStatusText: '已连接',
      batteryLevel: 78,
      pressedBtn: null,
      currentMode: 'focus',
      modes: [
        { label: '深度专注', value: 'focus', icon: '🎯' },
        { label: '单聊陪伴', value: 'chat', icon: '💬' },
        { label: '共享大厅', value: 'share', icon: '🌐' }
      ],
      currentVoice: '小暖',
      volume: 75,
      speed: 1.0,
      waveHeights: [],
      waveTimer: null,
      careItems: [
        { 
          title: '久坐提醒', 
          desc: '每小时提醒起身活动', 
          icon: '⏰', 
          bg: 'linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%)',
          enabled: true 
        },
        { 
          title: '熬夜预警', 
          desc: '22:00后提醒休息', 
          icon: '🌙', 
          bg: 'linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%)',
          enabled: true 
        },
        { 
          title: '环境优化', 
          desc: '检测环境并给出建议', 
          icon: '🌱', 
          bg: 'linear-gradient(135deg, #10b981 0%, #34d399 100%)',
          enabled: false 
        }
      ],
      isDragging: false,
      dragType: null,
      dragStartX: 0
    }
  },
  computed: {
    currentModeDesc() {
      const descs = {
        focus: '开启后，AI 伙伴会减少打扰，仅在关键时间点提醒你',
        chat: '随时可以和 AI 伙伴聊天，它会温柔地陪伴你',
        share: '连接到共享大厅，与其他工位搭子互动'
      }
      return descs[this.currentMode]
    }
  },
  onLoad() {
    this.initWaveAnimation()
  },
  onUnload() {
    if (this.waveTimer) {
      clearInterval(this.waveTimer)
    }
  },
  methods: {
    initWaveAnimation() {
      this.waveHeights = Array(20).fill(0).map(() => 30 + Math.random() * 50)
      this.waveTimer = setInterval(() => {
        this.waveHeights = this.waveHeights.map(() => 30 + Math.random() * 50)
      }, 200)
    },
    pressBtn(direction) {
      this.pressedBtn = direction
      this.sendControlCommand(direction)
    },
    releaseBtn() {
      this.pressedBtn = null
    },
    sendControlCommand(direction) {
      console.log('发送控制指令:', direction)
      uni.showToast({
        title: `云台${this.getDirectionText(direction)}`,
        icon: 'none',
        duration: 800
      })
    },
    getDirectionText(dir) {
      const texts = { up: '上移', down: '下移', left: '左转', right: '右转' }
      return texts[dir]
    },
    switchMode(mode) {
      this.currentMode = mode
      uni.showToast({
        title: `已切换到${this.modes.find(m => m.value === mode).label}模式`,
        icon: 'success'
      })
    },
    toggleCare(index) {
      this.careItems[index].enabled = !this.careItems[index].enabled
    },
    startDrag(type, e) {
      this.isDragging = true
      this.dragType = type
      this.dragStartX = e.touches[0].clientX
    },
    onDrag(type, e) {
      if (!this.isDragging || this.dragType !== type) return
      
      const touch = e.touches[0]
      const trackWidth = 280
      const deltaX = touch.clientX - this.dragStartX
      
      if (type === 'volume') {
        let newVolume = this.volume + (deltaX / trackWidth) * 100
        newVolume = Math.max(0, Math.min(100, newVolume))
        this.volume = Math.round(newVolume)
      } else if (type === 'speed') {
        let newSpeed = this.speed + (deltaX / trackWidth) * 1.5
        newSpeed = Math.max(0.5, Math.min(2, newSpeed))
        this.speed = Math.round(newSpeed * 10) / 10
      }
      
      this.dragStartX = touch.clientX
    },
    endDrag() {
      this.isDragging = false
      this.dragType = null
    },
    playPreview() {
      uni.showToast({
        title: '正在播放试听...',
        icon: 'none'
      })
    },
    resetDevice() {
      uni.showModal({
        title: '确认重置',
        content: '确定要重置所有设置吗？',
        success: (res) => {
          if (res.confirm) {
            this.volume = 75
            this.speed = 1.0
            this.currentMode = 'focus'
            this.careItems.forEach(item => item.enabled = item.title !== '环境优化')
            uni.showToast({
              title: '已重置',
              icon: 'success'
            })
          }
        }
      })
    },
    saveSettings() {
      uni.showLoading({ title: '保存中...' })
      setTimeout(() => {
        uni.hideLoading()
        uni.showToast({
          title: '设置已保存',
          icon: 'success'
        })
      }, 800)
    }
  }
}
</script>

<style lang="scss" scoped>
.console-container {
  min-height: 100vh;
  padding: 16px;
}

.console-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(20px);
  border-radius: 16px;
  margin-bottom: 16px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  
  .header-left {
    display: flex;
    align-items: center;
    gap: 12px;
    
    .device-indicator {
      width: 48px;
      height: 48px;
      border-radius: 16px;
      background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
      display: flex;
      align-items: center;
      justify-content: center;
      
      &.online {
        background: linear-gradient(135deg, rgba(16, 185, 129, 0.1) 0%, rgba(52, 211, 153, 0.1) 100%);
        
        .indicator-dot {
          background: #10b981;
          box-shadow: 0 0 12px rgba(16, 185, 129, 0.5);
        }
      }
      
      &.offline {
        .indicator-dot {
          background: #9ca3af;
        }
      }
      
      .indicator-dot {
        width: 16px;
        height: 16px;
        border-radius: 50%;
        transition: all 0.3s ease;
      }
    }
    
    .device-info {
      display: flex;
      flex-direction: column;
      gap: 2px;
      
      .device-name {
        font-size: 16px;
        font-weight: 600;
        color: #1f2937;
      }
      
      .device-status-text {
        font-size: 12px;
        color: #6b7280;
      }
    }
  }
  
  .battery-info {
    display: flex;
    align-items: center;
    gap: 6px;
    
    .battery-icon {
      font-size: 20px;
    }
    
    .battery-text {
      font-size: 14px;
      font-weight: 600;
      color: #1f2937;
    }
  }
}

.console-content {
  display: flex;
  gap: 16px;
  
  @media (max-width: 900px) {
    flex-direction: column;
  }
}

.left-panel {
  width: 320px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  gap: 16px;
  
  @media (max-width: 900px) {
    width: 100%;
  }
}

.right-panel {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.joystick-section,
.voice-section,
.mode-section,
.care-section {
  padding: 20px;
  
  .section-title {
    display: block;
    font-size: 14px;
    font-weight: 600;
    color: #374151;
    margin-bottom: 16px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }
}

.joystick-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  
  .joystick-base {
    width: 200px;
    height: 200px;
    position: relative;
    margin-bottom: 16px;
    
    .joystick-btn {
      position: absolute;
      width: 56px;
      height: 56px;
      background: linear-gradient(145deg, #ffffff 0%, #f3f4f6 100%);
      border-radius: 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 4px 4px 12px rgba(0, 0, 0, 0.1), -2px -2px 8px rgba(255, 255, 255, 0.9);
      transition: all 0.15s ease;
      cursor: pointer;
      
      &.active {
        box-shadow: inset 2px 2px 6px rgba(0, 0, 0, 0.1), inset -2px -2px 6px rgba(255, 255, 255, 0.9);
        transform: scale(0.95);
        
        .btn-icon {
          color: #2563eb;
        }
      }
      
      .btn-icon {
        font-size: 24px;
        font-weight: bold;
        color: #6b7280;
      }
      
      &.up {
        top: 0;
        left: 50%;
        transform: translateX(-50%);
      }
      
      &.down {
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
      }
      
      &.left {
        left: 0;
        top: 50%;
        transform: translateY(-50%);
      }
      
      &.right {
        right: 0;
        top: 50%;
        transform: translateY(-50%);
      }
    }
    
    .joystick-center {
      position: absolute;
      width: 64px;
      height: 64px;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      background: linear-gradient(145deg, #f9fafb 0%, #e5e7eb 100%);
      border-radius: 20px;
      box-shadow: inset 3px 3px 8px rgba(0, 0, 0, 0.08), inset -3px -3px 8px rgba(255, 255, 255, 0.9);
    }
  }
  
  .joystick-hint {
    font-size: 12px;
    color: #9ca3af;
  }
}

.voice-preview {
  background: linear-gradient(135deg, rgba(37, 99, 235, 0.05) 0%, rgba(96, 165, 250, 0.05) 100%);
  border-radius: 16px;
  padding: 16px;
  margin-bottom: 20px;
  
  .voice-wave {
    display: flex;
    align-items: flex-end;
    justify-content: center;
    gap: 4px;
    height: 60px;
    margin-bottom: 12px;
    
    .wave-bar {
      width: 4px;
      background: linear-gradient(180deg, #2563eb 0%, #60a5fa 100%);
      border-radius: 4px;
      transition: height 0.15s ease;
    }
  }
  
  .voice-info {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 4px;
    
    .voice-name {
      font-size: 16px;
      font-weight: 600;
      color: #1f2937;
    }
    
    .voice-desc {
      font-size: 12px;
      color: #6b7280;
    }
  }
}

.slider-group {
  display: flex;
  flex-direction: column;
  gap: 20px;
  margin-bottom: 20px;
  
  .slider-item {
    .slider-label {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
      
      .label-text {
        font-size: 13px;
        color: #374151;
        font-weight: 500;
      }
      
      .label-value {
        font-size: 13px;
        color: #2563eb;
        font-weight: 600;
      }
    }
    
    .slider-track {
      position: relative;
      height: 8px;
      background: #e5e7eb;
      border-radius: 8px;
      
      .slider-fill {
        position: absolute;
        top: 0;
        left: 0;
        height: 100%;
        background: linear-gradient(90deg, #2563eb 0%, #60a5fa 100%);
        border-radius: 8px;
        transition: width 0.1s ease;
      }
      
      .slider-thumb {
        position: absolute;
        top: 50%;
        width: 24px;
        height: 24px;
        background: #ffffff;
        border-radius: 50%;
        transform: translate(-50%, -50%);
        box-shadow: 0 2px 8px rgba(37, 99, 235, 0.3);
        border: 2px solid #2563eb;
        transition: left 0.1s ease;
      }
    }
  }
}

.play-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 14px;
  background: linear-gradient(135deg, #2563eb 0%, #60a5fa 100%);
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
  
  &:active {
    transform: scale(0.98);
  }
  
  .play-icon {
    font-size: 18px;
  }
  
  .play-text {
    font-size: 14px;
    font-weight: 600;
    color: #ffffff;
  }
}

.mode-switch {
  display: flex;
  background: #f3f4f6;
  border-radius: 12px;
  padding: 4px;
  margin-bottom: 12px;
  
  .mode-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 6px;
    padding: 12px 8px;
    border-radius: 10px;
    cursor: pointer;
    transition: all 0.3s ease;
    
    &.active {
      background: #ffffff;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
      
      .mode-label {
        color: #2563eb;
        font-weight: 600;
      }
    }
    
    .mode-icon {
      font-size: 20px;
    }
    
    .mode-label {
      font-size: 12px;
      color: #6b7280;
    }
  }
}

.mode-desc {
  font-size: 13px;
  color: #6b7280;
  line-height: 1.6;
  padding: 12px;
  background: rgba(37, 99, 235, 0.05);
  border-radius: 10px;
}

.care-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
  
  .care-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 14px;
    background: #f9fafb;
    border-radius: 12px;
    transition: all 0.3s ease;
    
    .care-info {
      display: flex;
      align-items: center;
      gap: 12px;
      
      .care-icon {
        width: 44px;
        height: 44px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        
        .icon-text {
          font-size: 20px;
        }
      }
      
      .care-text {
        display: flex;
        flex-direction: column;
        gap: 2px;
        
        .care-title {
          font-size: 14px;
          font-weight: 500;
          color: #1f2937;
        }
        
        .care-desc {
          font-size: 12px;
          color: #9ca3af;
        }
      }
    }
    
    .care-toggle {
      width: 48px;
      height: 28px;
      background: #e5e7eb;
      border-radius: 14px;
      position: relative;
      cursor: pointer;
      transition: all 0.3s ease;
      
      &.active {
        background: linear-gradient(90deg, #2563eb 0%, #60a5fa 100%);
        
        .toggle-knob {
          left: 24px;
        }
      }
      
      .toggle-knob {
        position: absolute;
        top: 3px;
        left: 3px;
        width: 22px;
        height: 22px;
        background: #ffffff;
        border-radius: 50%;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.15);
        transition: all 0.3s ease;
      }
    }
  }
}

.action-buttons {
  display: flex;
  gap: 12px;
  
  .action-btn {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 16px;
    border-radius: 14px;
    cursor: pointer;
    transition: all 0.3s ease;
    
    &:active {
      transform: scale(0.98);
    }
    
    &.secondary {
      background: #ffffff;
      border: 1px solid #e5e7eb;
      
      .btn-text {
        color: #374151;
      }
    }
    
    &.primary {
      background: linear-gradient(135deg, #10b981 0%, #34d399 100%);
      box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
      
      .btn-text {
        color: #ffffff;
        font-weight: 600;
      }
    }
    
    .btn-icon {
      font-size: 18px;
    }
    
    .btn-text {
      font-size: 14px;
    }
  }
}
</style>
