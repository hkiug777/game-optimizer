# 游戏安全优化工具

一个用于 Windows 的安全游戏优化批处理脚本，支持**三角洲行动**和 **CS2**。

## 安全承诺

- **不修改注册表**
- **不更改系统文件**
- **不关闭杀毒防护**（可选择临时退出火绒）
- **不使用任何 bcdedit、超频、注入等危险操作**
- 所有操作均为**临时性**，重启电脑后自动恢复
- 停止的服务仅临时关闭，不禁用，重启后自动恢复

## 功能

| 选项 | 功能 | 说明 |
|------|------|------|
| 1 | 一键游戏优化 | 关闭后台进程 + 停止非必要服务 + 卓越性能电源计划 + 刷新DNS |
| 2 | 仅结束后台进程 | 只关闭后台进程，不停止服务 |
| 3 | 设置游戏高优先级 | 自动识别三角洲/CS2，设置High优先级并确认电源计划 |
| 4 | 清理系统临时文件 | 清理TEMP、Windows\Temp、缩略图缓存 |
| 5 | 网络延迟优化 | 刷新DNS缓存 + 测试网关/DNS延迟 |
| 6 | 临时关闭后台服务 | 停止更新、索引、遥测、诊断、Xbox、SysMain等服务 |
| 7 | 退出火绒安全软件 | 临时关闭火绒进程和服务（火绒有自我保护，可能需手动退出） |
| 8 | 查看系统状态 | CPU/内存/显卡温度/电源计划/网络延迟/进程占用 |

## 使用方法

1. 右键 `GameOptimizer.bat` → **以管理员身份运行**
2. 启动游戏前选择 `[1]` 一键优化
3. 游戏进入大厅后切回窗口选择 `[3]` 设置高优先级
4. 打完游戏正常关闭即可，重启电脑全部恢复

## 关闭的进程（11大类）

- **聊天类**：QQ、微信、微信小程序、微信输入法、钉钉、飞书、腾讯会议、Zoom、Discord
- **视频类**：腾讯视频、爱奇艺、优酷、B站客户端、Spotify
- **直播类**：抖音、虎牙、OBS、抖音直播伴侣、B站直播姬
- **GPU占用类**：NVIDIA Broadcast、NVIDIA Overlay、ShadowPlay、Wallpaper Engine
- **Xbox类**：Game Bar、Game DVR、Xbox应用
- **游戏平台类**：Steam网页辅助、Epic、WeGame、完美世界竞技平台、迅游加速器
- **网盘下载类**：OneDrive、百度网盘、迅雷、qBittorrent、BitComet、IDM
- **浏览器办公类**：豆包、Chrome、Edge、Firefox、WPS、Word/Excel/PPT
- **远程串流类**：向日葵、ToDesk、TeamViewer、Parsec、Moonlight、DroidCam、Cloudflare WARP、MuMu模拟器
- **外设灯效类**：罗技G HUB全家桶、技嘉GCC/EasyTune/XTU、海盗船iCUE/设备服务、华硕灯效、雷蛇
- **其他**：触摸键盘、Flash助手、FANUC许可证、PLC服务、FlexNet许可证

## 停止的服务

- Windows更新：wuauserv、UsoSvc、BITS、DoSvc
- 搜索索引：WSearch
- SysMain预取
- 遥测诊断：DiagTrack、dmwappushservice、WerSvc、DPS、WdiServiceHost、WdiSystemHost
- Xbox：XblAuthManager、XblGameSave、XboxNetApiSvc、XboxGipSvc、GamingServices
- 触摸键盘：TabletInputService
- 其他：Print Spooler、SSDPSRV、upnphost、MapsBroker、lfsvc、Fax、RetailDemo、WMPNetworkSvc、PcaSvc

## 系统要求

- Windows 10/11
- 管理员权限
- NVIDIA显卡（部分状态显示功能依赖nvidia-smi）

## 编码说明

脚本使用 UTF-8 编码，开头已加 `chcp 65001`，在中文 Windows 下可正常显示中文。如遇乱码，请用记事本打开另存为 ANSI 编码。

## 免责声明

本脚本仅结束用户级进程和临时停止非关键服务，不会对系统造成永久性更改。使用前请确认已保存工作进度。作者不对因使用本脚本造成的任何损失负责。

## License

MIT
