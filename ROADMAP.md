# App Store Connect API 能力 Todo List

本文档列出了苹果 [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi) 支持的所有核心能力，并标记了当前 MCP 服务端已实现的工具。

---

## 📋 业务领域与能力清单

### 1. App 元数据与版本生命周期管理 (App Metadata & Lifecycle)
*   **App 基础操作**：
    *   [x] 查询 App 列表 (已实现工具: `list_apps`)
    *   [x] 获取 App 详情 (已实现工具: `get_app_details`)
*   **App Store 版本 (App Store Versions)**：
    *   [x] 查询指定 App 的版本列表 (已实现工具: `list_app_store_versions`)
    *   [x] 创建新的待提交版本 (已实现工具: `create_app_store_version`)
    *   [ ] 提审/提交发布 App Store 版本
    *   [x] 查询版本的语言本地化文本 (已实现工具: `list_app_store_version_localizations`)
    *   [x] 更新新版本的本地化文本 (描述 Description、关键词 Keywords、促销文本 Promotional Text) (已实现工具: `update_app_store_version_localizations`)
    *   [ ] 管理分阶段发布/渐进式更新 (Phased Releases)
*   **App 基础属性与分类 (App Infos & Categories)**：
    *   [x] 查询 App 基础信息 (包含分类关系等) (已实现工具: `list_app_infos`)
    *   [x] 查询分类的语言本地化 (已实现工具: `list_app_info_localizations`)
    *   [x] 更新 App 副标题 (Subtitle) (已实现工具: `update_app_info_localizations`)
    *   [x] 获取苹果官方全部分类 ID 字典 (已实现工具: `list_app_categories`)
    *   [x] 修改 App 主分类关系 (已实现工具: `update_app_info`)
    *   [ ] 声明 App 的数据隐私政策与年龄分级 (Age Ratings & Privacy Declarations)
*   **媒体资产管理 (Screenshots & Previews)**：
    *   [ ] 查询 App 截图组 (App Screenshot Sets) 列表
    *   [ ] 上传 App 屏幕截图 (App Screenshots)
    *   [ ] 删除、重新排序屏幕截图
    *   [ ] 管理 App 视频预览 (App Previews) 组与素材
*   **价格与分发 (Pricing & Availability)**：
    *   [ ] 查询或修改 App 的全球定价等级 (Pricing Tiers)
    *   [ ] 配置特定国家/地区的上架与下架状态 (Territory Availabilities)
    *   [ ] 管理 App 预订 (Pre-orders) 状态

---

### 2. TestFlight 与 Beta 测试自动化 (TestFlight & Beta Testing)
*   **构建版本管理 (Builds)**：
    *   [x] 查询从 Xcode 上传的所有构建包的列表与处理进度 (已实现工具: `list_builds`)
    *   [x] 获取特定版本的最新构建包状态 (已实现工具: `get_latest_build_info`)
    *   [ ] 更新构建版本的测试合规性出口申报 (Export Compliance)
    *   [ ] 修改构建版本的 TestFlight 测试说明 (What to Test)
*   **测试群组 (Beta Groups)**：
    *   [x] 获取应用的 Beta 测试包群组列表 (已实现工具: `list_beta_groups`)
    *   [x] 自动化新建公开或内部的测试群组 (已实现工具: `create_beta_group`)
    *   [ ] 修改或删除测试群组 (如启用 Public Link 邀请)
*   **测试员管理 (Beta Testers)**：
    *   [x] 列出特定群组内绑定的所有 Beta 测试员 (已实现工具: `list_beta_testers`)
    *   [x] 绑定已有的测试人员到指定的群组 (已实现工具: `add_beta_tester_to_group`)
    *   [ ] 添加、邀请新的 Beta 测试员 (外部/内部)
    *   [ ] 从群组或 App 中移除测试员
*   **沙盒测试管理 (Sandbox Testers)**：
    *   [ ] 列出沙盒测试 Apple ID 账号
    *   [ ] 一键清除特定沙盒账号的购买历史纪录

---

### 3. App 内购买项目与订阅管理 (In-App Purchases & Subscriptions)
*   **独立内购项 (In-App Purchases / IAP)**：
    *   [ ] 创建非消耗型/消耗型/非续期订阅内购商品
    *   [ ] 修改内购的元数据、定价计划 (IAP Price Schedules)
    *   [ ] 管理内购的本地化语言显示名称与描述
    *   [ ] 上传和管理内购对应的 App Store 审核截图
*   **自动续期订阅 (Auto-Renewable Subscriptions)**：
    *   [ ] 创建和管理订阅组 (Subscription Groups) 与订阅项目
    *   [ ] 配置推介服务价格 (Introductory Offers)
    *   [ ] 管理促销代码优惠 (Offer Codes)
    *   [ ] 配置订阅赢回优惠方案 (Win-Back Offers)

---

### 4. 用户反馈、评分与评价回复 (Ratings & Customer Reviews)
*   **评分数据 (Ratings)**：
    *   [ ] 获取 App 收集到的累计评分统计 (Ratings)
*   **客户评价 (Customer Reviews)**：
    *   [x] 拉取指定 App 的评分与评论详情 (已实现工具: `list_customer_reviews`)
*   **官方开发者答复 (Review Replies)**：
    *   [x] 向特定的用户评论直接提交或修改开发者答复 (已实现工具: `submit_customer_review_reply`)
    *   [ ] 删除已发表的官方回复

---

### 5. 开发者团队、角色与权限管理 (Users & Roles)
*   **团队成员管理 (Users)**：
    *   [x] 列出当前开发者账号下的所有人及角色 (已实现工具: `list_users`)
    *   [ ] 更改团队成员的角色权限 (Roles)
    *   [ ] 限制非管理员用户仅对指定 App 的可见性权限 (App Visibilities)
*   **邀请成员 (User Invitations)**：
    *   [ ] 发送新成员加入团队的 Email 邀请
    *   [ ] 撤销或删除待处理的邀请

---

### 6. 数据报告、销售财务与分析 (Reports & Analytics)
*   [ ] 下载销售与趋势报告 (Sales and Trends Reports) CSV
*   [ ] 下载财务与结算付款报告 (Finance Reports)
*   [ ] 查询 App 的崩溃日志与统计数据 (Crash Logs)
*   [ ] 获取电量、启动时间、内存等 App 性能诊断指标 (Power & Performance Metrics)

---

### 7. 证书、标识符与描述文件 (Certificates, Identifiers & Profiles)
*   [ ] 创建、吊销、下载开发/发布证书 (Certificates)
*   [ ] 注册和列出测试真机 UDID 设备 (Devices)
*   [ ] 注册 Bundle ID 并配置其服务权限 (Capabilities)
*   [ ] 生成、下载和删除 Provisioning Profiles 描述文件

---

### 8. 高级营销与推广特性 (Advanced Marketing Features)
*   [ ] 创建与配置自定义产品页面 (Custom Product Pages)
*   [ ] 配置 App Store 页面 A/B 测试实验 (A/B Test / Experiments)
*   [ ] 创建 App 内限时活动推广 (App Events)
