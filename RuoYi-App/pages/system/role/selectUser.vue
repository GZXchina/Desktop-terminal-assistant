<template>
  <view class="container">
    <uni-section title="选择用户" type="line"></uni-section>
    
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
        :showCheckbox="true"
        :checked="selectedUserIds.includes(item.userId)"
        @checkboxChange="(e) => handleSelect(e, item)"
      />
    </uni-list>
    
    <uni-pagination 
      :total="total"
      :current="queryParams.pageNum"
      :pageSize="queryParams.pageSize"
      @change="handlePageChange"
    />
    
    <view class="footer">
      <button type="primary" @click="handleSubmit">确定</button>
      <button @click="handleCancel">取消</button>
    </view>
  </view>
</template>

<script>
import { unallocatedUserList, authUserSelectAll } from '@/api/role'

export default {
  data() {
    return {
      roleId: undefined,
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userName: undefined,
        phonenumber: undefined
      },
      userList: [],
      selectedUserIds: [],
      total: 0
    }
  },
  onLoad(options) {
    this.roleId = options.id
    this.getList()
  },
  methods: {
    getList() {
      unallocatedUserList(this.queryParams).then(response => {
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
    handleSelect(e, row) {
      if (e.value) {
        this.selectedUserIds.push(row.userId)
      } else {
        const index = this.selectedUserIds.indexOf(row.userId)
        if (index > -1) {
          this.selectedUserIds.splice(index, 1)
        }
      }
    },
    handleSubmit() {
      if (this.selectedUserIds.length === 0) {
        uni.showToast({ title: '请选择用户', icon: 'none' })
        return
      }
      
      authUserSelectAll({
        roleId: this.roleId,
        userIds: this.selectedUserIds.join(',')
      }).then(() => {
        uni.showToast({ title: '授权成功' })
        uni.navigateBack()
      })
    },
    handleCancel() {
      uni.navigateBack()
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
