<#
.SYNOPSIS
    Validates documentation files for informal language patterns.
    
.DESCRIPTION
    This script scans all markdown files in the Docs/ folder and detects
    informal Vietnamese expressions, non-standard approximations, and
    unprofessional placeholders that need to be replaced.
    
.PARAMETER Path
    The root path to scan. Defaults to "Docs/"
    
.PARAMETER OutputFile
    Optional. Path to save the validation report.
    
.PARAMETER FixMode
    If specified, shows suggested replacements (does not auto-fix).
    
.EXAMPLE
    .\validate-doc-language.ps1
    
.EXAMPLE
    .\validate-doc-language.ps1 -Path "Docs/features/car-physics" -OutputFile "report.txt"
    
.NOTES
    Version: 1.0.0
    Created: 2026-01-26
    Part of: Documentation Language Professionalization
#>

param(
    [string]$Path = "Docs",
    [string]$OutputFile = "",
    [switch]$FixMode,
    [switch]$Verbose,
    [switch]$IncludeExamples
)

# Files to exclude (contain examples of patterns to avoid)
$ExcludedFiles = @(
    "terminology-glossary.md",
    "documentation-standards.md"
)

# ============================================================================
# CONFIGURATION: Informal Patterns to Detect
# ============================================================================

$InformalPatterns = @{
    # Vietnamese informal expressions
    "ít trừng phạt" = @{
        Pattern = "ít trừng phạt"
        Replacement = "giảm mức độ ảnh hưởng tiêu cực"
        Category = "Informal Vietnamese"
        Severity = "HIGH"
    }
    "khoan dung" = @{
        Pattern = "khoan dung"
        Replacement = "có dung sai cao / linh hoạt"
        Category = "Informal Vietnamese"
        Severity = "HIGH"
    }
    "húc văng" = @{
        Pattern = "húc văng"
        Replacement = "đẩy ra khỏi đường đua"
        Category = "Informal Vietnamese"
        Severity = "HIGH"
    }
    "đập hộp" = @{
        Pattern = "đập hộp"
        Replacement = "mở hộp quà"
        Category = "Informal Vietnamese"
        Severity = "HIGH"
    }
    "sẽ bổ sung sau" = @{
        Pattern = "sẽ bổ sung( sau)?"
        Replacement = "[PENDING] block format"
        Category = "Informal Placeholder"
        Severity = "MEDIUM"
    }
    "bứt phá qua" = @{
        Pattern = "bứt phá qua"
        Replacement = "vượt qua"
        Category = "Informal Vietnamese"
        Severity = "MEDIUM"
    }
    "dính vào tường" = @{
        Pattern = "dính vào (tường|rào)"
        Replacement = "mắc kẹt tại rào chắn"
        Category = "Informal Vietnamese"
        Severity = "MEDIUM"
    }
    "văng ra" = @{
        Pattern = "văng ra"
        Replacement = "bị đẩy ra / mất kiểm soát"
        Category = "Informal Vietnamese"
        Severity = "MEDIUM"
    }
    "đâm sầm" = @{
        Pattern = "đâm sầm"
        Replacement = "va chạm trực diện"
        Category = "Informal Vietnamese"
        Severity = "MEDIUM"
    }
    "chạy bon bon" = @{
        Pattern = "chạy bon bon"
        Replacement = "di chuyển ổn định"
        Category = "Informal Vietnamese"
        Severity = "LOW"
    }
    
    # Approximation patterns
    "TildeNumber" = @{
        Pattern = "~\d+"
        Replacement = "approximately X or ≈X"
        Category = "Informal Approximation"
        Severity = "HIGH"
    }
    "khoảng" = @{
        Pattern = "khoảng \d+"
        Replacement = "approximately X"
        Category = "Informal Approximation"
        Severity = "MEDIUM"
    }
    "tầm" = @{
        Pattern = "tầm \d+"
        Replacement = "approximately X"
        Category = "Informal Approximation"
        Severity = "MEDIUM"
    }
    "chừng" = @{
        Pattern = "chừng \d+"
        Replacement = "approximately X"
        Category = "Informal Approximation"
        Severity = "MEDIUM"
    }
    
    # Placeholder patterns
    "TBD_standalone" = @{
        # Match TBD but NOT in [PENDING] blocks or Target Date fields
        Pattern = "(?<!\[)(?<!Target Date:\s*)(?<!Target Date\*\*:\s*)\bTBD\b(?!\])"
        Replacement = "[PENDING] block format"
        Category = "Informal Placeholder"
        Severity = "MEDIUM"
    }
    "Pending_prose" = @{
        # Only match "Pending" NOT in:
        # - emoji status indicators (⏸️ Pending)
        # - Mermaid classDef
        # - [PENDING] block format
        # - Code blocks (enum values, comments)
        Pattern = "(?<!⏸️\s)(?<!⏸️)(?<!classDef\s)(?<!class\s\w+\s)(?<!\[)(?<!EPurchaseStatus::)(?<!= )(?<!UMETA\(DisplayName = `")(?<!// \d+ = \w+, \d+ = )\bPending\b(?!\s*\])(?!\s*=)(?!.*fill:)(?!.*UMETA)"
        Replacement = "[PENDING] block format or In Progress"
        Category = "Informal Placeholder"
        Severity = "MEDIUM"
    }
    "TrailingEllipsis" = @{
        # Match trailing ellipsis but NOT in:
        # - directory trees (│, └, ├)
        # - code comments (// ...)
        # - code block placeholders
        Pattern = "(?<!│\s*)(?<!└──\s*)(?<!├──\s*)(?<!// )(?<!// )\.\.\.+\s*$"
        Replacement = "Complete sentence or [PENDING] block"
        Category = "Incomplete Content"
        Severity = "LOW"
    }
    "Đang cập nhật" = @{
        Pattern = "Đang cập nhật"
        Replacement = "[PENDING] block format"
        Category = "Informal Placeholder"
        Severity = "MEDIUM"
    }
    "Chưa hoàn thành" = @{
        Pattern = "Chưa hoàn thành"
        Replacement = "[PENDING] block format"
        Category = "Informal Placeholder"
        Severity = "MEDIUM"
    }
    
    # Inconsistent technical terms - only match INCORRECT variants
    # RubberBand_variants - DISABLED (matches Mermaid diagram node names which are valid identifiers)
    # "RubberBand_variants" = @{
    #     Pattern = "\b(rubberband|Rubberband|rubber-banding|RubberBand)\b"
    #     Replacement = "Rubber Banding"
    #     Category = "Inconsistent Terminology"
    #     Severity = "LOW"
    # }
    "AI_variants" = @{
        Pattern = "\b(A\.I\.|A\.I|a\.i)\b"
        Replacement = "AI"
        Category = "Inconsistent Terminology"
        Severity = "LOW"
    }
    # Cooldown_variants - DISABLED (PowerShell -match is case-insensitive, causing false positives)
    # The correct form "Cooldown" is already being used in the codebase
    # "Cooldown_variants" = @{
    #     Pattern = "\b(CoolDown|Cool Down|Cool-down)\b"
    #     Replacement = "Cooldown"
    #     Category = "Inconsistent Terminology"
    #     Severity = "LOW"
    # }

    # Formatting issues - DISABLED (too many false positives in technical docs)
    # "NoSpaceKmh" = @{
    #     Pattern = "\d+km/h"
    #     Replacement = "X km/h (with space)"
    #     Category = "Formatting"
    #     Severity = "LOW"
    # }
}

# ============================================================================
# FUNCTIONS
# ============================================================================

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Get-SeverityColor {
    param([string]$Severity)
    switch ($Severity) {
        "HIGH" { return "Red" }
        "MEDIUM" { return "Yellow" }
        "LOW" { return "Cyan" }
        default { return "White" }
    }
}

function Test-InformalPatterns {
    param(
        [string]$FilePath,
        [string]$Content,
        [int]$LineNumber,
        [string]$Line
    )

    $violations = @()

    foreach ($key in $InformalPatterns.Keys) {
        $patternInfo = $InformalPatterns[$key]
        if ($Line -match $patternInfo.Pattern) {
            $violations += [PSCustomObject]@{
                File = $FilePath
                Line = $LineNumber
                Pattern = $key
                Category = $patternInfo.Category
                Severity = $patternInfo.Severity
                Match = $Matches[0]
                Replacement = $patternInfo.Replacement
                Context = $Line.Trim()
            }
        }
    }

    return $violations
}

function Format-Report {
    param([array]$Violations)

    $report = @()
    $report += "=" * 80
    $report += "DOCUMENTATION LANGUAGE VALIDATION REPORT"
    $report += "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    $report += "=" * 80
    $report += ""

    # Summary by severity
    $highCount = ($Violations | Where-Object { $_.Severity -eq "HIGH" }).Count
    $mediumCount = ($Violations | Where-Object { $_.Severity -eq "MEDIUM" }).Count
    $lowCount = ($Violations | Where-Object { $_.Severity -eq "LOW" }).Count

    $report += "SUMMARY"
    $report += "-" * 40
    $report += "Total Violations: $($Violations.Count)"
    $report += "  HIGH:   $highCount"
    $report += "  MEDIUM: $mediumCount"
    $report += "  LOW:    $lowCount"
    $report += ""

    # Summary by category
    $report += "BY CATEGORY"
    $report += "-" * 40
    $Violations | Group-Object Category | ForEach-Object {
        $report += "  $($_.Name): $($_.Count)"
    }
    $report += ""

    # Summary by file
    $report += "BY FILE"
    $report += "-" * 40
    $Violations | Group-Object File | Sort-Object Count -Descending | Select-Object -First 20 | ForEach-Object {
        $report += "  $($_.Count) violations: $($_.Name)"
    }
    $report += ""

    # Detailed violations
    $report += "DETAILED VIOLATIONS"
    $report += "=" * 80

    $Violations | Group-Object File | ForEach-Object {
        $report += ""
        $report += "FILE: $($_.Name)"
        $report += "-" * 60

        $_.Group | ForEach-Object {
            $report += "  Line $($_.Line) [$($_.Severity)] $($_.Category)"
            $report += "    Pattern: $($_.Pattern)"
            $report += "    Found: $($_.Match)"
            $report += "    Replace with: $($_.Replacement)"
            $report += "    Context: $($_.Context.Substring(0, [Math]::Min(100, $_.Context.Length)))..."
            $report += ""
        }
    }

    return $report -join "`n"
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

Write-ColorOutput "`n========================================" "Cyan"
Write-ColorOutput "Documentation Language Validator v1.0.0" "Cyan"
Write-ColorOutput "========================================`n" "Cyan"

# Validate path
if (-not (Test-Path $Path)) {
    Write-ColorOutput "ERROR: Path '$Path' does not exist." "Red"
    exit 1
}

Write-ColorOutput "Scanning: $Path" "White"
Write-ColorOutput "Looking for informal language patterns...`n" "White"

# Get all markdown files
$mdFiles = Get-ChildItem -Path $Path -Filter "*.md" -Recurse -File

# Filter out excluded files (unless -IncludeExamples is specified)
if (-not $IncludeExamples) {
    $mdFiles = $mdFiles | Where-Object { $ExcludedFiles -notcontains $_.Name }
}

Write-ColorOutput "Found $($mdFiles.Count) markdown files`n" "Green"

# Process each file
$allViolations = @()
$processedFiles = 0

foreach ($file in $mdFiles) {
    $processedFiles++
    $relativePath = $file.FullName.Replace((Get-Location).Path + "\", "")

    if ($Verbose) {
        Write-Progress -Activity "Scanning files" -Status $relativePath -PercentComplete (($processedFiles / $mdFiles.Count) * 100)
    }

    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $lines = Get-Content $file.FullName -Encoding UTF8

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $violations = Test-InformalPatterns -FilePath $relativePath -Content $content -LineNumber ($i + 1) -Line $lines[$i]
        $allViolations += $violations
    }
}

# Output results
if ($allViolations.Count -eq 0) {
    Write-ColorOutput "✅ SUCCESS: No informal language patterns detected!" "Green"
    Write-ColorOutput "All $($mdFiles.Count) files pass validation.`n" "Green"
}
else {
    Write-ColorOutput "⚠️  VIOLATIONS FOUND: $($allViolations.Count) issues detected`n" "Yellow"

    # Display summary
    $highCount = ($allViolations | Where-Object { $_.Severity -eq "HIGH" }).Count
    $mediumCount = ($allViolations | Where-Object { $_.Severity -eq "MEDIUM" }).Count
    $lowCount = ($allViolations | Where-Object { $_.Severity -eq "LOW" }).Count

    Write-ColorOutput "Summary by Severity:" "White"
    Write-ColorOutput "  HIGH:   $highCount" "Red"
    Write-ColorOutput "  MEDIUM: $mediumCount" "Yellow"
    Write-ColorOutput "  LOW:    $lowCount" "Cyan"
    Write-ColorOutput ""

    # Display top violations
    Write-ColorOutput "Top 10 Files with Most Violations:" "White"
    $allViolations | Group-Object File | Sort-Object Count -Descending | Select-Object -First 10 | ForEach-Object {
        Write-ColorOutput "  $($_.Count) issues: $($_.Name)" "White"
    }
    Write-ColorOutput ""

    # Display sample violations (first 5 HIGH severity)
    Write-ColorOutput "Sample HIGH Severity Violations:" "Red"
    $allViolations | Where-Object { $_.Severity -eq "HIGH" } | Select-Object -First 5 | ForEach-Object {
        Write-ColorOutput "  $($_.File):$($_.Line)" "White"
        Write-ColorOutput "    Found: '$($_.Match)' -> Replace with: '$($_.Replacement)'" "Yellow"
    }
}

# Save report if output file specified
if ($OutputFile) {
    $report = Format-Report -Violations $allViolations
    $report | Out-File -FilePath $OutputFile -Encoding UTF8
    Write-ColorOutput "`nReport saved to: $OutputFile" "Green"
}

# Return exit code
if ($allViolations.Count -gt 0) {
    Write-ColorOutput "`nValidation FAILED. Please fix the violations above." "Red"
    exit 1
}
else {
    Write-ColorOutput "`nValidation PASSED." "Green"
    exit 0
}

