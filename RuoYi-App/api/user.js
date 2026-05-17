import request from '@/utils/request'
import { parseStrEmpty } from "@/utils/ruoyi"


// 获取用户列表
export function listUser(query) {
  return request({
    url: '/system/user/list',
    method: 'get',
    params: query
  })
}

// 获取单个用户
export function getUser(userId) {
  return request({
    url: '/system/user/' + parseStrEmpty(userId),
    method: 'get'
  })
}

// 添加用户
export function addUser(data) {
  return request({
    url: '/system/user',
    method: 'post',
    data: data
  })
}

// 更新用户
export function updateUser(data) {
  return request({
    url: '/system/user',
    method: 'put',
    data: data
  })
}

// 删除用户
export function delUser(userId) {
  return request({
    url: '/system/user/' + userId,
    method: 'delete'
  })
}

// 重置密码
export function resetUserPwd(userId, password) {
  return request({
    url: '/system/user/resetPwd',
    method: 'put',
    data: { userId, password }
  })
}

// 修改用户状态
export function changeUserStatus(userId, status) {
  return request({
    url: '/system/user/changeStatus',
    method: 'put',
    data: { userId, status }
  })
}

// 获取用户个人信息
export function getUserProfile() {
  return request({
    url: '/system/user/profile',
    method: 'get'
  })
}

// 更新用户个人信息
export function updateUserProfile(data) {
  return request({
    url: '/system/user/profile',
    method: 'put',
    data: data
  })
}

// 更新密码
export function updateUserPwd(oldPassword, newPassword) {
  return request({
    url: '/system/user/profile/updatePwd',
    method: 'put',
    data: { oldPassword, newPassword }
  })
}

// 上传头像
export function uploadAvatar(data) {
  return request({
    url: '/system/user/profile/avatar',
    method: 'post',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    data: data
  })
}