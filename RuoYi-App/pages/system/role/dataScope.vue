<template>
  <view class="container">
    <uni-section title="数据权限配置" type="line"></uni-section>
    
    <uni-form :model="form" :rules="rules" ref="form">
      <uni-form-item label="角色名称" prop="roleName">
        <uni-easyinput v-model="form.roleName" disabled />
      </uni-form-item>
      
      <uni-form-item label="权限范围" prop="dataScope">
        <uni-data-select 
          v-model="form.dataScope"
          :localdata="dataScopeOptions"
          @change="handleScopeChange"
        />
      </uni-form-item>
      
      <uni-form-item 
        label="数据权限" 
        prop="deptIds" 
        v-if="form.dataScope === '2'"
      >
        <uni-transfer 
          :data="deptOptions"
          v-model="form.deptIds"
          :titles="['可选部门', '已选部门']"
        />
      </uni-form-item>
    </uni-form>
    
    <view class="footer">
      <button type="primary" @click="submitForm">提交</button>
      <button @click="handleClose">关闭</button>
    </view>
  </view>
</template>

<script>
import { getRole, dataScope, deptTreeSelect } from '@/api/role'

export default {
  data() {
    return {
      form: {
        roleId: undefined,
        roleName: '',
        dataScope: '',
        deptIds: []
      },
      dataScopeOptions: [
        { value: '1', text: '全部数据权限' },
        { value: '2', text: '自定义数据权限' },
        { value: '3', text: '本部门数据权限' },
        { value: '4', text: '本部门及以下数据权限' },
        { value: '5', text: '仅本人数据权限' }
      ],
      deptOptions: [],
      rules: {
        dataScope: { required: true, message: '请选择权限范围' }
      }
    }
  },
  onLoad(options) {
    this.form.roleId = options.id
    this.getRole()
    this.getDeptTree()
  },
  methods: {
    getRole() {
      getRole(this.form.roleId).then(response => {
        this.form = response.data
      })
    },
    getDeptTree() {
      deptTreeSelect(this.form.roleId).then(response => {
        this.deptOptions = response.data.map(item => ({
          key: item.id,
          title: item.label,
          disabled: item.disabled
        }))
      })
    },
    handleScopeChange(value) {
      if (value !== '2') {
        this.form.deptIds = []
      }
    },
    submitForm() {
      this.$refs.form.validate().then(valid => {
        if (valid) {
          dataScope(this.form).then(() => {
            uni.showToast({ title: '修改成功' })
            uni.navigateBack()
          })
        }
      })
    },
    handleClose() {
      uni.navigateBack()
    }
  }
}
</script>

<style lang="scss">
.container {
  padding: 15px;
}
.footer {
  margin-top: 20px;
  display: flex;
  gap: 10px;
}
</style>