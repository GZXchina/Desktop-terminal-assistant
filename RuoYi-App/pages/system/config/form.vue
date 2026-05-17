<template>
  <view class="container">
    <uni-forms ref="form" :model="form" :rules="rules">
      <uni-forms-item label="参数名称" name="configName">
        <uni-easyinput v-model="form.configName" placeholder="请输入参数名称" />
      </uni-forms-item>
      <uni-forms-item label="参数键名" name="configKey">
        <uni-easyinput v-model="form.configKey" placeholder="请输入参数键名" />
      </uni-forms-item>
      <uni-forms-item label="参数键值" name="configValue">
        <uni-easyinput type="textarea" v-model="form.configValue" placeholder="请输入参数键值" />
      </uni-forms-item>
      <uni-forms-item label="系统内置" name="configType">
        <uni-data-checkbox v-model="form.configType" :localdata="configTypeOptions" />
      </uni-forms-item>
      <uni-forms-item label="备注" name="remark">
        <uni-easyinput type="textarea" v-model="form.remark" placeholder="请输入备注" />
      </uni-forms-item>
    </uni-forms>
    
    <view class="button-group">
      <button type="primary" @click="submitForm">提交</button>
      <button @click="cancel">取消</button>
    </view>
  </view>
</template>

<script>
import { getConfig, addConfig, updateConfig } from '@/api/system/config'

export default {
  data() {
    return {
      form: {
        configId: undefined,
        configName: '',
        configKey: '',
        configValue: '',
        configType: 'Y',
        remark: ''
      },
      configTypeOptions: [
        { value: 'Y', text: '是' },
        { value: 'N', text: '否' }
      ],
      rules: {
        configName: { rules: [{ required: true, errorMessage: '参数名称不能为空' }] },
        configKey: { rules: [{ required: true, errorMessage: '参数键名不能为空' }] },
        configValue: { rules: [{ required: true, errorMessage: '参数键值不能为空' }] }
      }
    }
  },
  onLoad(options) {
    if (options.id) {
      getConfig(options.id).then(response => {
        this.form = response.data
      })
    }
  },
  methods: {
    submitForm() {
      this.$refs.form.validate().then(valid => {
        if (valid) {
          if (this.form.configId) {
            updateConfig(this.form).then(() => {
              uni.showToast({ title: '修改成功' })
              uni.navigateBack()
            })
          } else {
            addConfig(this.form).then(() => {
              uni.showToast({ title: '新增成功' })
              uni.navigateBack()
            })
          }
        }
      })
    },
    cancel() {
      uni.navigateBack()
    }
  }
}
</script>

<style>
.container {
  padding: 15px;
}
.button-group {
  margin-top: 15px;
}
</style>