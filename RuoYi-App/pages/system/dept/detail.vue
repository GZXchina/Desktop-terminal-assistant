<template>
  <view class="container">
    <uni-card title="部门信息">
      <uni-list>
        <uni-list-item title="部门名称" :rightText="dept.deptName" />
        <uni-list-item title="上级部门" :rightText="dept.parentName || '顶级部门'" />
        <uni-list-item title="负责人" :rightText="dept.leader" />
        <uni-list-item title="联系电话" :rightText="dept.phone" />
        <uni-list-item title="邮箱" :rightText="dept.email" />
        <uni-list-item title="状态" :rightText="dept.status === '0' ? '启用' : '停用'" />
        <uni-list-item title="创建时间" :rightText="dept.createTime" />
      </uni-list>
    </uni-card>
  </view>
</template>

<script>
import { getDept } from '@/api/system/dept'

export default {
  data() {
    return {
      dept: {}
    }
  },
  onLoad(options) {
    if (options.id) {
      this.getDept(options.id)
    }
  },
  methods: {
    getDept(deptId) {
      getDept(deptId).then(response => {
        this.dept = response.data
      })
    }
  }
}
</script>

<style lang="scss">
.container {
  padding: 10px;
}
</style>