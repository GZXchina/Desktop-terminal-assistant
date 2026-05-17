<template>
  <view class="container">
    <uni-list>
      <uni-list-item 
        v-for="(item, index) in list" 
        :key="index"
        :title="item.userName"
        :note="`${item.ipaddr} | ${parseTime(item.loginTime)}`"
        :rightText="item.status === '0' ? '成功' : '失败'"
        :showArrow="true"
        @click="handleDetail(item)"
      >
        <template v-slot:footer>
          <button type="warn" size="mini" @click.stop="handleDelete(item)">删除</button>
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
import { list as listLogininfor, delLogininfor } from '@/api/monitor/logininfor'

export default {
  data() {
    return {
      queryParams: {
        pageNum: 1,
        pageSize: 10
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
      listLogininfor(this.queryParams).then(response => {
        this.list = response.rows
        this.total = response.total
      })
    },
    handlePageChange(e) {
      this.queryParams.pageNum = e.current
      this.getList()
    },
    handleDetail(row) {
      uni.navigateTo({
        url: `/pages/system/logininfor/detail?id=${row.infoId}`
      })
    },
    handleDelete(row) {
      uni.showModal({
        title: '提示',
        content: '确认删除该日志吗？',
        success: (res) => {
          if (res.confirm) {
            delLogininfor(row.infoId).then(() => {
              uni.showToast({ title: '删除成功' })
              this.getList()
            })
          }
        }
      })
    },
    parseTime(time) {
      const formattedTime = time.replace(/-/g, '/')
      return new Date(formattedTime).toLocaleString()
    }
  }
}
</script>

<style lang="scss">
.container {
  padding: 15px;
}
</style>