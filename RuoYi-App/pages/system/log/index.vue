<template>
  <view class="container">
    <uni-segmented-control 
      :current="currentTab" 
      :values="tabs" 
      @clickItem="handleTabChange"
    />
    
    <!-- 操作日志 -->
    <view v-if="currentTab === 0">
      <uni-card>
        <uni-list>
          <uni-list-item 
            v-for="(item, index) in operList" 
            :key="index"
            :title="item.title"
            :note="`${item.operName} | ${parseTime(item.operTime)}`"
            :rightText="item.status === '0' ? '成功' : '失败'"
            :showArrow="true"
            @click="handleView(item)"
          >
            <template v-slot:footer>
              <button type="warn" size="mini" @click.stop="handleDelete(item, 'oper')">删除</button>
            </template>
          </uni-list-item>
        </uni-list>
        <uni-pagination 
          :total="operTotal"
          :current="operQueryParams.pageNum"
          :pageSize="operQueryParams.pageSize"
          @change="handlePageChange"
        />
      </uni-card>
    </view>
    
    <!-- 登录日志 -->
    <view v-else>
      <uni-card>
        <uni-list>
          <uni-list-item 
            v-for="(item, index) in loginList" 
            :key="index"
            :title="item.userName"
            :note="`${item.ipaddr} | ${parseTime(item.loginTime)}`"
            :rightText="item.status === '0' ? '成功' : '失败'"
            :showArrow="true"
            @click="handleView(item)"
          >
            <template v-slot:footer>
              <button type="warn" size="mini" @click.stop="handleDelete(item, 'login')">删除</button>
            </template>
          </uni-list-item>
        </uni-list>
        <uni-pagination 
          :total="loginTotal"
          :current="loginQueryParams.pageNum"
          :pageSize="loginQueryParams.pageSize"
          @change="handlePageChange"
        />
      </uni-card>
    </view>
  </view>
</template>

<script>
import { listOperlog, delOperlog } from '@/api/monitor/operlog'
import { listLogininfor, delLogininfor } from '@/api/monitor/logininfor'

export default {
  data() {
    return {
      currentTab: 0,
      tabs: ['操作日志', '登录日志'],
      operQueryParams: {
        pageNum: 1,
        pageSize: 10
      },
      loginQueryParams: {
        pageNum: 1,
        pageSize: 10  
      },
      operList: [],
      loginList: [],
      operTotal: 0,
      loginTotal: 0
    }
  },
  onLoad() {
    this.loadData()
  },
  methods: {
    loadData() {
      if(this.currentTab === 0) {
        listOperlog(this.operQueryParams).then(response => {
          this.operList = response.rows
          this.operTotal = response.total
        })
      } else {
        listLogininfor(this.loginQueryParams).then(response => {
          this.loginList = response.rows
          this.loginTotal = response.total
        }).catch(error => {
          console.error('获取登录日志失败:', error)
          uni.showToast({
            title: '获取日志失败',
            icon: 'none'
          })
        })
      }
    },
    handleTabChange(e) {
      this.currentTab = e.currentIndex
      this.loadData()
    },
    handlePageChange(e) {
      if(this.currentTab === 0) {
        this.operQueryParams.pageNum = e.current
      } else {
        this.loginQueryParams.pageNum = e.current
      }
      this.loadData()
    },
    handleView(row) {
      const path = this.currentTab === 0 ? 'operlog' : 'logininfor'
      uni.navigateTo({
        url: `/pages/system/${path}/detail?id=${row.operId || row.infoId}`
      })
    },
    handleDelete(row, type) {
      uni.showModal({
        title: '提示',
        content: '确认删除该日志吗？',
        success: (res) => {
          if (res.confirm) {
            const deleteApi = type === 'oper' ? delOperlog : delLogininfor
            const id = type === 'oper' ? row.operId : row.infoId
            deleteApi(id).then(() => {
              uni.showToast({ title: '删除成功' })
              this.loadData()
            })
          }
        }
      })
    },
    parseTime(time) {
      // 将"yyyy-MM-dd HH:mm:ss"转换为iOS兼容格式
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
.action-buttons {
  margin-top: 15px;
  display: flex;
  gap: 10px;
}
</style>