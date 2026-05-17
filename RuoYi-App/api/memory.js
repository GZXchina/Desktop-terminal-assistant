import request from '@/utils/request'

export function getMemoryList(params) {
  return request({
    url: '/memory/list',
    method: 'get',
    params: params
  })
}

export function searchMemory(keyword) {
  return request({
    url: '/memory/search',
    method: 'get',
    params: { keyword }
  })
}

export function getMemoryDetail(id) {
  return request({
    url: '/memory/' + id,
    method: 'get'
  })
}

export function deleteMemory(id) {
  return request({
    url: '/memory/' + id,
    method: 'delete'
  })
}
