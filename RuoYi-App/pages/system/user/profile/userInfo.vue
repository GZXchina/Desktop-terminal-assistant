<template>
  <view class="container">
    <uni-forms ref="form" :model="form" :rules="rules">
      <uni-forms-item label="用户昵称" name="nickName">
        <uni-easyinput v-model="form.nickName" placeholder="请输入用户昵称" />
      </uni-forms-item>
      <uni-forms-item label="手机号码" name="phonenumber">
        <uni-easyinput v-model="form.phonenumber" placeholder="请输入手机号码" />
      </uni-forms-item>
      <uni-forms-item label="邮箱" name="email">
        <uni-easyinput v-model="form.email" placeholder="请输入邮箱" />
      </uni-forms-item>
      <uni-forms-item label="性别">
        <uni-data-checkbox v-model="form.sex" :localdata="sexOptions" />
      </uni-forms-item>
      
      <button type="primary" @click="submitForm">保存</button>
    </uni-forms>
  </view>
</template>

<script>
import { getUserProfile, updateUserProfile } from '@/api/system/user'

export default {
  data() {
    return {
      form: {
        nickName: '',
        phonenumber: '',
        email: '',
        sex: '0'
      },
      sexOptions: [
        { text: '男', value: '0' },
        { text: '女', value: '1' }
      ],
      rules: {
        nickName: { rules: [{ required: true, errorMessage: '用户昵称不能为空' }] },
        phonenumber: { 
          rules: [
            { required: true, errorMessage: '手机号码不能为空' },
            { pattern: /^1[3-9]\d{9}$/, errorMessage: '请输入正确的手机号码' }
          ] 
        },
        email: { 
          rules: [
            { required: true, errorMessage: '邮箱不能为空' },
            { pattern: /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/, errorMessage: '请输入正确的邮箱' }
          ] 
        }
      }
    }
  },
  onLoad() {
    this.getUserProfile()
  },
  methods: {
    getUserProfile() {
      getUserProfile().then(response => {
        this.form = response.data
      })
    },
    submitForm() {
      this.$refs.form.validate().then(valid => {
        if (valid) {
          updateUserProfile(this.form).then(() => {
            uni.showToast({ title: '修改成功' })
            uni.navigateBack()
          })
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