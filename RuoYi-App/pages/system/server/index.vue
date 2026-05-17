<template>
  <view class="container">
    <uni-card title="服务器信息">
      <uni-list>
        <uni-list-item title="服务器名称" :rightText="serverInfo.name" />
        <uni-list-item title="操作系统" :rightText="serverInfo.os" />
        <uni-list-item title="系统架构" :rightText="serverInfo.arch" />
      </uni-list>
    </uni-card>

    <uni-card title="CPU信息">
      <uni-list>
        <uni-list-item title="核心数" :rightText="cpuInfo.cpuNum" />
        <uni-list-item title="使用率" :rightText="cpuInfo.used + '%'" />
      </uni-list>
    </uni-card>

    <uni-card title="内存信息">
      <uni-list>
        <uni-list-item title="总内存" :rightText="memInfo.total + 'MB'" />
        <uni-list-item title="已用内存" :rightText="memInfo.used + 'MB'" />
        <uni-list-item title="使用率" :rightText="memInfo.usage + '%'" />
      </uni-list>
    </uni-card>
  </view>
</template>

<script>
import { getServerInfo } from '@/api/monitor/server'

export default {
  data() {
    return {
      serverInfo: {},
      cpuInfo: {},
      memInfo: {},
      jvmInfo: {}
    }
  },
  onLoad() {
    this.getInfo()
  },
  methods: {
    getInfo() {
      getServerInfo().then(response => {
        this.serverInfo = response.data.server
        this.cpuInfo = response.data.cpu
        this.memInfo = response.data.mem
        this.jvmInfo = response.data.jvm
      })
    }
  }
}
</script>