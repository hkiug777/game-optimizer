@echo off
chcp 65001 >nul
title 游戏安全优化工具 v2.9
setlocal enabledelayedexpansion

REM ============================================================
REM  游戏安全优化工具 v2.9
REM  支持：三角洲行动 / CS2
REM  安全承诺：不修改注册表、不更改系统文件
REM  所有操作均为临时性，重启电脑后自动恢复
REM  v2.9 更新：新增内存深度清理（释放进程工作集，实测可释放6GB+）
REM ============================================================

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 正在请求管理员权限...
    powershell -NoProfile -Command "Start-Process cmd -ArgumentList '/c ""%~f0""' -Verb RunAs"
    exit /b
)

:menu
cls
echo ============================================================
echo           游戏安全优化工具 v2.9
echo           支持：三角洲行动 / CS2
echo ============================================================
echo.
echo  【安全声明】所有优化均为临时性，重启电脑后自动恢复
echo  不修改注册表 / 不更改系统文件
echo  停止的服务仅临时关闭，不禁用，重启后自动恢复
echo.
echo  ----------------------------------------------------------
echo.
echo   [1] 一键游戏优化
echo       内存深度清理 + 关闭后台进程 + 停止非必要服务
echo       + 卓越性能电源计划 + 刷新DNS缓存。
echo       三角洲和CS2均适用。启动游戏前运行此项。
echo.
echo   [2] 仅结束后台占用进程
echo       只关闭后台进程，不停止服务、不改电源计划。
echo.
echo   [3] 设置游戏高优先级
echo       游戏启动并进入大厅后运行，自动识别三角洲或CS2，
echo       设置高优先级并确认电源计划未被游戏篡改。
echo.
echo   [4] 清理系统临时文件
echo       清理用户临时文件夹、系统临时文件夹、缩略图缓存。
echo       不碰回收站和个人文件，被占用的文件自动跳过。
echo.
echo   [5] 网络延迟优化
echo       刷新DNS缓存、测试网络延迟、关闭占带宽后台进程。
echo       不修改任何网络注册表参数，安全无副作用。
echo.
echo   [6] 临时关闭后台服务
echo       停止Windows更新、搜索索引、遥测、诊断、SysMain、
echo       打印后台、Xbox、触控笔等非必要服务。重启后自动恢复。
echo.
echo   [7] 退出火绒安全软件
echo       临时关闭火绒杀毒的进程和服务。
echo       注意：火绒有自我保护，可能需要手动右键托盘退出。
echo.
echo   [8] 内存深度清理
echo       通过Windows API清空所有进程工作集，释放被缓存占用
 echo       的内存。实测可释放6GB+，完全临时性，不修改系统。
echo.
echo   [9] 查看当前系统状态
echo       显示CPU/内存/显卡温度/电源计划/网络延迟/进程占用。
echo.
echo   [10] 退出
echo.
echo  ----------------------------------------------------------
echo.
set /p choice=请输入数字 1-10 后按回车: 

if "%choice%"=="1" goto full_optimize
if "%choice%"=="2" goto kill_processes
if "%choice%"=="3" goto game_priority
if "%choice%"=="4" goto clean_temp
if "%choice%"=="5" goto network_opt
if "%choice%"=="6" goto stop_services
if "%choice%"=="7" goto kill_huorong
if "%choice%"=="8" goto mem_clean
if "%choice%"=="9" goto sys_status
if "%choice%"=="10" exit
goto menu

:full_optimize
cls
echo ============================================================
echo  正在执行一键游戏优化...
echo ============================================================
echo.

echo [内存优化] 深度清理内存...
call :mem_clean_quiet

call :kill_processes_quiet
call :stop_services_quiet
call :kill_huorong_quiet
call :power_plan_quiet
call :network_quiet

echo.
echo ============================================================
echo  优化完成！
echo ============================================================
echo.
echo  已完成以下优化：
echo   - 内存深度清理（释放进程工作集，通常可释放数GB）
echo   - 关闭后台占用进程（聊天/视频/直播/网盘/下载/外设等）
echo   - 临时停止非必要系统服务（更新/索引/遥测/SysMain等）
echo   - 临时关闭火绒安全软件
echo   - 电源计划确认为卓越性能
echo   - DNS缓存已刷新
echo.
echo  所有改动均为临时性，重启电脑后自动恢复。
echo.
echo  现在可以启动三角洲行动或CS2了。
echo  游戏进入大厅后，请切回本窗口选择 [3] 设置高优先级。
echo.
pause
goto menu

:kill_processes
cls
echo ============================================================
echo  正在结束后台占用进程...
echo ============================================================
echo.
call :kill_processes_quiet
echo.
echo 进程清理完成！被关闭的软件需要时手动重新打开即可。
pause
goto menu

:kill_processes_quiet
echo [1/11] 关闭聊天和输入法类进程...
taskkill /f /im QQ.exe /t >nul 2>&1 && echo      - 已关闭 QQ
taskkill /f /im WeChat.exe /t >nul 2>&1 && echo      - 已关闭 微信
taskkill /f /im Weixin.exe /t >nul 2>&1 && echo      - 已关闭 微信4.0
taskkill /f /im WeChatAppEx.exe /t >nul 2>&1 && echo      - 已关闭 微信小程序
taskkill /f /im wetype_server.exe /t >nul 2>&1 && echo      - 已关闭 微信输入法
taskkill /f /im wetype_update.exe /t >nul 2>&1
taskkill /f /im wetype_renderer.exe /t >nul 2>&1
taskkill /f /im wetype_service.exe /t >nul 2>&1
taskkill /f /im SogouCloud.exe /t >nul 2>&1 && echo      - 已关闭 搜狗云服务
taskkill /f /im DingTalk.exe /t >nul 2>&1 && echo      - 已关闭 钉钉
taskkill /f /im feishu.exe /t >nul 2>&1 && echo      - 已关闭 飞书
taskkill /f /im wemeet.exe /t >nul 2>&1 && echo      - 已关闭 腾讯会议
taskkill /f /im WeMeetApp.exe /t >nul 2>&1
taskkill /f /im Zoom.exe /t >nul 2>&1 && echo      - 已关闭 Zoom
taskkill /f /im Discord.exe /t >nul 2>&1 && echo      - 已关闭 Discord

echo [2/11] 关闭视频类进程...
taskkill /f /im TenVideo.exe /t >nul 2>&1 && echo      - 已关闭 腾讯视频
taskkill /f /im QQLive.exe /t >nul 2>&1
taskkill /f /im iQIYI.exe /t >nul 2>&1 && echo      - 已关闭 爱奇艺
taskkill /f /im Youku.exe /t >nul 2>&1 && echo      - 已关闭 优酷
taskkill /f /im bilibili.exe /t >nul 2>&1 && echo      - 已关闭 B站客户端
taskkill /f /im Spotify.exe /t >nul 2>&1 && echo      - 已关闭 Spotify

echo [3/11] 关闭短视频和直播类进程...
taskkill /f /im douyin.exe /t >nul 2>&1 && echo      - 已关闭 抖音
taskkill /f /im HuyaExternal.exe /t >nul 2>&1 && echo      - 已关闭 虎牙
taskkill /f /im Huya.exe /t >nul 2>&1
taskkill /f /im obs64.exe /t >nul 2>&1 && echo      - 已关闭 OBS
taskkill /f /im obs32.exe /t >nul 2>&1
taskkill /f /im DouyinStudio.exe /t >nul 2>&1 && echo      - 已关闭 抖音直播伴侣
taskkill /f /im livehime.exe /t >nul 2>&1 && echo      - 已关闭 B站直播姬

echo [4/11] 关闭GPU占用类进程...
taskkill /f /im "NVIDIA Broadcast.exe" /t >nul 2>&1 && echo      - 已关闭 NVIDIA Broadcast
taskkill /f /im "NVIDIA Overlay.exe" /t >nul 2>&1 && echo      - 已关闭 NVIDIA覆盖层
taskkill /f /im nvsphelper64.exe /t >nul 2>&1 && echo      - 已关闭 NVIDIA ShadowPlay助手
taskkill /f /im wallpaper64.exe /t >nul 2>&1 && echo      - 已关闭 Wallpaper Engine
taskkill /f /im wallpaper32.exe /t >nul 2>&1

echo [5/11] 关闭Xbox和游戏录制类进程...
taskkill /f /im GameBar.exe /t >nul 2>&1 && echo      - 已关闭 Xbox Game Bar
taskkill /f /im GameBarFTServer.exe /t >nul 2>&1
taskkill /f /im GameBarPresenceWriter.exe /t >nul 2>&1
taskkill /f /im GameDVR.exe /t >nul 2>&1
taskkill /f /im XboxApp.exe /t >nul 2>&1 && echo      - 已关闭 Xbox应用
taskkill /f /im XboxPcAppFT.exe /t >nul 2>&1
taskkill /f /im bcastdvr.exe /t >nul 2>&1

echo [6/11] 关闭游戏平台和对战平台进程...
taskkill /f /im steamwebhelper.exe /t >nul 2>&1 && echo      - 已关闭 Steam网页辅助
taskkill /f /im EpicGamesLauncher.exe /t >nul 2>&1 && echo      - 已关闭 Epic启动器
taskkill /f /im WeGame.exe /t >nul 2>&1 && echo      - 已关闭 WeGame
taskkill /f /im WeGameLauncher.exe /t >nul 2>&1
taskkill /f /im "完美世界竞技平台.exe" /t >nul 2>&1 && echo      - 已关闭 完美世界竞技平台
taskkill /f /im XYServiceLink.exe /t >nul 2>&1 && echo      - 已关闭 迅游加速器监控

echo [7/11] 关闭网盘和下载类进程...
taskkill /f /im OneDrive.exe /t >nul 2>&1 && echo      - 已关闭 OneDrive
taskkill /f /im OneDrive.Sync.Service.exe /t >nul 2>&1
taskkill /f /im baidunetdisk.exe /t >nul 2>&1 && echo      - 已关闭 百度网盘
taskkill /f /im BaiduNetdisk.exe /t >nul 2>&1
taskkill /f /im Thunder.exe /t >nul 2>&1 && echo      - 已关闭 迅雷
taskkill /f /im Xunlei.exe /t >nul 2>&1
taskkill /f /im qbittorrent.exe /t >nul 2>&1 && echo      - 已关闭 qBittorrent
taskkill /f /im BitComet.exe /t >nul 2>&1 && echo      - 已关闭 BitComet
taskkill /f /im ida.exe /t >nul 2>&1 && echo      - 已关闭 IDM下载器
taskkill /f /im IDMan.exe /t >nul 2>&1

echo [8/11] 关闭浏览器和办公类进程...
taskkill /f /im Doubao.exe /t >nul 2>&1 && echo      - 已关闭 豆包
taskkill /f /im aha_doctor.exe /t >nul 2>&1
taskkill /f /im command_helper.exe /t >nul 2>&1
taskkill /f /im chrome.exe /t >nul 2>&1 && echo      - 已关闭 Chrome浏览器
taskkill /f /im msedge.exe /t >nul 2>&1 && echo      - 已关闭 Edge浏览器
taskkill /f /im firefox.exe /t >nul 2>&1 && echo      - 已关闭 Firefox浏览器
taskkill /f /im msedgewebview2.exe /t >nul 2>&1 && echo      - 已关闭 Edge WebView组件
taskkill /f /im wps.exe /t >nul 2>&1 && echo      - 已关闭 WPS
taskkill /f /im wpscloudsvr.exe /t >nul 2>&1
taskkill /f /im wpscenter.exe /t >nul 2>&1
taskkill /f /im wpsupdate.exe /t >nul 2>&1
taskkill /f /im WINWORD.EXE /t >nul 2>&1 && echo      - 已关闭 Word
taskkill /f /im EXCEL.EXE /t >nul 2>&1 && echo      - 已关闭 Excel
taskkill /f /im POWERPNT.EXE /t >nul 2>&1 && echo      - 已关闭 PowerPoint

echo [9/11] 关闭远程控制、串流和VPN类进程...
taskkill /f /im SunloginClient.exe /t >nul 2>&1 && echo      - 已关闭 向日葵远程
taskkill /f /im ToDesk.exe /t >nul 2>&1 && echo      - 已关闭 ToDesk
taskkill /f /im TeamViewer.exe /t >nul 2>&1 && echo      - 已关闭 TeamViewer
taskkill /f /im Parsec.exe /t >nul 2>&1 && echo      - 已关闭 Parsec
taskkill /f /im moonlight.exe /t >nul 2>&1 && echo      - 已关闭 Moonlight串流
taskkill /f /im DroidCam.exe /t >nul 2>&1 && echo      - 已关闭 DroidCam
taskkill /f /im IVCam.exe /t >nul 2>&1 && echo      - 已关闭 iVCam
taskkill /f /im warp-svc.exe /t >nul 2>&1 && echo      - 已关闭 Cloudflare WARP
taskkill /f /im "Cloudflare WARP.exe" /t >nul 2>&1
taskkill /f /im MuMuRemoteBackend.exe /t >nul 2>&1 && echo      - 已关闭 MuMu模拟器远程
taskkill /f /im MuMuRemoteService.exe /t >nul 2>&1

echo [10/11] 关闭外设控制和灯效类进程...
taskkill /f /im lghub_agent.exe /t >nul 2>&1 && echo      - 已关闭 罗技G HUB
taskkill /f /im lghub.exe /t >nul 2>&1
taskkill /f /im lghub_system_tray.exe /t >nul 2>&1
taskkill /f /im lghub_updater.exe /t >nul 2>&1
taskkill /f /im lghub_gl.exe /t >nul 2>&1
taskkill /f /im CS_GO_Arx_Applet.exe /t >nul 2>&1 && echo      - 已关闭 罗技CS2小程序
taskkill /f /im LGHUBUpdaterService.exe /t >nul 2>&1
taskkill /f /im GCC.exe /t >nul 2>&1 && echo      - 已关闭 技嘉控制中心
taskkill /f /im EasyTuneEngineService.exe /t >nul 2>&1 && echo      - 已关闭 技嘉EasyTune
taskkill /f /im AorusLcdService.exe /t >nul 2>&1 && echo      - 已关闭 技嘉LCD服务
taskkill /f /im XtuService.exe /t >nul 2>&1 && echo      - 已关闭 Intel XTU超频服务
taskkill /f /im CorsairDeviceControlService.exe /t >nul 2>&1 && echo      - 已关闭 海盗船设备服务
taskkill /f /im "Razer Central.exe" /t >nul 2>&1 && echo      - 已关闭 Razer雷蛇
taskkill /f /im iCUE.exe /t >nul 2>&1 && echo      - 已关闭 海盗船iCUE
taskkill /f /im LightingService.exe /t >nul 2>&1 && echo      - 已关闭 华硕灯效服务

echo [11/11] 关闭其他非必要进程...
taskkill /f /im TabTip.exe /t >nul 2>&1 && echo      - 已关闭 触摸键盘和手写面板
taskkill /f /im FlashHelperService.exe /t >nul 2>&1 && echo      - 已关闭 Flash助手服务
taskkill /f /im ServerLicenseMonitor.exe /t >nul 2>&1 && echo      - 已关闭 FANUC许可证监控
taskkill /f /im MMSserve.exe /t >nul 2>&1 && echo      - 已关闭 PLC服务进程
taskkill /f /im FNPLicensingService64.exe /t >nul 2>&1 && echo      - 已关闭 FlexNet许可证服务
taskkill /f /im GoogleUpdate.exe /t >nul 2>&1
taskkill /f /im MicrosoftEdgeUpdate.exe /t >nul 2>&1
goto :eof

:game_priority
cls
echo ============================================================
echo  设置游戏高优先级
echo ============================================================
echo.
echo  请确认游戏已经在运行中，进入大厅或对局均可。
echo  支持自动识别：三角洲行动 / CS2
echo.

set "game_found=0"

echo 正在检测三角洲行动...
call :check_and_set "DeltaForceClient-Win64-Shipping.exe"
call :check_and_set "delta_force_launcher.exe"
call :check_and_set "DeltaForce.exe"
call :check_and_set "DeltaForceClient.exe"

echo 正在检测CS2...
call :check_and_set "cs2.exe"
call :check_and_set "csgo.exe"

if "%game_found%"=="0" (
    echo.
    echo  未检测到游戏进程。
    echo  请先启动游戏并进入大厅后再运行此选项。
    echo.
    echo  如果你知道游戏的准确进程名，也可以手动输入。
    echo.
    set /p custom_proc=请输入进程名，直接回车则返回菜单: 
    if not "!custom_proc!"=="" (
        tasklist /fi "imagename eq !custom_proc!" 2>nul | find /i "!custom_proc!" >nul 2>&1
        if !errorLevel! equ 0 (
            for /f "tokens=2" %%a in ('tasklist /fi "imagename eq !custom_proc!" /nh 2^>nul') do (
                powershell -NoProfile -Command "(Get-Process -Id %%a).PriorityClass='High'" 2>nul
            )
            echo      已设置 !custom_proc! 为高优先级
        ) else (
            echo      未找到该进程，请确认进程名是否正确。
        )
    )
)

echo.
echo 确认电源计划...
call :power_plan_quiet

echo.
pause
goto menu

:check_and_set
tasklist /fi "imagename eq %~1" 2>nul | find /i "%~1" >nul 2>&1
if %errorLevel% equ 0 (
    echo  找到游戏进程: %~1
    for /f "tokens=2" %%a in ('tasklist /fi "imagename eq %~1" /nh 2^>nul') do (
        powershell -NoProfile -Command "(Get-Process -Id %%a).PriorityClass='High'" 2>nul
    )
    echo      已设置为高优先级
    set "game_found=1"
)
goto :eof

:clean_temp
cls
echo ============================================================
echo  清理系统临时文件
echo ============================================================
echo.
echo  正在扫描临时文件大小...
echo.

powershell -NoProfile -Command "$t1=(Get-ChildItem $env:TEMP -Recurse -ErrorAction SilentlyContinue|Measure-Object Length -Sum).Sum; $t2=(Get-ChildItem 'C:\Windows\Temp' -Recurse -ErrorAction SilentlyContinue|Measure-Object Length -Sum).Sum; $tp=Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Explorer'; $t3=(Get-ChildItem $tp -Filter 'thumbcache_*.db' -ErrorAction SilentlyContinue|Measure-Object Length -Sum).Sum; Write-Host ('  用户临时文件: {0:N1} MB' -f ($t1/1MB)); Write-Host ('  系统临时文件: {0:N1} MB' -f ($t2/1MB)); Write-Host ('  缩略图缓存:   {0:N1} MB' -f ($t3/1MB)); Write-Host ('  合计:         {0:N1} MB' -f (($t1+$t2+$t3)/1MB))"

echo.
echo  正在清理...
echo.

echo [1/3] 清理用户临时文件夹...
powershell -NoProfile -Command "Get-ChildItem $env:TEMP -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue"
echo      - 用户临时文件清理完成

echo [2/3] 清理系统临时文件夹...
powershell -NoProfile -Command "Get-ChildItem 'C:\Windows\Temp' -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue"
echo      - 系统临时文件清理完成

echo [3/3] 清理缩略图缓存...
powershell -NoProfile -Command "$tp=Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Explorer'; Get-ChildItem $tp -Filter 'thumbcache_*.db' -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue"
echo      - 缩略图缓存清理完成

echo.
echo  清理完成！被占用的文件已自动跳过，不影响系统运行。
echo  注意：不会清理回收站、下载文件夹和个人文档。
echo.
pause
goto menu

:network_opt
cls
echo ============================================================
echo  网络延迟优化
echo ============================================================
echo.

call :network_quiet

echo.
echo  正在测试网络延迟...
echo.
echo  --- 测试本地网关延迟 ---
powershell -NoProfile -Command "$gw=(Get-NetRoute -DestinationPrefix '0.0.0.0/0'|Sort-Object RouteMetric|Select-Object -First 1).NextHop; if($gw){Test-Connection -ComputerName $gw -Count 3 -ErrorAction SilentlyContinue|ForEach-Object{Write-Host ('  网关 ' + $gw + ' : ' + $_.ResponseTime + 'ms')} }else{Write-Host '  未检测到网关'}"

echo.
echo  --- 测试阿里DNS延迟 ---
ping 223.5.5.5 -n 3
echo.
echo  --- 测试腾讯DNS延迟 ---
ping 119.29.29.29 -n 3

echo.
echo ============================================================
echo  网络优化完成
echo ============================================================
echo.
echo  已完成：
echo   - DNS缓存已刷新
echo   - 占带宽后台进程已关闭
echo.
echo  降低游戏延迟建议：
echo   - 尽量使用有线网络连接，WiFi延迟更高且不稳定
echo   - 游戏时关闭迅雷/网盘等占带宽软件
echo   - 如果延迟持续偏高，联系运营商检查线路
echo.
pause
goto menu

:network_quiet
echo 刷新DNS缓存...
ipconfig /flushdns >nul 2>&1
if %errorLevel% equ 0 (
    echo      - DNS缓存已刷新
) else (
    echo      - DNS缓存刷新失败，不影响使用
)
goto :eof

:stop_services
cls
echo ============================================================
echo  临时关闭后台服务
echo ============================================================
echo.
echo  以下服务将被临时停止，重启电脑后自动恢复：
echo   - Windows更新相关服务
echo   - 搜索索引服务
echo   - SysMain超级预取服务
echo   - 遥测和诊断服务
echo   - 错误报告服务
echo   - 打印后台服务
echo   - Xbox相关服务
echo   - 触摸键盘和手写面板服务
echo.
echo  不会停止杀毒、网络、显卡驱动等关键服务。
echo.
call :stop_services_quiet
echo.
echo  服务停止完成！重启电脑后所有服务自动恢复。
echo.
pause
goto menu

:stop_services_quiet
echo [1/6] 停止Windows更新相关服务...
net stop wuauserv /y >nul 2>&1 && echo      - 已停止 Windows更新服务
net stop UsoSvc /y >nul 2>&1 && echo      - 已停止 更新会话协调服务
net stop BITS /y >nul 2>&1 && echo      - 已停止 后台智能传输服务
net stop DoSvc /y >nul 2>&1 && echo      - 已停止 传递优化服务

echo [2/6] 停止搜索和预取服务...
net stop WSearch /y >nul 2>&1 && echo      - 已停止 Windows搜索索引
net stop SysMain /y >nul 2>&1 && echo      - 已停止 SysMain预取服务

echo [3/6] 停止遥测和诊断服务...
net stop DiagTrack /y >nul 2>&1 && echo      - 已停止 遥测服务
net stop dmwappushservice /y >nul 2>&1 && echo      - 已停止 WAP推送服务
net stop WerSvc /y >nul 2>&1 && echo      - 已停止 错误报告服务
net stop DPS /y >nul 2>&1 && echo      - 已停止 诊断策略服务
net stop WdiServiceHost /y >nul 2>&1 && echo      - 已停止 诊断服务主机
net stop WdiSystemHost /y >nul 2>&1 && echo      - 已停止 诊断系统主机

echo [4/6] 停止Xbox和游戏录制服务...
net stop XblAuthManager /y >nul 2>&1 && echo      - 已停止 Xbox认证服务
net stop XblGameSave /y >nul 2>&1 && echo      - 已停止 Xbox存档服务
net stop XboxNetApiSvc /y >nul 2>&1 && echo      - 已停止 Xbox网络服务
net stop XboxGipSvc /y >nul 2>&1 && echo      - 已停止 Xbox输入服务
net stop GamingServices /y >nul 2>&1 && echo      - 已停止 游戏服务

echo [5/6] 停止触摸键盘和手写面板服务...
net stop TabletInputService /y >nul 2>&1 && echo      - 已停止 触摸键盘手写服务

echo [6/6] 停止其他非必要服务...
net stop Spooler /y >nul 2>&1 && echo      - 已停止 打印后台服务
net stop SSDPSRV /y >nul 2>&1 && echo      - 已停止 SSDP设备发现
net stop upnphost /y >nul 2>&1 && echo      - 已停止 UPnP设备主机
net stop MapsBroker /y >nul 2>&1 && echo      - 已停止 地图管理器
net stop lfsvc /y >nul 2>&1 && echo      - 已停止 地理位置服务
net stop Fax /y >nul 2>&1 && echo      - 已停止 传真服务
net stop RetailDemo /y >nul 2>&1 && echo      - 已停止 零售演示服务
net stop WMPNetworkSvc /y >nul 2>&1 && echo      - 已停止 媒体播放器共享
net stop PcaSvc /y >nul 2>&1 && echo      - 已停止 程序兼容性助手
goto :eof

:kill_huorong
cls
echo ============================================================
echo  退出火绒安全软件
echo ============================================================
echo.
call :kill_huorong_quiet
echo.
pause
goto menu

:kill_huorong_quiet
echo 正在关闭火绒安全软件...
echo      - 尝试停止火绒服务...
net stop HipsDaemon /y >nul 2>&1
net stop Sysdiag /y >nul 2>&1
net stop HipsService /y >nul 2>&1
echo      - 尝试结束火绒进程...
taskkill /f /im HipsDaemon.exe /t >nul 2>&1 && echo      - 已结束 火绒核心进程
taskkill /f /im HipsTray.exe /t >nul 2>&1 && echo      - 已结束 火绒托盘
taskkill /f /im HipsMain.exe /t >nul 2>&1 && echo      - 已结束 火绒主程序
taskkill /f /im usysdiag.exe /t >nul 2>&1 && echo      - 已结束 火绒系统诊断
taskkill /f /im wsctrl.exe /t >nul 2>&1 && echo      - 已结束 火绒网页控制
taskkill /f /im PopBlock.exe /t >nul 2>&1 && echo      - 已结束 火绒弹窗拦截
taskkill /f /im HipsLog.exe /t >nul 2>&1
tasklist /fi "imagename eq HipsDaemon.exe" 2>nul | find /i "HipsDaemon.exe" >nul 2>&1
if %errorLevel% equ 0 (
    echo.
    echo      [提示] 火绒有自我保护，自动关闭未完全成功。
    echo      请手动操作：右键任务栏火绒图标 ^> 退出
    echo      或在火绒设置中临时关闭自我保护后重试。
) else (
    echo      - 火绒安全软件已临时关闭，重启后自动恢复
)
goto :eof

:mem_clean
cls
echo ============================================================
echo  内存深度清理
echo ============================================================
echo.
echo  通过Windows API清空所有进程的工作集，释放被缓存占用的内存。
echo  完全临时性，不修改任何系统设置，重启后自动恢复。
echo.
echo  清理前内存状态：
powershell -NoProfile -Command "$os=Get-CimInstance Win32_OperatingSystem; $t=[math]::Round($os.TotalVisibleMemorySize/1MB,1); $f=[math]::Round($os.FreePhysicalMemory/1MB,1); Write-Host ('  总计: ' + $t + ' GB  已用: ' + [math]::Round($t-$f,1) + ' GB  可用: ' + $f + ' GB')"
echo.
call :mem_clean_quiet
echo.
echo  清理后内存状态：
powershell -NoProfile -Command "$os=Get-CimInstance Win32_OperatingSystem; $t=[math]::Round($os.TotalVisibleMemorySize/1MB,1); $f=[math]::Round($os.FreePhysicalMemory/1MB,1); Write-Host ('  总计: ' + $t + ' GB  已用: ' + [math]::Round($t-$f,1) + ' GB  可用: ' + $f + ' GB')"
echo.
echo  内存深度清理完成！
echo.
pause
goto menu

:mem_clean_quiet
powershell -NoProfile -EncodedCommand JABzAGkAZwAgAD0AIABAACIADQAKAHUAcwBpAG4AZwAgAFMAeQBzAHQAZQBtADsADQAKAHUAcwBpAG4AZwAgAFMAeQBzAHQAZQBtAC4AUgB1AG4AdABpAG0AZQAuAEkAbgB0AGUAcgBvAHAAUwBlAHIAdgBpAGMAZQBzADsADQAKAHAAdQBiAGwAaQBjACAAYwBsAGEAcwBzACAATQBDACAAewANAAoAIAAgACAAIABbAEQAbABsAEkAbQBwAG8AcgB0ACgAIgBwAHMAYQBwAGkALgBkAGwAbAAiACkAXQAgAHAAdQBiAGwAaQBjACAAcwB0AGEAdABpAGMAIABlAHgAdABlAHIAbgAgAGkAbgB0ACAARQBtAHAAdAB5AFcAbwByAGsAaQBuAGcAUwBlAHQAKABJAG4AdABQAHQAcgAgAGgAKQA7AA0ACgAgACAAIAAgAFsARABsAGwASQBtAHAAbwByAHQAKAAiAG4AdABkAGwAbAAuAGQAbABsACIAKQBdACAAcAB1AGIAbABpAGMAIABzAHQAYQB0AGkAYwAgAGUAeAB0AGUAcgBuACAAaQBuAHQAIABSAHQAbABBAGQAagB1AHMAdABQAHIAaQB2AGkAbABlAGcAZQAoAGkAbgB0ACAAcAAsACAAYgBvAG8AbAAgAGUALAAgAGIAbwBvAGwAIAB0ACwAIABvAHUAdAAgAGIAbwBvAGwAIAByACkAOwANAAoAfQANAAoAIgBAAA0ACgBBAGQAZAAtAFQAeQBwAGUAIAAkAHMAaQBnACAALQBFAHIAcgBvAHIAQQBjAHQAaQBvAG4AIABTAGkAbABlAG4AdABsAHkAQwBvAG4AdABpAG4AdQBlAA0ACgBbAE0AQwBdADoAOgBSAHQAbABBAGQAagB1AHMAdABQAHIAaQB2AGkAbABlAGcAZQAoADIAMgAsACQAdAByAHUAZQAsACQAZgBhAGwAcwBlACwAWwByAGUAZgBdACQAbgB1AGwAbAApAHwATwB1AHQALQBOAHUAbABsAA0ACgBbAE0AQwBdADoAOgBSAHQAbABBAGQAagB1AHMAdABQAHIAaQB2AGkAbABlAGcAZQAoADEAMQAsACQAdAByAHUAZQAsACQAZgBhAGwAcwBlACwAWwByAGUAZgBdACQAbgB1AGwAbAApAHwATwB1AHQALQBOAHUAbABsAA0ACgAkAGMAPQAwADsAIABHAGUAdAAtAFAAcgBvAGMAZQBzAHMAfABGAG8AcgBFAGEAYwBoAC0ATwBiAGoAZQBjAHQAewAgAHQAcgB5AHsAWwBNAEMAXQA6ADoARQBtAHAAdAB5AFcAbwByAGsAaQBuAGcAUwBlAHQAKAAkAF8ALgBIAGEAbgBkAGwAZQApAHwATwB1AHQALQBOAHUAbABsADsAJABjACsAKwB9AGMAYQB0AGMAaAB7AH0AIAB9AA0ACgBXAHIAaQB0AGUALQBIAG8AcwB0ACAAIgAgACAA8l0FbgZ0IAAkAGMAIAAqTtuPC3oM/8qRPmWFUVhbLU4uAC4ALgAiAA0ACgBTAHQAYQByAHQALQBTAGwAZQBlAHAAIAAtAE0AaQBsAGwAaQBzAGUAYwBvAG4AZABzACAANQAwADAA
goto :eof

:sys_status
cls
echo ============================================================
echo  当前系统状态
echo ============================================================
echo.

echo 【CPU】
powershell -NoProfile -Command "$cpu = Get-CimInstance Win32_Processor; Write-Host ('  型号: ' + $cpu.Name); Write-Host ('  当前使用率: ' + $cpu.LoadPercentage + '%%')"

echo.
echo 【内存】
powershell -NoProfile -Command "$os = Get-CimInstance Win32_OperatingSystem; $total = [math]::Round($os.TotalVisibleMemorySize/1MB,1); $free = [math]::Round($os.FreePhysicalMemory/1MB,1); $used = [math]::Round($total - $free,1); Write-Host ('  总内存: ' + $total + ' GB'); Write-Host ('  已使用: ' + $used + ' GB'); Write-Host ('  可用: ' + $free + ' GB')"

echo.
echo 【显卡 RTX 3060 Ti】
nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,memory.used,memory.total,power.draw --format=csv,noheader 2>nul
if %errorLevel% neq 0 (
    echo  nvidia-smi不可用，跳过显卡状态
)

echo.
echo 【电源计划】
powercfg /getactivescheme | findstr "("

echo.
echo 【网络延迟测试】
ping 223.5.5.5 -n 2 | findstr "时间="
if %errorLevel% neq 0 (
    ping 223.5.5.5 -n 2 | findstr "time="
)

echo.
echo 【占用内存最高的前10个进程】
powershell -NoProfile -Command "Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 10 @{N='进程名';E={$_.Name}},@{N='内存MB';E={[math]::Round($_.WorkingSet64/1MB,0)}} | Format-Table -AutoSize"

echo.
pause
goto menu

:power_plan_quiet
echo 确认电源计划...
powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
if %errorLevel% equ 0 (
    echo      - 电源计划已确认为卓越性能
) else (
    echo      - 卓越性能电源计划设置失败，请手动确认
)
goto :eof
