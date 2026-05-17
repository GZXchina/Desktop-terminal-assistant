<template>
  <view class="container">
    <uni-search-bar
      v-model="queryParams.dictLabel"
      placeholder="请输入字典标签"
      @confirm="handleQuery"
    />
    <uni-search-bar
      v-model="queryParams.dictValue"
      placeholder="请输入字典键值"
      @confirm="handleQuery"
    />
    
    <uni-list>
      <uni-list-item
        v-for="item in dictDataList"
        :key="item.dictCode"
        :title="item.dictLabel"
        :note="item.dictValue"
        :rightText="item.status === '0' ? '正常' : '停用'"
        clickable
        @click="handleUpdate(item)"
      />
    </uni-list>
    
    <uni-pagination
      :total="total"
      :current="queryParams.pageNum"
      :pageSize="queryParams.pageSize"
      @change="handlePageChange"
    />
    
    <uni-fab
      horizontal="right"
      vertical="bottom"
      @fabClick="handleAdd"
    />
  </view>
</template>

<script>
import { listData, delData } from '@/api/system/dict/data'

export default {
  data() {
    return {
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        dictLabel: undefined,
        dictValue: undefined,
        dictType: undefined
      },
      // 字典数据列表
      dictDataList: [],
      // 总条数
      total: 0
    }
  },
  onLoad(options) {
    if (options.dictType) {
      this.queryParams.dictType = options.dictType
    }
    this.getList()
  },
  methods: {
    // 获取字典数据列表
    getList() {
      listData(this.queryParams).then(response => {
        this.dictDataList = response.rows
        this.total = response.total
      })
    },
    // 新增按钮操作
    handleAdd() {
      uni.navigateTo({
        url: `/pages/system/config/data/form?dictType=${this.queryParams.dictType}`
      })
    },
    // 修改按钮操作
    handleUpdate(row) {
      uni.navigateTo({
        url: `/pages/system/config/data/form?dictCode=${row.dictCode}`
      })
    },
    // 分页操作
    handlePageChange(e) {
      this.queryParams.pageNum = e.current
      this.getList()
    },
    // 搜索操作
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    }
  }
}
</script>