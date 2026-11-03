<#
.SYNOPSIS
  Jira REST API Helper Script (PowerShell thuần - Zero Dependencies)
.DESCRIPTION
  Cho phép AI và Developer tra cứu, cập nhật ticket Jira trực tiếp qua REST API chính thức của Atlassian.
  Hỗ trợ cả Jira Cloud (API Token) và Jira Server / Data Center (Bearer PAT).
.EXAMPLE
  .\scripts\jira.ps1 get PROJ-101
  .\scripts\jira.ps1 comment PROJ-101 "Đã hoàn thành subtask T1"
  .\scripts\jira.ps1 transitions PROJ-101
  .\scripts\jira.ps1 transition PROJ-101 "In Progress"
#>

[CmdletBinding()]
param (
    [Parameter(Position=0, Mandatory=$false)]
    [ValidateSet("get", "comment", "transitions", "transition", "help")]
    [string]$Action = "help",

    [Parameter(Position=1)]
    [string]$IssueKey,

    [Parameter(Position=2)]
    [string]$Value
)

# Nếu gọi help hoặc không truyền action, hiển thị hướng dẫn và thoát luôn
if ($Action -eq "help" -or -not $Action) {
    Write-Host "================ JIRA REST API HELPER ================" -ForegroundColor Cyan
    Write-Host "Sử dụng:" -ForegroundColor Yellow
    Write-Host "  .\scripts\jira.ps1 get <KEY>                      - Xem tóm tắt & mô tả ticket"
    Write-Host "  .\scripts\jira.ps1 comment <KEY> '<Nội dung>'     - Gửi comment báo cáo tiến độ"
    Write-Host "  .\scripts\jira.ps1 transitions <KEY>              - Xem các bước chuyển trạng thái hợp lệ"
    Write-Host "  .\scripts\jira.ps1 transition <KEY> '<Trạng thái>' - Đổi trạng thái ticket"
    Write-Host "------------------------------------------------------"
    Write-Host "Cấu hình kết nối:" -ForegroundColor Yellow
    Write-Host "  Tạo file .env.jira từ file mẫu .env.jira.example"
    exit 0
}

# 1. Đọc cấu hình từ .env.jira hoặc biến môi trường
$envFilePath = Join-Path $PSScriptRoot "..\.env.jira"
if (Test-Path $envFilePath) {
    Get-Content $envFilePath | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#") -and $line.Contains("=")) {
            $parts = $line.Split("=", 2)
            $name = $parts[0].Trim()
            $val = $parts[1].Trim()
            [Environment]::SetEnvironmentVariable($name, $val, "Process")
        }
    }
}

$baseUrl  = $env:JIRA_BASE_URL
$jiraType = $env:JIRA_TYPE   # "cloud" hoặc "server" (mặc định: server)
$token    = $env:JIRA_TOKEN  # PAT (Server) hoặc API Token (Cloud)
$email    = $env:JIRA_EMAIL  # Dùng khi JIRA_TYPE là cloud

if (-not $baseUrl -or -not $token) {
    Write-Host "[ERROR] Chưa cấu hình thông tin kết nối Jira!" -ForegroundColor Red
    Write-Host "Vui lòng copy file mẫu .env.jira.example thành .env.jira và điền thông tin:" -ForegroundColor Yellow
    Write-Host "  JIRA_BASE_URL=https://jira.yourcompany.com"
    Write-Host "  JIRA_TYPE=server   # hoặc 'cloud'"
    Write-Host "  JIRA_TOKEN=your_pat_or_api_token"
    Write-Host "  JIRA_EMAIL=your_email@company.com (chỉ cần nếu là cloud)"
    exit 1
}

# Chuẩn hóa Base URL
$baseUrl = $baseUrl.TrimEnd("/")
$apiVersion = if ($jiraType -eq "cloud") { "3" } else { "2" }

# Cấu hình Headers chứng thực
$headers = @{
    "Content-Type" = "application/json"
    "Accept"       = "application/json"
}

if ($jiraType -eq "cloud") {
    $pair = "${email}:${token}"
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($pair)
    $base64 = [Convert]::ToBase64String($bytes)
    $headers["Authorization"] = "Basic $base64"
} else {
    # Jira Server / Data Center dùng Personal Access Token (Bearer)
    $headers["Authorization"] = "Bearer $token"
}

# Bật TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Hàm phụ trợ trích xuất văn bản từ Atlassian Document Format (ADF) của Cloud
function Extract-AdfText($node) {
    if (-not $node) { return "" }
    if ($node -is [string]) { return $node }
    $text = ""
    if ($node.text) { $text += $node.text }
    if ($node.content) {
        foreach ($child in $node.content) {
            $text += (Extract-AdfText $child) + "`n"
        }
    }
    return $text.Trim()
}

switch ($Action) {
    "get" {
        if (-not $IssueKey) {
            Write-Host "[ERROR] Cần cung cấp Issue Key (VD: PROJ-101)" -ForegroundColor Red
            exit 1
        }
        
        $url = "$baseUrl/rest/api/$apiVersion/issue/$IssueKey"
        try {
            $resp = Invoke-RestMethod -Uri $url -Method Get -Headers $headers -TimeoutSec 15
            $f = $resp.fields
            
            $desc = ""
            if ($f.description) {
                if ($jiraType -eq "cloud" -and $f.description.content) {
                    $desc = Extract-AdfText $f.description
                } else {
                    $desc = $f.description
                }
            }

            Write-Host "================ JIRA ISSUE: $($resp.key) ================" -ForegroundColor Cyan
            Write-Host "Key:         $($resp.key)"
            Write-Host "Summary:     $($f.summary)"
            Write-Host "Type:        $($f.issuetype.name)"
            Write-Host "Status:      $($f.status.name)"
            Write-Host "Assignee:    $($f.assignee.displayName)"
            Write-Host "Reporter:    $($f.reporter.displayName)"
            Write-Host "Created:     $($f.created)"
            Write-Host "--------------------------------------------------------" -ForegroundColor Gray
            Write-Host "Description:" -ForegroundColor Yellow
            Write-Host $desc
            Write-Host "--------------------------------------------------------" -ForegroundColor Gray
            
            if ($f.subtasks -and $f.subtasks.Count -gt 0) {
                Write-Host "Subtasks:" -ForegroundColor Yellow
                foreach ($st in $f.subtasks) {
                    Write-Host "  - [$($st.key)] $($st.fields.summary) (Status: $($st.fields.status.name))"
                }
            }
        }
        catch {
            Write-Host "[ERROR] Không thể lấy thông tin issue $($IssueKey): $($_.Exception.Message)" -ForegroundColor Red
            exit 1
        }
    }

    "comment" {
        if (-not $IssueKey -or -not $Value) {
            Write-Host "[ERROR] Cú pháp: .\scripts\jira.ps1 comment <KEY> '<Nội dung>'" -ForegroundColor Red
            exit 1
        }
        $url = "$baseUrl/rest/api/$apiVersion/issue/$IssueKey/comment"
        
        if ($jiraType -eq "cloud") {
            $bodyObj = @{
                body = @{
                    type = "doc"
                    version = 1
                    content = @(
                        @{
                            type = "paragraph"
                            content = @(
                                @{ type = "text"; text = $Value }
                            )
                        }
                    )
                }
            }
        } else {
            $bodyObj = @{ body = $Value }
        }
        
        $jsonBody = $bodyObj | ConvertTo-Json -Depth 5
        try {
            $resp = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body ([System.Text.Encoding]::UTF8.GetBytes($jsonBody))
            Write-Host "[SUCCESS] Đã thêm comment vào ticket $($IssueKey) thành công!" -ForegroundColor Green
        }
        catch {
            Write-Host "[ERROR] Thêm comment thất bại: $($_.Exception.Message)" -ForegroundColor Red
            exit 1
        }
    }

    "transitions" {
        if (-not $IssueKey) {
            Write-Host "[ERROR] Cần cung cấp Issue Key" -ForegroundColor Red
            exit 1
        }
        $url = "$baseUrl/rest/api/$apiVersion/issue/$IssueKey/transitions"
        try {
            $resp = Invoke-RestMethod -Uri $url -Method Get -Headers $headers
            Write-Host "Trạng thái có thể chuyển của ticket $($IssueKey):" -ForegroundColor Cyan
            foreach ($t in $resp.transitions) {
                Write-Host "  - ID: $($t.id) | Tên: '$($t.name)'"
            }
        }
        catch {
            Write-Host "[ERROR] Không thể lấy danh sách transition: $($_.Exception.Message)" -ForegroundColor Red
            exit 1
        }
    }

    "transition" {
        if (-not $IssueKey -or -not $Value) {
            Write-Host "[ERROR] Cú pháp: .\scripts\jira.ps1 transition <KEY> '<Tên hoặc ID trạng thái>'" -ForegroundColor Red
            exit 1
        }
        
        $transUrl = "$baseUrl/rest/api/$apiVersion/issue/$IssueKey/transitions"
        $resp = Invoke-RestMethod -Uri $transUrl -Method Get -Headers $headers
        $target = $resp.transitions | Where-Object { $_.id -eq $Value -or $_.name -like "*$Value*" } | Select-Object -First 1

        if (-not $target) {
            Write-Host "[ERROR] Không tìm thấy trạng thái '$Value'. Chạy 'transitions' để xem danh sách hợp lệ." -ForegroundColor Red
            exit 1
        }

        $body = @{ transition = @{ id = $target.id } } | ConvertTo-Json
        try {
            Invoke-RestMethod -Uri $transUrl -Method Post -Headers $headers -Body ([System.Text.Encoding]::UTF8.GetBytes($body))
            Write-Host "[SUCCESS] Đã chuyển trạng thái ticket $($IssueKey) sang: '$($target.name)' (ID: $($target.id))" -ForegroundColor Green
        }
        catch {
            Write-Host "[ERROR] Chuyển trạng thái thất bại: $($_.Exception.Message)" -ForegroundColor Red
            exit 1
        }
    }
}
