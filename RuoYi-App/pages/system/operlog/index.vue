<template>
  <view class="container">
    <!-- 搜索区域 -->
    <view class="search-box">
      <uni-search-bar 
        placeholder="请输入操作地址" 
        v-model="queryParams.operIp"
        @confirm="handleQuery"
      />
      <uni-search-bar 
        placeholder="请输入系统模块" 
        v-model="queryParams.title"
        @confirm="handleQuery"
      />
      <uni-data-select 
        v-model="queryParams.businessType"
        :localdata="businessTypeOptions"
        placeholder="请选择操作类型"
        @change="handleQuery"
      />
    </view>

    <!-- 日志列表 -->
    <uni-list>
      <uni-list-item 
        v-for="(item, index) in list" 
        :key="index"
        :title="item.title"
        :note="`${item.operName} | ${parseTime(item.operTime)}`"
        :rightText="item.status === '0' ? '成功' : '失败'"
        @click="handleView(item)"
      />
    </uni-list>

    <!-- 分页 -->
    <uni-pagination 
      :total="total"
      :current="queryParams.pageNum"
      :pageSize="queryParams.pageSize"
      @change="handlePageChange"
    />
  </view>
</template>

<script>
import { listOperlog } from '@/api/monitor/operlog'

export default {
  data() {
    return {
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        operIp: undefined,
        title: undefined,
        businessType: undefined
      },
      businessTypeOptions: [
        // ... 操作类型选项
      ],
      list: [],
      total: 0
    }
  },
  onLoad() {
    this.getList()
  },
  methods: {
    getList() {
      listOperlog(this.queryParams).then(response => {
        this.list = response.rows
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
    handleView(row) {
      uni.navigateTo({
        url: `/pages/system/operlog/detail?id=${row.operId}`
      })
    }
  }
}
</script>