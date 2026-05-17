<template>
  <view class="container">
    <!-- 搜索区域 -->
    <view class="search-box">
      <uni-search-bar 
        placeholder="请输入菜单名称" 
        v-model="queryParams.menuName"
        @confirm="handleQuery"
      />
      <uni-data-select 
        v-model="queryParams.status"
        :localdata="statusOptions"
        placeholder="请选择状态"
        @change="handleQuery"
      />
    </view>

    <!-- 菜单列表 -->
    <uni-list>
      <uni-list-item 
        v-for="(item, index) in menuList" 
        :key="index"
        :title="item.menuName"
        :note="item.perms"
        :rightText="item.status === '0' ? '启用' : '停用'"
        :showArrow="true"
        @click="handleMenuClick(item)"
      >
        <template v-slot:footer>
          <view class="action-buttons">
            <uni-icons 
              type="compose" 
              size="20" 
              @click.stop="handleUpdate(item)"
            ></uni-icons>
            <uni-icons 
              type="plus" 
              size="20" 
              @click.stop="handleAdd(item)"
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
import { listMenu, delMenu } from '@/api/system/menu'

export default {
  data() {
    return {
      queryParams: {
        menuName: undefined,
        status: undefined
      },
      statusOptions: [
        { value: '0', text: '启用' },
        { value: '1', text: '停用' }
      ],
      menuList: []
    }
  },
  onLoad() {
    this.getList()
  },
  methods: {
    getList() {
      listMenu(this.queryParams).then(response => {
        this.menuList = response.data
      })
    },
    handleQuery() {
      this.getList()
    },
    handleMenuClick(row) {
      // 查看菜单详情
    },
    handleAdd(row) {
      uni.navigateTo({
        url: '/pages/system/menu/form' + (row ? `?parentId=${row.menuId}` : '')
      })
    },
    handleUpdate(row) {
      uni.navigateTo({
        url: `/pages/system/menu/form?menuId=${row.menuId}`
      })
    },
    handleDelete(row) {
      uni.showModal({
        title: '提示',
        content: '确认删除该菜单吗？',
        success: (res) => {
          if (res.confirm) {
            delMenu(row.menuId).then(() => {
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