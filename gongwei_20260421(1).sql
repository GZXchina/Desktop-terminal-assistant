-- ========================================================
-- 工位搭子 —— 融合数据库设计
-- 基于 RuoYi-Vue + xiaozhi-esp32-server + MimiClaw 整合
-- 版本: v1.0
-- 日期: 2026-04-21
-- 设计原则: 扁平化、一功能一表、复用 RuoYi 基础表
-- ========================================================

-- ========================================================
-- 一、设备管理模块 (复用并扩展 ai_device)
-- ========================================================

-- 1.1 设备信息主表（扩展 xiaozhi 的 ai_device）
DROP TABLE IF EXISTS `gw_device`;
CREATE TABLE `gw_device` (
    `id` VARCHAR(32) NOT NULL COMMENT '设备唯一标识',
    `user_id` BIGINT COMMENT '所属用户ID（关联sys_user）',
    `mac_address` VARCHAR(50) COMMENT 'MAC地址',
    `device_name` VARCHAR(64) DEFAULT '' COMMENT '设备名称',
    `device_remark` VARCHAR(255) DEFAULT NULL COMMENT '设备备注',
    `board_type` VARCHAR(50) DEFAULT 'esp32s3' COMMENT '硬件型号：esp32s3/rk3576',
    `firmware_version` VARCHAR(20) DEFAULT '' COMMENT '固件版本号',
    `agent_id` VARCHAR(32) DEFAULT NULL COMMENT '当前绑定智能体ID',
    `work_mode` TINYINT DEFAULT 1 COMMENT '工作模式：1单聊模式 2大厅模式',
    `auto_update` TINYINT UNSIGNED DEFAULT 0 COMMENT '自动OTA开关：0关闭 1开启',
    `last_connected_at` DATETIME COMMENT '最后连接时间',
    `online_status` TINYINT DEFAULT 0 COMMENT '在线状态：0离线 1在线',
    `ptz_horizontal` INT DEFAULT 0 COMMENT '云台水平角度：-90~+90',
    `ptz_vertical` INT DEFAULT 0 COMMENT '云台垂直角度：-30~+60',
    `theme_code` VARCHAR(20) DEFAULT '' COMMENT '当前节气主题编码',
    `theme_auto` TINYINT DEFAULT 1 COMMENT '自动跟随节气：0关闭 1开启',
    `voice_volume` INT DEFAULT 80 COMMENT '音量：0-100',
    `voice_speed` TINYINT DEFAULT 2 COMMENT '语速：1慢 2正常 3快',
    `voice_timbre_id` VARCHAR(32) DEFAULT NULL COMMENT '当前音色ID',
    `wake_word` VARCHAR(50) DEFAULT '你好小智' COMMENT '唤醒词',
    `scene_camera` TINYINT DEFAULT 0 COMMENT '摄像头开关：0关闭 1开启',
    `scene_recognition_freq` INT DEFAULT 15 COMMENT '场景识别频率：分钟',
    `productivity_mode` TINYINT DEFAULT 1 COMMENT '算力模式：1官方云 2本地算力',
    `local_compute_addr` VARCHAR(255) DEFAULT NULL COMMENT '本地算力地址',
    `local_compute_token` VARCHAR(255) DEFAULT NULL COMMENT '本地算力Token',
    `workspace_path` VARCHAR(255) DEFAULT NULL COMMENT 'Workspace路径',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `del_flag` TINYINT DEFAULT 0 COMMENT '删除标志：0存在 2删除',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_device_user_id` (`user_id`),
    INDEX `idx_gw_device_mac` (`mac_address`),
    INDEX `idx_gw_device_online` (`online_status`),
    INDEX `idx_gw_device_agent` (`agent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工位搭子设备信息表';

-- 1.2 设备插件映射表
DROP TABLE IF EXISTS `gw_device_plugin`;
CREATE TABLE `gw_device_plugin` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `device_id` VARCHAR(32) NOT NULL COMMENT '设备ID',
    `plugin_id` VARCHAR(32) NOT NULL COMMENT '插件ID',
    `plugin_name` VARCHAR(64) DEFAULT '' COMMENT '插件名称',
    `plugin_version` VARCHAR(20) DEFAULT '' COMMENT '插件版本',
    `param_info` JSON COMMENT '插件参数配置',
    `enabled` TINYINT DEFAULT 1 COMMENT '启用状态：0禁用 1启用',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_device_plugin` (`device_id`, `plugin_id`),
    INDEX `idx_gw_device_plugin_device` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备插件映射表';

-- 1.3 OTA固件版本表
DROP TABLE IF EXISTS `gw_ota_firmware`;
CREATE TABLE `gw_ota_firmware` (
    `id` VARCHAR(32) NOT NULL COMMENT '固件唯一标识',
    `firmware_name` VARCHAR(100) DEFAULT '' COMMENT '固件名称',
    `firmware_type` VARCHAR(50) DEFAULT '' COMMENT '固件类型：device/esp32s3/rk3576',
    `version` VARCHAR(50) NOT NULL COMMENT '版本号',
    `version_code` INT DEFAULT 0 COMMENT '版本码（用于比较）',
    `file_size` BIGINT DEFAULT 0 COMMENT '文件大小（字节）',
    `file_path` VARCHAR(255) DEFAULT '' COMMENT '固件存储路径',
    `file_md5` VARCHAR(32) DEFAULT '' COMMENT '文件MD5校验',
    `release_note` TEXT COMMENT '发布说明',
    `force_update` TINYINT DEFAULT 0 COMMENT '强制更新：0否 1是',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0停用 1启用',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `del_flag` TINYINT DEFAULT 0 COMMENT '删除标志',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_ota_type_version` (`firmware_type`, `version_code`),
    INDEX `idx_gw_ota_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OTA固件版本表';

-- 1.4 OTA升级记录表
DROP TABLE IF EXISTS `gw_ota_record`;
CREATE TABLE `gw_ota_record` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '记录ID',
    `device_id` VARCHAR(32) NOT NULL COMMENT '设备ID',
    `firmware_id` VARCHAR(32) NOT NULL COMMENT '固件ID',
    `from_version` VARCHAR(50) DEFAULT '' COMMENT '原版本号',
    `to_version` VARCHAR(50) NOT NULL COMMENT '目标版本号',
    `upgrade_status` TINYINT DEFAULT 0 COMMENT '升级状态：0待升级 1升级中 2成功 3失败 4已取消',
    `progress` INT DEFAULT 0 COMMENT '升级进度：0-100',
    `error_msg` VARCHAR(500) DEFAULT '' COMMENT '错误信息',
    `start_time` DATETIME COMMENT '开始时间',
    `complete_time` DATETIME COMMENT '完成时间',
    `create_time` DATETIME COMMENT '创建时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_ota_record_device` (`device_id`),
    INDEX `idx_gw_ota_record_status` (`upgrade_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OTA升级记录表';

-- 1.5 设备批量操作任务表
DROP TABLE IF EXISTS `gw_device_batch_task`;
CREATE TABLE `gw_device_batch_task` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '任务ID',
    `task_type` TINYINT NOT NULL COMMENT '任务类型：1批量解绑 2批量OTA',
    `task_name` VARCHAR(100) DEFAULT '' COMMENT '任务名称',
    `device_ids` JSON NOT NULL COMMENT '设备ID列表',
    `task_status` TINYINT DEFAULT 0 COMMENT '任务状态：0待执行 1执行中 2完成 3失败',
    `total_count` INT DEFAULT 0 COMMENT '总设备数',
    `success_count` INT DEFAULT 0 COMMENT '成功数',
    `fail_count` INT DEFAULT 0 COMMENT '失败数',
    `result_detail` JSON COMMENT '执行结果详情',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `complete_time` DATETIME COMMENT '完成时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_batch_task_type` (`task_type`),
    INDEX `idx_gw_batch_task_status` (`task_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备批量操作任务表';

-- ========================================================
-- 二、智能体管理模块
-- ========================================================

-- 2.1 智能体配置表（扩展 xiaozhi 的 ai_agent）
DROP TABLE IF EXISTS `gw_agent`;
CREATE TABLE `gw_agent` (
    `id` VARCHAR(32) NOT NULL COMMENT '智能体唯一标识',
    `user_id` BIGINT COMMENT '所属用户ID（关联sys_user）',
    `agent_code` VARCHAR(36) DEFAULT '' COMMENT '智能体编码',
    `agent_name` VARCHAR(64) NOT NULL COMMENT '智能体名称',
    `agent_icon` VARCHAR(255) DEFAULT '' COMMENT '智能体图标',
    `agent_desc` VARCHAR(500) DEFAULT '' COMMENT '智能体描述',
    `system_prompt` TEXT COMMENT '系统提示词（角色设定）',
    `lang_code` VARCHAR(10) DEFAULT 'zh-CN' COMMENT '语言编码',
    `asr_model_id` VARCHAR(32) DEFAULT NULL COMMENT 'ASR模型配置ID',
    `vad_model_id` VARCHAR(32) DEFAULT NULL COMMENT 'VAD模型配置ID',
    `llm_model_id` VARCHAR(32) DEFAULT NULL COMMENT 'LLM模型配置ID',
    `tts_model_id` VARCHAR(32) DEFAULT NULL COMMENT 'TTS模型配置ID',
    `tts_voice_id` VARCHAR(32) DEFAULT NULL COMMENT '音色ID',
    `mem_model_id` VARCHAR(32) DEFAULT NULL COMMENT '记忆模型ID',
    `intent_model_id` VARCHAR(32) DEFAULT NULL COMMENT '意图模型ID',
    `temperature` DECIMAL(3,2) DEFAULT 0.70 COMMENT '生成温度：0.00-2.00',
    `max_tokens` INT DEFAULT 2048 COMMENT '最大生成token数',
    `top_p` DECIMAL(3,2) DEFAULT 0.90 COMMENT 'Top-p采样',
    `context_window` INT DEFAULT 4096 COMMENT '上下文窗口大小',
    `is_default` TINYINT DEFAULT 0 COMMENT '是否默认智能体：0否 1是',
    `is_enabled` TINYINT DEFAULT 1 COMMENT '启用状态：0禁用 1启用',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序权重',
    `del_flag` TINYINT DEFAULT 0 COMMENT '删除标志',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_agent_user_id` (`user_id`),
    INDEX `idx_gw_agent_default` (`user_id`, `is_default`),
    INDEX `idx_gw_agent_enabled` (`is_enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='智能体配置表';

-- 2.2 智能体模板表
DROP TABLE IF EXISTS `gw_agent_template`;
CREATE TABLE `gw_agent_template` (
    `id` VARCHAR(32) NOT NULL COMMENT '模板唯一标识',
    `template_code` VARCHAR(36) DEFAULT '' COMMENT '模板编码',
    `template_name` VARCHAR(64) NOT NULL COMMENT '模板名称',
    `template_icon` VARCHAR(255) DEFAULT '' COMMENT '模板图标',
    `template_desc` VARCHAR(500) DEFAULT '' COMMENT '模板描述',
    `category` VARCHAR(50) DEFAULT '' COMMENT '模板分类：work/life/entertain',
    `system_prompt` TEXT COMMENT '系统提示词模板',
    `lang_code` VARCHAR(10) DEFAULT 'zh-CN' COMMENT '语言编码',
    `asr_model_id` VARCHAR(32) DEFAULT NULL COMMENT '默认ASR模型ID',
    `vad_model_id` VARCHAR(32) DEFAULT NULL COMMENT '默认VAD模型ID',
    `llm_model_id` VARCHAR(32) DEFAULT NULL COMMENT '默认LLM模型ID',
    `tts_model_id` VARCHAR(32) DEFAULT NULL COMMENT '默认TTS模型ID',
    `tts_voice_id` VARCHAR(32) DEFAULT NULL COMMENT '默认音色ID',
    `mem_model_id` VARCHAR(32) DEFAULT NULL COMMENT '默认记忆模型ID',
    `temperature` DECIMAL(3,2) DEFAULT 0.70 COMMENT '默认温度',
    `max_tokens` INT DEFAULT 2048 COMMENT '默认最大token',
    `is_system` TINYINT DEFAULT 0 COMMENT '是否系统预设：0否 1是',
    `is_enabled` TINYINT DEFAULT 1 COMMENT '启用状态',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_agent_tpl_category` (`category`),
    INDEX `idx_gw_agent_tpl_system` (`is_system`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='智能体模板表';

-- 2.3 智能体标签表
DROP TABLE IF EXISTS `gw_agent_tag`;
CREATE TABLE `gw_agent_tag` (
    `id` VARCHAR(32) NOT NULL COMMENT '标签唯一标识',
    `tag_name` VARCHAR(64) NOT NULL COMMENT '标签名称',
    `tag_color` VARCHAR(20) DEFAULT '#1890ff' COMMENT '标签颜色',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_gw_agent_tag_name` (`tag_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='智能体标签表';

-- 2.4 智能体标签关联表
DROP TABLE IF EXISTS `gw_agent_tag_relation`;
CREATE TABLE `gw_agent_tag_relation` (
    `id` VARCHAR(32) NOT NULL COMMENT '关联唯一标识',
    `agent_id` VARCHAR(32) NOT NULL COMMENT '智能体ID',
    `tag_id` VARCHAR(32) NOT NULL COMMENT '标签ID',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_gw_agent_tag_rel` (`agent_id`, `tag_id`),
    INDEX `idx_gw_agent_tag_rel_agent` (`agent_id`),
    INDEX `idx_gw_agent_tag_rel_tag` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='智能体标签关联表';

-- 2.5 智能体上下文提供者配置表
DROP TABLE IF EXISTS `gw_agent_context`;
CREATE TABLE `gw_agent_context` (
    `id` VARCHAR(32) NOT NULL COMMENT '配置唯一标识',
    `agent_id` VARCHAR(32) NOT NULL COMMENT '智能体ID',
    `provider_type` VARCHAR(50) DEFAULT '' COMMENT '提供者类型：memory/env/schedule',
    `provider_config` JSON COMMENT '提供者配置',
    `is_enabled` TINYINT DEFAULT 1 COMMENT '启用状态',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_agent_context_agent` (`agent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='智能体上下文提供者配置表';

-- ========================================================
-- 三、模型配置模块
-- ========================================================

-- 3.1 模型提供商表（扩展 xiaozhi 的 ai_model_provider）
DROP TABLE IF EXISTS `gw_model_provider`;
CREATE TABLE `gw_model_provider` (
    `id` VARCHAR(32) NOT NULL COMMENT '提供商唯一标识',
    `model_type` VARCHAR(20) NOT NULL COMMENT '模型类型：VAD/ASR/LLM/TTS/Memory/Intent/Plugin',
    `provider_code` VARCHAR(50) NOT NULL COMMENT '提供商编码',
    `provider_name` VARCHAR(50) NOT NULL COMMENT '提供商名称',
    `fields` JSON COMMENT '配置字段定义（JSON Schema）',
    `doc_link` VARCHAR(255) DEFAULT '' COMMENT '官方文档链接',
    `is_system` TINYINT DEFAULT 0 COMMENT '是否系统预设',
    `is_enabled` TINYINT DEFAULT 1 COMMENT '启用状态',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_model_provider_type` (`model_type`),
    INDEX `idx_gw_model_provider_code` (`provider_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模型提供商表';

-- 3.2 模型配置实例表（扩展 xiaozhi 的 ai_model_config）
DROP TABLE IF EXISTS `gw_model_config`;
CREATE TABLE `gw_model_config` (
    `id` VARCHAR(32) NOT NULL COMMENT '配置唯一标识',
    `model_type` VARCHAR(20) NOT NULL COMMENT '模型类型',
    `provider_id` VARCHAR(32) NOT NULL COMMENT '提供商ID',
    `model_code` VARCHAR(50) NOT NULL COMMENT '模型编码',
    `model_name` VARCHAR(50) NOT NULL COMMENT '模型名称',
    `config_json` JSON COMMENT '模型配置参数',
    `is_default` TINYINT DEFAULT 0 COMMENT '是否默认配置',
    `is_enabled` TINYINT DEFAULT 1 COMMENT '启用状态',
    `doc_link` VARCHAR(255) DEFAULT '' COMMENT '官方文档链接',
    `remark` VARCHAR(500) DEFAULT '' COMMENT '备注说明',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_model_config_type` (`model_type`),
    INDEX `idx_gw_model_config_provider` (`provider_id`),
    INDEX `idx_gw_model_config_default` (`model_type`, `is_default`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模型配置实例表';

-- 3.3 TTS音色表（扩展 xiaozhi 的 ai_tts_voice）
DROP TABLE IF EXISTS `gw_tts_voice`;
CREATE TABLE `gw_tts_voice` (
    `id` VARCHAR(32) NOT NULL COMMENT '音色唯一标识',
    `tts_model_id` VARCHAR(32) NOT NULL COMMENT '所属TTS模型ID',
    `voice_name` VARCHAR(20) NOT NULL COMMENT '音色名称',
    `voice_code` VARCHAR(50) NOT NULL COMMENT '音色编码',
    `language` VARCHAR(50) DEFAULT 'zh-CN' COMMENT '支持语言',
    `gender` TINYINT DEFAULT 0 COMMENT '性别：0未知 1男 2女',
    `age_group` TINYINT DEFAULT 0 COMMENT '年龄段：0未知 1童声 2青年 3中年 4老年',
    `emotion_tags` VARCHAR(255) DEFAULT '' COMMENT '情感标签：温柔/活泼/沉稳',
    `demo_url` VARCHAR(500) DEFAULT '' COMMENT '音色试听URL',
    `is_system` TINYINT DEFAULT 0 COMMENT '是否系统预设',
    `is_enabled` TINYINT DEFAULT 1 COMMENT '启用状态',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_tts_voice_model` (`tts_model_id`),
    INDEX `idx_gw_tts_voice_enabled` (`is_enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='TTS音色表';

-- ========================================================
-- 四、声纹与音色克隆模块
-- ========================================================

-- 4.1 声纹管理表
DROP TABLE IF EXISTS `gw_voiceprint`;
CREATE TABLE `gw_voiceprint` (
    `id` VARCHAR(32) NOT NULL COMMENT '声纹唯一标识',
    `user_id` BIGINT NOT NULL COMMENT '所属用户ID',
    `agent_id` VARCHAR(32) DEFAULT NULL COMMENT '关联智能体ID',
    `voiceprint_name` VARCHAR(64) DEFAULT '' COMMENT '声纹名称',
    `description` VARCHAR(255) DEFAULT '' COMMENT '声纹描述',
    `embedding` LONGTEXT COMMENT '声纹特征向量（JSON数组）',
    `sample_count` INT DEFAULT 0 COMMENT '样本数量',
    `is_enabled` TINYINT DEFAULT 1 COMMENT '启用状态',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_voiceprint_user` (`user_id`),
    INDEX `idx_gw_voiceprint_agent` (`agent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='声纹管理表';

-- 4.2 音色克隆表（扩展 xiaozhi 的 ai_voice_clone）
DROP TABLE IF EXISTS `gw_voice_clone`;
CREATE TABLE `gw_voice_clone` (
    `id` VARCHAR(32) NOT NULL COMMENT '克隆音色唯一标识',
    `user_id` BIGINT NOT NULL COMMENT '所属用户ID',
    `clone_name` VARCHAR(64) DEFAULT '' COMMENT '克隆音色名称',
    `tts_model_id` VARCHAR(32) DEFAULT NULL COMMENT '关联TTS模型ID',
    `voice_id` VARCHAR(32) DEFAULT '' COMMENT '远端音色ID',
    `audio_sample` LONGBLOB COMMENT '参考音频样本',
    `audio_text` TEXT COMMENT '参考音频文本',
    `train_status` TINYINT DEFAULT 0 COMMENT '训练状态：0待训练 1训练中 2成功 3失败',
    `train_error` VARCHAR(255) DEFAULT '' COMMENT '训练错误信息',
    `quality_score` DECIMAL(3,2) DEFAULT NULL COMMENT '音质评分',
    `is_enabled` TINYINT DEFAULT 0 COMMENT '启用状态',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_voice_clone_user` (`user_id`),
    INDEX `idx_gw_voice_clone_status` (`train_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='音色克隆表';

-- ========================================================
-- 五、记忆模块
-- ========================================================

-- 5.1 记忆时间轴表
DROP TABLE IF EXISTS `gw_memory_timeline`;
CREATE TABLE `gw_memory_timeline` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '记忆ID',
    `user_id` BIGINT NOT NULL COMMENT '所属用户ID',
    `device_id` VARCHAR(32) DEFAULT NULL COMMENT '关联设备ID',
    `memory_type` TINYINT DEFAULT 1 COMMENT '记忆类型：1日常 2重要 3周报 4月报',
    `trigger_scene` VARCHAR(50) DEFAULT '' COMMENT '触发场景',
    `content_summary` VARCHAR(500) DEFAULT '' COMMENT '内容摘要',
    `content_detail` TEXT COMMENT '详细内容',
    `emotion_tag` VARCHAR(50) DEFAULT '' COMMENT '情感标签',
    `importance` TINYINT DEFAULT 3 COMMENT '重要程度：1-5',
    `memory_date` DATE COMMENT '记忆日期',
    `memory_time` DATETIME COMMENT '记忆时间',
    `location` VARCHAR(255) DEFAULT '' COMMENT '位置信息',
    `media_urls` JSON COMMENT '关联媒体URL列表',
    `is_shared` TINYINT DEFAULT 0 COMMENT '是否共享：0私有 1共享',
    `is_archived` TINYINT DEFAULT 0 COMMENT '是否归档',
    `del_flag` TINYINT DEFAULT 0 COMMENT '删除标志',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_memory_user` (`user_id`),
    INDEX `idx_gw_memory_date` (`user_id`, `memory_date`),
    INDEX `idx_gw_memory_type` (`memory_type`),
    INDEX `idx_gw_memory_device` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='记忆时间轴表';

-- 5.2 记忆文件管理表（SOUL.md / USER.md / MEMORY.md / 每日笔记）
DROP TABLE IF EXISTS `gw_memory_file`;
CREATE TABLE `gw_memory_file` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '文件ID',
    `user_id` BIGINT NOT NULL COMMENT '所属用户ID',
    `device_id` VARCHAR(32) DEFAULT NULL COMMENT '关联设备ID',
    `file_type` VARCHAR(20) NOT NULL COMMENT '文件类型：SOUL/USER/MEMORY/NOTE',
    `file_name` VARCHAR(100) DEFAULT '' COMMENT '文件名称',
    `file_content` MEDIUMTEXT COMMENT '文件内容',
    `file_size` INT DEFAULT 0 COMMENT '文件大小（字节）',
    `version` INT DEFAULT 1 COMMENT '版本号',
    `is_pinned` TINYINT DEFAULT 0 COMMENT '是否置顶',
    `privacy_level` TINYINT DEFAULT 1 COMMENT '隐私级别：1公开 2私密 3敏感',
    `last_edit_time` DATETIME COMMENT '最后编辑时间',
    `del_flag` TINYINT DEFAULT 0 COMMENT '删除标志',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_gw_memory_file_user_type` (`user_id`, `device_id`, `file_type`),
    INDEX `idx_gw_memory_file_user` (`user_id`),
    INDEX `idx_gw_memory_file_type` (`file_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='记忆文件管理表';

-- 5.3 记忆文件版本历史表
DROP TABLE IF EXISTS `gw_memory_file_version`;
CREATE TABLE `gw_memory_file_version` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '版本ID',
    `file_id` BIGINT NOT NULL COMMENT '文件ID',
    `version` INT NOT NULL COMMENT '版本号',
    `file_content` MEDIUMTEXT COMMENT '文件内容',
    `file_size` INT DEFAULT 0 COMMENT '文件大小',
    `change_summary` VARCHAR(255) DEFAULT '' COMMENT '变更摘要',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_mem_file_ver_file` (`file_id`),
    INDEX `idx_gw_mem_file_ver_version` (`file_id`, `version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='记忆文件版本历史表';

-- 5.4 数据导出任务表
DROP TABLE IF EXISTS `gw_data_export`;
CREATE TABLE `gw_data_export` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '导出任务ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `export_type` TINYINT NOT NULL COMMENT '导出类型：1记忆 2环境 3设备日志 4全部',
    `export_format` VARCHAR(10) DEFAULT 'json' COMMENT '导出格式：json/csv',
    `date_range_start` DATE COMMENT '日期范围起',
    `date_range_end` DATE COMMENT '日期范围止',
    `file_path` VARCHAR(255) DEFAULT '' COMMENT '导出文件路径',
    `file_size` BIGINT DEFAULT 0 COMMENT '文件大小',
    `task_status` TINYINT DEFAULT 0 COMMENT '任务状态：0排队 1执行中 2完成 3失败',
    `error_msg` VARCHAR(500) DEFAULT '' COMMENT '错误信息',
    `create_time` DATETIME COMMENT '创建时间',
    `complete_time` DATETIME COMMENT '完成时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_export_user` (`user_id`),
    INDEX `idx_gw_export_status` (`task_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据导出任务表';

-- ========================================================
-- 六、聊天记录模块
-- ========================================================

-- 6.1 聊天会话表（扩展 xiaozhi 的 ai_chat_history）
DROP TABLE IF EXISTS `gw_chat_session`;
CREATE TABLE `gw_chat_session` (
    `id` VARCHAR(32) NOT NULL COMMENT '会话唯一标识',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `agent_id` VARCHAR(32) DEFAULT NULL COMMENT '智能体ID',
    `device_id` VARCHAR(32) DEFAULT NULL COMMENT '设备ID',
    `session_title` VARCHAR(100) DEFAULT '' COMMENT '会话标题',
    `message_count` INT DEFAULT 0 COMMENT '消息数量',
    `last_message_time` DATETIME COMMENT '最后消息时间',
    `last_message_preview` VARCHAR(200) DEFAULT '' COMMENT '最后消息预览',
    `is_pinned` TINYINT DEFAULT 0 COMMENT '是否置顶',
    `is_archived` TINYINT DEFAULT 0 COMMENT '是否归档',
    `del_flag` TINYINT DEFAULT 0 COMMENT '删除标志',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_chat_session_user` (`user_id`),
    INDEX `idx_gw_chat_session_agent` (`agent_id`),
    INDEX `idx_gw_chat_session_time` (`last_message_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='聊天会话表';

-- 6.2 聊天消息表（扩展 xiaozhi 的 ai_chat_message）
DROP TABLE IF EXISTS `gw_chat_message`;
CREATE TABLE `gw_chat_message` (
    `id` VARCHAR(32) NOT NULL COMMENT '消息唯一标识',
    `session_id` VARCHAR(32) NOT NULL COMMENT '会话ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `agent_id` VARCHAR(32) DEFAULT NULL COMMENT '智能体ID',
    `role` TINYINT NOT NULL COMMENT '角色：1用户 2智能体 3系统',
    `content` TEXT COMMENT '消息内容',
    `content_type` VARCHAR(20) DEFAULT 'text' COMMENT '内容类型：text/audio/image',
    `audio_id` VARCHAR(32) DEFAULT NULL COMMENT '关联音频ID',
    `audio_duration` INT DEFAULT 0 COMMENT '音频时长（毫秒）',
    `prompt_tokens` INT DEFAULT 0 COMMENT '提示token数',
    `completion_tokens` INT DEFAULT 0 COMMENT '完成token数',
    `total_tokens` INT DEFAULT 0 COMMENT '总token数',
    `prompt_ms` INT DEFAULT 0 COMMENT '提示耗时（毫秒）',
    `completion_ms` INT DEFAULT 0 COMMENT '完成耗时（毫秒）',
    `total_ms` INT DEFAULT 0 COMMENT '总耗时（毫秒）',
    `model_name` VARCHAR(50) DEFAULT '' COMMENT '使用的模型名称',
    `interrupt_type` TINYINT DEFAULT 0 COMMENT '打断类型：0正常 1用户打断 2超时',
    `del_flag` TINYINT DEFAULT 0 COMMENT '删除标志',
    `create_time` DATETIME COMMENT '创建时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_chat_msg_session` (`session_id`),
    INDEX `idx_gw_chat_msg_user` (`user_id`),
    INDEX `idx_gw_chat_msg_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='聊天消息表';

-- 6.3 聊天音频数据表
DROP TABLE IF EXISTS `gw_chat_audio`;
CREATE TABLE `gw_chat_audio` (
    `id` VARCHAR(32) NOT NULL COMMENT '音频唯一标识',
    `message_id` VARCHAR(32) DEFAULT NULL COMMENT '关联消息ID',
    `audio_format` VARCHAR(10) DEFAULT 'opus' COMMENT '音频格式',
    `audio_data` LONGBLOB COMMENT '音频二进制数据',
    `audio_url` VARCHAR(255) DEFAULT '' COMMENT '音频存储URL',
    `duration` INT DEFAULT 0 COMMENT '音频时长（毫秒）',
    `file_size` INT DEFAULT 0 COMMENT '文件大小',
    `create_time` DATETIME COMMENT '创建时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_chat_audio_msg` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='聊天音频数据表';

-- ========================================================
-- 七、知识库模块 (RAG)
-- ========================================================

-- 7.1 知识库表（扩展 xiaozhi 的 ai_rag_dataset）
DROP TABLE IF EXISTS `gw_knowledge_base`;
CREATE TABLE `gw_knowledge_base` (
    `id` VARCHAR(32) NOT NULL COMMENT '知识库唯一标识',
    `dataset_id` VARCHAR(64) DEFAULT '' COMMENT 'RAGFlow远端知识库ID',
    `user_id` BIGINT NOT NULL COMMENT '所属用户ID',
    `kb_name` VARCHAR(100) NOT NULL COMMENT '知识库名称',
    `kb_desc` TEXT COMMENT '知识库描述',
    `kb_avatar` TEXT COMMENT '知识库头像（Base64或URL）',
    `embedding_model` VARCHAR(50) DEFAULT '' COMMENT '嵌入模型名称',
    `chunk_method` VARCHAR(50) DEFAULT '' COMMENT '分块方法',
    `parser_config` JSON COMMENT '解析器配置',
    `permission` VARCHAR(20) DEFAULT 'me' COMMENT '权限：me个人/team团队',
    `chunk_count` BIGINT DEFAULT 0 COMMENT '分块总数',
    `document_count` BIGINT DEFAULT 0 COMMENT '文档总数',
    `token_num` BIGINT DEFAULT 0 COMMENT '总Token数',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0停用 1启用',
    `del_flag` TINYINT DEFAULT 0 COMMENT '删除标志',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME COMMENT '更新时间',
    `last_sync_at` DATETIME COMMENT '最后同步时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_kb_user` (`user_id`),
    INDEX `idx_gw_kb_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识库表';

-- 7.2 知识库文档表（扩展 xiaozhi 的 ai_rag_knowledge_document）
DROP TABLE IF EXISTS `gw_knowledge_doc`;
CREATE TABLE `gw_knowledge_doc` (
    `id` VARCHAR(36) NOT NULL COMMENT '本地唯一ID',
    `kb_id` VARCHAR(32) NOT NULL COMMENT '知识库ID',
    `document_id` VARCHAR(64) DEFAULT '' COMMENT 'RAGFlow远端文档ID',
    `doc_name` VARCHAR(255) DEFAULT '' COMMENT '文档名称',
    `doc_size` BIGINT DEFAULT 0 COMMENT '文件大小（字节）',
    `doc_type` VARCHAR(20) DEFAULT '' COMMENT '文件类型',
    `doc_url` VARCHAR(255) DEFAULT '' COMMENT '文件存储URL',
    `chunk_method` VARCHAR(50) DEFAULT '' COMMENT '分块方法',
    `parser_config` JSON COMMENT '解析配置',
    `run_status` VARCHAR(32) DEFAULT 'UNSTART' COMMENT '运行状态：UNSTART/RUNNING/CANCEL/DONE/FAIL',
    `progress` DECIMAL(5,2) DEFAULT 0 COMMENT '解析进度：0.00-1.00',
    `chunk_count` INT DEFAULT 0 COMMENT '分块数量',
    `token_count` BIGINT DEFAULT 0 COMMENT 'Token数量',
    `error_info` TEXT COMMENT '错误信息',
    `source_type` VARCHAR(32) DEFAULT 'local' COMMENT '来源类型：local/url/s3',
    `meta_fields` JSON COMMENT '自定义元数据',
    `enabled` TINYINT DEFAULT 1 COMMENT '启用状态',
    `del_flag` TINYINT DEFAULT 0 COMMENT '删除标志',
    `create_by` BIGINT DEFAULT NULL COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    `last_sync_at` DATETIME COMMENT '最后同步时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_kd_kb` (`kb_id`),
    INDEX `idx_gw_kd_status` (`run_status`),
    INDEX `idx_gw_kd_doc_id` (`document_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识库文档表';

-- ========================================================
-- 八、生产力模块
-- ========================================================

-- 8.1 云服务套餐配置表
DROP TABLE IF EXISTS `gw_cloud_plan`;
CREATE TABLE `gw_cloud_plan` (
    `id` VARCHAR(32) NOT NULL COMMENT '套餐唯一标识',
    `plan_code` VARCHAR(50) NOT NULL COMMENT '套餐编码：basic/standard/professional/enterprise',
    `plan_name` VARCHAR(50) NOT NULL COMMENT '套餐名称',
    `plan_desc` VARCHAR(500) DEFAULT '' COMMENT '套餐描述',
    `cpu_cores` INT DEFAULT 2 COMMENT 'CPU核数',
    `memory_gb` INT DEFAULT 4 COMMENT '内存GB',
    `storage_gb` INT DEFAULT 50 COMMENT '存储GB',
    `monthly_price` DECIMAL(10,2) DEFAULT 0 COMMENT '月费（元）',
    `yearly_price` DECIMAL(10,2) DEFAULT 0 COMMENT '年费（元）',
    `max_tasks` INT DEFAULT 5 COMMENT '最大并发任务数',
    `max_file_size` BIGINT DEFAULT 104857600 COMMENT '最大文件大小（字节）',
    `features` JSON COMMENT '功能特性列表',
    `is_enabled` TINYINT DEFAULT 1 COMMENT '启用状态',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_gw_cloud_plan_code` (`plan_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='云服务套餐配置表';

-- 8.2 用户云服务订阅表
DROP TABLE IF EXISTS `gw_cloud_subscription`;
CREATE TABLE `gw_cloud_subscription` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '订阅ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `plan_id` VARCHAR(32) NOT NULL COMMENT '套餐ID',
    `subscribe_status` TINYINT DEFAULT 1 COMMENT '订阅状态：1有效 2过期 3取消',
    `start_date` DATE COMMENT '开始日期',
    `end_date` DATE COMMENT '结束日期',
    `auto_renew` TINYINT DEFAULT 0 COMMENT '自动续费：0关闭 1开启',
    `used_cpu_hours` DECIMAL(10,2) DEFAULT 0 COMMENT '已用CPU时长（小时）',
    `used_storage_bytes` BIGINT DEFAULT 0 COMMENT '已用存储（字节）',
    `used_task_count` INT DEFAULT 0 COMMENT '已用任务数',
    `last_bill_date` DATE COMMENT '最后账单日期',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_cloud_sub_user` (`user_id`),
    INDEX `idx_gw_cloud_sub_status` (`subscribe_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户云服务订阅表';

-- 8.3 生产力任务表
DROP TABLE IF EXISTS `gw_productivity_task`;
CREATE TABLE `gw_productivity_task` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '任务ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `device_id` VARCHAR(32) DEFAULT NULL COMMENT '设备ID',
    `task_name` VARCHAR(200) DEFAULT '' COMMENT '任务名称',
    `task_type` TINYINT NOT NULL COMMENT '任务类型：1文档生成 2代码执行 3数据分析 4AI增强',
    `task_status` TINYINT DEFAULT 0 COMMENT '任务状态：0排队中 1执行中 2已完成 3失败 4已取消',
    `task_params` JSON COMMENT '任务参数',
    `progress` INT DEFAULT 0 COMMENT '进度：0-100',
    `result_summary` VARCHAR(500) DEFAULT '' COMMENT '结果摘要',
    `result_detail` TEXT COMMENT '结果详情',
    `result_files` JSON COMMENT '结果文件列表',
    `error_msg` TEXT COMMENT '错误信息',
    `execute_log` MEDIUMTEXT COMMENT '执行日志',
    `estimated_time` INT DEFAULT 0 COMMENT '预计耗时（秒）',
    `actual_time` INT DEFAULT 0 COMMENT '实际耗时（秒）',
    `retry_count` INT DEFAULT 0 COMMENT '重试次数',
    `max_retry` INT DEFAULT 3 COMMENT '最大重试次数',
    `cancelled_by` BIGINT DEFAULT NULL COMMENT '取消者ID',
    `cancel_time` DATETIME COMMENT '取消时间',
    `start_time` DATETIME COMMENT '开始时间',
    `complete_time` DATETIME COMMENT '完成时间',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_task_user` (`user_id`),
    INDEX `idx_gw_task_status` (`task_status`),
    INDEX `idx_gw_task_type` (`task_type`),
    INDEX `idx_gw_task_device` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='生产力任务表';

-- 8.4 Workspace文件管理表
DROP TABLE IF EXISTS `gw_workspace_file`;
CREATE TABLE `gw_workspace_file` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '文件ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `parent_id` BIGINT DEFAULT 0 COMMENT '父目录ID：0为根目录',
    `file_name` VARCHAR(255) NOT NULL COMMENT '文件名称',
    `file_path` VARCHAR(500) NOT NULL COMMENT '文件路径',
    `file_type` VARCHAR(50) DEFAULT '' COMMENT '文件类型',
    `file_size` BIGINT DEFAULT 0 COMMENT '文件大小',
    `is_directory` TINYINT DEFAULT 0 COMMENT '是否目录：0文件 1目录',
    `storage_url` VARCHAR(255) DEFAULT '' COMMENT '存储URL',
    `preview_url` VARCHAR(255) DEFAULT '' COMMENT '预览URL',
    `del_flag` TINYINT DEFAULT 0 COMMENT '删除标志',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_ws_file_user` (`user_id`),
    INDEX `idx_gw_ws_file_parent` (`parent_id`),
    INDEX `idx_gw_ws_file_path` (`file_path`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Workspace文件管理表';

-- 8.5 生产力工具开关表
DROP TABLE IF EXISTS `gw_productivity_tool`;
CREATE TABLE `gw_productivity_tool` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '配置ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `device_id` VARCHAR(32) DEFAULT NULL COMMENT '设备ID',
    `tool_type` TINYINT NOT NULL COMMENT '工具类型：1文档处理 2代码执行 3数据分析 4AI增强',
    `tool_name` VARCHAR(50) DEFAULT '' COMMENT '工具名称',
    `is_enabled` TINYINT DEFAULT 1 COMMENT '启用状态',
    `tool_config` JSON COMMENT '工具配置参数',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_gw_prod_tool_user_type` (`user_id`, `device_id`, `tool_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='生产力工具开关表';

-- ========================================================
-- 九、环境与专注度模块
-- ========================================================

-- 9.1 环境数据表
DROP TABLE IF EXISTS `gw_env_data`;
CREATE TABLE `gw_env_data` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '数据ID',
    `device_id` VARCHAR(32) NOT NULL COMMENT '设备ID',
    `temperature` DECIMAL(4,1) DEFAULT NULL COMMENT '温度（摄氏度）',
    `humidity` INT DEFAULT NULL COMMENT '湿度（百分比）',
    `co2_ppm` INT DEFAULT NULL COMMENT 'CO2浓度（ppm）',
    `voc_level` VARCHAR(20) DEFAULT '' COMMENT 'VOC等级：优/良/差',
    `iaq_index` INT DEFAULT NULL COMMENT 'IAQ空气质量指数',
    `pm25` INT DEFAULT NULL COMMENT 'PM2.5',
    `noise_db` DECIMAL(5,2) DEFAULT NULL COMMENT '噪音分贝',
    `light_lux` INT DEFAULT NULL COMMENT '光照强度（lux）',
    `data_time` DATETIME COMMENT '数据采集时间',
    `create_time` DATETIME COMMENT '创建时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_env_device` (`device_id`),
    INDEX `idx_gw_env_time` (`device_id`, `data_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='环境数据表';

-- 9.2 专注度数据表
DROP TABLE IF EXISTS `gw_focus_data`;
CREATE TABLE `gw_focus_data` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '数据ID',
    `device_id` VARCHAR(32) NOT NULL COMMENT '设备ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `focus_score` INT DEFAULT 0 COMMENT '专注度评分：0-100',
    `focus_level` TINYINT DEFAULT 1 COMMENT '专注等级：1深度专注 2一般专注 3轻度分心 4严重分心',
    `radar_confidence` DECIMAL(5,2) DEFAULT 0 COMMENT '雷达置信度',
    `csi_confidence` DECIMAL(5,2) DEFAULT 0 COMMENT 'CSI置信度',
    `activity_state` VARCHAR(20) DEFAULT '' COMMENT '活动状态',
    `data_time` DATETIME COMMENT '数据采集时间',
    `create_time` DATETIME COMMENT '创建时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_focus_device` (`device_id`),
    INDEX `idx_gw_focus_user_time` (`user_id`, `data_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='专注度数据表';

-- 9.3 今日统计表
DROP TABLE IF EXISTS `gw_daily_stats`;
CREATE TABLE `gw_daily_stats` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '统计ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `device_id` VARCHAR(32) NOT NULL COMMENT '设备ID',
    `stat_date` DATE NOT NULL COMMENT '统计日期',
    `sedentary_minutes` INT DEFAULT 0 COMMENT '久坐时长（分钟）',
    `activity_count` INT DEFAULT 0 COMMENT '活动次数',
    `sleep_minutes` INT DEFAULT 0 COMMENT '睡眠时长（分钟）',
    `interrupt_count` INT DEFAULT 0 COMMENT '被打扰次数',
    `deep_focus_minutes` INT DEFAULT 0 COMMENT '深度专注时长（分钟）',
    `avg_focus_score` INT DEFAULT 0 COMMENT '平均专注度评分',
    `env_alert_count` INT DEFAULT 0 COMMENT '环境预警次数',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_gw_daily_stats` (`user_id`, `device_id`, `stat_date`),
    INDEX `idx_gw_daily_stats_date` (`stat_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='今日统计表';

-- ========================================================
-- 十、消息中心模块
-- ========================================================

-- 10.1 消息表
DROP TABLE IF EXISTS `gw_message`;
CREATE TABLE `gw_message` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '消息ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `device_id` VARCHAR(32) DEFAULT NULL COMMENT '设备ID',
    `msg_title` VARCHAR(200) DEFAULT '' COMMENT '消息标题',
    `msg_summary` VARCHAR(500) DEFAULT '' COMMENT '消息摘要',
    `msg_content` TEXT COMMENT '消息内容',
    `msg_type` TINYINT DEFAULT 1 COMMENT '消息类型：1环境提醒 2记忆共鸣 3关怀提示 4系统通知',
    `risk_level` TINYINT DEFAULT 1 COMMENT '打扰风险：1低 2中 3高',
    `delivery_mode` TINYINT DEFAULT 1 COMMENT '投递方式：1语音+卡片 2仅卡片 3静默',
    `is_read` TINYINT DEFAULT 0 COMMENT '是否已读：0未读 1已读',
    `read_time` DATETIME COMMENT '阅读时间',
    `action_url` VARCHAR(255) DEFAULT '' COMMENT '跳转链接',
    `action_type` VARCHAR(50) DEFAULT '' COMMENT '动作类型',
    `del_flag` TINYINT DEFAULT 0 COMMENT '删除标志',
    `create_time` DATETIME COMMENT '创建时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_msg_user` (`user_id`),
    INDEX `idx_gw_msg_read` (`user_id`, `is_read`),
    INDEX `idx_gw_msg_type` (`msg_type`),
    INDEX `idx_gw_msg_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息表';

-- ========================================================
-- 十一、定时任务与心跳模块
-- ========================================================

-- 11.1 设备定时任务表（Cron）
DROP TABLE IF EXISTS `gw_cron_task`;
CREATE TABLE `gw_cron_task` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '任务ID',
    `device_id` VARCHAR(32) NOT NULL COMMENT '设备ID',
    `task_name` VARCHAR(100) DEFAULT '' COMMENT '任务名称',
    `cron_expression` VARCHAR(50) NOT NULL COMMENT 'Cron表达式',
    `task_desc` VARCHAR(255) DEFAULT '' COMMENT '任务描述',
    `task_action` VARCHAR(50) DEFAULT '' COMMENT '任务动作',
    `task_params` JSON COMMENT '任务参数',
    `is_enabled` TINYINT DEFAULT 1 COMMENT '启用状态',
    `last_run_time` DATETIME COMMENT '最后执行时间',
    `last_run_result` TINYINT DEFAULT 0 COMMENT '最后执行结果：0未执行 1成功 2失败',
    `run_count` INT DEFAULT 0 COMMENT '执行次数',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_cron_device` (`device_id`),
    INDEX `idx_gw_cron_enabled` (`is_enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备定时任务表';

-- 11.2 心跳任务表（HEARTBEAT.md 驱动）
DROP TABLE IF EXISTS `gw_heartbeat_task`;
CREATE TABLE `gw_heartbeat_task` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '任务ID',
    `device_id` VARCHAR(32) NOT NULL COMMENT '设备ID',
    `task_name` VARCHAR(100) DEFAULT '' COMMENT '任务名称',
    `check_interval` INT DEFAULT 60 COMMENT '检查间隔（分钟）',
    `task_desc` TEXT COMMENT '任务描述',
    `last_check_time` DATETIME COMMENT '最后检查时间',
    `next_check_time` DATETIME COMMENT '下次检查时间',
    `check_result` TINYINT DEFAULT 0 COMMENT '检查结果：0待检查 1正常 2异常',
    `result_detail` TEXT COMMENT '结果详情',
    `is_enabled` TINYINT DEFAULT 1 COMMENT '启用状态',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_heartbeat_device` (`device_id`),
    INDEX `idx_gw_heartbeat_next` (`next_check_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='心跳任务表';

-- ========================================================
-- 十二、MCP工具模块
-- ========================================================

-- 12.1 MCP接入点配置表
DROP TABLE IF EXISTS `gw_mcp_endpoint`;
CREATE TABLE `gw_mcp_endpoint` (
    `id` VARCHAR(32) NOT NULL COMMENT '接入点唯一标识',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `endpoint_name` VARCHAR(64) DEFAULT '' COMMENT '接入点名称',
    `endpoint_url` VARCHAR(255) NOT NULL COMMENT 'MCP服务端地址',
    `auth_type` TINYINT DEFAULT 1 COMMENT '认证类型：1无认证 2Token 3OAuth',
    `auth_config` JSON COMMENT '认证配置',
    `transport_type` VARCHAR(20) DEFAULT 'stdio' COMMENT '传输类型：stdio/sse/websocket',
    `is_enabled` TINYINT DEFAULT 1 COMMENT '启用状态',
    `last_connect_time` DATETIME COMMENT '最后连接时间',
    `last_connect_status` TINYINT DEFAULT 0 COMMENT '最后连接状态：0未连接 1成功 2失败',
    `tool_count` INT DEFAULT 0 COMMENT '工具数量',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_mcp_user` (`user_id`),
    INDEX `idx_gw_mcp_status` (`is_enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MCP接入点配置表';

-- 12.2 MCP工具注册表
DROP TABLE IF EXISTS `gw_mcp_tool`;
CREATE TABLE `gw_mcp_tool` (
    `id` VARCHAR(32) NOT NULL COMMENT '工具唯一标识',
    `endpoint_id` VARCHAR(32) NOT NULL COMMENT '接入点ID',
    `tool_name` VARCHAR(64) NOT NULL COMMENT '工具名称',
    `tool_desc` VARCHAR(500) DEFAULT '' COMMENT '工具描述',
    `input_schema` JSON COMMENT '输入参数Schema',
    `is_enabled` TINYINT DEFAULT 1 COMMENT '启用状态',
    `sort` INT UNSIGNED DEFAULT 0 COMMENT '排序',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_mcp_tool_endpoint` (`endpoint_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='MCP工具注册表';

-- ========================================================
-- 十三、用户与系统模块（扩展 RuoYi）
-- ========================================================

-- 13.1 用户扩展信息表（关联 sys_user）
DROP TABLE IF EXISTS `gw_user_profile`;
CREATE TABLE `gw_user_profile` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '记录ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID（关联sys_user）',
    `nickname` VARCHAR(50) DEFAULT '' COMMENT '用户昵称',
    `birthday` DATE COMMENT '生日',
    `gender` TINYINT DEFAULT 0 COMMENT '性别：0未知 1男 2女',
    `job_title` VARCHAR(50) DEFAULT '' COMMENT '职位',
    `company` VARCHAR(100) DEFAULT '' COMMENT '公司',
    `bio` VARCHAR(500) DEFAULT '' COMMENT '个人简介',
    `privacy_level` TINYINT DEFAULT 2 COMMENT '隐私级别：1公开 2好友 3私密',
    `data_retention_days` INT DEFAULT 365 COMMENT '数据保留天数',
    `notify_enabled` TINYINT DEFAULT 1 COMMENT '消息通知：0关闭 1开启',
    `disturb_start` TIME COMMENT '勿扰时段开始',
    `disturb_end` TIME COMMENT '勿扰时段结束',
    `theme_preference` VARCHAR(20) DEFAULT 'auto' COMMENT '主题偏好',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_gw_user_profile_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户扩展信息表';

-- 13.2 用户订阅与会员表
DROP TABLE IF EXISTS `gw_user_subscription`;
CREATE TABLE `gw_user_subscription` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '订阅ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `member_level` TINYINT DEFAULT 1 COMMENT '会员等级：1免费 2基础 3高级 4专业',
    `level_name` VARCHAR(20) DEFAULT '免费版' COMMENT '等级名称',
    `expire_date` DATE COMMENT '过期日期',
    `total_devices` INT DEFAULT 1 COMMENT '设备总数限制',
    `total_agents` INT DEFAULT 3 COMMENT '智能体总数限制',
    `total_voice_clones` INT DEFAULT 1 COMMENT '音色克隆次数限制',
    `features` JSON COMMENT '功能权限列表',
    `create_time` DATETIME COMMENT '创建时间',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_gw_user_sub_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户订阅与会员表';

-- 13.3 操作审计日志表（扩展 sys_oper_log）
DROP TABLE IF EXISTS `gw_audit_log`;
CREATE TABLE `gw_audit_log` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
    `user_name` VARCHAR(50) DEFAULT '' COMMENT '用户名',
    `oper_type` TINYINT DEFAULT 0 COMMENT '操作类型：1查询 2新增 3修改 4删除 5导出 6登录',
    `oper_module` VARCHAR(50) DEFAULT '' COMMENT '操作模块',
    `oper_desc` VARCHAR(255) DEFAULT '' COMMENT '操作描述',
    `request_method` VARCHAR(10) DEFAULT '' COMMENT '请求方法',
    `request_url` VARCHAR(255) DEFAULT '' COMMENT '请求URL',
    `request_params` TEXT COMMENT '请求参数',
    `response_data` TEXT COMMENT '响应数据',
    `oper_ip` VARCHAR(128) DEFAULT '' COMMENT '操作IP',
    `oper_location` VARCHAR(255) DEFAULT '' COMMENT '操作地点',
    `status` TINYINT DEFAULT 0 COMMENT '状态：0正常 1异常',
    `error_msg` VARCHAR(2000) DEFAULT '' COMMENT '错误消息',
    `cost_time` BIGINT DEFAULT 0 COMMENT '耗时（毫秒）',
    `create_time` DATETIME COMMENT '创建时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_audit_user` (`user_id`),
    INDEX `idx_gw_audit_module` (`oper_module`),
    INDEX `idx_gw_audit_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作审计日志表';

-- 13.4 系统参数表（扩展 sys_params，工位搭子专用）
DROP TABLE IF EXISTS `gw_system_config`;
CREATE TABLE `gw_system_config` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '配置ID',
    `config_key` VARCHAR(100) NOT NULL COMMENT '配置键',
    `config_value` TEXT COMMENT '配置值',
    `value_type` VARCHAR(20) DEFAULT 'string' COMMENT '值类型：string/number/boolean/json/array',
    `config_group` VARCHAR(50) DEFAULT 'common' COMMENT '配置分组：common/device/agent/productivity',
    `remark` VARCHAR(200) DEFAULT '' COMMENT '备注',
    `is_system` TINYINT DEFAULT 0 COMMENT '是否系统配置',
    `create_by` VARCHAR(64) DEFAULT '' COMMENT '创建者',
    `create_time` DATETIME COMMENT '创建时间',
    `update_by` VARCHAR(64) DEFAULT '' COMMENT '更新者',
    `update_time` DATETIME COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_gw_sys_config_key` (`config_key`),
    INDEX `idx_gw_sys_config_group` (`config_group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工位搭子系统参数表';

-- ========================================================
-- 十四、WebSocket连接监控模块
-- ========================================================

-- 14.1 设备连接状态表
DROP TABLE IF EXISTS `gw_connection_log`;
CREATE TABLE `gw_connection_log` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
    `device_id` VARCHAR(32) NOT NULL COMMENT '设备ID',
    `connect_type` VARCHAR(20) DEFAULT 'websocket' COMMENT '连接类型：websocket/mqtt',
    `event_type` TINYINT NOT NULL COMMENT '事件类型：1连接 2断开 3重连',
    `latency_ms` INT DEFAULT 0 COMMENT '延迟（毫秒）',
    `packet_loss` DECIMAL(5,2) DEFAULT 0 COMMENT '丢包率',
    `client_ip` VARCHAR(128) DEFAULT '' COMMENT '客户端IP',
    `error_msg` VARCHAR(500) DEFAULT '' COMMENT '错误信息',
    `create_time` DATETIME COMMENT '创建时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_conn_device` (`device_id`),
    INDEX `idx_gw_conn_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备连接状态日志表';

-- ========================================================
-- 十五、场景识别模块
-- ========================================================

-- 15.1 场景识别记录表
DROP TABLE IF EXISTS `gw_scene_recognition`;
CREATE TABLE `gw_scene_recognition` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '记录ID',
    `device_id` VARCHAR(32) NOT NULL COMMENT '设备ID',
    `scene_label` VARCHAR(20) DEFAULT '' COMMENT '场景标签：工作中/休息中/离开/会议中',
    `confidence` DECIMAL(5,2) DEFAULT 0 COMMENT '置信度：0.00-1.00',
    `trigger_mode` TINYINT DEFAULT 1 COMMENT '触发方式：1自动 2手动',
    `image_url` VARCHAR(255) DEFAULT '' COMMENT '场景图片URL（可选）',
    `create_time` DATETIME COMMENT '识别时间',
    PRIMARY KEY (`id`),
    INDEX `idx_gw_scene_device` (`device_id`),
    INDEX `idx_gw_scene_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='场景识别记录表';

-- ========================================================
-- 初始化数据
-- ========================================================

-- 初始化云服务套餐
INSERT INTO `gw_cloud_plan` (`id`, `plan_code`, `plan_name`, `plan_desc`, `cpu_cores`, `memory_gb`, `storage_gb`, `monthly_price`, `yearly_price`, `max_tasks`, `max_file_size`, `features`, `is_enabled`, `sort`, `create_time`) VALUES
('PLAN_BASIC', 'basic', '基础版', '适合个人用户的轻量办公需求', 2, 4, 50, 29.00, 290.00, 3, 104857600, '["doc_process", "light_task"]', 1, 1, NOW()),
('PLAN_STANDARD', 'standard', '标准版', '适合职场人士的中度使用', 4, 8, 100, 69.00, 690.00, 5, 209715200, '["doc_process", "code_exec", "data_analysis"]', 1, 2, NOW()),
('PLAN_PROFESSIONAL', 'professional', '专业版', '适合专业用户重度使用', 8, 16, 200, 149.00, 1490.00, 10, 524288000, '["doc_process", "code_exec", "data_analysis", "ai_enhance"]', 1, 3, NOW()),
('PLAN_ENTERPRISE', 'enterprise', '企业版', '适合团队协作与私有部署', 16, 32, 500, 0.00, 0.00, 50, 1073741824, '["all_features", "team_collab", "private_deploy"]', 1, 4, NOW());

-- 初始化系统参数
INSERT INTO `gw_system_config` (`config_key`, `config_value`, `value_type`, `config_group`, `remark`, `is_system`) VALUES
('device.max_per_user', '5', 'number', 'device', '每个用户最多绑定设备数', 1),
('agent.max_per_user', '10', 'number', 'agent', '每个用户最多创建智能体数', 1),
('memory.max_file_size', '102400', 'number', 'memory', '记忆文件最大大小（字节）', 1),
('memory.save_interval', '300', 'number', 'memory', '记忆文件保存间隔（秒）', 1),
('env.data_retention_days', '90', 'number', 'env', '环境数据保留天数', 1),
('focus.calc_interval', '60', 'number', 'env', '专注度计算间隔（秒）', 1),
('message.max_unread', '99', 'number', 'message', '未读消息最大显示数', 1),
('productivity.task_timeout', '3600', 'number', 'productivity', '任务默认超时时间（秒）', 1),
('productivity.max_retry', '3', 'number', 'productivity', '任务最大重试次数', 1),
('security.token_rotate_days', '90', 'number', 'security', 'Token轮换提醒天数', 1);

-- 初始化智能体模板
INSERT INTO `gw_agent_template` (`id`, `template_code`, `template_name`, `template_icon`, `template_desc`, `category`, `system_prompt`, `lang_code`, `temperature`, `max_tokens`, `is_system`, `is_enabled`, `sort`, `create_time`) VALUES
('AGENT_TPL_WORK', 'work_assistant', '职场助手', '🤖', '专注提升工作效率的智能助手', 'work', '你是一位专业的职场助手，擅长时间管理、任务规划和效率提升。请用简洁专业的语言回答用户问题。', 'zh-CN', 0.70, 2048, 1, 1, 1, NOW()),
('AGENT_TPL_LIFE', 'life_companion', '生活伴侣', '🏠', '温暖贴心的生活助手', 'life', '你是一位温暖的生活伴侣，关心用户的身心健康和生活品质。用亲切自然的语言与用户交流。', 'zh-CN', 0.80, 2048, 1, 1, 2, NOW()),
('AGENT_TPL_CODE', 'code_helper', '编程助手', '💻', '专业编程辅助与代码审查', 'work', '你是一位资深程序员，精通多种编程语言和技术栈。请提供高质量的代码和详细的技术解释。', 'zh-CN', 0.60, 4096, 1, 1, 3, NOW()),
('AGENT_TPL_DATA', 'data_analyst', '数据分析师', '📊', '数据分析与可视化专家', 'work', '你是一位数据分析专家，擅长数据清洗、统计分析和可视化呈现。请用数据驱动的方式回答问题。', 'zh-CN', 0.70, 2048, 1, 1, 4, NOW()),
('AGENT_TPL_ENTERTAIN', 'entertainment', '娱乐伙伴', '🎮', '轻松愉快的娱乐陪伴', 'entertain', '你是一位有趣的娱乐伙伴，了解各种流行文化和娱乐资讯。用轻松幽默的方式与用户互动。', 'zh-CN', 0.90, 2048, 1, 1, 5, NOW());

-- 初始化智能体标签
INSERT INTO `gw_agent_tag` (`id`, `tag_name`, `tag_color`, `sort`, `create_by`, `create_time`) VALUES
('TAG_WORK', '职场', '#1890ff', 1, 'system', NOW()),
('TAG_LIFE', '生活', '#52c41a', 2, 'system', NOW()),
('TAG_TECH', '技术', '#722ed1', 3, 'system', NOW()),
('TAG_STUDY', '学习', '#faad14', 4, 'system', NOW()),
('TAG_ENTERTAIN', '娱乐', '#eb2f96', 5, 'system', NOW());

-- 初始化模型提供商
INSERT INTO `gw_model_provider` (`id`, `model_type`, `provider_code`, `provider_name`, `fields`, `doc_link`, `is_system`, `is_enabled`, `sort`, `create_time`) VALUES
('PROV_LLM_OPENAI', 'LLM', 'OpenAILLM', 'OpenAI', '[{"key":"api_key","label":"API密钥","type":"string"},{"key":"model","label":"模型","type":"string","default":"gpt-4o"}]', 'https://platform.openai.com/docs', 1, 1, 1, NOW()),
('PROV_LLM_CLAUDE', 'LLM', 'ClaudeLLM', 'Anthropic Claude', '[{"key":"api_key","label":"API密钥","type":"string"},{"key":"model","label":"模型","type":"string","default":"claude-3-sonnet"}]', 'https://docs.anthropic.com', 1, 1, 2, NOW()),
('PROV_LLM_DOUBAO', 'LLM', 'DoubaoLLM', '字节豆包', '[{"key":"api_key","label":"API密钥","type":"string"},{"key":"model","label":"模型","type":"string","default":"doubao-pro"}]', 'https://www.volcengine.com/docs', 1, 1, 3, NOW()),
('PROV_TTS_DOUBAO', 'TTS', 'DoubaoTTS', '字节豆包TTS', '[{"key":"api_key","label":"API密钥","type":"string"},{"key":"voice","label":"音色","type":"string"}]', 'https://www.volcengine.com/docs', 1, 1, 4, NOW()),
('PROV_ASR_DOUBAO', 'ASR', 'DoubaoASR', '字节豆包ASR', '[{"key":"api_key","label":"API密钥","type":"string"}]', 'https://www.volcengine.com/docs', 1, 1, 5, NOW()),
('PROV_VAD_SILERO', 'VAD', 'SileroVAD', 'Silero VAD', '[{"key":"model_path","label":"模型路径","type":"string"}]', 'https://github.com/snakers4/silero-vad', 1, 1, 6, NOW()),
('PROV_MEM_LOCAL', 'Memory', 'LocalMemory', '本地记忆', '[{"key":"storage_path","label":"存储路径","type":"string"}]', '', 1, 1, 7, NOW()),
('PROV_INTENT_RULE', 'Intent', 'RuleIntent', '规则意图', '[]', '', 1, 1, 8, NOW());

-- 初始化模型配置
INSERT INTO `gw_model_config` (`id`, `model_type`, `provider_id`, `model_code`, `model_name`, `config_json`, `is_default`, `is_enabled`, `sort`, `create_time`) VALUES
('CFG_LLM_GPT4O', 'LLM', 'PROV_LLM_OPENAI', 'GPT4o', 'GPT-4o', '{"api_key":"","model":"gpt-4o","temperature":0.7,"max_tokens":2048}', 1, 1, 1, NOW()),
('CFG_LLM_CLAUDE', 'LLM', 'PROV_LLM_CLAUDE', 'ClaudeSonnet', 'Claude 3 Sonnet', '{"api_key":"","model":"claude-3-sonnet-20240229","temperature":0.7,"max_tokens":2048}', 0, 1, 2, NOW()),
('CFG_LLM_DOUBAO', 'LLM', 'PROV_LLM_DOUBAO', 'DoubaoPro', '豆包Pro', '{"api_key":"","model":"doubao-pro-32k","temperature":0.7,"max_tokens":2048}', 0, 1, 3, NOW()),
('CFG_TTS_DOUBAO', 'TTS', 'PROV_TTS_DOUBAO', 'DoubaoTTS', '豆包TTS', '{"api_key":"","voice":"zh_female_shuangkuaisisi_moon_bigtts"}', 1, 1, 4, NOW()),
('CFG_ASR_DOUBAO', 'ASR', 'PROV_ASR_DOUBAO', 'DoubaoASR', '豆包ASR', '{"api_key":""}', 1, 1, 5, NOW()),
('CFG_VAD_SILERO', 'VAD', 'PROV_VAD_SILERO', 'SileroVAD', 'Silero VAD', '{"model_path":"silero_vad.onnx"}', 1, 1, 6, NOW()),
('CFG_MEM_LOCAL', 'Memory', 'PROV_MEM_LOCAL', 'LocalMemory', '本地记忆', '{"storage_path":"./memory"}', 1, 1, 7, NOW()),
('CFG_INTENT_RULE', 'Intent', 'PROV_INTENT_RULE', 'RuleIntent', '规则意图识别', '{}', 1, 1, 8, NOW());

-- 初始化TTS音色
INSERT INTO `gw_tts_voice` (`id`, `tts_model_id`, `voice_name`, `voice_code`, `language`, `gender`, `age_group`, `emotion_tags`, `demo_url`, `is_system`, `is_enabled`, `sort`, `create_time`) VALUES
('VOICE_SHUANGKUAI', 'CFG_TTS_DOUBAO', '爽快思思', 'zh_female_shuangkuaisisi_moon_bigtts', 'zh-CN', 2, 2, '活泼,开朗', '', 1, 1, 1, NOW()),
('VOICE_WENROU', 'CFG_TTS_DOUBAO', '温柔女声', 'zh_female_wenrouxxx_moon_bigtts', 'zh-CN', 2, 2, '温柔,亲切', '', 1, 1, 2, NOW()),
('VOICE_CHENWEN', 'CFG_TTS_DOUBAO', '沉稳男声', 'zh_male_chenwenxxx_moon_bigtts', 'zh-CN', 1, 3, '沉稳,专业', '', 1, 1, 3, NOW()),
('VOICE_TONGBAO', 'CFG_TTS_DOUBAO', '童声小宝', 'zh_male_tongbaoxxx_moon_bigtts', 'zh-CN', 1, 1, '可爱,天真', '', 1, 1, 4, NOW());

-- 初始化生产力工具配置
INSERT INTO `gw_productivity_tool` (`id`, `user_id`, `device_id`, `tool_type`, `tool_name`, `is_enabled`, `tool_config`, `sort`, `create_time`) VALUES
(1, 0, NULL, 1, '文档处理', 1, '{"max_file_size":104857600,"supported_formats":["docx","pdf","txt","md"]}', 1, NOW()),
(2, 0, NULL, 2, '代码执行', 1, '{"supported_languages":["python","javascript","bash"],"timeout":300}', 2, NOW()),
(3, 0, NULL, 3, '数据分析', 1, '{"max_rows":100000,"supported_formats":["csv","xlsx","json"]}', 3, NOW()),
(4, 0, NULL, 4, 'AI增强', 1, '{"enhancement_types":["summarize","translate","rewrite","code_gen"]}', 4, NOW());

-- ========================================================
-- 表结构说明
-- ========================================================
-- 1. 设备管理模块: gw_device, gw_device_plugin, gw_ota_firmware, gw_ota_record, gw_device_batch_task
-- 2. 智能体管理模块: gw_agent, gw_agent_template, gw_agent_tag, gw_agent_tag_relation, gw_agent_context
-- 3. 模型配置模块: gw_model_provider, gw_model_config, gw_tts_voice
-- 4. 声纹与音色克隆模块: gw_voiceprint, gw_voice_clone
-- 5. 记忆模块: gw_memory_timeline, gw_memory_file, gw_memory_file_version, gw_data_export
-- 6. 聊天记录模块: gw_chat_session, gw_chat_message, gw_chat_audio
-- 7. 知识库模块: gw_knowledge_base, gw_knowledge_doc
-- 8. 生产力模块: gw_cloud_plan, gw_cloud_subscription, gw_productivity_task, gw_workspace_file, gw_productivity_tool
-- 9. 环境与专注度模块: gw_env_data, gw_focus_data, gw_daily_stats
-- 10. 消息中心模块: gw_message
-- 11. 定时任务与心跳模块: gw_cron_task, gw_heartbeat_task
-- 12. MCP工具模块: gw_mcp_endpoint, gw_mcp_tool
-- 13. 用户与系统模块: gw_user_profile, gw_user_subscription, gw_audit_log, gw_system_config
-- 14. WebSocket连接监控模块: gw_connection_log
-- 15. 场景识别模块: gw_scene_recognition
-- ========================================================