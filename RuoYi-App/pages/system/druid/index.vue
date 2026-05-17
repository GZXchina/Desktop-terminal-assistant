<template>
  <web-view :src="url"></web-view>
</template>

<script>
export default {
  data() {
    return {
      url: process.env.VUE_APP_BASE_API + '/druid/login.html'
    }
  }
}
</script>