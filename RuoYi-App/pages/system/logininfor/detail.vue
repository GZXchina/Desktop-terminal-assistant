<template>
  <view class="container">
    <uni-card title="登录日志详情">
      <uni-list>
        <uni-list-item title="用户名称" :rightText="info.userName" />
        <uni-list-item title="登录地址" :rightText="info.ipaddr" />
        <uni-list-item title="登录地点" :rightText="info.loginLocation" />
        <uni-list-item title="浏览器" :rightText="info.browser" />
        <uni-list-item title="操作系统" :rightText="info.os" />
        <uni-list-item title="登录状态" :rightText="info.status === '0' ? '成功' : '失败'" />
        <uni-list-item title="操作信息" :rightText="info.msg" />
        <uni-list-item title="登录时间" :rightText="parseTime(info.loginTime)" />
      </uni-list>
    </uni-card>
  </view>
</template>

<script>
import { getLogininfor } from '@/api/monitor/logininfor'

export default {
  data() {
    return {
      info: {}
    }
  },
  onLoad(options) {
    if (options.id) {
      this.getInfo(options.id)
    }
  },
  methods: {
    getInfo(infoId) {
      getLogininfor(infoId).then(response => {
        this.info = response.data
      })
    },
    parseTime(time) {
      // 将"yyyy-MM-dd HH:mm:ss"转换为iOS兼容格式
      const formattedTime = time.replace(/-/g, '/')
      return new Date(formattedTime).toLocaleString()
    }
},
}
</script>

<style lang="scss">
.container {
  padding: 10px;
}
</style>