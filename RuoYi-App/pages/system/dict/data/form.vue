<template>
  <view class="container">
    <uni-forms ref="form" :model="form" :rules="rules">
      <uni-forms-item label="字典标签" name="dictLabel">
        <uni-easyinput v-model="form.dictLabel" placeholder="请输入字典标签" />
      </uni-forms-item>
      <uni-forms-item label="字典键值" name="dictValue">
        <uni-easyinput v-model="form.dictValue" placeholder="请输入字典键值" />
      </uni-forms-item>
      <uni-forms-item label="状态" name="status">
        <uni-data-checkbox v-model="form.status" :localdata="statusOptions" />
      </uni-forms-item>
    </uni-forms>

    <view class="button-group">
      <button type="primary" @click="submitForm">提交</button>
      <button @click="cancel">取消</button>
    </view>
  </view>
</template>

<script>
import { getData, addData, updateData } from '@/api/dict'

export default {
  data() {
    return {
      form: {
        dictCode: undefined,
        dictLabel: undefined,
        dictValue: undefined,
        status: '0'
      },
      statusOptions: [
        { value: '0', text: '启用' },
        { value: '1', text: '停用' }
      ],
      rules: {
        dictLabel: { required: true, message: '字典标签不能为空' },
        dictValue: { required: true, message: '字典键值不能为空' }
      }
    }
  },
  onLoad(options) {
    if (options.dictCode) {
      getData(options.dictCode).then(response => {
        this.form = response.data
      })
    } else {
      this.form.dictType = options.dictType
    }
  },
  methods: {
    submitForm() {
      this.$refs.form.validate().then(valid => {
        if (valid) {
          if (this.form.dictCode) {
            updateData(this.form).then(() => {
              uni.showToast({ title: '修改成功' })
              uni.navigateBack()
            })
          } else {
            addData(this.form).then(() => {
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