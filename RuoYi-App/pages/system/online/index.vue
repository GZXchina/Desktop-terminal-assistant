<template>
  <view class="container">
    <uni-card title="在线用户查询">
      <uni-form :model="queryParams" ref="queryForm">
        <uni-form-item label="用户名称">
          <uni-easyinput v-model="queryParams.userName" placeholder="请输入用户名称" />
        </uni-form-item>
        <uni-form-item label="登录地址">
          <uni-easyinput v-model="queryParams.ipaddr" placeholder="请输入登录地址" />
        </uni-form-item>
        <view class="action-buttons">
          <button type="primary" @click="handleQuery">搜索</button>
          <button @click="resetQuery">重置</button>
        </view>
      </uni-form>
    </uni-card>

    <uni-list>
      <uni-list-item 
        v-for="(item, index) in list" 
        :key="index"
        :title="item.userName"
        :note="`${item.ipaddr} | ${item.loginLocation}`"
        :rightText="item.browser"
      >
        <template v-slot:footer>
          <button type="warn" size="mini" @click.stop="handleForceLogout(item)">强退</button>
        </template>
      </uni-list-item>
    </uni-list>

    <uni-pagination 
      :total="total"
      :current="queryParams.pageNum"
      :pageSize="queryParams.pageSize"
      @change="handlePageChange"
    />
  </view>
</template>

<script>
import { listOnline, forceLogout } from '@/api/monitor/online'

export default {
  data() {
    return {
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        ipaddr: undefined,
        userName: undefined
      },
      list: [],
      total: 0
    }
  },
  onLoad() {
    this.getList()
  },
  methods: {
    getList() {
      listOnline(this.queryParams).then(response => {
        this.list = response.rows
        this.total = response.total
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.queryParams = {
        pageNum: 1,
        pageSize: 10,
        ipaddr: undefined,
        userName: undefined
      }
      this.getList()
    },
    handlePageChange(e) {
      this.queryParams.pageNum = e.current
      this.getList()
    },
    handleForceLogout(row) {
      uni.showModal({
        title: '提示',
        content: `确认强退用户"${row.userName}"吗？`,
        success: (res) => {
          if (res.confirm) {
            forceLogout(row.tokenId).then(() => {
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
.action-buttons {
  margin-top: 15px;
  display: flex;
  gap: 10px;
}
</style>