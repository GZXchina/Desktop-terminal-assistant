<template>
  <view class="container">
    <view class="avatar-container">
      <image :src="tempAvatar || user.avatar" class="avatar" mode="aspectFill" />
      <button type="primary" @click="chooseImage">选择图片</button>
      <button type="primary" @click="uploadAvatar" :disabled="!tempAvatar">上传头像</button>
    </view>
  </view>
</template>

<script>
import { getUserProfile, uploadAvatar } from '@/api/system/user'

export default {
  data() {
    return {
      user: {
        avatar: ''
      },
      tempAvatar: ''
    }
  },
  onLoad() {
    this.getUserProfile()
  },
  methods: {
    getUserProfile() {
      getUserProfile().then(response => {
        this.user = response.data
      })
    },
    chooseImage() {
      uni.chooseImage({
        count: 1,
        sizeType: ['compressed'],
        sourceType: ['album', 'camera'],
        success: (res) => {
          this.tempAvatar = res.tempFilePaths[0]
        }
      })
    },
    uploadAvatar() {
      uni.uploadFile({
        url: `${process.env.VUE_APP_BASE_API}/system/user/profile/avatar`,
        filePath: this.tempAvatar,
        name: 'avatarfile',
        header: {
          'Authorization': 'Bearer ' + uni.getStorageSync('token')
        },
        success: () => {
          uni.showToast({ title: '头像上传成功' })
          this.getUserProfile()
          uni.navigateBack()
        }
      })
    }
  }
}
</script>

<style lang="scss">
.container {
  padding: 20px;
}

.avatar-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  
  .avatar {
    width: 200px;
    height: 200px;
    border-radius: 50%;
    margin-bottom: 20px;
  }
  
  button {
    margin-top: 10px;
    width: 100%;
  }
}
</style>