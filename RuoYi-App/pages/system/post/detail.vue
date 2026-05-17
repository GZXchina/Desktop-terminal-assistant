<template>
  <view class="container">
    <uni-card title="岗位详情">
      <uni-list>
        <uni-list-item title="岗位编号" :rightText="post.postId" />
        <uni-list-item title="岗位名称" :rightText="post.postName" />
        <uni-list-item title="岗位编码" :rightText="post.postCode" />
        <uni-list-item title="岗位排序" :rightText="post.postSort" />
        <uni-list-item title="状态" :rightText="post.status === '0' ? '启用' : '停用'" />
        <uni-list-item title="创建时间" :rightText="post.createTime" />
        <uni-list-item title="备注" :rightText="post.remark" />
      </uni-list>
    </uni-card>

    <view class="footer">
      <button type="primary" @click="handleEdit">编辑</button>
    </view>
  </view>
</template>

<script>
import { getPost } from '@/api/system/post'

export default {
  data() {
    return {
      post: {}
    }
  },
  onLoad(options) {
    if (options.id) {
      this.getPost(options.id)
    }
  },
  methods: {
    getPost(postId) {
      getPost(postId).then(response => {
        this.post = response.data
      })
    },
    handleEdit() {
      uni.navigateTo({
        url: `/pages/system/post/form?id=${this.post.postId}`
      })
    }
  }
}
</script>

<style lang="scss">
.container {
  padding: 10px;
}

.footer {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 10px;
  background-color: #fff;
}
</style>