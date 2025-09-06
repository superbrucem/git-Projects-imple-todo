#Requires -Version 5.1

<#
.SYNOPSIS
    Creates a new Git repository locally and publishes it to GitHub.

.DESCRIPTION
    This PowerShell script creates a new Git repository with all necessary files
    (README.md, .gitignore, LICENSE) and publishes it to GitHub using GitHub CLI.

.PARAMETER RepoName
    The name of the repository to create (required).

.PARAMETER Description
    Description for the repository.

.PARAMETER Username
    GitHub username (if not set in git config).

.PARAMETER Private
    Create a private repository instead of public.

.PARAMETER CommitMessage
    Custom initial commit message.

.PARAMETER NoGitignore
    Skip creating .gitignore file.

.PARAMETER License
    Create LICENSE file with specified type (MIT, Apache, GPL).

.PARAMETER Help
    Show help information.

.EXAMPLE
    .\Create-GitRepo.ps1 -RepoName "my-project"
    Creates a public repository named "my-project" with default settings.

.EXAMPLE
    .\Create-GitRepo.ps1 -RepoName "secret-project" -Description "My secret project" -Private
    Creates a private repository with a custom description.

.EXAMPLE
    .\Create-GitRepo.ps1 -RepoName "awesome-app" -Description "An awesome app" -License MIT -Username "myuser"
    Creates a repository with MIT license and specified username.

.NOTES
    Author: Automated Script Generator
    Version: 1.0
    Requires: Git, GitHub CLI (gh)
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidatePattern('^[a-zA-Z0-9._-]+$')]
    [string]$RepoName,
    
    [Parameter(Mandatory = $false)]
    [string]$Description = "",
    
    [Parameter(Mandatory = $false)]
    [string]$Username = "",
    
    [Parameter(Mandatory = $false)]
    [switch]$Private,
    
    [Parameter(Mandatory = $false)]
    [string]$CommitMessage = "Initial commit: Project setup",
    
    [Parameter(Mandatory = $false)]
    [switch]$NoGitignore,
    
    [Parameter(Mandatory = $false)]
    [ValidateSet("MIT", "Apache", "GPL")]
    [string]$License = "",
    
    [Parameter(Mandatory = $false)]
    [switch]$Help
)

# Color definitions for console output
$Colors = @{
    Red      = [ConsoleColor]::Red
    Green    = [ConsoleColor]::Green
    Yellow   = [ConsoleColor]::Yellow
    Blue     = [ConsoleColor]::Blue
    Cyan     = [ConsoleColor]::Cyan
    Magenta  = [ConsoleColor]::Magenta
    White    = [ConsoleColor]::White
}

# Function to write colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [ConsoleColor]$ForegroundColor = [ConsoleColor]::White,
        [string]$Prefix = ""
    )
    
    if ($Prefix) {
        Write-Host "$Prefix " -ForegroundColor $ForegroundColor -NoNewline
    }
    Write-Host $Message -ForegroundColor $ForegroundColor
}

function Write-Info {
    param([string]$Message)
    Write-ColorOutput -Message $Message -ForegroundColor $Colors.Blue -Prefix "ℹ️"
}

function Write-Success {
    param([string]$Message)
    Write-ColorOutput -Message $Message -ForegroundColor $Colors.Green -Prefix "✅"
}

function Write-Warning {
    param([string]$Message)
    Write-ColorOutput -Message $Message -ForegroundColor $Colors.Yellow -Prefix "⚠️"
}

function Write-Error {
    param([string]$Message)
    Write-ColorOutput -Message $Message -ForegroundColor $Colors.Red -Prefix "❌"
}

function Write-Step {
    param([string]$Message)
    Write-ColorOutput -Message $Message -ForegroundColor $Colors.Magenta -Prefix "🔧"
}

# Function to show usage information
function Show-Usage {
    Write-ColorOutput -Message "Git Repository Creator" -ForegroundColor $Colors.Cyan
    Write-ColorOutput -Message "=====================" -ForegroundColor $Colors.Cyan
    Write-Host ""
    Write-Host "Usage: .\Create-GitRepo.ps1 -RepoName <name> [options]"
    Write-Host ""
    Write-Host "Required:"
    Write-Host "  -RepoName <name>       Name of the repository to create"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Description <text>    Repository description"
    Write-Host "  -Username <name>       GitHub username"
    Write-Host "  -Private               Create private repository"
    Write-Host "  -CommitMessage <msg>   Initial commit message"
    Write-Host "  -NoGitignore           Don't create .gitignore file"
    Write-Host "  -License <type>        Create LICENSE file (MIT, Apache, GPL)"
    Write-Host "  -Help                  Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\Create-GitRepo.ps1 -RepoName 'my-project'"
    Write-Host "  .\Create-GitRepo.ps1 -RepoName 'my-project' -Description 'My awesome project' -Private"
    Write-Host "  .\Create-GitRepo.ps1 -RepoName 'my-project' -Username 'myuser' -License MIT"
}

# Function to test if a command exists
function Test-Command {
    param([string]$CommandName)
    
    try {
        Get-Command $CommandName -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Function to check prerequisites
function Test-Prerequisites {
    Write-Step "Checking prerequisites..."
    
    # Check if Git is installed
    if (-not (Test-Command "git")) {
        Write-Error "Git is not installed. Please install Git first."
        Write-Info "Download from: https://git-scm.com/download/windows"
        exit 1
    }
    
    # Check if GitHub CLI is installed
    if (-not (Test-Command "gh")) {
        Write-Error "GitHub CLI (gh) is not installed."
        Write-Info "Install with: winget install GitHub.cli"
        Write-Info "Or download from: https://cli.github.com/"
        exit 1
    }
    
    # Check if GitHub CLI is authenticated
    try {
        $null = gh auth status 2>$null
        if ($LASTEXITCODE -ne 0) {
            throw "Not authenticated"
        }
    }
    catch {
        Write-Error "GitHub CLI is not authenticated."
        Write-Info "Please run: gh auth login"
        exit 1
    }
    
    Write-Success "All prerequisites met"
}

# Function to get GitHub username
function Get-GitHubUsername {
    if ([string]::IsNullOrEmpty($script:Username)) {
        
        # Try to get from GitHub CLI
        try {
            $script:Username = gh api user --jq '.login' 2>$null
        }
        catch { }
        
        # If still empty, prompt user
        if ([string]::IsNullOrEmpty($script:Username)) {
            $script:Username = Read-Host "Enter your GitHub username"
        }
    }
    
    if ([string]::IsNullOrEmpty($script:Username)) {
        Write-Error "GitHub username is required"
        exit 1
    }
    
    Write-Info "Using GitHub username: $script:Username"
}

# Function to create .gitignore file
function New-GitignoreFile {
    if (-not $NoGitignore) {
        Write-Step "Creating .gitignore file..."
        
        $gitignoreContent = @'
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/

# nyc test coverage
.nyc_output

# Grunt intermediate storage
.grunt

# Bower dependency directory
bower_components

# node_modules
node_modules/

# Optional npm cache directory
.npm

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env
.env.test
.env.local
.env.development.local
.env.test.local
.env.production.local

# parcel-bundler cache
.cache
.parcel-cache

# next.js build output
.next

# nuxt.js build output
.nuxt

# vuepress build output
.vuepress/dist

# Serverless directories
.serverless

# FuseBox cache
.fusebox/

# DynamoDB Local files
.dynamodb/

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Build directories
build/
dist/
out/

# Temporary files
*.tmp
*.temp

# Windows specific
desktop.ini
$RECYCLE.BIN/
*.cab
*.msi
*.msix
*.msm
*.msp
*.lnk
'@
        
        $gitignoreContent | Out-File -FilePath ".gitignore" -Encoding UTF8
        Write-Success ".gitignore created"
    }
}

# Function to create LICENSE file
function New-LicenseFile {
    if (-not [string]::IsNullOrEmpty($License)) {
        Write-Step "Creating LICENSE file..."
        
        $currentYear = (Get-Date).Year
        
        switch ($License) {
            "MIT" {
                $licenseContent = @"
MIT License

Copyright (c) $currentYear $script:Username

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@
                break
            }
            "Apache" {
                $licenseContent = @"
Apache License
Version 2.0, January 2004
http://www.apache.org/licenses/

Copyright $currentYear $script:Username

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"@
                break
            }
            default {
                Write-Warning "License type '$License' not fully implemented. Creating basic license."
                $licenseContent = @"
Copyright (c) $currentYear $script:Username

All rights reserved.
"@
            }
        }
        
        $licenseContent | Out-File -FilePath "LICENSE" -Encoding UTF8
        Write-Success "LICENSE file created ($License)"
    }
}

# Function to create README.md
function New-ReadmeFile {
    Write-Step "Creating README.md..."
    
    $licenseSection = if (-not [string]::IsNullOrEmpty($License)) {
        "This project is licensed under the $License License - see the [LICENSE](LICENSE) file for details."
    } else {
        "This project is open source."
    }
    
    $readmeContent = @"
# $RepoName

$script:Description

## Description

This repository was created using an automated PowerShell script.

## Getting Started

### Prerequisites

- Git installed on your machine
- Access to this repository

### Installation

```powershell
git clone [https://github.com/$script:Username/$RepoName.git](https://github.com/$script:Username/$RepoName.git)
cd $RepoName
```

## Usage

Add usage instructions here.

## Contributing

1. Fork the repository
2. Create your feature branch (``git checkout -b feature/amazing-feature``)
3. Commit your changes (``git commit -m 'Add some amazing feature'``)
4. Push to the branch (``git push origin feature/amazing-feature``)
5. Open a Pull Request

## License

$licenseSection

## Contact

$script:Username - [@$script:Username](https://github.com/$script:Username)

Project Link: [https://github.com/$script:Username/$RepoName](https://github.com/$script:Username/$RepoName)
"@
    
    $readmeContent | Out-File -FilePath "README.md" -Encoding UTF8
    Write-Success "README.md created"
}

# Function to create local repository
function New-LocalRepository {
    Write-Step "Creating local repository: $RepoName"

    # Check if directory already exists
    if (Test-Path $RepoName) {
        Write-Error "Directory '$RepoName' already exists"
        $response = Read-Host "Do you want to continue and use the existing directory? (y/N)"
        if ($response -notmatch '^[Yy]$') {
            exit 1
        }
    } else {
        New-Item -ItemType Directory -Name $RepoName | Out-Null
    }

    Set-Location $RepoName

    # Initialize git repository
    Write-Step "Initializing git repository..."
    git init

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to initialize git repository"
        exit 1
    }

    # Create files
    New-ReadmeFile
    New-GitignoreFile
    New-LicenseFile

    # Add and commit files
    Write-Step "Creating initial commit..."
    git add .
    git commit -m "$CommitMessage"

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to create initial commit"
        exit 1
    }

    Write-Success "Local repository created successfully"
}

# Function to create GitHub repository and push
function New-GitHubRepository {
    Write-Step "Creating GitHub repository..."

    # Determine visibility
    $visibilityFlag = if ($Private) { "--private" } else { "--public" }

    if ($Private) {
        Write-Info "Creating private repository"
    } else {
        Write-Info "Creating public repository"
    }

    # Create repository on GitHub
    try {
        gh repo create $RepoName $visibilityFlag --description "$script:Description" --source .

        if ($LASTEXITCODE -ne 0) {
            throw "GitHub CLI returned error code $LASTEXITCODE"
        }

        Write-Success "GitHub repository created"
    }
    catch {
        Write-Error "Failed to create GitHub repository: $_"
        exit 1
    }

    # Set main branch and push
    Write-Step "Pushing to GitHub..."

    try {
        git branch -M main
        git push -u origin main

        if ($LASTEXITCODE -ne 0) {
            throw "Git push failed with error code $LASTEXITCODE"
        }

        Write-Success "Code pushed to GitHub successfully"
    }
    catch {
        Write-Error "Failed to push to GitHub: $_"
        exit 1
    }

    # Display success information
    Write-Host ""
    Write-Success "Repository created and published successfully!"
    Write-ColorOutput -Message "🔗 Repository URL: https://github.com/$script:Username/$RepoName" -ForegroundColor $Colors.Cyan
    Write-ColorOutput -Message "📁 Local directory: $(Get-Location)" -ForegroundColor $Colors.Cyan
}

# Function to show configuration
function Show-Configuration {
    Write-Host ""
    Write-Info "Configuration:"
    Write-Host "  Repository Name: $RepoName"
    Write-Host "  Description: $script:Description"
    Write-Host "  GitHub Username: $script:Username"
    Write-Host "  Visibility: $(if ($Private) { 'Private' } else { 'Public' })"
    Write-Host "  Create .gitignore: $(-not $NoGitignore)"
    Write-Host "  Create LICENSE: $(-not [string]::IsNullOrEmpty($License))"
    if (-not [string]::IsNullOrEmpty($License)) {
        Write-Host "  License Type: $License"
    }
    Write-Host ""
}

# Function to confirm operation
function Confirm-Operation {
    $response = Read-Host "Do you want to proceed? (Y/n)"
    if ($response -match '^[Nn]$') {
        Write-Info "Operation cancelled"
        exit 0
    }
}

# Main function
function Invoke-Main {
    # Show header
    Write-Host ""
    Write-ColorOutput -Message "╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor $Colors.Cyan
    Write-ColorOutput -Message "║                    Git Repository Creator                         ║" -ForegroundColor $Colors.Cyan
    Write-ColorOutput -Message "║                   PowerShell Script v1.0                          ║" -ForegroundColor $Colors.Cyan
    Write-ColorOutput -Message "╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor $Colors.Cyan
    Write-Host ""

    # Check prerequisites
    Test-Prerequisites

    # Get GitHub username
    Get-GitHubUsername

    # Set default description if empty
    if ([string]::IsNullOrEmpty($script:Description)) {
        $script:Description = "Repository $RepoName created via automated PowerShell script"
    }

    # Show configuration
    Show-Configuration

    # Confirm before proceeding
    Confirm-Operation

    # Store current location
    $originalLocation = Get-Location

    try {
        # Create repository
        New-LocalRepository
        New-GitHubRepository

        Write-Host ""
        Write-Success "🎉 All done! Your repository is ready to use."
    }
    catch {
        Write-Error "An unexpected error occurred: $_"
        exit 1
    }
    finally {
        # Return to original location if something went wrong
        if ((Get-Location).Path -ne $originalLocation.Path) {
            Set-Location $originalLocation
        }
    }
}

# Script entry point
if ($Help) {
    Show-Usage
    exit 0
}

# Set script-level variables
$script:Username = $Username
$script:Description = $Description
 
Invoke-Main
