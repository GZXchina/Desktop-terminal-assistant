<template>
  <view class="container">
    <uni-card>
      <uni-list>
        <uni-list-item title="参数名称" :rightText="form.configName" />
        <uni-list-item title="参数键名" :rightText="form.configKey" />
        <uni-list-item title="参数键值" :rightText="form.configValue" />
        <uni-list-item title="系统内置" :rightText="form.configType === 'Y' ? '是' : '否'" />
        <uni-list-item title="备注" :rightText="form.remark" />
      </uni-list>
    </uni-card>
  </view>
</template>

<script>
import { getConfig } from '@/api/system/config'

export default {
  data() {
    return {
      form: {}
    }
  },
  onLoad(options) {
    getConfig(options.id).then(response => {
      this.form = response.data
    })
  }
}
</script>

<style>
.container {
  padding: 15px;
}
</style>