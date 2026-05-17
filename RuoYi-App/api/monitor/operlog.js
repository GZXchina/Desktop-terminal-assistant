import request from '@/utils/request'

// 查询操作日志列表
export function listOperlog(query) {
  return request({
    url: '/monitor/operlog/list',
    method: 'get',
    params: query
  })
}

// 查询操作日志详细
export function getOperlog(operId) {
  return request({
    url: '/monitor/operlog/' + operId,
    method: 'get'
  })
}

export function delOperlog(operId) {
  return request({
    url: '/monitor/operlog/' + operId,
    method: 'delete'
  })
}

export function cleanOperlog() {
  return request({
    url: '/monitor/operlog/clean',
    method: 'delete'
  })
}