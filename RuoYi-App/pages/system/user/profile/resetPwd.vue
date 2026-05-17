<template>
  <view class="container">
    <uni-forms ref="form" :model="form" :rules="rules">
      <uni-forms-item label="旧密码" name="oldPassword">
        <uni-easyinput type="password" v-model="form.oldPassword" placeholder="请输入旧密码" />
      </uni-forms-item>
      <uni-forms-item label="新密码" name="newPassword">
        <uni-easyinput type="password" v-model="form.newPassword" placeholder="请输入新密码" />
      </uni-forms-item>
      <uni-forms-item label="确认密码" name="confirmPassword">
        <uni-easyinput type="password" v-model="form.confirmPassword" placeholder="请再次输入新密码" />
      </uni-forms-item>
      
      <button type="primary" @click="submitForm">提交</button>
    </uni-forms>
  </view>
</template>

<script>
import { updateUserPwd } from '@/api/system/user'

export default {
  data() {
    return {
      form: {
        oldPassword: '',
        newPassword: '',
        confirmPassword: ''
      },
      rules: {
        oldPassword: { rules: [{ required: true, errorMessage: '旧密码不能为空' }] },
        newPassword: { 
          rules: [
            { required: true, errorMessage: '新密码不能为空' },
            { minLength: 6, errorMessage: '密码长度不能小于6位' }
          ] 
        },
        confirmPassword: { 
          rules: [
            { required: true, errorMessage: '确认密码不能为空' },
            { 
              validateFunction: (rule, value, data, callback) => {
                if (value !== this.form.newPassword) {
                  callback('两次输入的密码不一致')
                }
                return true
              }
            }
          ] 
        }
      }
    }
  },
  methods: {
    submitForm() {
      this.$refs.form.validate().then(valid => {
        if (valid) {
          updateUserPwd(this.form.oldPassword, this.form.newPassword).then(() => {
            uni.showToast({ title: '密码修改成功' })
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