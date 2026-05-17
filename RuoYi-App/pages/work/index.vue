<template>
  <view class="work-container">
    <!-- 轮播图 -->
    <uni-swiper-dot class="uni-swiper-dot-box" :info="data" :current="current" field="content">
      <swiper class="swiper-box" :current="swiperDotIndex" @change="changeSwiper">
        <swiper-item v-for="(item, index) in data" :key="index">
          <view class="swiper-item" @click="clickBannerItem(item)">
            <image :src="item.image" mode="aspectFill" :draggable="false" />
          </view>
        </swiper-item>
      </swiper>
    </uni-swiper-dot>

    <!-- 企业报表卡片 -->
    <view class="enterprise-card card-glass" @click="navigateToEnterpriseReport">
      <view class="enterprise-card-left">
        <view class="enterprise-icon">
          <text class="icon-text">📊</text>
        </view>
        <view class="enterprise-info">
          <text class="enterprise-title">团队健康报表</text>
          <text class="enterprise-desc">HR 数据看板 & 关怀下发</text>
        </view>
      </view>
      <view class="enterprise-arrow">
        <text class="arrow">→</text>
      </view>
    </view>

    <!-- 记忆时光卡片 -->
    <view class="memory-card card-glass" @click="navigateToMemoryTimeline">
      <view class="memory-card-left">
        <view class="memory-icon">
          <text class="icon-text">📝</text>
        </view>
        <view class="memory-info">
          <text class="memory-title">记忆时光</text>
          <text class="memory-desc">回顾温暖的陪伴记忆</text>
        </view>
      </view>
      <view class="memory-arrow">
        <text class="arrow">→</text>
      </view>
    </view>

    <!-- 设备控制卡片 -->
    <view class="device-card card-glass" @click="navigateToDeviceConsole">
      <view class="device-card-left">
        <view class="device-icon">
          <text class="icon-text">🎮</text>
        </view>
        <view class="device-info">
          <text class="device-title">设备控制台</text>
          <text class="device-desc">控制工位搭子云台、设置模式</text>
        </view>
      </view>
      <view class="device-arrow">
        <text class="arrow">→</text>
      </view>
    </view>

    <!-- 宫格组件 -->
    <uni-section title="系统管理" type="line"></uni-section>
    <view class="grid-body">
      <uni-grid :column="4" :showBorder="false" @change="changeGrid">
        <uni-grid-item>
          <view class="grid-item-box" @click="navigateToUserManagement">
            <uni-icons type="person-filled" size="30"></uni-icons>
            <text class="text">用户管理</text>
          </view>
        </uni-grid-item>
        <uni-grid-item>
          <view class="grid-item-box" @click="navigateToRoleManagement">
            <uni-icons type="staff-filled" size="30"></uni-icons>
            <text class="text">角色管理</text>
          </view>
        </uni-grid-item>
        <uni-grid-item>
          <view class="grid-item-box" @click="navigateToMenuManagement">
            <uni-icons type="color" size="30"></uni-icons>
            <text class="text">菜单管理</text>
          </view>
        </uni-grid-item>
        <uni-grid-item>
          <view class="grid-item-box" @click="navigateToDeptManagement">
            <uni-icons type="settings-filled" size="30"></uni-icons>
            <text class="text">部门管理</text>
          </view>
        </uni-grid-item>
        <uni-grid-item>
          <view class="grid-item-box" @click="navigateToPostManagement">
            <uni-icons type="heart-filled" size="30"></uni-icons>
            <text class="text">岗位管理</text>
          </view>
        </uni-grid-item>
        <uni-grid-item>
          <view class="grid-item-box" @click="navigateToDictManagement">
            <uni-icons type="bars" size="30"></uni-icons>
            <text class="text">字典管理</text>
          </view>
        </uni-grid-item>
        <uni-grid-item>
          <view class="grid-item-box" @click="navigateToConfigManagement">
            <uni-icons type="gear-filled" size="30"></uni-icons>
            <text class="text">参数设置</text>
          </view>
        </uni-grid-item>
        <uni-grid-item>
          <view class="grid-item-box" @click="navigateToNoticeManagement">
            <uni-icons type="chat-filled" size="30"></uni-icons>
            <text class="text">通知公告</text>
          </view>
        </uni-grid-item>
        <uni-grid-item>
          <view class="grid-item-box" @click="navigateToLogManagement">
            <uni-icons type="wallet-filled" size="30"></uni-icons>
            <text class="text">日志管理</text>
          </view>
        </uni-grid-item>
      </uni-grid>
    </view>
  </view>
</template>

<script>
import { listUser } from '@/api/user'

export default {
  data() {
    return {
      current: 0,
      swiperDotIndex: 0,
      data: [{
          image: '/static/images/banner/banner01.jpg'
        },
        {
          image: '/static/images/banner/banner02.jpg'
        },
        {
          image: '/static/images/banner/banner03.jpg'
        }
      ]
    }
  },
  methods: {
    clickBannerItem(item) {
      console.info(item)
    },
    changeSwiper(e) {
      this.current = e.detail.current
    },
    navigateToEnterpriseReport() {
      uni.navigateTo({
        url: '/pages/enterprise/report'
      })
    },
    navigateToMemoryTimeline() {
      uni.navigateTo({
        url: '/pages/memory/timeline'
      })
    },
    navigateToDeviceConsole() {
      uni.navigateTo({
        url: '/pages/device/console'
      })
    },
    navigateToUserManagement() {
      uni.navigateTo({
        url: '/pages/system/user/index'
      })
    },
    navigateToRoleManagement() {
      uni.navigateTo({
        url: '/pages/system/role/index'
      })
    },
    navigateToMenuManagement() {
      uni.navigateTo({
        url: '/pages/system/menu/index'
      })
    },
    navigateToDeptManagement() {
      uni.navigateTo({
        url: '/pages/system/dept/index'
      })
    },
    navigateToPostManagement() {
      uni.navigateTo({
        url: '/pages/system/post/index'
      })
    },
    navigateToDictManagement() {
      uni.navigateTo({
        url: '/pages/system/dict/index'
      })
    },
    navigateToConfigManagement() {
      uni.navigateTo({
        url: '/pages/system/config/index'  // 正确路径
      })
    },
    navigateToNoticeManagement() {
      uni.navigateTo({
        url: '/pages/system/notice/index'
      })
    },
    navigateToLogManagement() {
      uni.navigateTo({
        url: '/pages/system/log/index'
      })
    },
    changeGrid(e) {
      const index = e.detail.index
      if(index === 0) { // 用户管理
        this.navigateToUserManagement()
      } else if(index === 1) { // 角色管理
        this.navigateToRoleManagement()
      } else if(index === 2) { // 菜单管理
        this.navigateToMenuManagement()
      } else if(index === 3) { // 部门管理
        this.navigateToDeptManagement()
      } else if(index === 4) { // 岗位管理
        this.navigateToPostManagement()
      } else if(index === 5) { // 字典管理
        this.navigateToDictManagement()
      } else if(index === 6) { // 参数设置
        this.navigateToConfigManagement()
      } else if(index === 7) { // 通知公告
        this.navigateToNoticeManagement()
      } else if(index === 8) { // 日志管理
        this.navigateToLogManagement()
      } else {
        this.$modal.showToast('模块建设中~')
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  /* #ifndef APP-NVUE */
  page {
    display: flex;
    flex-direction: column;
    box-sizing: border-box;
    background-color: #fff;
    min-height: 100%;
    height: auto;
  }

  view {
    font-size: 14px;
    line-height: inherit;
  }
  /* #endif */

  .text {
    text-align: center;
    font-size: 26rpx;
    margin-top: 10rpx;
  }

  .enterprise-card {
    margin: 16px;
    padding: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
    transition: all 0.3s ease;
    
    &:active {
      transform: scale(0.98);
    }
    
    .enterprise-card-left {
      display: flex;
      align-items: center;
      gap: 12px;
      
      .enterprise-icon {
        width: 48px;
        height: 48px;
        background: linear-gradient(135deg, #1f2937 0%, #374151 100%);
        border-radius: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        
        .icon-text {
          font-size: 24px;
        }
      }
      
      .enterprise-info {
        display: flex;
        flex-direction: column;
        gap: 4px;
        
        .enterprise-title {
          font-size: 16px;
          font-weight: 600;
          color: #1f2937;
        }
        
        .enterprise-desc {
          font-size: 13px;
          color: #6b7280;
        }
      }
    }
    
    .enterprise-arrow {
      .arrow {
        font-size: 20px;
        color: #9ca3af;
      }
    }
  }

  .memory-card {
    margin: 16px;
    padding: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
    transition: all 0.3s ease;
    
    &:active {
      transform: scale(0.98);
    }
    
    .memory-card-left {
      display: flex;
      align-items: center;
      gap: 12px;
      
      .memory-icon {
        width: 48px;
        height: 48px;
        background: linear-gradient(135deg, #8b5cf6 0%, #a78bfa 100%);
        border-radius: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        
        .icon-text {
          font-size: 24px;
        }
      }
      
      .memory-info {
        display: flex;
        flex-direction: column;
        gap: 4px;
        
        .memory-title {
          font-size: 16px;
          font-weight: 600;
          color: #1f2937;
        }
        
        .memory-desc {
          font-size: 13px;
          color: #6b7280;
        }
      }
    }
    
    .memory-arrow {
      .arrow {
        font-size: 20px;
        color: #9ca3af;
      }
    }
  }

  .device-card {
    
    &:active {
      transform: scale(0.98);
    }
    
    .device-card-left {
      display: flex;
      align-items: center;
      gap: 12px;
      
      .device-icon {
        width: 48px;
        height: 48px;
        background: linear-gradient(135deg, #2563eb 0%, #60a5fa 100%);
        border-radius: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        
        .icon-text {
          font-size: 24px;
        }
      }
      
      .device-info {
        display: flex;
        flex-direction: column;
        gap: 4px;
        
        .device-title {
          font-size: 16px;
          font-weight: 600;
          color: #1f2937;
        }
        
        .device-desc {
          font-size: 13px;
          color: #6b7280;
        }
      }
    }
    
    .device-arrow {
      .arrow {
        font-size: 20px;
        color: #9ca3af;
      }
    }
  }

  .grid-item-box {
    flex: 1;
    /* #ifndef APP-NVUE */
    display: flex;
    /* #endif */
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 15px 0;
  }

  .uni-margin-wrap {
    width: 690rpx;
    width: 100%;
    ;
  }

  .swiper {
    height: 300rpx;
  }

  .swiper-box {
    height: 150px;
  }

  .swiper-item {
    /* #ifndef APP-NVUE */
    display: flex;
    /* #endif */
    flex-direction: column;
    justify-content: center;
    align-items: center;
    color: #fff;
    height: 300rpx;
    line-height: 300rpx;
  }

  @media screen and (min-width: 500px) {
    .uni-swiper-dot-box {
      width: 400px;
      /* #ifndef APP-NVUE */
      margin: 0 auto;
      /* #endif */
      margin-top: 8px;
    }

    .image {
      width: 100%;
    }
  }
</style>
