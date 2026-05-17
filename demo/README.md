# 工位搭子 · 项目 Demo

本目录提供**无需后端**即可体验的产品演示。

## Web 交互演示（推荐）

直接在浏览器打开 `index.html`：

```powershell
# Windows
Start-Process ".\demo\index.html"

# 或使用脚本
.\demo\start-demo.ps1
```

### 演示内容

| 模块 | 功能 |
|------|------|
| 门户 | 四大业务入口导航 |
| 状态监测 | AI 伙伴、专注度、呼吸、久坐、情绪曲线（数据自动刷新） |
| 设备遥控 | 虚拟摇杆、工作模式、主动关怀开关 |
| 记忆时光 | 语义搜索、记忆粉碎动画 |
| 企业关怀 | 团队报表、热力图、关怀下发 |

## 移动端演示（RuoYi-App）

1. 用 HBuilderX 打开 `RuoYi-App/`
2. 确认 `config.js` 中 `demoMode: true`
3. 运行到微信开发者工具或浏览器
4. 在登录页点击 **「体验 Demo（免后端）」**

业务页面已内置 Mock 数据，无需启动 RuoYi 后端。

### 关闭演示模式

将 `RuoYi-App/config.js` 中的 `demoMode` 设为 `false`，并配置正确的 `baseUrl` 后，使用正常账号登录。

## GitHub Pages（可选）

将 `demo/` 目录设为 Pages 源，即可在线访问 Web Demo。
