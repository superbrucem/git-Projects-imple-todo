# Bash Scripts Collection

This folder contains useful bash scripts for development and automation tasks.

## 📁 Scripts Available

### `create-git-repo.sh` - Git Repository Creator (Bash)

A comprehensive bash script that creates a new Git repository locally and publishes it to GitHub with all the necessary files and configurations.

### `Create-GitRepo.ps1` - Git Repository Creator (PowerShell)

A PowerShell equivalent of the bash script with the same functionality, designed for Windows environments and PowerShell users.

## 🚀 Quick Start

### Prerequisites

Before using the script, ensure you have:

1. **Git** installed and configured:
   ```bash
   git --version
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

2. **GitHub CLI (gh)** installed and authenticated:
   ```bash
   # Install GitHub CLI
   # macOS: brew install gh
   # Ubuntu/Debian: sudo apt install gh
   # Windows: winget install GitHub.cli
   
   # Authenticate with GitHub
   gh auth login
   ```

### Installation

#### For Bash Script (Linux/macOS/WSL):
1. Make the script executable:
   ```bash
   chmod +x create-git-repo.sh
   ```

2. Optionally, add to your PATH for global access:
   ```bash
   # Add to ~/.bashrc or ~/.zshrc
   export PATH="$PATH:/path/to/bashscript"
   ```

#### For PowerShell Script (Windows/Cross-platform):
1. Set execution policy (if needed):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. Optionally, add to your PowerShell profile for global access:
   ```powershell
   # Add to $PROFILE
   $env:PATH += ";C:\path\to\bashscript"
   ```

## 📖 Usage

### Basic Usage

#### Bash:
```bash
./create-git-repo.sh my-awesome-project
```

#### PowerShell:
```powershell
.\Create-GitRepo.ps1 -RepoName "my-awesome-project"
```

### Advanced Usage

#### Bash:
```bash
./create-git-repo.sh my-project \
  --description "My awesome new project" \
  --username "myusername" \
  --private \
  --license MIT \
  --message "Initial setup with all configurations"
```

#### PowerShell:
```powershell
.\Create-GitRepo.ps1 -RepoName "my-project" `
  -Description "My awesome new project" `
  -Username "myusername" `
  -Private `
  -License MIT `
  -CommitMessage "Initial setup with all configurations"
```

### Command Line Options

#### Bash Script Options:
| Option | Short | Description | Example |
|--------|-------|-------------|---------|
| `--description` | `-d` | Repository description | `-d "My project description"` |
| `--username` | `-u` | GitHub username | `-u "myusername"` |
| `--private` | `-p` | Create private repository | `-p` |
| `--message` | `-m` | Initial commit message | `-m "Initial commit"` |
| `--no-gitignore` | | Skip .gitignore creation | `--no-gitignore` |
| `--license` | | Create LICENSE file | `--license MIT` |
| `--help` | `-h` | Show help message | `-h` |

#### PowerShell Script Parameters:
| Parameter | Description | Example |
|-----------|-------------|---------|
| `-RepoName` | Repository name (required) | `-RepoName "my-project"` |
| `-Description` | Repository description | `-Description "My project"` |
| `-Username` | GitHub username | `-Username "myusername"` |
| `-Private` | Create private repository | `-Private` |
| `-CommitMessage` | Initial commit message | `-CommitMessage "Initial commit"` |
| `-NoGitignore` | Skip .gitignore creation | `-NoGitignore` |
| `-License` | Create LICENSE file | `-License MIT` |
| `-Help` | Show help message | `-Help` |

## 🎯 What the Script Does

### 1. **Prerequisites Check**
- ✅ Verifies Git is installed
- ✅ Verifies GitHub CLI is installed and authenticated
- ✅ Gets GitHub username from config or prompts user

### 2. **Local Repository Creation**
- 📁 Creates project directory
- 🔧 Initializes Git repository
- 📝 Creates comprehensive README.md
- 🚫 Creates .gitignore with common patterns
- ⚖️ Creates LICENSE file (optional)
- 💾 Makes initial commit

### 3. **GitHub Integration**
- 🌐 Creates repository on GitHub
- 🔒 Sets visibility (public/private)
- 📤 Pushes code to GitHub
- 🔗 Provides repository URL

### 4. **Generated Files**

#### README.md
- Project title and description
- Installation instructions
- Usage guidelines
- Contributing guidelines
- License information
- Contact details

#### .gitignore
- Node.js patterns
- IDE files
- OS-specific files
- Build directories
- Environment files
- Temporary files

#### LICENSE (optional)
- MIT License template
- Automatically filled with current year and username

## 🎨 Features

### 🌈 **Colorful Output**
- Color-coded messages for better readability
- Progress indicators and status updates
- Clear error messages and warnings

### 🛡️ **Error Handling**
- Comprehensive prerequisite checking
- Graceful error handling and recovery
- User confirmation before destructive operations

### ⚙️ **Customization**
- Flexible command-line options
- Smart defaults for quick usage
- Configurable file generation

### 🔍 **Validation**
- Repository name validation
- GitHub authentication verification
- Directory existence checking

## 📋 Examples

### Create a Simple Public Repository

#### Bash:
```bash
./create-git-repo.sh my-website
```

#### PowerShell:
```powershell
.\Create-GitRepo.ps1 -RepoName "my-website"
```

### Create a Private Project with Description

#### Bash:
```bash
./create-git-repo.sh secret-project \
  --description "My secret project" \
  --private
```

#### PowerShell:
```powershell
.\Create-GitRepo.ps1 -RepoName "secret-project" `
  -Description "My secret project" `
  -Private
```

### Create a Full-Featured Repository

#### Bash:
```bash
./create-git-repo.sh awesome-app \
  --description "An awesome application" \
  --username "myusername" \
  --license MIT \
  --message "🎉 Initial commit: Project foundation"
```

#### PowerShell:
```powershell
.\Create-GitRepo.ps1 -RepoName "awesome-app" `
  -Description "An awesome application" `
  -Username "myusername" `
  -License MIT `
  -CommitMessage "🎉 Initial commit: Project foundation"
```

### Create Without .gitignore

#### Bash:
```bash
./create-git-repo.sh simple-project \
  --no-gitignore \
  --description "Simple project without gitignore"
```

#### PowerShell:
```powershell
.\Create-GitRepo.ps1 -RepoName "simple-project" `
  -NoGitignore `
  -Description "Simple project without gitignore"
```

## 🔧 Customization

### Modify Default .gitignore
Edit the `create_gitignore()` function in the script to customize the default .gitignore patterns.

### Add More License Types
Extend the `create_license()` function to support additional license types like Apache, GPL, etc.

### Change Default Commit Message
Modify the `INIT_COMMIT_MESSAGE` variable or use the `-m` option.

## 🐛 Troubleshooting

### Common Issues

#### "GitHub CLI is not authenticated"
```bash
# For both Bash and PowerShell
gh auth login
# Follow the prompts to authenticate
```

#### "Permission denied" when running Bash script
```bash
chmod +x create-git-repo.sh
```

#### "Execution policy" error in PowerShell
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### "Repository already exists on GitHub"
- Choose a different repository name
- Or delete the existing repository on GitHub first

#### "Directory already exists"
- Both scripts will ask if you want to use the existing directory
- Or choose a different name

### Debug Mode
Add `set -x` at the beginning of the script to enable debug mode and see detailed execution steps.

## 🤝 Contributing

Feel free to improve this script by:
- Adding new features
- Improving error handling
- Supporting additional file types
- Adding more license templates
- Enhancing documentation

## 📄 License

This script is provided as-is for educational and development purposes. Feel free to modify and distribute according to your needs.

## 🔗 Related Resources

- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Git Documentation](https://git-scm.com/doc)
- [Bash Scripting Guide](https://tldp.org/LDP/Bash-Beginners-Guide/html/)
- [GitHub Repository Best Practices](https://docs.github.com/en/repositories)

---

**Happy Coding! 🚀**
