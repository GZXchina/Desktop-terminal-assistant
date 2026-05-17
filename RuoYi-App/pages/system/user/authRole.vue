<template>
  <view class="container">
    <uni-card title="基本信息">
      <uni-list>
        <uni-list-item title="用户昵称" :rightText="form.nickName" />
        <uni-list-item title="登录账号" :rightText="form.userName" />
      </uni-list>
    </uni-card>

    <uni-card title="角色信息">
      <uni-indexed-list 
        :options="roles" 
        :show-select="true"
        @change="handleSelectionChange"
      />
    </uni-card>

    <view class="action-buttons">
      <button type="primary" @click="submitForm">提交</button>
      <button @click="close">返回</button>
    </view>
  </view>
</template>

<script>
import { getAuthRole, updateAuthRole } from '@/api/system/user'

export default {
  data() {
    return {
      form: {},
      roles: [],
      selectedRoleIds: []
    }
  },
  onLoad(options) {
    if (options.id) {
      this.getAuthRole(options.id)
    }
  },
  methods: {
    getAuthRole(userId) {
      getAuthRole(userId).then(response => {
        this.form = response.user
        this.roles = response.roles.map(item => ({
          letter: item.roleName,
          data: [{
            ...item,
            checked: item.flag
          }]
        }))
      })
    },
    handleSelectionChange(selection) {
      this.selectedRoleIds = selection.map(item => item.roleId)
    },
    submitForm() {
      updateAuthRole({
        userId: this.form.userId,
        roleIds: this.selectedRoleIds.join(',')
      }).then(() => {
        uni.showToast({ title: '授权成功' })
        uni.navigateBack()
      })
    },
    close() {
      uni.navigateBack()
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