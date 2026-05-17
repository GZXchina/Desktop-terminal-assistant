<template>
  <view class="container">
    <uni-forms ref="form" :model="form" :rules="rules" label-position="top">
      <uni-forms-item label="用户昵称" name="nickName">
        <uni-easyinput v-model="form.nickName" placeholder="请输入用户昵称" />
      </uni-forms-item>
      <uni-forms-item label="用户名称" name="userName" v-if="!form.userId">
        <uni-easyinput v-model="form.userName" placeholder="请输入用户名称" />
      </uni-forms-item>
      <uni-forms-item label="密码" name="password" v-if="!form.userId">
        <uni-easyinput 
          v-model="form.password" 
          type="password" 
          placeholder="请输入密码" 
        />
      </uni-forms-item>
      <uni-forms-item label="手机号码" name="phonenumber">
        <uni-easyinput v-model="form.phonenumber" placeholder="请输入手机号码" />
      </uni-forms-item>
      <uni-forms-item label="邮箱" name="email">
        <uni-easyinput v-model="form.email" placeholder="请输入邮箱" />
      </uni-forms-item>
      <uni-forms-item label="性别" name="sex">
        <uni-data-checkbox v-model="form.sex" :localdata="sexOptions" />
      </uni-forms-item>
      <uni-forms-item label="状态">
        <uni-data-checkbox v-model="form.status" :localdata="statusOptions" />
      </uni-forms-item>
      
      <button type="primary" @click="submitForm">提交</button>
    </uni-forms>
  </view>
</template>

<script>
import { getUser, addUser, updateUser } from '@/api/user'
import { parseStrEmpty } from '@/utils/ruoyi'
export default {
  data() {
    return {
      form: {
        userId: undefined,
        nickName: '',
        userName: '',
        password: '',
        phonenumber: '',
        email: '',
        sex: '0',
        status: '0'
      },
      sexOptions: [
        { text: '男', value: '0' },
        { text: '女', value: '1' }
      ],
      statusOptions: [
        { text: '启用', value: '0' },
        { text: '停用', value: '1' }
      ],
      rules: {
        nickName: { rules: [{ required: true, errorMessage: '用户昵称不能为空' }] },
        userName: { rules: [{ required: true, errorMessage: '用户名称不能为空' }] },
        password: { rules: [{ required: true, errorMessage: '密码不能为空' }] },
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
  onLoad(options) {
    if (options.id) {
      this.getUser(options.id)
    }
  },
  methods: {
    getUser(userId) {
      getUser(userId).then(response => {
        this.form = response.data
      })
    },
    submitForm() {
      this.$refs.form.validate().then(valid => {
        if (valid) {
          if (this.form.userId) {
            updateUser(this.form).then(() => {
              uni.showToast({ title: '修改成功' })
              uni.navigateBack()
            })
          } else {
            addUser(this.form).then(() => {
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