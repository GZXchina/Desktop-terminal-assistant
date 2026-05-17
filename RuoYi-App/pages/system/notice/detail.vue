<template>
  <view class="container">
    <view class="notice-title">{{ notice.noticeTitle }}</view>
    <view class="notice-meta">
      <text>类型: {{ notice.noticeType === '1' ? '通知' : '公告' }}</text>
      <text>状态: {{ notice.status === '0' ? '正常' : '停用' }}</text>
      <text>创建者: {{ notice.createBy }}</text>
      <text>创建时间: {{ notice.createTime }}</text>
    </view>
    <rich-text 
      class="notice-content" 
      :nodes="notice.noticeContent"
    ></rich-text>
  </view>
</template>

<script>
import { getNotice } from '@/api/system/notice'

export default {
  data() {
    return {
      notice: {}
    }
  },
  onLoad(options) {
    if (options.noticeId) {
      this.getNotice(options.noticeId)
    }
  },
  methods: {
    getNotice(noticeId) {
      getNotice(noticeId).then(response => {
        this.notice = response.data
      })
    }
  }
}
</script>

<style lang="scss">
.container {
  padding: 15px;
}
.notice-title {
  font-size: 18px;
  font-weight: bold;
  margin-bottom: 10px;
}
.notice-meta {
  display: flex;
  flex-direction: column;
  margin-bottom: 15px;
  color: #666;
  font-size: 14px;
}
.notice-content {
  line-height: 1.6;
  img {
    max-width: 100%;
  }
}
</style>