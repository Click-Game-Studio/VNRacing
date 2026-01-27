# Script to update all "Production" and "Complete" statuses to "Development"
# Also updates Multiplayer to "Pending" and Race Modes to "Development"

Write-Host "Starting status update..." -ForegroundColor Cyan

$filesUpdated = 0
$changesCount = 0

# Get all markdown files in Docs directory
$markdownFiles = Get-ChildItem -Path "Docs" -Filter "*.md" -Recurse

foreach ($file in $markdownFiles) {
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    $fileChanged = $false
    
    # Replace "✅ Production" with "🔄 Development"
    $content = $content -replace '✅ Production', '🔄 Development'
    
    # Replace status badges
    $content = $content -replace '\!\[Status: Complete\]\(https://img\.shields\.io/badge/Status-Complete-success\)', '![Status: Development](https://img.shields.io/badge/Status-Development-blue)'
    
    # Replace status metadata
    $content = $content -replace '\*\*Status\*\*: ✅ Production', '**Status**: 🔄 Development'
    $content = $content -replace '\*\*Status\*\*: Complete', '**Status**: Development'
    $content = $content -replace 'status: production', 'status: development'
    $content = $content -replace '\*\*Status\*\*: ✅ Complete', '**Status**: 🔄 Development'
    
    # Replace inline status
    $content = $content -replace '\| \*\*Status\*\*: Complete', '| **Status**: Development'
    
    # Special handling for Multiplayer - change to Pending
    if ($file.FullName -like "*multiplayer*") {
        $content = $content -replace '🔄 In Dev', '⏸️ Pending'
        $content = $content -replace '\*\*Status\*\*: Development', '**Status**: Pending'
        $content = $content -replace 'Status-Development', 'Status-Pending'
        $content = $content -replace '\!\[Status: Development\]', '![Status: Pending]'
        $content = $content -replace 'badge/Status-Development-blue', 'badge/Status-Pending-yellow'
    }
    
    # Check if content changed
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        $filesUpdated++
        $fileChanged = $true
        Write-Host "Updated: $($file.FullName)" -ForegroundColor Green
    }
}

Write-Host "`nUpdate complete!" -ForegroundColor Cyan
Write-Host "Files updated: $filesUpdated" -ForegroundColor Yellow
