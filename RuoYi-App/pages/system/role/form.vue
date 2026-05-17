<template>
  <view class="container">
    <uni-forms ref="form" :model="form" labelWidth="80px">
      <uni-forms-item label="角色名称" name="roleName">
        <uni-easyinput v-model="form.roleName" placeholder="请输入角色名称" />
      </uni-forms-item>
      <uni-forms-item label="角色权限" name="roleKey">
        <uni-easyinput v-model="form.roleKey" placeholder="请输入角色权限" />
      </uni-forms-item>
      <uni-forms-item label="显示顺序" name="roleSort">
        <uni-easyinput v-model="form.roleSort" placeholder="请输入显示顺序" />
      </uni-forms-item>
      <uni-forms-item label="状态" name="status">
        <uni-data-checkbox v-model="form.status" :localdata="statusOptions" />
      </uni-forms-item>
    </uni-forms>
    <button type="primary" @click="submit">提交</button>
  </view>
</template>

<script>
import { getRole, addRole, updateRole } from '@/api/role'

export default {
  data() {
    return {
      form: {
        roleId: undefined,
        roleName: '',
        roleKey: '',
        roleSort: 0,
        status: '0'
      },
      statusOptions: [
        { text: '正常', value: '0' },
        { text: '停用', value: '1' }
      ]
    }
  },
  onLoad(options) {
    if (options.id) {
      this.form.roleId = options.id
      this.getRole()
    }
  },
  methods: {
    getRole() {
      getRole(this.form.roleId).then(response => {
        this.form = response.data
      })
    },
    submit() {
      this.$refs.form.validate().then(valid => {
        if (valid) {
          if (this.form.roleId) {
            updateRole(this.form).then(() => {
              uni.showToast({ title: '修改成功' })
              uni.navigateBack()
            })
          } else {
            addRole(this.form).then(() => {
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