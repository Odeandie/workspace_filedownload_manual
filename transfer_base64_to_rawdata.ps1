# 定位当前所在目录并读取当前目录下的所有文件
$folderSync = Get-Location
$files = Get-ChildItem -Path $folderSync

# 根据当前日期，创建用于存放处理结果的文件夹
$currentDate = Get-Date -Format "yyMMdd"
$folderTaret = [System.String]::Concat($folderSync, "\",$currentDate)

New-Item -Path $folderTaret -ItemType Directory

# 循环处理列表内的文件
foreach ($file in $files) {

    # 读取文件内容
    $base64String = Get-Content $file

    # 设定存储路径
    $fileTarget = [System.String]::Concat($folderTaret, "\", $file)

    # 开始还原
    try {

        $fileBytes = [System.Convert]::FromBase64String($base64String)
        [System.IO.File]::WriteAllBytes($fileTarget, $fileBytes)
        Write-Output "文件已还原到：$fileTarget"

    } catch {
        Write-Error "无法还原文件：$_"
    }
}

# 准备替换文件名后缀
$oldTail = ".txt"
$newTail = ""

# 批量替换文件名
dir $folderTaret -Include "*.*" -Recurse | ForEach-Object{
    
    Rename-Item $_.FullName $_.FullName.Replace($oldTail,$newTail)

}