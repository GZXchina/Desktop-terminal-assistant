<template>
  <view class="container">
    <uni-card :title="title">
      <uni-forms ref="form" :model="form" :rules="rules">
        <uni-forms-item label="岗位名称" name="postName">
          <uni-easyinput v-model="form.postName" placeholder="请输入岗位名称" />
        </uni-forms-item>
        <uni-forms-item label="岗位编码" name="postCode">
          <uni-easyinput v-model="form.postCode" placeholder="请输入岗位编码" />
        </uni-forms-item>
        <uni-forms-item label="岗位排序" name="postSort">
          <uni-number-box v-model="form.postSort" :min="0" />
        </uni-forms-item>
        <uni-forms-item label="岗位状态" name="status">
          <uni-data-select 
            v-model="form.status"
            :localdata="statusOptions"
          />
        </uni-forms-item>
        <uni-forms-item label="备注" name="remark">
          <uni-easyinput 
            type="textarea" 
            v-model="form.remark" 
            placeholder="请输入内容"
          />
        </uni-forms-item>
      </uni-forms>
    </uni-card>

    <view class="footer">
      <button type="primary" @click="submitForm">提交</button>
      <button @click="cancel">取消</button>
    </view>
  </view>
</template>

<script>
import { getPost, addPost, updatePost } from '@/api/system/post'

export default {
  data() {
    return {
      title: '',
      form: {
        postId: undefined,
        postName: '',
        postCode: '',
        postSort: 0,
        status: '0',
        remark: ''
      },
      statusOptions: [
        { value: '0', text: '启用' },
        { value: '1', text: '停用' }
      ],
      rules: {
        postName: { rules: [{ required: true, errorMessage: '岗位名称不能为空' }] },
        postCode: { rules: [{ required: true, errorMessage: '岗位编码不能为空' }] }
      }
    }
  },
  onLoad(options) {
    if (options.id) {
      this.title = '修改岗位'
      this.getPost(options.id)
    } else {
      this.title = '新增岗位'
    }
  },
  methods: {
    getPost(postId) {
      getPost(postId).then(response => {
        this.form = response.data
      })
    },
    submitForm() {
      this.$refs.form.validate().then(valid => {
        if (valid) {
          if (this.form.postId) {
            updatePost(this.form).then(() => {
              uni.showToast({ title: '修改成功' })
              uni.navigateBack()
            })
          } else {
            addPost(this.form).then(() => {
              uni.showToast({ title: '新增成功' })
              uni.navigateBack()
            })
          }
        }
      })
    },
    cancel() {
      uni.navigateBack()
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
  display: flex;
  justify-content: space-around;
}
</style>