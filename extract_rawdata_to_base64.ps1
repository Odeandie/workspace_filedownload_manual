# 定位当前所在目录并读取当前目录下的所有文件
$folderSync = Get-Location
$files = Get-ChildItem -Path $folderSync -File

# 根据当前日期，创建用于存放处理结果的文件夹
$currentDate = Get-Date -Format "yyMMdd"
$folderTaret = [System.String]::Concat($folderSync, "\", $currentDate)

New-Item -Path $folderTaret -ItemType Directory

# 输出的文件格式
$tail = ".txt"

foreach ($file in $files) {
    
    # 创建用于存储结果的文件
    New-Item -Path $folderTaret\$file$tail -ItemType File
    
    # 以二进制的形式，读取当前的文件内容
    $fileContent = Get-Content -Path $file.FullName -Encoding Byte
    
    # 将上一步的内容，改为 Base64 的编码
    $base64Content = [System.Convert]::ToBase64String($fileContent)

    # 输出结果到开始时创建的文件里
    $base64Content | Out-File -FilePath $folderTaret\$file$tail -Encoding ascii

    Write-Output "File: $($file.name) Done!"
    Write-Output ""
}