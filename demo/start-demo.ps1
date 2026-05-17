# 启动工位搭子 Web Demo
$demoPath = Join-Path $PSScriptRoot "index.html"
if (-not (Test-Path $demoPath)) {
    Write-Error "找不到 demo/index.html"
    exit 1
}
Write-Host "正在打开工位搭子 Demo: $demoPath"
Start-Process $demoPath
