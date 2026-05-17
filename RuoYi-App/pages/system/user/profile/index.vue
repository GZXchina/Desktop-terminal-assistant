<template>
  <view class="container">
    <uni-card>
      <view class="avatar-section">
        <image :src="user.avatar" class="avatar" @click="changeAvatar" />
        <text class="nickname">{{ user.nickName }}</text>
      </view>
      
      <uni-list>
        <uni-list-item title="个人信息" showArrow @click="navigateTo('info')" />
        <uni-list-item title="修改密码" showArrow @click="navigateTo('resetPwd')" />
      </uni-list>
    </uni-card>
  </view>
</template>

<script>
import { getUserProfile } from '@/api/system/user'

export default {
  data() {
    return {
      user: {
        nickName: '',
        avatar: ''
      }
    }
  },
  onShow() {
    this.getUserProfile()
  },
  methods: {
    getUserProfile() {
      getUserProfile().then(response => {
        this.user = response.data
      })
    },
    changeAvatar() {
      uni.navigateTo({
        url: '/pages/system/user/profile/avatar'
      })
    },
    navigateTo(type) {
      uni.navigateTo({
        url: `/pages/system/user/profile/${type}`
      })
    }
  }
}
</script>

<style lang="scss">
.container {
  padding: 10px;
}

.avatar-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px 0;
  
  .avatar {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    margin-bottom: 10px;
  }
  
  .nickname {
    font-size: 16px;
    font-weight: bold;
  }
}
</style>