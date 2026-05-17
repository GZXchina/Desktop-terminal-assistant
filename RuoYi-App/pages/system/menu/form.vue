<template>
  <view class="container">
    <uni-forms ref="form" :model="form" :rules="rules" label-position="top">
      <uni-forms-item label="上级菜单" name="parentId">
        <uni-data-select 
          v-model="form.parentId"
          :localdata="menuOptions"
          placeholder="请选择上级菜单"
        />
      </uni-forms-item>
      
      <uni-forms-item label="菜单类型" name="menuType">
        <uni-data-checkbox 
          v-model="form.menuType"
          :localdata="menuTypeOptions"
        />
      </uni-forms-item>
      
      <uni-forms-item label="菜单名称" name="menuName">
        <uni-easyinput v-model="form.menuName" placeholder="请输入菜单名称" />
      </uni-forms-item>
      
      <uni-forms-item label="排序" name="orderNum">
        <uni-number-box v-model="form.orderNum" :min="0" />
      </uni-forms-item>
      
      <uni-forms-item label="权限标识" name="perms">
        <uni-easyinput v-model="form.perms" placeholder="请输入权限标识" />
      </uni-forms-item>
      
      <uni-forms-item label="路由地址" name="path" v-if="form.menuType !== 'F'">
        <uni-easyinput v-model="form.path" placeholder="请输入路由地址" />
      </uni-forms-item>
      
      <uni-forms-item label="状态">
        <uni-data-checkbox 
          v-model="form.status"
          :localdata="statusOptions"
        />
      </uni-forms-item>
      
      <button type="primary" @click="submitForm">提交</button>
    </uni-forms>
  </view>
</template>

<script>
import { getMenu, addMenu, updateMenu, treeselect } from '@/api/system/menu'

export default {
  data() {
    return {
      form: {
        menuId: undefined,
        parentId: 0,
        menuName: '',
        menuType: 'M',
        orderNum: 0,
        perms: '',
        path: '',
        status: '0'
      },
      menuTypeOptions: [
        { text: '目录', value: 'M' },
        { text: '菜单', value: 'C' },
        { text: '按钮', value: 'F' }
      ],
      statusOptions: [
        { text: '启用', value: '0' },
        { text: '停用', value: '1' }
      ],
      menuOptions: [],
      rules: {
        menuName: { rules: [{ required: true, errorMessage: '菜单名称不能为空' }] },
        orderNum: { rules: [{ required: true, errorMessage: '排序不能为空' }] }
      }
    }
  },
  onLoad(options) {
    this.getTreeselect()
    if (options.menuId) {
      this.getMenu(options.menuId)
    } else if (options.parentId) {
      this.form.parentId = options.parentId
    }
  },
  methods: {
    getMenu(menuId) {
      getMenu(menuId).then(response => {
        this.form = response.data
      })
    },
    getTreeselect() {
      treeselect().then(response => {
        this.menuOptions = response.data.map(item => ({
          value: item.menuId,
          text: item.menuName
        }))
        this.menuOptions.unshift({ value: 0, text: '主类目' })
      })
    },
    submitForm() {
      this.$refs.form.validate().then(valid => {
        if (valid) {
          if (this.form.menuId) {
            updateMenu(this.form).then(() => {
              uni.showToast({ title: '修改成功' })
              uni.navigateBack()
            })
          } else {
            addMenu(this.form).then(() => {
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