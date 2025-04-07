# Copyright (C) 2025 anjisuan608
# 用户配置全局变量
# 配置Java路径，若存在环境变量可以直接使用 java 来使用系统中默认的Java
# 若使用自定义Java路径，请将其设置为Java的完整路径
# 例如：$Global:JVM = "C:\Program Files\Java\jdk-16.0.2\bin\java.exe"
$Global:JVM = "java"
# 设置服务器核心文件名称,在变量等号后键入(一直接写到.jar)
# 若核心没有实体的jar文件(如部分Forge、NeoForge核心,及其它核心采用同样策略的核心)请将该变量**留空**,按照下方说明填写 ServerTXT 变量!
$Global:ServerJar = "leaves-1.21.4.jar"
# 特殊核心路径变量
# 若使用的是部分Forge、NeoForge等核心,请在目录中找到Forge、NeoForge服务器安装器生成的"run.bat"文件
# 右键->编辑
# 找到当中的"java @user_jvm_args.txt @libraries/net/xxxforge/xxxforge/x.x.x-xx.xx.xx/win_args.txt %*"语句
# 复制当中的"@libraries/net/xxxforge/xxxforge/x.x.x-xx.xx.xx/win_args.txt"字段
# 粘贴到下方ServerTXT变量的等号后面
# 注:请务必看清文件扩展(后缀)名!当中的run.sh文件适用于Linux平台,请勿复制该文件的字段!
# 开启文件扩展名显示:文件夹选项->查看,在下方的选项框中找到"隐藏已知文件类型的扩展名"取消勾选,应用并确定
# 注:当 ServerJar 变量有内容时, ServerTXT变量 **不生效**
$Global:ServerTXT = "@libraries/net/minecraftforge/forge/1.20.1-47.2.20/win_args.txt"
# 设置服务器内存,最大与最小
# 基本
# 最大可用内存(在变量等号后键入数字,单位MB)
$Global:XmxSize=8192
# 最小内存用量(在变量等号后键入数字,单位MB)
$Global:XmsSize=4096
# 高级
# Xmn/Xss启用/禁用
$Global:XmnEnable=$false
$Global:XssEnable=$false
# Xmn配置
# 设置年轻代大小(在变量等号后键入数字,单位MB)
# 整个堆大小=年轻代大小 + 年老代大小 + 持久代大小
# 持久代一般固定大小为64m,所以增大年轻代后,将会减小年老代大小
# 此值对系统性能影响较大
# Sun官方推荐配置为整个堆的3/8.
$Global:XmnSize=3072
# Xss配置
# 设置每个线程的堆栈大小(在变量等号后键入数字,单位MB)
$Global:XssSize=512
# 识别Xmn/Xss配置
if ($Global:XmnEnable -eq 1) { $global:XmnStatus = "-Xmn$($global:XmnSize)m" }
if ($Global:XssEnable -eq 1) { $global:XssStatus = "-Xss$($global:XssSize)m" }
# 设置服务器GUI状态(留空为显示GUI,"nogui"为不显示GUI)
$Global:GUI = ""
# 检测系统信息
# 规划中…
# 配置自定义的登录认证服务器(非必要,请留空!)
# 注:已预置LittleSkin和MUA
# 如果使用其它的认证服务器则写在下方变量的等号后
$Global:CustomAuthURL=""
# 核心文件检测
function CheckServerCore {
    if ($global:ServerJar -ne "") {
        if (Test-Path $global:ServerJar) {
            Write-Host "[OK] 检测到服务器核心文件"
            $global:ServerFile = "-jar `"$global:ServerJar`""
            return $true
        } else {
            Write-Host "[ERROR] 服务器核心文件不存在！"
            return $false
        }
    } else {
        $global:ServerFile = "`"$global:ServerTXT`""
        return $true
    }
}
do {
    Clear-Host
    Write-Host "`n==== 认证服务器配置 ===="
    Write-Host "1) LittleSkin (默认)"
    Write-Host "2) MUA"
    Write-Host "3) 自定义"
    Write-Host "0) 返回主菜单"
    
    $AuthServerChoice = Read-Host "请选择 (0-3)"
    
    # 输入验证
    if ($AuthServerChoice -notmatch "^[0-3]$") {
        Write-Host "无效选择，请输入 0-3 之间的数字！" -ForegroundColor Red
        Start-Sleep -Seconds 2
        continue
    }
} until ($userInput -match "^[1-3]$")
    switch ($AuthServerChoice) {
        1 { 
            $global:AuthURL = "https://littleskin.cn/api/yggdrasil"
            Write-Host "已选择 LittleSkin 认证服务器" -ForegroundColor Green
        }
        2 { 
            $global:AuthURL = "https://skin.mualliance.ltd/api/union/yggdrasil" 
            Write-Host "已选择 MUA 认证服务器" -ForegroundColor Green
        }
        3 {
            # 自定义服务器验证
            if ([string]::IsNullOrWhiteSpace($global:CustomAuthURL)) {
                Write-Host "未配置自定义认证服务器！" -ForegroundColor Yellow
                $tempURL = Read-Host "请输入认证服务器URL (或按回车取消)"
                
                if (-not [string]::IsNullOrWhiteSpace($tempURL)) {
                    if ($tempURL -match "^https?://") {
                        $global:CustomAuthURL = $tempURL
                        $global:AuthURL = $tempURL
                        Write-Host "已设置自定义服务器" -ForegroundColor Green
                    } else {
                        Write-Host "URL格式不正确，必须包含 http:// 或 https://" -ForegroundColor Red
                    }
                }
            } else {
                $global:AuthURL = $global:CustomAuthURL
                Write-Host "使用预定义的自定义服务器：$global:CustomAuthURL" -ForegroundColor Green
            }
        }
        0 { return }
    }

# 下载authlib
function DownloadAuthLib {
    try {
        Invoke-WebRequest -Uri "https://authlib-injector.yushi.moe/artifact/53/authlib-injector-1.2.5.jar" -OutFile ".\authlib-injector-1.2.5.jar"
        Write-Host "[OK] 下载完成"
    } catch {
        Write-Host "[ERROR] 下载失败：$_"
    }
}
function StartServer {
    $jvmArgs = @(
        "-XX:+UnlockExperimentalVMOptions",
        "-XX:+UseG1GC",
        "-XX:G1NewSizePercent=20",
        "-XX:G1ReservePercent=20",
        "-XX:MaxGCPauseMillis=50",
        "-XX:G1HeapRegionSize=16M",
        "-XX:-UseAdaptiveSizePolicy",
        "-XX:-OmitStackTraceInFastThrow",
        "-Xmx$($global:XmxSize)m",
        "-Xms$($global:XmsSize)m",
        $global:XmnStatus,
        $global:XssStatus,
        $global:Auth,
        $global:ServerFile,
        $global:gui
    ) -join " "

    Write-Host "`n启动命令：$global:JVM $jvmArgs`n"
    $process = Start-Process $global:JVM -ArgumentList $jvmArgs -NoNewWindow -PassThru
    $process.WaitForExit()
    
    if ($global:Auto) {
        Write-Host "[自动重启] 检测到自动重启配置"
        Start-Sleep -Seconds 5
        StartServer
    }
}