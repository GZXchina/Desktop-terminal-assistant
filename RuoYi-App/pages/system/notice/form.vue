<template>
  <view class="container">
    <uni-forms ref="form" :model="form" :rules="rules" label-position="top">
      <uni-forms-item label="公告标题" name="noticeTitle">
        <uni-easyinput v-model="form.noticeTitle" placeholder="请输入公告标题" />
      </uni-forms-item>
      
      <uni-forms-item label="公告类型" name="noticeType">
        <uni-data-checkbox 
          v-model="form.noticeType"
          :localdata="noticeTypeOptions"
        />
      </uni-forms-item>
      
      <uni-forms-item label="状态">
        <uni-data-checkbox 
          v-model="form.status"
          :localdata="statusOptions"
        />
      </uni-forms-item>
      
      <uni-forms-item label="公告内容" name="noticeContent">
        <editor 
          v-model="form.noticeContent" 
          placeholder="请输入公告内容"
          :show-img-size="true"
          :show-img-toolbar="true"
          :show-img-resize="true"
        />
      </uni-forms-item>
      
      <button type="primary" @click="submitForm">提交</button>
    </uni-forms>
  </view>
</template>

<script>
import { getNotice, addNotice, updateNotice } from '@/api/system/notice'

export default {
  data() {
    return {
      form: {
        noticeId: undefined,
        noticeTitle: '',
        noticeType: '1',
        noticeContent: '',
        status: '0'
      },
      noticeTypeOptions: [
        { text: '通知', value: '1' },
        { text: '公告', value: '2' }
      ],
      statusOptions: [
        { text: '正常', value: '0' },
        { text: '停用', value: '1' }
      ],
      rules: {
        noticeTitle: { rules: [{ required: true, errorMessage: '公告标题不能为空' }] },
        noticeType: { rules: [{ required: true, errorMessage: '公告类型不能为空' }] },
        noticeContent: { rules: [{ required: true, errorMessage: '公告内容不能为空' }] }
      }
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
        this.form = response.data
      })
    },
    submitForm() {
      this.$refs.form.validate().then(valid => {
        if (valid) {
          if (this.form.noticeId) {
            updateNotice(this.form).then(() => {
              uni.showToast({ title: '修改成功' })
              uni.navigateBack()
            })
          } else {
            addNotice(this.form).then(() => {
              uni.showToast({ title: '新增成功' })
              uni.navigateBack()
            })
          }
        }
      })
    }
  }
}
</script>

<style lang="scss">
.container {
  padding: 15px;
}
</style>