<template>
  <view class="container">
    <!-- 搜索区域 -->
    <view class="search-box">
      <uni-search-bar 
        placeholder="请输入字典名称" 
        v-model="queryParams.dictName"
        @confirm="handleQuery"
      />
      <uni-search-bar 
        placeholder="请输入字典类型" 
        v-model="queryParams.dictType"
        @confirm="handleQuery"
      />
      <uni-data-select 
        v-model="queryParams.status"
        :localdata="statusOptions"
        placeholder="请选择状态"
        @change="handleQuery"
      />
    </view>

    <!-- 字典类型列表 -->
    <uni-list>
      <uni-list-item 
        v-for="(item, index) in dictList" 
        :key="index"
        :title="item.dictName"
        :note="item.dictType"
        :rightText="item.status === '0' ? '启用' : '停用'"
        :showArrow="true"
        @click="handleDictClick(item)"
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
import { listType, delType } from '@/api/dict'

export default {
  data() {
    return {
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        dictName: undefined,
        dictType: undefined,
        status: undefined
      },
      statusOptions: [
        { value: '0', text: '启用' },
        { value: '1', text: '停用' }
      ],
      dictList: [],
      total: 0
    }
  },
  onLoad() {
    this.getList()
  },
  methods: {
    getList() {
      listType(this.queryParams).then(response => {
        this.dictList = response.rows
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
    handleDictClick(row) {
      uni.navigateTo({
        url: `/pages/system/dict/data/index?dictId=${row.dictId}`
      })
    },
    handleAdd() {
      uni.navigateTo({
        url: '/pages/system/dict/form'
      })
    },
    handleUpdate(row) {
      uni.navigateTo({
        url: `/pages/system/dict/form?dictId=${row.dictId}`
      })
    },
    handleDelete(row) {
      uni.showModal({
        title: '提示',
        content: '确认删除该字典类型吗？',
        success: (res) => {
          if (res.confirm) {
            delType(row.dictId).then(() => {
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