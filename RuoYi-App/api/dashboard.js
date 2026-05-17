import request from '@/utils/request'

export function getDashboardData() {
    return request({
        url: '/dashboard/data',
        method: 'get'
    })
}

export function getRealtimeStatus() {
    return request({
        url: '/dashboard/realtime',
        method: 'get'
    })
}

export function getHealthData() {
    return request({
        url: '/dashboard/health',
        method: 'get'
    })
}

export function getEmotionData() {
    return request({
        url: '/dashboard/emotion',
        method: 'get'
    })
}

export function getAiPartnerStatus() {
    return request({
        url: '/dashboard/partner',
        method: 'get'
    })
}