<#
.SYNOPSIS
    ALK融合新药研发进展 - 本地极简版 PowerShell 上传脚本
#>

# 1. 自动定位到当前项目根目录
$WorkDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $WorkDir

# 2. 设置配置 (这一部分您可以按需修改)
$SourceFile = "alk-drug-development-notice.md" # 直接查找当前目录下的文件
$GitUserEmail = "[EMAIL_ADDRESS]"
$GitUserName = "[YOUR_GIT_USERNAME]"

# --- 开始处理 ---
$DateStamp = Get-Date -Format "yyyyMMdd"
$TargetFile = "alk-drug-development-$DateStamp.md"

Write-Host "`n>>> 启动存档任务 [$DateStamp] <<<" -ForegroundColor Cyan

# 检查当前目录下是否有报告源文件
if (-not (Test-Path $SourceFile)) {
    Write-Host "提示: 找不到源文件 '$SourceFile'。" -ForegroundColor Yellow
    Write-Host "请确保文件已放至: $WorkDir\$SourceFile" -ForegroundColor Gray
    exit
}

# 复制、重命名并存档
try {
    # 如果源文件和目标文件名不同，才执行复制（防止自己复制自己）
    if ($SourceFile -ne $TargetFile) {
        Copy-Item $SourceFile $TargetFile -Force
        Write-Host "成功存档: $TargetFile" -ForegroundColor Green
    }
} catch {
    Write-Host "存档操作失败: $_" -ForegroundColor Red
    exit
}

# Git 自动化同步
Write-Host "同步至 GitHub..." -ForegroundColor Cyan
git add $TargetFile
git config --local user.email $GitUserEmail
git config --local user.name $GitUserName
git commit -m "Archive: ALK drug development update $DateStamp"
git push origin main

Write-Host "任务完成！报告已存档并推送到云端。`n" -ForegroundColor Green
