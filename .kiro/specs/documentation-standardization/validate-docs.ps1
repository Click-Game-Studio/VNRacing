# Documentation Validation Script
# Phase 8: Final Polish and Consistency Check

$ErrorActionPreference = "Continue"
$results = @{
    TotalFiles = 0
    MetadataValid = 0
    MetadataInvalid = @()
    MermaidDiagrams = 0
    MermaidErrors = @()
    BrokenLinks = @()
    StatusBadges = 0
    InvalidBadges = @()
    MarkdownIssues = @()
    FilesProcessed = @()
}

Write-Host "=== Documentation Validation Suite ===" -ForegroundColor Cyan
Write-Host "Starting comprehensive validation..." -ForegroundColor Yellow
Write-Host ""

# Get all markdown files
$mdFiles = Get-ChildItem -Path "Docs" -Filter "*.md" -Recurse

$results.TotalFiles = $mdFiles.Count
Write-Host "Found $($mdFiles.Count) markdown files to validate" -ForegroundColor Green
Write-Host ""

# Validation 1: Metadata Check
Write-Host "[1/5] Validating metadata (Version 1.0.0, Date 2026-01-20)..." -ForegroundColor Cyan
foreach ($file in $mdFiles) {
    $content = Get-Content $file.FullName -Raw
    $results.FilesProcessed += $file.FullName.Replace((Get-Location).Path + "\", "")
    
    # Check for version and date
    if ($content -match "Version:\s*1\.0\.0" -and $content -match "Date:\s*2026-01-20") {
        $results.MetadataValid++
    } else {
        $results.MetadataInvalid += $file.FullName.Replace((Get-Location).Path + "\", "")
    }
}
Write-Host "  ✓ Valid metadata: $($results.MetadataValid)/$($results.TotalFiles)" -ForegroundColor Green
if ($results.MetadataInvalid.Count -gt 0) {
    Write-Host "  ⚠ Files with missing/incorrect metadata: $($results.MetadataInvalid.Count)" -ForegroundColor Yellow
}
Write-Host ""

# Validation 2: Mermaid Diagrams
Write-Host "[2/5] Validating Mermaid diagrams..." -ForegroundColor Cyan
foreach ($file in $mdFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Count mermaid blocks
    $mermaidBlocks = [regex]::Matches($content, '```mermaid[\s\S]*?```')
    $results.MermaidDiagrams += $mermaidBlocks.Count
    
    # Check for basic syntax errors
    foreach ($block in $mermaidBlocks) {
        $blockContent = $block.Value
        # Check for unclosed brackets, invalid syntax
        if ($blockContent -match '\[(?![^\]]*\])' -or $blockContent -match '\((?![^\)]*\))') {
            $results.MermaidErrors += @{
                File = $file.FullName.Replace((Get-Location).Path + "\", "")
                Issue = "Potential unclosed bracket/parenthesis"
            }
        }
    }
}
Write-Host "  ✓ Total Mermaid diagrams found: $($results.MermaidDiagrams)" -ForegroundColor Green
if ($results.MermaidErrors.Count -gt 0) {
    Write-Host "  ⚠ Potential diagram issues: $($results.MermaidErrors.Count)" -ForegroundColor Yellow
}
Write-Host ""

# Validation 3: Cross-reference Links
Write-Host "[3/5] Validating cross-reference links..." -ForegroundColor Cyan
foreach ($file in $mdFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Find markdown links
    $links = [regex]::Matches($content, '\[([^\]]+)\]\(([^)]+)\)')
    
    foreach ($link in $links) {
        $linkPath = $link.Groups[2].Value
        
        # Skip external links and anchors
        if ($linkPath -match '^https?://' -or $linkPath -match '^#' -or $linkPath -match '^mailto:') {
            continue
        }
        
        # Check if relative path exists
        $basePath = Split-Path $file.FullName -Parent
        $fullPath = Join-Path $basePath $linkPath
        
        # Remove anchor if present
        $fullPath = $fullPath -replace '#.*$', ''
        
        if (-not (Test-Path $fullPath)) {
            $results.BrokenLinks += @{
                File = $file.FullName.Replace((Get-Location).Path + "\", "")
                Link = $linkPath
            }
        }
    }
}
Write-Host "  ✓ Links validated" -ForegroundColor Green
if ($results.BrokenLinks.Count -gt 0) {
    Write-Host "  ⚠ Broken links found: $($results.BrokenLinks.Count)" -ForegroundColor Yellow
}
Write-Host ""

# Validation 4: Status Badges
Write-Host "[4/5] Validating status badges..." -ForegroundColor Cyan
foreach ($file in $mdFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Find status badges
    $badges = [regex]::Matches($content, 'Status:\s*([^|\n]+)')
    
    foreach ($badge in $badges) {
        $status = $badge.Groups[1].Value.Trim()
        $results.StatusBadges++
        
        # Check if status is valid
        if ($status -notmatch '✅\s*(Complete|Production)' -and 
            $status -notmatch '🔄\s*(Development|In Progress)' -and 
            $status -notmatch '⚠️\s*Deprecated' -and
            $status -notmatch '⏸️\s*Paused') {
            $results.InvalidBadges += @{
                File = $file.FullName.Replace((Get-Location).Path + "\", "")
                Status = $status
            }
        }
    }
}
Write-Host "  ✓ Status badges found: $($results.StatusBadges)" -ForegroundColor Green
if ($results.InvalidBadges.Count -gt 0) {
    Write-Host "  ⚠ Invalid status badges: $($results.InvalidBadges.Count)" -ForegroundColor Yellow
}
Write-Host ""

# Validation 5: Markdown Formatting Consistency
Write-Host "[5/5] Checking markdown formatting consistency..." -ForegroundColor Cyan
$headingStyles = @{}
$listStyles = @{}
$codeFenceStyles = @{}

foreach ($file in $mdFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Check heading style (ATX vs Setext)
    $atxHeadings = [regex]::Matches($content, '^#{1,6}\s+', [System.Text.RegularExpressions.RegexOptions]::Multiline).Count
    $setextHeadings = [regex]::Matches($content, '^[=-]+$', [System.Text.RegularExpressions.RegexOptions]::Multiline).Count
    
    if ($atxHeadings -gt 0) { 
        if (-not $headingStyles.ContainsKey('ATX')) { $headingStyles['ATX'] = 0 }
        $headingStyles['ATX'] = $headingStyles['ATX'] + 1 
    }
    if ($setextHeadings -gt 0) { 
        if (-not $headingStyles.ContainsKey('Setext')) { $headingStyles['Setext'] = 0 }
        $headingStyles['Setext'] = $headingStyles['Setext'] + 1 
    }
    
    # Check list markers
    $dashLists = [regex]::Matches($content, '^\s*-\s+', [System.Text.RegularExpressions.RegexOptions]::Multiline).Count
    $asteriskLists = [regex]::Matches($content, '^\s*\*\s+', [System.Text.RegularExpressions.RegexOptions]::Multiline).Count
    
    if ($dashLists -gt 0) { 
        if (-not $listStyles.ContainsKey('Dash')) { $listStyles['Dash'] = 0 }
        $listStyles['Dash'] = $listStyles['Dash'] + 1 
    }
    if ($asteriskLists -gt 0) { 
        if (-not $listStyles.ContainsKey('Asterisk')) { $listStyles['Asterisk'] = 0 }
        $listStyles['Asterisk'] = $listStyles['Asterisk'] + 1 
    }
    
    # Check code fence style
    $backtickFences = [regex]::Matches($content, '^```', [System.Text.RegularExpressions.RegexOptions]::Multiline).Count
    $tildeFences = [regex]::Matches($content, '^~~~', [System.Text.RegularExpressions.RegexOptions]::Multiline).Count
    
    if ($backtickFences -gt 0) { 
        if (-not $codeFenceStyles.ContainsKey('Backtick')) { $codeFenceStyles['Backtick'] = 0 }
        $codeFenceStyles['Backtick'] = $codeFenceStyles['Backtick'] + 1 
    }
    if ($tildeFences -gt 0) { 
        if (-not $codeFenceStyles.ContainsKey('Tilde')) { $codeFenceStyles['Tilde'] = 0 }
        $codeFenceStyles['Tilde'] = $codeFenceStyles['Tilde'] + 1 
    }
}

$atxCount = if ($headingStyles.ContainsKey('ATX')) { $headingStyles['ATX'] } else { 0 }
$setextCount = if ($headingStyles.ContainsKey('Setext')) { $headingStyles['Setext'] } else { 0 }
$dashCount = if ($listStyles.ContainsKey('Dash')) { $listStyles['Dash'] } else { 0 }
$asteriskCount = if ($listStyles.ContainsKey('Asterisk')) { $listStyles['Asterisk'] } else { 0 }
$backtickCount = if ($codeFenceStyles.ContainsKey('Backtick')) { $codeFenceStyles['Backtick'] } else { 0 }
$tildeCount = if ($codeFenceStyles.ContainsKey('Tilde')) { $codeFenceStyles['Tilde'] } else { 0 }

Write-Host "  ✓ Heading styles: ATX=$atxCount, Setext=$setextCount" -ForegroundColor Green
Write-Host "  ✓ List markers: Dash=$dashCount, Asterisk=$asteriskCount" -ForegroundColor Green
Write-Host "  ✓ Code fences: Backtick=$backtickCount, Tilde=$tildeCount" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "=== Validation Summary ===" -ForegroundColor Cyan
Write-Host "Total files processed: $($results.TotalFiles)" -ForegroundColor White
Write-Host "Files with valid metadata: $($results.MetadataValid)" -ForegroundColor Green
Write-Host "Files with invalid metadata: $($results.MetadataInvalid.Count)" -ForegroundColor $(if ($results.MetadataInvalid.Count -eq 0) { "Green" } else { "Yellow" })
Write-Host "Total Mermaid diagrams: $($results.MermaidDiagrams)" -ForegroundColor White
Write-Host "Mermaid diagram issues: $($results.MermaidErrors.Count)" -ForegroundColor $(if ($results.MermaidErrors.Count -eq 0) { "Green" } else { "Yellow" })
Write-Host "Broken links: $($results.BrokenLinks.Count)" -ForegroundColor $(if ($results.BrokenLinks.Count -eq 0) { "Green" } else { "Yellow" })
Write-Host "Status badges: $($results.StatusBadges)" -ForegroundColor White
Write-Host "Invalid status badges: $($results.InvalidBadges.Count)" -ForegroundColor $(if ($results.InvalidBadges.Count -eq 0) { "Green" } else { "Yellow" })
Write-Host ""

# Export detailed results
$outputPath = Join-Path (Get-Location) "validation-results.json"
$results | ConvertTo-Json -Depth 10 | Out-File $outputPath
Write-Host "Detailed results exported to: $outputPath" -ForegroundColor Cyan

# Return exit code based on critical issues
if ($results.BrokenLinks.Count -gt 0 -or $results.MermaidErrors.Count -gt 5) {
    exit 1
} else {
    exit 0
}
