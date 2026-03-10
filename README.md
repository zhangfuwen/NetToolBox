# 网络调试工具箱 (NetToolBox)

纯鸿蒙应用 (HarmonyOS Next)，用于网络调试和开发。

## 功能

- [ ] Ping - 网络连通性测试
- [ ] HTTP 客户端 - 发送 HTTP 请求
- [ ] TCP/UDP 服务端 - 本地服务器
- [ ] BLE 调试器 - 蓝牙低功耗设备调试
- [ ] WiFi 分析 - 信号强度和信道分析
- [ ] 端口扫描 - 扫描开放端口

## 技术栈

- 语言: ArkTS
- UI: ArkUI
- 最低版本: HarmonyOS 3.1 / API 9

## 开发环境

1. 安装 DevEco Studio
2. 配置 HarmonyOS SDK
3. 连接鸿蒙设备或启动模拟器

## 构建

```bash
# 在 DevEco Studio 中打开项目
# 点击 Build -> Build Hap(s)/App(s)
```

## 权限

- ohos.permission.INTERNET - 网络访问
- ohos.permission.GET_WIFI_INFO - WiFi 信息
- ohos.permission.LOCATION - 位置（WiFi 扫描需要）
- ohos.permission.ACCESS_BLUETOOTH - 蓝牙
