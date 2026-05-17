<template>
  <view class="container">
    <!-- 搜索区域 -->
    <view class="search-box">
      <uni-search-bar 
        placeholder="请输入部门名称" 
        v-model="queryParams.deptName"
        @confirm="handleQuery"
      />
      <uni-data-select 
        v-model="queryParams.status"
        :localdata="statusOptions"
        placeholder="请选择状态"
        @change="handleQuery"
      />
    </view>

    <!-- 部门列表 -->
    <uni-collapse>
      <uni-collapse-item 
        v-for="(item, index) in deptList" 
        :key="index"
        :title="item.deptName"
        :show-arrow="item.children && item.children.length > 0"
        :open="expandedKeys.has(item.deptId)"
        @click="toggleExpand(item)"
      >
        <template v-if="item.children && item.children.length > 0">
          <view v-for="(child, childIndex) in item.children" 
            :key="childIndex"
            :style="{paddingLeft: '20px'}"
          >
            <uni-collapse-item 
              :title="child.deptName"
              :show-arrow="child.children && child.children.length > 0"
              @click="toggleExpand(child)"
            >
              <template v-if="child.children && child.children.length > 0">
                <view v-for="(subChild, subIndex) in child.children" 
                  :key="subIndex"
                  :style="{paddingLeft: '40px'}"
                >
                  <uni-collapse-item 
                    :title="subChild.deptName"
                    @click="handleDeptClick(subChild)"
                  >
                    <view class="action-buttons">
                      <uni-icons type="compose" size="20" @click.stop="handleUpdate(subChild)"></uni-icons>
                      <uni-icons type="plus" size="20" @click.stop="handleAdd(subChild)"></uni-icons>
                      <uni-icons type="trash" size="20" @click.stop="handleDelete(subChild)"></uni-icons>
                    </view>
                  </uni-collapse-item>
                </view>
              </template>
              <view class="action-buttons">
                <uni-icons type="compose" size="20" @click.stop="handleUpdate(child)"></uni-icons>
                <uni-icons type="plus" size="20" @click.stop="handleAdd(child)"></uni-icons>
                <uni-icons type="trash" size="20" @click.stop="handleDelete(child)"></uni-icons>
              </view>
            </uni-collapse-item>
          </view>
        </template>
        
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
      </uni-collapse-item>
    </uni-collapse>

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
import { listDept, delDept } from '@/api/system/dept'

export default {
  data() {
    return {
      queryParams: {
        deptName: undefined,
        status: undefined
      },
      statusOptions: [
        { value: '0', text: '启用' },
        { value: '1', text: '停用' }
      ],
      deptList: [],
      isExpandAll: false,
      refreshTable: true,
      expandedKeys: new Set() // 添加用于记录展开状态的Set
    }
  },
  onLoad() {
    this.getList()
  },
  methods: {
    // 添加树形结构处理方法
    handleTree(data, id, parentId, children) {
      const config = {
        id: id || 'deptId',
        parentId: parentId || 'parentId',
        childrenList: children || 'children'
      }
      
      const childrenListMap = {}
      const nodeIds = {}
      const tree = []
      
      for (const d of data) {
        const parentId = d[config.parentId]
        if (childrenListMap[parentId] == null) {
          childrenListMap[parentId] = []
        }
        nodeIds[d[config.id]] = d
        childrenListMap[parentId].push(d)
      }
      
      for (const d of data) {
        const parentId = d[config.parentId]
        if (nodeIds[parentId] == null) {
          tree.push(d)
        }
      }
      
      function adaptToChildrenList(o) {
        if (childrenListMap[o[config.id]] !== null) {
          o[config.childrenList] = childrenListMap[o[config.id]]
        }
        if (o[config.childrenList]) {
          for (const c of o[config.childrenList]) {
            adaptToChildrenList(c)
          }
        }
      }
      
      for (const t of tree) {
        adaptToChildrenList(t)
      }
      
      return tree
    },
    // 添加展开/折叠方法
    toggleExpandAll() {
      this.refreshTable = false
      this.isExpandAll = !this.isExpandAll
      this.$nextTick(() => {
        this.refreshTable = true
      })
    },
    getList() {
      listDept(this.queryParams).then(response => {
        this.deptList = this.handleTree(response.data, "deptId", "parentId")
        this.expandedKeys.clear()
        // 添加这行确保视图更新
        this.$nextTick(() => {
          this.$forceUpdate()
        })
      })
    },
    handleQuery() {
      this.getList()
    },
    // 修改原有的handleDeptClick方法
    handleDeptClick(row) {
      if (!row.children || row.children.length === 0) {
        uni.navigateTo({
          url: `/pages/system/dept/detail?id=${row.deptId}`
        })
      }
    },
    handleAdd(row) {
      uni.navigateTo({
        url: '/pages/system/dept/form' + (row ? `?parentId=${row.deptId}` : '')
      })
    },
    handleUpdate(row) {
      uni.navigateTo({
        url: `/pages/system/dept/form?id=${row.deptId}`
      })
    },
    handleDelete(row) {
      uni.showModal({
        title: '提示',
        content: '确认删除该部门吗？',
        success: (res) => {
          if (res.confirm) {
            delDept(row.deptId).then(() => {
              uni.showToast({ title: '删除成功' })
              this.getList()
            })
          }
        }
      })
    },
    // 修改toggleExpand方法
    toggleExpand(item) {
      if (item.children && item.children.length > 0) {
        if (this.expandedKeys.has(item.deptId)) {
          this.expandedKeys.delete(item.deptId)
        } else {
          this.expandedKeys.add(item.deptId)
        }
        this.$forceUpdate()
      } else {
        this.handleDeptClick(item)
      }
    },
  }
}
</script>

<style lang="scss">
.container {
  padding: 10px;
}

.uni-collapse-item__content {
  /* 修改为自动高度 */
  height: auto !important;
  overflow: visible !important;
}

.uni-collapse-item__wrap {
  height: auto !important;
  overflow: hidden;
  transition: height 0.3s ease;
}

.uni-collapse-item__content {
  height: auto !important;
  overflow: visible !important;
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

/* 添加缩进样式 */
.collapse-item {
  .uni-collapse-item__title {
    padding-left: 20px;
  }
  
  .uni-collapse-item__content {
    padding-left: 40px;
  }
}
</style>