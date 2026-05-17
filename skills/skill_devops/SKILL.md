---
name: "skill_devops"
description: "Apply DevOps capabilities for building automated infrastructure, CI/CD pipelines, and monitoring systems. Invoke when setting up deployment automation, cloud infrastructure, or observability."
---

# DevOps技能 (DevOps)

## 核心定义
构建自动化基础设施、CI/CD流水线和监控系统，实现快速、可靠、安全的软件交付。

## 技能能力
- **CI/CD流水线**：自动化构建、测试、部署，支持回滚策略
- **云基础设施配置**：IaC（Terraform/Pulumi）、网络配置、权限管理
- **监控与可观测性**：日志聚合、分布式追踪、SLO仪表盘、告警规则
- **部署自动化**：蓝绿部署、金丝雀发布、滚动更新
- **容器化**：Docker、Kubernetes、服务网格

## 执行流程
```
1. 需求分析 → 部署频率、环境数量、合规要求
2. 流水线设计 → 构建、测试、部署阶段
3. 基础设施配置 → IaC定义、网络规划
4. 监控设计 → 指标采集、告警规则、仪表盘
5. 安全集成 → 镜像扫描、密钥管理
6. 文档输出 → 运维手册、应急预案
```

## 实践要点
1. **自动化优先**：所有操作都应该自动化，减少人工干预
2. **基础设施即代码**：所有配置都版本化管理
3. **可观测性**：日志、指标、追踪三位一体
4. **安全左移**：安全扫描前置到开发阶段
5. **快速回滚**：任何变更都能快速回退

## 使用示例

### 示例 1：CI/CD流水线

```yaml
# .github/workflows/deploy.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  # 代码质量检查
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run type-check
      - run: npm run test:unit -- --coverage

  # 构建与镜像
  build:
    needs: lint-and-test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v5
        with:
          push: true
          tags: ghcr.io/${{ github.repository }}:${{ github.sha }}

  # 安全扫描
  security-scan:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: aquasecurity/trivy-action@master
        with:
          image-ref: ghcr.io/${{ github.repository }}:${{ github.sha }}

  # 部署到开发环境
  deploy-dev:
    needs: [build, security-scan]
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    environment: development
    steps:
      - run: echo "Deploying to dev"

  # 部署到生产环境
  deploy-prod:
    needs: [build, security-scan]
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - run: echo "Deploying to production"
```

### 示例 2：监控告警配置

```yaml
# prometheus-rules.yml
groups:
  - name: service-alerts
    rules:
      # 服务可用性告警
      - alert: ServiceDown
        expr: up{job="api-service"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "服务 {{ $labels.instance }} 宕机"
          description: "服务已宕机超过1分钟"

      # 高错误率告警
      - alert: HighErrorRate
        expr: |
          sum(rate(http_requests_total{status=~"5.."}[5m])) 
          / sum(rate(http_requests_total[5m])) > 0.05
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "高错误率 detected"
          description: "错误率超过5%"

      # 响应时间告警
      - alert: HighLatency
        expr: histogram_quantile(0.95, 
          sum(rate(http_request_duration_seconds_bucket[5m])) by (le)) > 0.5
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "高延迟 detected"
          description: "P95响应时间超过500ms"
```

### 示例 3：Dockerfile最佳实践

```dockerfile
# 反例：不安全的Dockerfile
FROM node:latest
COPY . /app
RUN npm install
CMD npm start

# 正确做法：多阶段构建 + 安全优化
# 构建阶段
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# 运行阶段
FROM node:18-alpine
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001
WORKDIR /app

COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --chown=nextjs:nodejs . .

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

USER nextjs
EXPOSE 3000
ENV NODE_ENV=production
CMD ["node", "server.js"]
```

### 示例 4：部署问题排查

```bash
# Pod启动失败排查流程

# 1. 查看Pod状态
kubectl get pods
# NAME                    READY   STATUS             RESTARTS   AGE
# api-service-xxx         0/1     CrashLoopBackOff   5          10m

# 2. 查看Pod事件
kubectl describe pod api-service-xxx
# Events:
#   Warning  Failed     5m    kubelet     Failed to pull image
#   Warning  BackOff    1m    kubelet     Back-off restarting failed container

# 3. 查看容器日志
kubectl logs api-service-xxx --previous
# Error: Cannot find module 'express'

# 4. 进入容器调试
kubectl exec -it api-service-xxx -- /bin/sh

# 常见原因和解决方案：
# ┌─────────────────────┬────────────────────────────────────┐
# │ 症状                │ 解决方案                           │
# ├─────────────────────┼────────────────────────────────────┤
# │ ImagePullBackOff    │ 检查镜像名称和仓库权限              │
# │ CrashLoopBackOff    │ 查看日志，修复应用错误              │
# │ OOMKilled           │ 增加内存限制或优化应用              │
# │ Pending             │ 检查资源配额和节点资源              │
# │ ErrImagePull        │ 检查镜像是否存在和网络连通性        │
# └─────────────────────┴────────────────────────────────────┘
```

## 结构化分析框架

### CI/CD流水线评估维度

| 维度 | 评估要点 | 通过标准 |
|-----|---------|---------|
| 自动化程度 | 构建/测试/部署自动化 | 全流程无人值守 |
| 安全集成 | 镜像扫描/密钥管理 | 高危漏洞阻断部署 |
| 可观测性 | 日志/指标/告警 | 问题可快速定位 |
| 回滚能力 | 回滚方案/演练 | 5分钟内完成回滚 |
| 环境一致性 | 开发/测试/生产 | 配置统一，差异可控 |

### 部署策略选择矩阵

| 策略 | 适用场景 | 风险 | 复杂度 |
|-----|---------|------|-------|
| 滚动更新 | 小变更、低风险 | 中 | 低 |
| 蓝绿部署 | 大变更、需快速回滚 | 低 | 中 |
| 金丝雀发布 | 新功能验证、A/B测试 | 低 | 高 |
| 影子流量 | 性能对比、风险验证 | 无 | 高 |

## 约束与限制
- 生产部署需要人工审批
- 镜像必须扫描后才能部署
- 密钥不能硬编码在配置中
- 变更必须可回滚
- 监控告警必须配置

## 自检清单
- [ ] CI/CD覆盖构建/测试/部署全流程
- [ ] 有回滚方案且已验证
- [ ] 监控告警配置完整
- [ ] 密钥管理安全
- [ ] 日志收集完整
- [ ] 灾难恢复演练通过
- [ ] 镜像已安全扫描
- [ ] 文档和运维手册完整

## 常见陷阱

### 陷阱 1：硬编码密钥

```yaml
# 反例：硬编码密钥在配置文件中
# docker-compose.yml
services:
  app:
    image: myapp:latest
    environment:
      DATABASE_URL: "postgres://admin:SuperSecret123@db:5432/myapp"
      AWS_ACCESS_KEY: "AKIAIOSFODNN7EXAMPLE"

# 正确做法：使用环境变量或密钥管理服务
services:
  app:
    image: myapp:latest
    environment:
      DATABASE_URL: ${DATABASE_URL}
      AWS_ACCESS_KEY: ${AWS_ACCESS_KEY}
    secrets:
      - db_password

secrets:
  db_password:
    external: true
```

### 陷阱 2：无回滚方案

```yaml
# 反例：没有回滚方案的部署
jobs:
  deploy:
    steps:
      - name: Deploy
        run: |
          kubectl set image deployment/myapp myapp=myapp:${{ github.sha }}
          kubectl rollout status deployment/myapp
      # 没有健康检查，部署失败无法自动回滚

# 正确做法：安全的部署流程
jobs:
  deploy:
    steps:
      - name: Security Scan
        run: trivy image myapp:${{ github.sha }}
      
      - name: Deploy to Staging
        run: |
          helm upgrade --install myapp ./chart \
            --set image.tag=${{ github.sha }} \
            --wait --timeout=5m
      
      - name: Smoke Tests
        run: curl -f https://staging.example.com/health
      
      - name: Canary Deploy (10%)
        run: |
          helm upgrade --install myapp ./chart \
            --set image.tag=${{ github.sha }} \
            --set canary.enabled=true \
            --set canary.weight=10
      
      - name: Full Deploy or Rollback
        run: |
          if ./check-metrics.sh; then
            helm upgrade --install myapp ./chart --set image.tag=${{ github.sha }}
          else
            helm rollback myapp 0
            exit 1
          fi
```

### 陷阱 3：忽视安全扫描

```yaml
# 反例：不进行安全扫描
jobs:
  build:
    steps:
      - name: Build
        run: docker build -t myapp:latest .
      - name: Deploy
        run: kubectl set image deployment/myapp myapp=myapp:latest

# 正确做法：安全扫描前置
jobs:
  build:
    steps:
      - name: Build
        run: docker build -t myapp:${{ github.sha }} .
      
      - name: Security Scan
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: myapp:${{ github.sha }}
          exit-code: '1'  # 发现漏洞时失败
          severity: 'CRITICAL,HIGH'
      
      - name: Deploy
        run: kubectl set image deployment/myapp myapp=myapp:${{ github.sha }}
```

### 陷阱 4：监控缺失

```yaml
# 反例：上线后无法感知问题
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: myapp
          image: myapp:latest
          # 没有健康检查，没有资源限制，没有监控

# 正确做法：完整的可观测性配置
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: myapp
          image: myapp:latest
          resources:
            requests:
              memory: "128Mi"
              cpu: "100m"
            limits:
              memory: "512Mi"
              cpu: "500m"
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /ready
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 5
```

### 陷阱 5：环境不一致

```yaml
# 反例：各环境配置差异大
# docker-compose.dev.yml (开发环境)
services:
  app:
    image: myapp:dev
    environment:
      DB_HOST: localhost
      CACHE_ENABLED: false

# docker-compose.prod.yml (生产环境)
services:
  app:
    image: myapp:latest
    environment:
      DB_HOST: prod-db.internal
      CACHE_ENABLED: true
      # 配置差异大，开发环境无法验证生产配置

# 正确做法：统一配置模板，差异参数化
# docker-compose.yml
services:
  app:
    image: myapp:${IMAGE_TAG:-latest}
    environment:
      DB_HOST: ${DB_HOST}
      CACHE_ENABLED: ${CACHE_ENABLED:-true}
      LOG_LEVEL: ${LOG_LEVEL:-info}
```
