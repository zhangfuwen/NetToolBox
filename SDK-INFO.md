# 鸿蒙 SDK 构建信息

## SDK 位置

本地 SDK 路径：`/Users/zhangfuwen/bin/command-line-tools/`

### 目录结构
```
command-line-tools/
├── bin/                    # 可执行工具
│   ├── codelinter         # 代码检查工具
│   ├── hstack             # 鸿蒙栈工具
│   ├── hvigorw            # 构建工具 (版本 6.22.3)
│   └── ohpm               # 包管理器
├── hvigor/                # hvigor 构建系统 (270MB)
│   ├── bin/
│   ├── hvigor/
│   └── hvigor-ohos-plugin/
├── ohpm/                  # OHPM 包管理
├── sdk/                   # SDK 目录
│   └── default/
├── tool/                  # 工具目录
│   └── node/
├── LICENSE.txt
├── NOTICE.txt
└── version.txt
```

## 环境变量配置

```bash
# 添加到 PATH
export PATH=/Users/zhangfuwen/bin/command-line-tools/bin:$PATH

# SDK 根目录
export HOS_SDK=/Users/zhangfuwen/bin/command-line-tools

# 工具链目录
export HOS_TOOLCHAINS=/Users/zhangfuwen/bin/command-line-tools/toolchains
```

## 构建命令

```bash
# 设置环境
export PATH=/Users/zhangfuwen/bin/command-line-tools/bin:$PATH

# 构建 HAP (Debug)
cd /path/to/project
hvigorw assembleHap --mode debug

# 构建 HAP (Release)
hvigorw assembleHap --mode release

# 查看版本
hvigorw --version
```

## 项目结构要求

鸿蒙项目需要以下文件：
- `build-profile.json5` - 构建配置
- `hvigor/hvigor-config.json5` - hvigor 配置
- `hvigorfile.ts` - hvigor 任务配置
- `oh-package.json5` - 包管理配置
- `entry/src/main/module.json5` - 模块配置
- `entry/src/main/resources/base/profile/main_pages.json` - 页面路由

## 已知问题

1. **CI 构建困难**：华为没有提供公开 SDK 下载链接，需要预上传 SDK 到 GitHub Releases
2. **项目结构复杂**：手动创建容易出错，建议使用 DevEco Studio 创建项目后复制代码
3. **SDK 体积大**：完整 SDK 约 5.9GB，精简后仍需 270MB+

## 替代方案

- **本地构建**：使用 DevEco Studio IDE
- **Android 版本**：功能相同，CI 构建简单

## 参考链接

- 华为命令行工具下载：https://developer.huawei.com/consumer/cn/download/command-line-tools-for-hmos
- npm 包：harmonyos-deploy (社区方案)
