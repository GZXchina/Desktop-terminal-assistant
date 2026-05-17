<template>
  <view class="container">
    <!-- 搜索区域 -->
    <view class="search-box">
      <uni-search-bar 
        placeholder="请输入岗位编码" 
        v-model="queryParams.postCode"
        @confirm="handleQuery"
      />
      <uni-search-bar 
        placeholder="请输入岗位名称" 
        v-model="queryParams.postName"
        @confirm="handleQuery"
      />
      <uni-data-select 
        v-model="queryParams.status"
        :localdata="statusOptions"
        placeholder="请选择状态"
        @change="handleQuery"
      />
    </view>

    <!-- 岗位列表 -->
    <uni-list>
      <uni-list-item 
        v-for="(item, index) in postList" 
        :key="index"
        :title="item.postName"
        :note="item.postCode"
        :rightText="item.status === '0' ? '启用' : '停用'"
        :showArrow="true"
        @click="handlePostClick(item)"
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
import { listPost, delPost } from '@/api/system/post'

export default {
  data() {
    return {
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        postCode: undefined,
        postName: undefined,
        status: undefined
      },
      statusOptions: [
        { value: '0', text: '启用' },
        { value: '1', text: '停用' }
      ],
      postList: [],
      total: 0
    }
  },
  onLoad() {
    this.getList()
  },
  methods: {
    // 获取岗位列表
    getList() {
      listPost(this.queryParams).then(response => {
        this.postList = response.rows
        this.total = response.total
      })
    },
    // 搜索
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    // 分页
    handlePageChange(e) {
      this.queryParams.pageNum = e.current
      this.getList()
    },
    // 岗位点击
    handlePostClick(row) {
      uni.navigateTo({
        url: `/pages/system/post/detail?id=${row.postId}`
      })
    },
    // 新增岗位
    handleAdd() {
      uni.navigateTo({
        url: '/pages/system/post/form'
      })
    },
    // 修改岗位
    handleUpdate(row) {
      uni.navigateTo({
        url: `/pages/system/post/form?id=${row.postId}`
      })
    },
    // 删除岗位
    handleDelete(row) {
      uni.showModal({
        title: '提示',
        content: '确认删除该岗位吗？',
        success: (res) => {
          if (res.confirm) {
            delPost(row.postId).then(() => {
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