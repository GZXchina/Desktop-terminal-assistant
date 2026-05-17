<template>
  <view class="container">
    <uni-section title="缓存监控" type="line"></uni-section>
    
    <view class="card-container">
      <uni-card v-for="(item, index) in cacheList" :key="index" :title="item.cacheName">
        <view class="card-content">
          <text>备注: {{ item.remark }}</text>
          <button size="mini" type="warn" @click="handleClear(item)">清理</button>
        </view>
      </uni-card>
    </view>
  </view>
</template>

<script>
import { listCacheName, clearCacheName } from '@/api/monitor/cache'

export default {
  data() {
    return {
      cacheList: []
    }
  },
  onLoad() {
    this.getList()
  },
  methods: {
    getList() {
      listCacheName().then(response => {
        this.cacheList = response.data
      })
    },
    handleClear(item) {
      uni.showModal({
        title: '提示',
        content: `确认清理缓存[${item.cacheName}]吗？`,
        success: (res) => {
          if (res.confirm) {
            clearCacheName(item.cacheName).then(() => {
              uni.showToast({ title: '清理成功' })
              this.getList()
            })
          }
        }
      })
    }
  }
}
</script>

<style>
.container {
  padding: 15px;
}
.card-container {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.card-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>