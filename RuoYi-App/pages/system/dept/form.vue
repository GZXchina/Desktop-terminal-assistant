<template>
  <view class="container">
    <uni-forms ref="form" :model="form" :rules="rules" label-position="top">
      <uni-forms-item label="上级部门" name="parentId" v-if="form.parentId !== 0">
        <uni-data-select 
          v-model="form.parentId"
          :localdata="deptOptions"
          placeholder="请选择上级部门"
        />
      </uni-forms-item>
      
      <uni-forms-item label="部门名称" name="deptName">
        <uni-easyinput v-model="form.deptName" placeholder="请输入部门名称" />
      </uni-forms-item>
      
      <uni-forms-item label="排序" name="orderNum">
        <uni-number-box v-model="form.orderNum" :min="0" />
      </uni-forms-item>
      
      <uni-forms-item label="负责人" name="leader">
        <uni-easyinput v-model="form.leader" placeholder="请输入负责人" />
      </uni-forms-item>
      
      <uni-forms-item label="联系电话" name="phone">
        <uni-easyinput v-model="form.phone" placeholder="请输入联系电话" />
      </uni-forms-item>
      
      <uni-forms-item label="邮箱" name="email">
        <uni-easyinput v-model="form.email" placeholder="请输入邮箱" />
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
import { getDept, addDept, updateDept, listDept } from '@/api/system/dept'

export default {
  data() {
    return {
      form: {
        deptId: undefined,
        parentId: 0,
        deptName: '',
        orderNum: 0,
        leader: '',
        phone: '',
        email: '',
        status: '0'
      },
      statusOptions: [
        { text: '启用', value: '0' },
        { text: '停用', value: '1' }
      ],
      deptOptions: [],
      rules: {
        deptName: { rules: [{ required: true, errorMessage: '部门名称不能为空' }] },
        orderNum: { rules: [{ required: true, errorMessage: '排序不能为空' }] }
      }
    }
  },
  onLoad(options) {
    this.getDeptList()
    if (options.id) {
      this.getDept(options.id)
    } else if (options.parentId) {
      this.form.parentId = options.parentId
    }
  },
  methods: {
    getDept(deptId) {
      getDept(deptId).then(response => {
        this.form = response.data
      })
    },
    getDeptList() {
      listDept().then(response => {
        this.deptOptions = response.data.map(item => ({
          value: item.deptId,
          text: item.deptName
        }))
        this.deptOptions.unshift({ value: 0, text: '顶级部门' })
      })
    },
    submitForm() {
      this.$refs.form.validate().then(valid => {
        if (valid) {
          if (this.form.deptId) {
            updateDept(this.form).then(() => {
              uni.showToast({ title: '修改成功' })
              uni.navigateBack()
            })
          } else {
            addDept(this.form).then(() => {
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