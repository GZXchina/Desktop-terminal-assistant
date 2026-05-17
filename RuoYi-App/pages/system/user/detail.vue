<template>
  <view class="container">
    <uni-card title="用户信息">
      <uni-list>
        <uni-list-item title="用户名称" :rightText="user.userName" />
        <uni-list-item title="用户昵称" :rightText="user.nickName" />
        <uni-list-item title="手机号码" :rightText="user.phonenumber" />
        <uni-list-item title="邮箱" :rightText="user.email" />
        <uni-list-item title="部门" :rightText="user.dept.deptName" />
        <uni-list-item title="状态" :rightText="user.status === '0' ? '启用' : '停用'" />
        <uni-list-item title="创建时间" :rightText="user.createTime" />
      </uni-list>
    </uni-card>

    <view class="action-buttons">
      <button type="primary" @click="handleAuthRole">分配角色</button>
      <button type="warn" @click="handleResetPwd">重置密码</button>
    </view>
  </view>
</template>

<script>
import { getUser } from '@/api/system/user'

export default {
  data() {
    return {
      user: {}
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
        this.user = response.data
      })
    },
    handleAuthRole() {
      uni.navigateTo({
        url: `/pages/system/user/authRole?id=${this.user.userId}`
      })
    },
    handleResetPwd() {
      uni.showModal({
        title: '重置密码',
        content: '请输入新密码',
        editable: true,
        success: (res) => {
          if (res.confirm) {
            // 调用重置密码API
            uni.showToast({ title: '密码重置成功' })
          }
        }
      })
    }
  }
}
</script>

<style lang="scss">
.container {
  padding: 10px;
}

.action-buttons {
  margin-top: 20px;
  display: flex;
  justify-content: space-around;
}
</style>