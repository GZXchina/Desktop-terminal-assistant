<template>
  <view class="container">
    <uni-section title="定时任务" type="line"></uni-section>
    
    <uni-search-bar 
      placeholder="请输入任务名称" 
      v-model="queryParams.jobName"
      @confirm="handleQuery"
    />
    
    <uni-list>
      <uni-list-item 
        v-for="(item, index) in jobList" 
        :key="index"
        :title="item.jobName"
        :note="item.invokeTarget"
        :rightText="item.status === '0' ? '运行中' : '暂停'"
        :showArrow="true"
        @click="handleDetail(item)"
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
    
    <uni-pagination 
      :total="total"
      :current="queryParams.pageNum"
      :pageSize="queryParams.pageSize"
      @change="handlePageChange"
    />
    
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
import { listJob } from '@/api/monitor/job'

export default {
  data() {
    return {
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        jobName: undefined,
        jobGroup: undefined,
        status: undefined
      },
      jobList: [],
      total: 0
    }
  },
  onLoad() {
    this.getList()
  },
  methods: {
    getList() {
      listJob(this.queryParams).then(response => {
        this.jobList = response.rows
        this.total = response.total
      })
    },
    // ... existing code ...
  }
}
</script>