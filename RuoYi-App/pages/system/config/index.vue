<template>
  <view class="container">
    <!-- 搜索区域 -->
    <view class="search-box">
      <uni-search-bar 
        placeholder="请输入参数名称" 
        v-model="queryParams.configName"
        @confirm="handleQuery"
      />
      <uni-search-bar 
        placeholder="请输入参数键名" 
        v-model="queryParams.configKey"
        @confirm="handleQuery"
      />
      <uni-data-select 
        v-model="queryParams.configType"
        :localdata="configTypeOptions"
        placeholder="请选择系统内置"
        @change="handleQuery"
      />
    </view>

    <!-- 参数列表 -->
    <uni-list>
      <uni-list-item 
        v-for="(item, index) in configList" 
        :key="index"
        :title="item.configName"
        :note="item.configKey"
        :rightText="item.configType === 'Y' ? '是' : '否'"
        :showArrow="true"
        @click="handleConfigClick(item)"
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
import { listConfig, delConfig } from '@/api/system/config'

export default {
  data() {
    return {
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        configName: undefined,
        configKey: undefined,
        configType: undefined
      },
      configTypeOptions: [
        { value: 'Y', text: '是' },
        { value: 'N', text: '否' }
      ],
      configList: [],
      total: 0
    }
  },
  onLoad() {
    this.getList()
  },
  methods: {
    getList() {
      listConfig(this.queryParams).then(response => {
        this.configList = response.rows
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
    handleConfigClick(row) {
      uni.navigateTo({
        url: `/pages/system/config/detail?id=${row.configId}`
      })
    },
    handleAdd() {
      uni.navigateTo({
        url: '/pages/system/config/form'
      })
    },
    handleUpdate(row) {
      uni.navigateTo({
        url: `/pages/system/config/form?id=${row.configId}`
      })
    },
    handleDelete(row) {
      uni.showModal({
        title: '提示',
        content: '确认删除该参数吗？',
        success: (res) => {
          if (res.confirm) {
            delConfig(row.configId).then(() => {
              uni.showToast({ title: '删除成功' })
              this.getList()
            })
          }
        }
      })
    },
    handleRefreshCache() {
      refreshCache().then(() => {
        uni.showToast({ title: "刷新成功" });
      });
    },
    handleExport() {
      this.download('system/config/export', {
        ...this.queryParams
      }, `config_${new Date().getTime()}.xlsx`)
    },
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.configId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
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