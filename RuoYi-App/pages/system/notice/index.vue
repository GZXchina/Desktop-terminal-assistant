<template>
  <view class="container">
    <!-- 搜索区域 -->
    <view class="search-box">
      <uni-search-bar 
        placeholder="请输入公告标题" 
        v-model="queryParams.noticeTitle"
        @confirm="handleQuery"
      />
      <uni-search-bar 
        placeholder="请输入操作人员" 
        v-model="queryParams.createBy"
        @confirm="handleQuery"
      />
      <uni-data-select 
        v-model="queryParams.noticeType"
        :localdata="noticeTypeOptions"
        placeholder="请选择公告类型"
        @change="handleQuery"
      />
    </view>

    <!-- 公告列表 -->
    <uni-table>
      <uni-tr>
        <uni-th width="60">序号</uni-th>
        <uni-th width="100">公告类型</uni-th>
        <uni-th>公告标题</uni-th>
        <uni-th width="80">状态</uni-th>
        <uni-th width="100">创建者</uni-th>
        <uni-th width="120">创建时间</uni-th>
        <uni-th width="80">操作</uni-th>
      </uni-tr>
      <uni-tr v-for="(item, index) in noticeList" :key="index">
        <uni-td>{{ index + 1 }}</uni-td>
        <uni-td>{{ item.noticeType === '1' ? '通知' : '公告' }}</uni-td>
        <uni-td>{{ item.noticeTitle }}</uni-td>
        <uni-td>{{ item.status === '0' ? '正常' : '停用' }}</uni-td>
        <uni-td>{{ item.createBy }}</uni-td>
        <uni-td>{{ item.createTime }}</uni-td>
        <uni-td>
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
        </uni-td>
      </uni-tr>
    </uni-table>

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
import { listNotice, delNotice } from '@/api/system/notice'

export default {
  data() {
    return {
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        noticeTitle: undefined,
        createBy: undefined,
        noticeType: undefined
      },
      noticeTypeOptions: [
        { value: '1', text: '通知' },
        { value: '2', text: '公告' }
      ],
      noticeList: []
    }
  },
  onLoad() {
    this.getList()
  },
  methods: {
    getList() {
      listNotice(this.queryParams).then(response => {
        this.noticeList = response.data
      })
    },
    handleQuery() {
      this.getList()
    },
    handleNoticeClick(row) {
      uni.navigateTo({
        url: `/pages/system/notice/detail?noticeId=${row.noticeId}`
      })
    },
    handleAdd() {
      uni.navigateTo({
        url: '/pages/system/notice/form'
      })
    },
    handleUpdate(row) {
      uni.navigateTo({
        url: `/pages/system/notice/form?noticeId=${row.noticeId}`
      })
    },
    handleDelete(row) {
      uni.showModal({
        title: '提示',
        content: '确认删除该公告吗？',
        success: (res) => {
          if (res.confirm) {
            delNotice(row.noticeId).then(() => {
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
  justify-content: center;
  gap: 10px;
}

.add-button {
  position: fixed;
  right: 20px;
  bottom: 20px;
}

uni-table {
  width: 100%;
  margin-top: 10px;
}

uni-th, uni-td {
  padding: 8px 12px;
  text-align: center;
  border-bottom: 1px solid #ebeef5;
}

uni-th {
  font-weight: bold;
  background-color: #f5f7fa;
}
</style>