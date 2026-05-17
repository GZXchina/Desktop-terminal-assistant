<template>
  <view class="container">
    <uni-section :title="'角色[' + roleName + ']的用户授权'" type="line"></uni-section>
    
    <view class="search-box">
      <uni-search-bar 
        placeholder="请输入用户名称" 
        v-model="queryParams.userName"
        @confirm="handleQuery"
      />
      <uni-search-bar 
        placeholder="请输入手机号码" 
        v-model="queryParams.phonenumber"
        @confirm="handleQuery"
      />
    </view>
    
    <uni-list>
      <uni-list-item 
        v-for="(item, index) in userList" 
        :key="index"
        :title="item.userName"
        :note="item.phonenumber"
        :showSwitch="true"
        :switchChecked="item.flag === '0'"
        @switchChange="(e) => handleSwitchChange(e, item)"
      />
    </uni-list>
    
    <uni-pagination 
      :total="total"
      :current="queryParams.pageNum"
      :pageSize="queryParams.pageSize"
      @change="handlePageChange"
    />
    
    <view class="footer">
      <button type="primary" @click="handleSelectUser">添加用户</button>
      <button @click="handleCancelAll">批量取消</button>
    </view>
  </view>
</template>

<script>
import { allocatedUserList, authUserCancel, authUserCancelAll, authUserSelectAll } from '@/api/role'

export default {
  data() {
    return {
      roleId: undefined,
      roleName: '',
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userName: undefined,
        phonenumber: undefined
      },
      userList: [],
      total: 0
    }
  },
  onLoad(options) {
    this.roleId = options.id
    this.roleName = options.name
    this.getList()
  },
  methods: {
    getList() {
      allocatedUserList(this.queryParams).then(response => {
        this.userList = response.rows
        this.total = response.total
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    handlePageChange(e) {
      this.queryParams.pageNum = e.current
      this.getList()
    },
    handleSwitchChange(e, row) {
      const method = e.value ? authUserSelectAll : authUserCancel
      method({ roleId: this.roleId, userIds: row.userId }).then(() => {
        uni.showToast({ title: '操作成功' })
        this.getList()
      })
    },
    handleSelectUser() {
      uni.navigateTo({
        url: `/pages/system/role/selectUser?id=${this.roleId}`
      })
    },
    handleCancelAll() {
      uni.showModal({
        title: '提示',
        content: '确认取消所有用户授权吗？',
        success: (res) => {
          if (res.confirm) {
            authUserCancelAll(this.roleId).then(() => {
              uni.showToast({ title: '操作成功' })
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
  padding: 15px;
}
.search-box {
  margin-bottom: 15px;
}
.footer {
  margin-top: 20px;
  display: flex;
  gap: 10px;
}
</style>