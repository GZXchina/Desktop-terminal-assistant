import request from '@/utils/request'

export function getTeamHealthData() {
  return request({
    url: '/enterprise/health',
    method: 'get'
  })
}

export function getFocusHeatmap() {
  return request({
    url: '/enterprise/heatmap',
    method: 'get'
  })
}

export function sendCareNotification(data) {
  return request({
    url: '/enterprise/care',
    method: 'post',
    data: data
  })
}

export function getNotificationHistory() {
  return request({
    url: '/enterprise/history',
    method: 'get'
  })
}
