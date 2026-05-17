import request from '@/utils/request'

export function getDeviceList() {
  return request({
    url: '/device/list',
    method: 'get'
  })
}

export function getDeviceDetail(id) {
  return request({
    url: '/device/' + id,
    method: 'get'
  })
}

export function controlDevice(data) {
  return request({
    url: '/device/control',
    method: 'post',
    data: data
  })
}

export function setDeviceMode(data) {
  return request({
    url: '/device/mode',
    method: 'post',
    data: data
  })
}

export function updateCareSettings(data) {
  return request({
    url: '/device/care',
    method: 'put',
    data: data
  })
}

export function updateVoiceSettings(data) {
  return request({
    url: '/device/voice',
    method: 'put',
    data: data
  })
}
