---
name: "skill_compliance"
description: "Apply compliance review capabilities for legal documents, privacy policies, and regulatory requirements. Invoke when reviewing compliance with GDPR, CCPA, or other regulations."
---

# Compliance Review Skill

## 核心定义
审查法律文件、隐私政策和服务条款，确保符合各类法规（GDPR、CCPA 等），识别合规风险并提供整改建议。

## 技能能力
- **法规合规评估**：分析文档合规性、提供整改建议、合规差距分析
- **风险识别与缓解**：发现可能带来法律责任的条款、消费者保护问题、合同风险
- **最佳实践建议**：提供标准条款示例、优先级整改清单、法律依据引用

## 执行流程
1. **范围界定**：确定审查范围和适用法规
2. **现状评估**：收集现有政策、流程、技术措施
3. **差距分析**：对比法规要求，识别差距
4. **风险评估**：评估各项差距的风险等级
5. **整改规划**：制定整改计划，设定优先级
6. **实施验证**：执行整改，验证效果
7. **持续监控**：定期复查，跟踪法规变化

## 实践要点
1. **法规跟踪**：持续关注法规变化和执法趋势
2. **风险评估**：量化合规风险的发生概率和影响
3. **整改优先级**：高风险高概率优先处理
4. **文档记录**：合规决策和整改措施需留痕
5. **定期审查**：合规不是一次性工作，需定期复查

## 使用示例

### 示例 1：数据处理合规审查

**场景**：审查用户数据处理代码的GDPR合规性

```python
# 反例：不合规的数据处理
def register_user(user_data):
    # 问题1：未验证用户同意
    # 问题2：收集过多数据
    # 问题3：未记录处理日志
    user = User.create({
        "email": user_data["email"],
        "phone": user_data["phone"],
        "address": user_data["address"],  # 可能不需要
        "id_card": user_data["id_card"],  # 过度收集
    })
    
    # 问题4：未告知用户就共享给第三方
    crm_api.create_contact(user_data)
    
    # 问题5：日志包含敏感信息
    logger.info(f"User registered: {user_data}")
    
    return user

# 正确做法：GDPR合规的数据处理
def register_user(user_data, consent_records):
    """用户注册 - GDPR合规版本"""
    # 1. 验证同意（合法性基础）
    required_consents = ["terms_of_service", "privacy_policy", "data_processing"]
    for consent in required_consents:
        if not consent_records.get(consent):
            raise ConsentRequiredError(f"Missing required consent: {consent}")
    
    # 2. 数据最小化 - 只收集必要字段
    minimal_data = {
        "email": user_data.get("email"),
        "password_hash": hash_password(user_data.get("password")),
        "created_at": datetime.now(),
        "data_retention_until": datetime.now() + timedelta(days=365*7)
    }
    
    user = User.create(minimal_data)
    
    # 3. 记录同意（可审计）
    ConsentLog.create({
        "user_id": user.id,
        "consents": consent_records,
        "ip_address": get_client_ip(),
        "timestamp": datetime.now(),
        "version": "2024-01-v1"
    })
    
    # 4. 脱敏日志
    logger.info(f"User registered: user_id={user.id}, email_hash={hash_email(user.email)}")
    
    # 5. 第三方共享（仅在用户同意时）
    if consent_records.get("data_sharing_crm"):
        crm_api.create_contact({
            "email_hash": hash_email(user.email),  # 假名化
            "registration_date": datetime.now()
        })
    
    return user
```

### 示例 2：隐私政策框架设计

**场景**：设计符合GDPR的隐私政策框架

```markdown
## 隐私政策框架（GDPR合规）

### 1. 数据控制者信息
- 公司名称：[公司名]
- DPO联系方式：dpo@company.com

### 2. 数据收集清单

| 数据类型 | 用途 | 法律依据 | 保留期限 |
|---------|-----|---------|---------|
| 邮箱 | 账户创建、服务通知 | 合同履行 | 账户存续期+2年 |
| 手机号 | 安全验证 | 合同履行 | 账户存续期 |
| IP地址 | 安全防护 | 合法利益 | 30天 |
| Cookie | 功能实现 | 同意 | 按类型区分 |

### 3. 用户权利

**访问权**：获取数据副本（30天内响应）
**更正权**：修改不准确数据
**删除权**：要求删除数据（被遗忘权）
**携带权**：导出结构化数据
**反对权**：反对营销处理

### 4. 数据安全措施
- 传输加密（TLS 1.3）
- 存储加密（AES-256）
- 访问控制（最小权限）
- 定期安全审计

### 5. 第三方共享
仅在以下情况共享：
- 已签署数据处理协议（DPA）
- 用户明确同意
- 法律法规要求
```

### 示例 3：数据泄露应急响应

**场景**：制定数据泄露应急响应流程

```python
# 数据泄露应急响应处理
class DataBreachResponse:
    def __init__(self):
        self.notification_deadline = 72  # GDPR要求72小时内通知
    
    def handle_breach(self, breach_info):
        """处理数据泄露事件"""
        # 1. 遏制（Containment）
        self._isolate_affected_systems(breach_info.affected_systems)
        self._stop_data_leak(breach_info.source)
        
        # 2. 评估（Assessment）
        impact = self._assess_impact(
            data_types=breach_info.data_types,
            user_count=breach_info.affected_users,
            severity=breach_info.severity
        )
        
        # 3. 通知（Notification）
        if impact.severity in ['high', 'critical']:
            # 72小时内通知监管机构
            self._notify_regulator(
                authority=breach_info.jurisdiction_authority,
                deadline_hours=self.notification_deadline
            )
            
            # 通知受影响用户
            self._notify_users(
                users=breach_info.affected_users,
                impact_description=impact.description,
                mitigation_measures=impact.mitigation
            )
        
        # 4. 记录（Documentation）
        self._document_breach({
            "timestamp": datetime.now(),
            "type": breach_info.type,
            "impact": impact,
            "notifications": self.notification_log,
            "remediation": self.remediation_actions
        })
        
        return {"status": "contained", "impact_level": impact.severity}
```

### 示例 4：数据导出功能实现

**场景**：实现GDPR数据可携带权（数据导出）

```python
# 反例：不安全的导出实现
def export_user_data(user_id):
    user = User.get(user_id)
    # 问题1：未验证权限
    # 问题2：包含系统日志
    # 问题3：未加密传输
    return {
        "id": user.id,
        "email": user.email,
        "phone": user.phone,
        "orders": [o.to_dict() for o in user.orders],
        "logs": [l.to_dict() for l in user.activity_logs]  # 不应包含
    }

# 正确做法：合规的数据导出
def export_user_data(user_id, requester_id):
    """导出用户数据 - GDPR数据可携带权实现"""
    # 1. 权限验证
    if user_id != requester_id and not is_admin(requester_id):
        raise UnauthorizedError("无权导出此用户数据")
    
    # 2. 记录审计日志
    AuditLog.create({
        "action": "data_export",
        "user_id": user_id,
        "requester_id": requester_id,
        "timestamp": datetime.now(),
        "ip_address": get_client_ip()
    })
    
    # 3. 构建导出数据（结构化、通用格式）
    user = User.get(user_id)
    export_data = {
        "export_metadata": {
            "export_date": datetime.now().isoformat(),
            "format_version": "1.0"
        },
        "profile": {
            "id": user.id,
            "email": user.email,
            "created_at": user.created_at.isoformat()
        },
        "orders": [
            {
                "id": order.id,
                "total_amount": float(order.total_amount),
                "created_at": order.created_at.isoformat(),
                "items": [{"product_id": item.product_id, "quantity": item.quantity}]
            }
            for order in user.orders
        ]
        # 注意：不包含系统日志（属于系统数据）
    }
    
    # 4. 生成加密文件
    json_data = json.dumps(export_data, ensure_ascii=False, indent=2)
    encrypted_file = encrypt_export_file(json_data, user_id)
    
    # 5. 发送安全下载链接（24小时有效）
    download_link = generate_secure_download_link(encrypted_file, expires_in=86400)
    send_email(to=user.email, subject="数据导出完成", body=f"下载链接：{download_link}")
    
    return {"status": "completed"}
```

## 结构化分析框架

### 合规风险评估矩阵

| 风险类型 | 发生概率 | 影响程度 | 风险等级 | 优先级 |
|---------|---------|---------|---------|-------|
| 未获取有效同意 | 高 | 高 | 严重 | P0 |
| 数据泄露 | 中 | 高 | 高 | P1 |
| 超范围使用数据 | 高 | 中 | 高 | P1 |
| 未响应用户请求 | 中 | 中 | 中 | P2 |
| 日志保留过长 | 低 | 低 | 低 | P3 |

### 合规检查清单

```markdown
## GDPR合规检查清单

### 数据处理合法性
- [ ] 有明确的法律依据（同意/合同/法律义务/合法利益）
- [ ] 同意机制符合要求（自由给予、具体、知情、明确）
- [ ] 记录同意证据（时间、方式、范围）

### 数据主体权利
- [ ] 提供数据访问功能
- [ ] 提供数据更正功能
- [ ] 提供数据删除功能
- [ ] 提供数据导出功能
- [ ] 提供处理限制功能
- [ ] 30天内响应用户请求

### 数据安全
- [ ] 传输加密
- [ ] 存储加密
- [ ] 访问控制
- [ ] 日志脱敏
- [ ] 定期安全审计

### 第三方管理
- [ ] 签署数据处理协议（DPA）
- [ ] 评估第三方安全措施
- [ ] 记录第三方数据共享
```

## 约束与限制
- 合规要求因地区而异，需针对性处理
- 合规整改可能影响产品功能和用户体验
- 某些合规要求可能与其他要求冲突
- 合规不是一次性工作，需持续维护

## 自检清单
- [ ] 数据处理有合法依据
- [ ] 用户同意机制完善
- [ ] 数据最小化原则遵循
- [ ] 用户权利保障（访问/更正/删除/携带）
- [ ] 数据安全措施到位
- [ ] 第三方数据处理协议签署
- [ ] 数据保留期限明确
- [ ] 隐私政策完整且可访问

## 常见陷阱

### 陷阱 1：同意机制不完善

```python
# 反例：默认勾选或强制同意
class RegistrationForm:
    def __init__(self):
        self.marketing_consent = True  # 默认勾选（违规！）
    
    def render(self):
        return {
            'marketing': '<input type="checkbox" checked name="marketing">',
            'terms': '<input type="checkbox" required name="terms">'  # 强制同意
        }
    
    def register(self, data):
        user = create_user(data)
        # 未记录同意证据
        return user

# 正确做法：明确的同意机制
class RegistrationForm:
    def render(self):
        return {
            # 默认不勾选，用户必须主动选择
            'marketing': '<input type="checkbox" name="marketing">',
            'analytics': '<input type="checkbox" name="analytics">'
        }
    
    def register(self, data):
        # 记录详细的同意证据
        consent_record = {
            'timestamp': datetime.utcnow().isoformat(),
            'ip_address': data.get('ip_address'),
            'consents': {
                'marketing': data.get('marketing_consent', False),
                'analytics': data.get('analytics_consent', False)
            },
            'terms_version': '2024-01-15'
        }
        
        user = create_user(data)
        save_consent_record(user.id, consent_record)
        return user
```

### 陷阱 2：日志记录敏感信息

```python
# 反例：日志包含敏感信息
@app.route('/api/login', methods=['POST'])
def login():
    data = request.json
    # 危险：记录密码！
    logger.info(f"Login attempt: email={data['email']}, password={data['password']}")
    
    user = authenticate(data['email'], data['password'])
    return {'token': user.token}

# 正确做法：安全的日志记录
import hashlib

def mask_email(email):
    """脱敏邮箱"""
    if '@' not in email:
        return '[INVALID]'
    local, domain = email.split('@')
    masked_local = local[:2] + '***' if len(local) > 2 else '***'
    return f"{masked_local}@{domain}"

@app.route('/api/login', methods=['POST'])
def login():
    data = request.json
    
    # 安全日志：记录尝试但不记录密码
    email_hash = hashlib.sha256(data['email'].encode()).hexdigest()[:8]
    logger.info(f"Login attempt: email_hash={email_hash}")
    
    user = authenticate(data['email'], data['password'])
    
    # 记录成功，使用脱敏邮箱
    logger.info(f"Login success: email={mask_email(data['email'])}, user_id={user.id}")
    
    return {'token': user.token}
```

### 陷阱 3：数据保留期限不明确

```python
# 反例：无数据保留策略
def create_user(data):
    user = User.create(data)
    # 数据永久保留，无删除机制
    return user

# 正确做法：明确的数据保留策略
def create_user(data):
    user = User.create({
        **data,
        "data_retention_until": datetime.now() + timedelta(days=365*7),  # 7年
        "last_activity": datetime.now()
    })
    return user

# 定期清理任务
def cleanup_expired_data():
    """清理过期数据"""
    expired_users = User.filter(
        data_retention_until__lt=datetime.now()
    )
    
    for user in expired_users:
        # 匿名化或删除
        anonymize_user_data(user.id)
        logger.info(f"Cleaned up expired data for user: {user.id}")
```

### 陷阱 4：忽视用户权利请求

```python
# 反例：不提供数据删除功能
def delete_user(user_id):
    # 仅标记删除，实际数据仍在
    User.filter(id=user_id).update(is_deleted=True)

# 正确做法：完整的删除实现
def delete_user(user_id, requester_id):
    """处理用户删除请求（被遗忘权）"""
    # 验证权限
    if user_id != requester_id:
        raise UnauthorizedError()
    
    # 记录删除请求
    DeletionRequest.create({
        "user_id": user_id,
        "requested_at": datetime.now(),
        "status": "processing"
    })
    
    # 删除或匿名化数据
    user = User.get(user_id)
    
    # 1. 删除个人标识信息
    user.email = f"deleted_{user_id}@anonymized.com"
    user.phone = None
    user.name = "Deleted User"
    
    # 2. 保留匿名化后的交易记录（法律要求）
    for order in user.orders:
        order.user_id = None  # 解除关联
        order.save()
    
    # 3. 删除日志中的个人标识
    AuditLog.filter(user_id=user_id).update(user_id=None)
    
    # 4. 通知第三方删除
    notify_third_parties_to_delete(user_id)
    
    # 5. 完成记录
    logger.info(f"User data deleted: user_id={user_id}")
    
    return {"status": "deleted", "user_id": user_id}
```
