<template>
  <view class="container">
    <!-- 搜索区域 -->
    <view class="search-box">
      <uni-search-bar 
        placeholder="请输入用户名称" 
        v-model="queryParams.userName"
        @confirm="handleQuery"
        @clear="resetQuery"
      />
      <uni-search-bar 
        placeholder="请输入手机号码" 
        v-model="queryParams.phonenumber"
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

    <!-- 用户列表 -->
    <uni-list>
      <uni-list-item 
        v-for="(item, index) in userList" 
        :key="index"
        :title="item.nickName"
        :note="`${item.dept.deptName} | ${item.phonenumber}`"
        :rightText="item.status === '0' ? '启用' : '停用'"
        :showArrow="true"
        @click="handleUserClick(item)"
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
import { listUser, delUser } from '@/api/user'

export default {
  data() {
    return {
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userName: undefined,
        phonenumber: undefined,
        status: undefined,
        deptId: undefined
      },
      statusOptions: [
        { value: '0', text: '启用' },
        { value: '1', text: '停用' }
      ],
      userList: [],
      total: 0
    }
  },
  onLoad() {
    this.getList()
  },
  methods: {
    // 获取用户列表
    getList() {
      listUser(this.queryParams).then(response => {
        this.userList = response.rows
        this.total = response.total
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
        userName: undefined,
        phonenumber: undefined,
        status: undefined,
        deptId: undefined
      }
      this.getList()
    },
    // 分页
    handlePageChange(e) {
      this.queryParams.pageNum = e.current
      this.getList()
    },
    // 用户点击
    handleUserClick(row) {
      uni.navigateTo({
        url: `/pages/system/user/detail?id=${row.userId}`
      })
    },
    // 新增用户
    handleAdd() {
      uni.navigateTo({
        url: '/pages/system/user/form'
      })
    },
    // 修改用户
    handleUpdate(row) {
      uni.navigateTo({
        url: `/pages/system/user/form?id=${row.userId}`
      })
    },
    // 删除用户
    handleDelete(row) {
      uni.showModal({
        title: '提示',
        content: '确认删除该用户吗？',
        success: (res) => {
          if (res.confirm) {
            delUser(row.userId).then(() => {
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