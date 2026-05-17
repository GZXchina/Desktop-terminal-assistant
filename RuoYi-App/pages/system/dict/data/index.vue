<template>
  <view class="container">
    <!-- 搜索区域 -->
    <view class="search-box">
      <uni-search-bar 
        placeholder="请输入字典标签" 
        v-model="queryParams.dictLabel"
        @confirm="handleQuery"
      />
      <uni-data-select 
        v-model="queryParams.status"
        :localdata="statusOptions"
        placeholder="请选择状态"
        @change="handleQuery"
      />
    </view>

    <!-- 字典数据列表 -->
    <uni-list>
      <uni-list-item 
        v-for="(item, index) in dataList" 
        :key="index"
        :title="item.dictLabel"
        :note="item.dictValue"
        :rightText="item.status === '0' ? '启用' : '停用'"
        :showArrow="true"
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
import { listData, delData } from '@/api/dict'

export default {
  data() {
    return {
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        dictType: undefined,
        dictLabel: undefined,
        status: undefined
      },
      statusOptions: [
        { value: '0', text: '启用' },
        { value: '1', text: '停用' }
      ],
      dataList: [],
      total: 0
    }
  },
  onLoad(options) {
    this.queryParams.dictType = options.dictType
    this.getList()
  },
  methods: {
    getList() {
      listData(this.queryParams).then(response => {
        this.dataList = response.rows
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
    handleAdd() {
      uni.navigateTo({
        url: `/pages/system/dict/data/form?dictType=${this.queryParams.dictType}`
      })
    },
    handleUpdate(row) {
      uni.navigateTo({
        url: `/pages/system/dict/data/form?dictCode=${row.dictCode}`
      })
    },
    handleDelete(row) {
      uni.showModal({
        title: '提示',
        content: '确认删除该字典数据吗？',
        success: (res) => {
          if (res.confirm) {
            delData(row.dictCode).then(() => {
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