# 知晓云 - 小程序开发快人一步

[知晓云](https://cloud.minapp.com/)是国内首家专注于小程序开发的后端云服务，为以小程序为代表的大前端开发者提供最低门槛的 Serverless 无服务架构接入体验。

它免去了小程序等大前端开发中服务器搭建、域名备案、数据接口实现等繁琐流程。让开发者专注于业务逻辑的实现，使用知晓云开发小程序、app、网站，门槛更低，效率更高。

![](images/001.jpg)

* 小程序云：各大小程序平台功能定制化支持，开箱即用
* 全平台：跨终端支持，可同时关联小程序、iOS、网页等多个平台
* 极速开发：轻量级 SDK，两行代码即可完成接入
* 高效稳定：弹性结构，自动扩容，轻松应对大流量

![](images/002.jpg)

**不断更新的开发工具，带来肉眼可见的效率提升**

* [弹性数据库](https://cloud.minapp.com/service/database/)：自动扩容，权限可控
* [云函数](https://cloud.minapp.com/service/cloud-function/)：运维成本低，扩展能力强
* [触发器](https://cloud.minapp.com/service/trigger/)：串起业务流的自动化引擎
* [第三方支付](https://cloud.minapp.com/service/payment/)：一行代码即可完成接入
* [运营后台](https://cloud.minapp.com/service/user-dashboard/)：智能扩展，自动部署


![](images/003.jpg)

**丰富的解决方案，满足不同行业应用场景**

* [知晓推送](https://cloud.minapp.com/solution/zhixiao-push/)：融合全平台模板消息推送服务，精准触达用户
* [iBeacon 室内外定位导航](https://cloud.minapp.com/solution/geo/)：远超国际标准，室内定位精度在 2 米内的 LBS 服务
* [小电商](https://minshop.com/)：开箱即用，拿来即用的 SaaS 电商小程序
* [跨境支付](https://cloud.minapp.com/solution/cross-border-payment/)：支持跨境收款，轻松完成业务出海
* [小游戏](https://cloud.minapp.com/solution/minigame/)：利用知晓云提供的核心组件，轻松实现小游戏


## 文档

* [SDK 使用文档](https://doc.minapp.com/)

## 目录结构

```
├── CHANGELOG.md
├── README.md
├── lib                       // 核心模块
├── test                      // 单元测试
├── example                   // 测试用例
├── images                   
├── pubspec.yaml              // 项目配置文件
└── pubspec.lock
```

## 贡献

### 开发流程

* 构建 Flutter 环境，详见[这里](https://flutter.dev/docs/get-started/install)。
* `flutter pub get` 安装依赖
* 开发、测试并提交代码
* [SDK 使用文档](https://github.com/ifanrx/hydrogen-sdk-doc) 中添加对应的内容
* PR ( SDK 与文档共两个 PR )

### 代码提交规范

* 内部方法的注释可以使用以下方式：

    ```
    /// 这是一条注释。
    /// 使用了 [param] 作为参数
    ```

* 代码中的逻辑部分需要写单元测试，后端接口调用部分不需要单元测试（这部分由集成测试应用来完成）。
