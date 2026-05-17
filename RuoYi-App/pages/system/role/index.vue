<template>
  <view class="container">
    <!-- 搜索区域 -->
    <view class="search-box">
      <uni-search-bar 
        placeholder="请输入角色名称" 
        v-model="queryParams.roleName"
        @confirm="handleQuery"
        @clear="resetQuery"
      />
      <uni-search-bar 
        placeholder="请输入权限字符" 
        v-model="queryParams.roleKey"
        @confirm="handleQuery"
        @clear="resetQuery"
      />
      <uni-data-select 
        v-model="queryParams.status"
        :localdata="statusOptions"
        placeholder="请选择状态"
        @change="handleQuery"
      />
    </view>

    <!-- 角色列表 -->
    <uni-list>
      <uni-list-item 
        v-for="(item, index) in roleList" 
        :key="index"
        :title="item.roleName"
        :note="item.roleKey"
        :rightText="item.status === '0' ? '启用' : '停用'"
        :showArrow="true"
        @click="handleRoleClick(item)"
      >
        <template v-slot:footer>
          <view class="action-buttons">
            <uni-icons 
              type="compose" 
              size="20" 
              @click.stop="handleUpdate(item)"
            ></uni-icons>
            <uni-icons 
              type="trash" 
              size="20" 
              @click.stop="handleDelete(item)"
            ></uni-icons>
          </view>
        </template>
      </uni-list-item>
    </uni-list>

    <!-- 分页 -->
    <uni-pagination 
      :total="total"
      :current="queryParams.pageNum"
      :pageSize="queryParams.pageSize"
      @change="handlePageChange"
    />

    <!-- 新增按钮 -->
    <view class="add-button">
      <uni-fab 
        horizontal="right" 
        vertical="bottom"
        @fabClick="handleAdd"
      ></uni-fab>
    </view>
  </view>
</template>

<script>
import { listRole, delRole } from '@/api/role'

export default {
  data() {
    return {
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        roleName: undefined,
        roleKey: undefined,
        status: undefined
      },
      statusOptions: [
        { value: '0', text: '启用' },
        { value: '1', text: '停用' }
      ],
      roleList: [],
      total: 0
    }
  },
  onLoad() {
    this.getList()
  },
  methods: {
    // 获取角色列表
    getList() {
      this.loading = true
      listRole(this.queryParams).then(response => {
        this.roleList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    // 角色状态切换
    handleStatusChange(row) {
      const text = row.status === '0' ? '启用' : '停用'
      uni.showModal({
        title: '提示',
        content: `确认要${text}"${row.roleName}"角色吗？`,
        success: (res) => {
          if (res.confirm) {
            changeRoleStatus(row.roleId, row.status).then(() => {
              uni.showToast({ title: `${text}成功` })
              this.getList()
            })
          }
        }
      })
    },
    // 数据权限
    handleDataScope(row) {
      uni.navigateTo({
        url: `/pages/system/role/dataScope?id=${row.roleId}`
      })
    },
    // 分配用户
    handleAuthUser(row) {
      uni.navigateTo({
        url: `/pages/system/role/authUser?id=${row.roleId}`
      })
    },
    // 搜索
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    // 重置搜索
    resetQuery() {
      this.queryParams = {
        pageNum: 1,
        pageSize: 10,
        roleName: undefined,
        roleKey: undefined,
        status: undefined
      }
      this.getList()
    },
    // 分页
    handlePageChange(e) {
      this.queryParams.pageNum = e.current
      this.getList()
    },
    // 角色点击
    handleRoleClick(row) {
      uni.navigateTo({
        url: `/pages/system/role/detail?id=${row.roleId}`
      })
    },
    // 新增角色
    handleAdd() {
      uni.navigateTo({
        url: '/pages/system/role/form'
      })
    },
    // 修改角色
    handleUpdate(row) {
      uni.navigateTo({
        url: `/pages/system/role/form?id=${row.roleId}`
      })
    },
    // 删除角色
    handleDelete(row) {
      uni.showModal({
        title: '提示',
        content: '确认删除该角色吗？',
        success: (res) => {
          if (res.confirm) {
            delRole(row.roleId).then(() => {
              uni.showToast({ title: '删除成功' })
              this.getList()
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
  padding: 10px;
}

.search-box {
  margin-bottom: 10px;
}

.action-buttons {
  display: flex;
  gap: 10px;
}

.add-button {
  position: fixed;
  right: 20px;
  bottom: 20px;
}
</style>