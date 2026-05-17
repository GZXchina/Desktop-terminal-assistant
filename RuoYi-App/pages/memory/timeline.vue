<template>
  <view class="timeline-container page-bg">
    <view class="timeline-header">
      <view class="header-title">
        <text class="title-text">记忆时光</text>
        <text class="subtitle-text">保存每一个温暖的瞬间</text>
      </view>
      <view class="search-box">
        <text class="search-icon">🔍</text>
        <input class="search-input" 
               v-model="searchKeyword"
               placeholder="想找回哪段温暖的记忆？"
               placeholder-class="search-placeholder"
               @confirm="doSearch" />
        <view v-if="searchKeyword" class="clear-btn" @click="clearSearch">
          <text class="clear-icon">✕</text>
        </view>
      </view>
    </view>

    <view class="timeline-content">
      <view class="timeline-line"></view>
      
      <view v-for="(item, index) in filteredMemories" :key="item.id" 
            class="memory-item"
            :class="{ 'shredding': shreddingId === item.id }"
            ref="memoryItems">
        <view class="memory-dot">
          <view class="dot-inner"></view>
        </view>
        
        <view class="memory-card" :class="{ 'card-shred': shreddingId === item.id }">
          <view class="card-header">
            <view class="card-type" :class="item.type">
              <text class="type-icon">{{ item.typeIcon }}</text>
              <text class="type-text">{{ item.typeText }}</text>
            </view>
            <text class="card-date">{{ item.dateText }}</text>
          </view>
          
          <view class="card-content">
            <text class="card-title">{{ item.title }}</text>
            <text class="card-text">{{ item.content }}</text>
          </view>
          
          <view class="card-tags">
            <view class="tag-item env-tag">
              <text class="tag-label">环境</text>
              <text class="tag-value">{{ item.environment }}</text>
            </view>
            <view class="tag-item bio-tag">
              <text class="tag-label">体征</text>
              <text class="tag-value">{{ item.biometrics }}</text>
            </view>
            <view class="tag-item time-tag">
              <text class="tag-label">时间</text>
              <text class="tag-value">{{ item.timePeriod }}</text>
            </view>
            <view class="tag-item semantic-tag">
              <text class="tag-label">语义</text>
              <text class="tag-value">{{ item.semantic }}</text>
            </view>
          </view>
          
          <view class="card-footer">
            <view class="footer-left">
              <text class="mood-text">{{ item.mood }}</text>
            </view>
            <view class="footer-right">
              <view class="action-btn view-btn" @click="viewMemory(item)">
                <text class="btn-text">查看</text>
              </view>
              <view class="action-btn shred-btn" @click="shredMemory(item, index)">
                <text class="btn-text">粉碎</text>
              </view>
            </view>
          </view>
        </view>
      </view>
    </view>

    <view v-if="shreddingId" class="shred-particles">
      <view v-for="i in 20" :key="i" 
            class="particle"
            :style="getParticleStyle(i)">
      </view>
    </view>

    <view v-if="filteredMemories.length === 0" class="empty-state">
      <text class="empty-icon">📝</text>
      <text class="empty-text">还没有记忆哦</text>
      <text class="empty-subtext">AI 伙伴正在记录你的每一天~</text>
    </view>
  </view>
</template>

<script>
import { getMemoryList, searchMemory, deleteMemory } from '@/api/memory'

export default {
  data() {
    return {
      searchKeyword: '',
      memories: [],
      shreddingId: null,
      shreddingIndex: -1,
      particles: []
    }
  },
  computed: {
    filteredMemories() {
      if (!this.searchKeyword) {
        return this.memories
      }
      const keyword = this.searchKeyword.toLowerCase()
      return this.memories.filter(item => 
        item.title.toLowerCase().includes(keyword) ||
        item.content.toLowerCase().includes(keyword) ||
        item.environment.toLowerCase().includes(keyword) ||
        item.semantic.toLowerCase().includes(keyword)
      )
    }
  },
  onLoad() {
    this.loadMockMemories()
  },
  methods: {
    loadMockMemories() {
      this.memories = [
        {
          id: 1,
          type: 'weekly',
          typeIcon: '📊',
          typeText: '陪伴周报',
          dateText: '2026年5月第1周',
          title: '高效工作周',
          content: '这一周你专注度很高，平均每天专注时长达到5.5小时。AI 伙伴为你感到骄傲！周三下午我们一起完成了那个重要的项目汇报，你的状态特别好~',
          environment: '办公室 · 靠窗位置',
          biometrics: '心率 68-75bpm',
          timePeriod: '工作日 9:00-18:00',
          semantic: '工作 · 专注 · 成就感',
          mood: '😊 开心'
        },
        {
          id: 2,
          type: 'essay',
          typeIcon: '💭',
          typeText: '心情随笔',
          dateText: '5月2日 20:30',
          title: '傍晚的咖啡时光',
          content: '今天傍晚你坐在窗边喝咖啡，看着夕阳西下。你说最近压力有点大，但看到晚霞的那一刻，感觉一切都值得了。AI 伙伴想告诉你：你已经很棒了，累了就休息一下~',
          environment: '家中 · 客厅窗边',
          biometrics: '放松状态',
          timePeriod: '傍晚 20:00-21:00',
          semantic: '放松 · 治愈 · 感悟',
          mood: '☕ 宁静'
        },
        {
          id: 3,
          type: 'weekly',
          typeIcon: '📊',
          typeText: '陪伴周报',
          dateText: '2026年4月第4周',
          title: '调整状态周',
          content: '这一周你有意识地调整作息，每天晚上11点前就休息了。虽然工作量没有减少，但你的精神状态明显好了很多。继续保持哦！',
          environment: '办公室 + 家中',
          biometrics: '睡眠质量改善',
          timePeriod: '全周',
          semantic: '健康 · 自律 · 调整',
          mood: '💪 加油'
        },
        {
          id: 4,
          type: 'essay',
          typeIcon: '💭',
          typeText: '心情随笔',
          dateText: '4月25日 14:15',
          title: '和同事的愉快交流',
          content: '今天中午和同事一起吃饭，聊得很开心。你说好久没有这么轻松地聊天了。人际关系也是工作的一部分呢，AI 伙伴很高兴看到你这么开心~',
          environment: '公司餐厅',
          biometrics: '心情愉悦',
          timePeriod: '午休时间',
          semantic: '社交 · 开心 · 团队',
          mood: '🎉 愉快'
        },
        {
          id: 5,
          type: 'essay',
          typeIcon: '💭',
          typeText: '心情随笔',
          dateText: '4月18日 09:00',
          title: '周一的清晨',
          content: '今早你来得特别早，办公室还没有人。你给自己泡了一杯茶，静静地坐了一会儿。你说喜欢这种宁静的感觉，可以好好规划一天的工作。',
          environment: '办公室 · 清晨',
          biometrics: '平静',
          timePeriod: '早晨 8:30-9:00',
          semantic: '宁静 · 规划 · 新开始',
          mood: '🌅 期待'
        }
      ]
    },
    doSearch() {
      if (this.searchKeyword) {
        console.log('搜索关键词:', this.searchKeyword)
      }
    },
    clearSearch() {
      this.searchKeyword = ''
    },
    viewMemory(item) {
      uni.showToast({
        title: '查看记忆: ' + item.title,
        icon: 'none'
      })
    },
    shredMemory(item, index) {
      uni.showModal({
        title: '确认粉碎',
        content: '确定要粉碎这段记忆吗？此操作无法恢复。',
        confirmText: '粉碎',
        confirmColor: '#ef4444',
        success: (res) => {
          if (res.confirm) {
            this.shreddingId = item.id
            this.shreddingIndex = index
            this.createParticles()
            
            setTimeout(() => {
              this.memories = this.memories.filter(m => m.id !== item.id)
              this.shreddingId = null
              this.shreddingIndex = -1
              this.particles = []
              uni.showToast({
                title: '记忆已粉碎',
                icon: 'success'
              })
            }, 800)
          }
        }
      })
    },
    createParticles() {
      this.particles = []
    },
    getParticleStyle(i) {
      const angle = Math.random() * 360
      const distance = 50 + Math.random() * 100
      const x = Math.cos(angle * Math.PI / 180) * distance
      const y = Math.sin(angle * Math.PI / 180) * distance
      const rotation = Math.random() * 720
      const delay = Math.random() * 0.3
      
      return {
        left: '50%',
        top: '50%',
        transform: `translate(-50%, -50%) translate(${x}px, ${y}px) rotate(${rotation}deg)`,
        opacity: 0,
        transition: `all 0.6s ease ${delay}s`,
        width: (10 + Math.random() * 20) + 'px',
        height: (10 + Math.random() * 20) + 'px',
        background: `hsl(${Math.random() * 60 + 200}, 70%, 70%)`
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.timeline-container {
  min-height: 100vh;
  padding: 16px;
  position: relative;
}

.timeline-header {
  margin-bottom: 24px;
  
  .header-title {
    margin-bottom: 16px;
    
    .title-text {
      display: block;
      font-size: 28px;
      font-weight: 700;
      color: #1f2937;
      margin-bottom: 4px;
      background: linear-gradient(135deg, #2563eb 0%, #60a5fa 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }
    
    .subtitle-text {
      font-size: 14px;
      color: #6b7280;
    }
  }
  
  .search-box {
    position: relative;
    display: flex;
    align-items: center;
    padding: 14px 18px;
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(20px);
    border-radius: 16px;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    
    .search-icon {
      font-size: 18px;
      margin-right: 10px;
    }
    
    .search-input {
      flex: 1;
      font-size: 15px;
      color: #1f2937;
    }
    
    .search-placeholder {
      color: #9ca3af;
    }
    
    .clear-btn {
      width: 24px;
      height: 24px;
      display: flex;
      align-items: center;
      justify-content: center;
      background: #e5e7eb;
      border-radius: 50%;
      
      .clear-icon {
        font-size: 12px;
        color: #6b7280;
        font-weight: bold;
      }
    }
  }
}

.timeline-content {
  position: relative;
  padding-left: 30px;
}

.timeline-line {
  position: absolute;
  left: 14px;
  top: 8px;
  bottom: 8px;
  width: 2px;
  background: linear-gradient(180deg, #2563eb 0%, #e5e7eb 100%);
}

.memory-item {
  position: relative;
  margin-bottom: 24px;
  opacity: 1;
  transform: translateY(0);
  transition: all 0.5s ease;
  
  &.shredding {
    opacity: 0;
    transform: scale(0.8) translateY(20px);
  }
  
  .memory-dot {
    position: absolute;
    left: -30px;
    top: 20px;
    width: 32px;
    height: 32px;
    background: #ffffff;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
    z-index: 2;
    
    .dot-inner {
      width: 16px;
      height: 16px;
      background: linear-gradient(135deg, #2563eb 0%, #60a5fa 100%);
      border-radius: 50%;
    }
  }
}

.memory-card {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
  
  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(90deg, #2563eb 0%, #60a5fa 50%, #10b981 100%);
    opacity: 0.6;
  }
  
  &.card-shred {
    animation: shake 0.3s ease;
  }
  
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
    
    .card-type {
      display: flex;
      align-items: center;
      gap: 6px;
      padding: 6px 12px;
      border-radius: 10px;
      font-size: 12px;
      font-weight: 500;
      
      &.weekly {
        background: linear-gradient(135deg, rgba(37, 99, 235, 0.1) 0%, rgba(96, 165, 250, 0.1) 100%);
        
        .type-text {
          color: #2563eb;
        }
      }
      
      &.essay {
        background: linear-gradient(135deg, rgba(16, 185, 129, 0.1) 0%, rgba(52, 211, 153, 0.1) 100%);
        
        .type-text {
          color: #10b981;
        }
      }
      
      .type-icon {
        font-size: 14px;
      }
    }
    
    .card-date {
      font-size: 13px;
      color: #9ca3af;
    }
  }
  
  .card-content {
    margin-bottom: 16px;
    
    .card-title {
      display: block;
      font-size: 18px;
      font-weight: 600;
      color: #1f2937;
      margin-bottom: 8px;
    }
    
    .card-text {
      font-size: 14px;
      color: #4b5563;
      line-height: 1.7;
    }
  }
  
  .card-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-bottom: 16px;
    
    .tag-item {
      display: flex;
      align-items: center;
      gap: 4px;
      padding: 6px 10px;
      border-radius: 8px;
      font-size: 11px;
      
      .tag-label {
        font-weight: 500;
      }
      
      .tag-value {
        color: #6b7280;
      }
      
      &.env-tag {
        background: rgba(59, 130, 246, 0.08);
        
        .tag-label {
          color: #2563eb;
        }
      }
      
      &.bio-tag {
        background: rgba(16, 185, 129, 0.08);
        
        .tag-label {
          color: #10b981;
        }
      }
      
      &.time-tag {
        background: rgba(245, 158, 11, 0.08);
        
        .tag-label {
          color: #f59e0b;
        }
      }
      
      &.semantic-tag {
        background: rgba(139, 92, 246, 0.08);
        
        .tag-label {
          color: #8b5cf6;
        }
      }
    }
  }
  
  .card-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-top: 12px;
    border-top: 1px solid #f3f4f6;
    
    .footer-left {
      .mood-text {
        font-size: 14px;
        color: #6b7280;
      }
    }
    
    .footer-right {
      display: flex;
      gap: 8px;
      
      .action-btn {
        padding: 8px 16px;
        border-radius: 10px;
        font-size: 13px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s ease;
        
        &:active {
          transform: scale(0.96);
        }
        
        &.view-btn {
          background: #f3f4f6;
          color: #374151;
        }
        
        &.shred-btn {
          background: rgba(239, 68, 68, 0.1);
          color: #ef4444;
        }
      }
    }
  }
}

.shred-particles {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
  z-index: 100;
  
  .particle {
    position: absolute;
    border-radius: 2px;
  }
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 60px 20px;
  
  .empty-icon {
    font-size: 64px;
    margin-bottom: 16px;
  }
  
  .empty-text {
    font-size: 18px;
    font-weight: 500;
    color: #374151;
    margin-bottom: 4px;
  }
  
  .empty-subtext {
    font-size: 14px;
    color: #9ca3af;
  }
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-5px); }
  75% { transform: translateX(5px); }
}
</style>
