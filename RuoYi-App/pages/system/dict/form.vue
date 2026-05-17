<template>
  <view class="container">
    <uni-forms ref="form" :model="form" :rules="rules">
      <uni-forms-item label="字典名称" name="dictName">
        <uni-easyinput v-model="form.dictName" placeholder="请输入字典名称" />
      </uni-forms-item>
      <uni-forms-item label="字典类型" name="dictType">
        <uni-easyinput v-model="form.dictType" placeholder="请输入字典类型" />
      </uni-forms-item>
      <uni-forms-item label="状态" name="status">
        <uni-data-checkbox v-model="form.status" :localdata="statusOptions" />
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
import { getType, addType, updateType } from '@/api/dict'

export default {
  data() {
    return {
      form: {
        dictId: undefined,
        dictName: undefined,
        dictType: undefined,
        status: '0',
        remark: undefined
      },
      statusOptions: [
        { value: '0', text: '启用' },
        { value: '1', text: '停用' }
      ],
      rules: {
        dictName: { required: true, message: '字典名称不能为空' },
        dictType: { required: true, message: '字典类型不能为空' }
      }
    }
  },
  onLoad(options) {
    if (options.dictId) {
      getType(options.dictId).then(response => {
        this.form = response.data
      })
    }
  },
  methods: {
    submitForm() {
      this.$refs.form.validate().then(valid => {
        if (valid) {
          if (this.form.dictId) {
            updateType(this.form).then(() => {
              uni.showToast({ title: '修改成功' })
              uni.navigateBack()
            })
          } else {
            addType(this.form).then(() => {
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