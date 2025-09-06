#Requires -Version 5.1

<#
.SYNOPSIS
    Updates Excel and Access databases with feature information

.DESCRIPTION
    This script updates both Excel spreadsheets and Access databases with 
    feature tracking information, integrating with the Augment workflow.

.PARAMETER FeatureName
    Name of the feature to add/update

.PARAMETER Description
    Description of the feature

.PARAMETER Status
    Current status (Planning, In Progress, Testing, Complete)

.PARAMETER Priority
    Priority level (High, Medium, Low)

.PARAMETER ExcelPath
    Path to the Excel tracking file

.PARAMETER AccessPath
    Path to the Access database file

.EXAMPLE
    .\Update-FeatureTracking.ps1 -FeatureName "User Authentication" -Description "Login system" -Status "Complete" -Priority "High"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$FeatureName,
    
    [Parameter(Mandatory = $true)]
    [string]$Description,
    
    [Parameter(Mandatory = $true)]
    [ValidateSet("Planning", "In Progress", "Testing", "Complete", "On Hold")]
    [string]$Status,
    
    [Parameter(Mandatory = $true)]
    [ValidateSet("High", "Medium", "Low")]
    [string]$Priority,
    
    [Parameter(Mandatory = $false)]
    [string]$ExcelPath = ".\feature-tracking.xlsx",
    
    [Parameter(Mandatory = $false)]
    [string]$AccessPath = ".\project-database.accdb",
    
    [Parameter(Mandatory = $false)]
    [switch]$CreateFiles
)

# Function to create Excel file if it doesn't exist
function New-FeatureTrackingExcel {
    param([string]$Path)
    
    try {
        $excel = New-Object -ComObject Excel.Application
        $excel.Visible = $false
        $excel.DisplayAlerts = $false
        
        $workbook = $excel.Workbooks.Add()
        $worksheet = $workbook.Worksheets.Item(1)
        $worksheet.Name = "Features"
        
        # Create headers
        $worksheet.Cells.Item(1, 1) = "Feature Name"
        $worksheet.Cells.Item(1, 2) = "Description"
        $worksheet.Cells.Item(1, 3) = "Status"
        $worksheet.Cells.Item(1, 4) = "Priority"
        $worksheet.Cells.Item(1, 5) = "Date Added"
        $worksheet.Cells.Item(1, 6) = "Last Updated"
        $worksheet.Cells.Item(1, 7) = "Estimated Hours"
        $worksheet.Cells.Item(1, 8) = "Actual Hours"
        $worksheet.Cells.Item(1, 9) = "Assigned To"
        $worksheet.Cells.Item(1, 10) = "Notes"
        
        # Format headers
        $headerRange = $worksheet.Range("A1:J1")
        $headerRange.Font.Bold = $true
        $headerRange.Interior.Color = 15773696  # Light blue
        $headerRange.Borders.Weight = 2
        
        # Auto-fit columns
        $worksheet.Columns.AutoFit() | Out-Null
        
        $workbook.SaveAs($Path)
        $workbook.Close()
        $excel.Quit()
        
        Write-Host "✅ Created Excel file: $Path" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to create Excel file: $_"
    }
    finally {
        if ($excel) {
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
        }
    }
}

# Function to update Excel file
function Update-ExcelFeatures {
    param(
        [string]$Path,
        [hashtable]$FeatureData
    )
    
    try {
        if (-not (Test-Path $Path)) {
            if ($CreateFiles) {
                New-FeatureTrackingExcel -Path $Path
            } else {
                throw "Excel file not found: $Path"
            }
        }
        
        $excel = New-Object -ComObject Excel.Application
        $excel.Visible = $false
        $excel.DisplayAlerts = $false
        
        $workbook = $excel.Workbooks.Open($Path)
        $worksheet = $workbook.Worksheets.Item("Features")
        
        # Find next empty row
        $lastRow = $worksheet.UsedRange.Rows.Count
        $nextRow = $lastRow + 1
        
        # Check if feature already exists
        $existingRow = $null
        for ($i = 2; $i -le $lastRow; $i++) {
            if ($worksheet.Cells.Item($i, 1).Text -eq $FeatureData.Name) {
                $existingRow = $i
                break
            }
        }
        
        if ($existingRow) {
            $row = $existingRow
            Write-Host "📝 Updating existing feature in Excel" -ForegroundColor Yellow
        } else {
            $row = $nextRow
            Write-Host "➕ Adding new feature to Excel" -ForegroundColor Green
        }
        
        # Update/Add feature data
        $worksheet.Cells.Item($row, 1) = $FeatureData.Name
        $worksheet.Cells.Item($row, 2) = $FeatureData.Description
        $worksheet.Cells.Item($row, 3) = $FeatureData.Status
        $worksheet.Cells.Item($row, 4) = $FeatureData.Priority
        
        if (-not $existingRow) {
            $worksheet.Cells.Item($row, 5) = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }
        $worksheet.Cells.Item($row, 6) = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        
        # Auto-fit columns
        $worksheet.Columns.AutoFit() | Out-Null
        
        $workbook.Save()
        $workbook.Close()
        $excel.Quit()
        
        Write-Host "✅ Excel file updated successfully" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to update Excel file: $_"
    }
    finally {
        if ($excel) {
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
        }
    }
}

# Function to create Access database if it doesn't exist
function New-FeatureTrackingAccess {
    param([string]$Path)
    
    try {
        $access = New-Object -ComObject Access.Application
        $access.Visible = $false
        
        # Create new database
        $access.DBEngine.CreateDatabase($Path, ";LANGID=0x0409;CP=1252;COUNTRY=0")
        $access.OpenCurrentDatabase($Path)
        
        # Create Features table
        $sql = @"
CREATE TABLE Features (
    ID AUTOINCREMENT PRIMARY KEY,
    FeatureName TEXT(255) NOT NULL,
    Description MEMO,
    Status TEXT(50),
    Priority TEXT(20),
    DateAdded DATETIME,
    LastUpdated DATETIME,
    EstimatedHours DOUBLE,
    ActualHours DOUBLE,
    AssignedTo TEXT(100),
    Notes MEMO
)
"@
        
        $access.CurrentDb().Execute($sql)
        
        $access.CloseCurrentDatabase()
        $access.Quit()
        
        Write-Host "✅ Created Access database: $Path" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to create Access database: $_"
    }
    finally {
        if ($access) {
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($access) | Out-Null
        }
    }
}

# Function to update Access database
function Update-AccessFeatures {
    param(
        [string]$Path,
        [hashtable]$FeatureData
    )
    
    try {
        if (-not (Test-Path $Path)) {
            if ($CreateFiles) {
                New-FeatureTrackingAccess -Path $Path
            } else {
                throw "Access database not found: $Path"
            }
        }
        
        $connectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=$Path"
        $connection = New-Object System.Data.OleDb.OleDbConnection($connectionString)
        $connection.Open()
        
        # Check if feature exists
        $checkSql = "SELECT COUNT(*) FROM Features WHERE FeatureName = ?"
        $checkCommand = New-Object System.Data.OleDb.OleDbCommand($checkSql, $connection)
        $checkCommand.Parameters.AddWithValue("@name", $FeatureData.Name)
        $exists = $checkCommand.ExecuteScalar() -gt 0
        
        if ($exists) {
            # Update existing feature
            $sql = @"
UPDATE Features 
SET Description = ?, Status = ?, Priority = ?, LastUpdated = ?
WHERE FeatureName = ?
"@
            $command = New-Object System.Data.OleDb.OleDbCommand($sql, $connection)
            $command.Parameters.AddWithValue("@desc", $FeatureData.Description)
            $command.Parameters.AddWithValue("@status", $FeatureData.Status)
            $command.Parameters.AddWithValue("@priority", $FeatureData.Priority)
            $command.Parameters.AddWithValue("@updated", (Get-Date))
            $command.Parameters.AddWithValue("@name", $FeatureData.Name)
            
            Write-Host "📝 Updating existing feature in Access database" -ForegroundColor Yellow
        } else {
            # Insert new feature
            $sql = @"
INSERT INTO Features (FeatureName, Description, Status, Priority, DateAdded, LastUpdated)
VALUES (?, ?, ?, ?, ?, ?)
"@
            $command = New-Object System.Data.OleDb.OleDbCommand($sql, $connection)
            $command.Parameters.AddWithValue("@name", $FeatureData.Name)
            $command.Parameters.AddWithValue("@desc", $FeatureData.Description)
            $command.Parameters.AddWithValue("@status", $FeatureData.Status)
            $command.Parameters.AddWithValue("@priority", $FeatureData.Priority)
            $command.Parameters.AddWithValue("@added", (Get-Date))
            $command.Parameters.AddWithValue("@updated", (Get-Date))
            
            Write-Host "➕ Adding new feature to Access database" -ForegroundColor Green
        }
        
        $command.ExecuteNonQuery()
        $connection.Close()
        
        Write-Host "✅ Access database updated successfully" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to update Access database: $_"
    }
    finally {
        if ($connection -and $connection.State -eq 'Open') {
            $connection.Close()
        }
    }
}

# Function to generate status report
function New-StatusReport {
    param([hashtable]$FeatureData)
    
    $reportPath = "feature-status-report.txt"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    $report = @"
Feature Status Report
Generated: $timestamp

Feature: $($FeatureData.Name)
Description: $($FeatureData.Description)
Status: $($FeatureData.Status)
Priority: $($FeatureData.Priority)

Files Updated:
- Excel: $ExcelPath
- Access: $AccessPath

Next Steps:
- Review feature implementation
- Update project documentation
- Notify stakeholders if needed
"@
    
    $report | Out-File -FilePath $reportPath -Encoding UTF8
    Write-Host "📊 Status report generated: $reportPath" -ForegroundColor Cyan
}

# Main execution
try {
    Write-Host "🚀 Starting Feature Tracking Update" -ForegroundColor Cyan
    Write-Host "Feature: $FeatureName" -ForegroundColor White
    Write-Host "Status: $Status" -ForegroundColor White
    Write-Host "Priority: $Priority" -ForegroundColor White
    
    $featureData = @{
        Name = $FeatureName
        Description = $Description
        Status = $Status
        Priority = $Priority
    }
    
    # Update Excel
    if (Test-Path $ExcelPath -or $CreateFiles) {
        Update-ExcelFeatures -Path $ExcelPath -FeatureData $featureData
    } else {
        Write-Warning "Excel file not found: $ExcelPath (use -CreateFiles to create)"
    }
    
    # Update Access
    if (Test-Path $AccessPath -or $CreateFiles) {
        Update-AccessFeatures -Path $AccessPath -FeatureData $featureData
    } else {
        Write-Warning "Access database not found: $AccessPath (use -CreateFiles to create)"
    }
    
    # Generate report
    New-StatusReport -FeatureData $featureData
    
    Write-Host "🎉 Feature tracking update completed successfully!" -ForegroundColor Green
}
catch {
    Write-Error "Feature tracking update failed: $_"
    exit 1
}
