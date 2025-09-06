#!/bin/bash

# =============================================================================
# Git Repository Creation and GitHub Publishing Script
# =============================================================================
# Description: Creates a new Git repository locally and publishes it to GitHub
# Author: Automated Script Generator
# Version: 1.0
# Usage: ./create-git-repo.sh <repo-name> [options]
# =============================================================================

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default values
GITHUB_USERNAME=""
DESCRIPTION=""
PRIVATE=false
INIT_COMMIT_MESSAGE="Initial commit: Project setup"
CREATE_GITIGNORE=true
CREATE_LICENSE=false
LICENSE_TYPE="MIT"

# Function to display usage information
show_usage() {
    echo -e "${CYAN}Git Repository Creator${NC}"
    echo -e "${CYAN}=====================${NC}"
    echo ""
    echo "Usage: $0 <repo-name> [options]"
    echo ""
    echo "Required:"
    echo "  <repo-name>           Name of the repository to create"
    echo ""
    echo "Options:"
    echo "  -d, --description     Repository description"
    echo "  -u, --username        GitHub username (if not set in git config)"
    echo "  -p, --private         Create private repository (default: public)"
    echo "  -m, --message         Initial commit message"
    echo "  --no-gitignore        Don't create .gitignore file"
    echo "  --license             Create LICENSE file (MIT, Apache, GPL)"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 my-project"
    echo "  $0 my-project -d \"My awesome project\" -p"
    echo "  $0 my-project -u myusername --license MIT"
}

# Function to log messages with colors
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_step() {
    echo -e "${PURPLE}🔧 $1${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    log_step "Checking prerequisites..."
    
    # Check if git is installed
    if ! command_exists git; then
        log_error "Git is not installed. Please install Git first."
        exit 1
    fi
    
    # Check if GitHub CLI is installed
    if ! command_exists gh; then
        log_error "GitHub CLI (gh) is not installed."
        log_info "Please install it from: https://cli.github.com/"
        exit 1
    fi
    
    # Check if GitHub CLI is authenticated
    if ! gh auth status >/dev/null 2>&1; then
        log_error "GitHub CLI is not authenticated."
        log_info "Please run: gh auth login"
        exit 1
    fi
    
    log_success "All prerequisites met"
}

# Function to get GitHub username
get_github_username() {
    if [ -z "$GITHUB_USERNAME" ]; then
        # Try to get from git config
        GITHUB_USERNAME=$(git config --global user.name 2>/dev/null)
        
        # If still empty, try to get from GitHub CLI
        if [ -z "$GITHUB_USERNAME" ]; then
            GITHUB_USERNAME=$(gh api user --jq '.login' 2>/dev/null)
        fi
        
        # If still empty, prompt user
        if [ -z "$GITHUB_USERNAME" ]; then
            read -p "Enter your GitHub username: " GITHUB_USERNAME
        fi
    fi
    
    if [ -z "$GITHUB_USERNAME" ]; then
        log_error "GitHub username is required"
        exit 1
    fi
    
    log_info "Using GitHub username: $GITHUB_USERNAME"
}

# Function to create .gitignore file
create_gitignore() {
    if [ "$CREATE_GITIGNORE" = true ]; then
        log_step "Creating .gitignore file..."
        
        cat > .gitignore << 'EOF'
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
EOF
        
        log_success ".gitignore created"
    fi
}

# Function to create LICENSE file
create_license() {
    if [ "$CREATE_LICENSE" = true ]; then
        log_step "Creating LICENSE file..."
        
        case "$LICENSE_TYPE" in
            "MIT")
                cat > LICENSE << EOF
MIT License

Copyright (c) $(date +%Y) $GITHUB_USERNAME

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
EOF
                ;;
            *)
                log_warning "License type '$LICENSE_TYPE' not implemented. Skipping LICENSE creation."
                CREATE_LICENSE=false
                ;;
        esac
        
        if [ "$CREATE_LICENSE" = true ]; then
            log_success "LICENSE file created ($LICENSE_TYPE)"
        fi
    fi
}

# Function to create README.md
create_readme() {
    log_step "Creating README.md..."
    
    cat > README.md << EOF
# $REPO_NAME

$DESCRIPTION

## Description

This repository was created using an automated bash script.

## Getting Started

### Prerequisites

- Git installed on your machine
- Access to this repository

### Installation

\`\`\`bash
git clone https://github.com/$GITHUB_USERNAME/$REPO_NAME.git
cd $REPO_NAME
\`\`\`

## Usage

Add usage instructions here.

## Contributing

1. Fork the repository
2. Create your feature branch (\`git checkout -b feature/amazing-feature\`)
3. Commit your changes (\`git commit -m 'Add some amazing feature'\`)
4. Push to the branch (\`git push origin feature/amazing-feature\`)
5. Open a Pull Request

## License

$(if [ "$CREATE_LICENSE" = true ]; then echo "This project is licensed under the $LICENSE_TYPE License - see the [LICENSE](LICENSE) file for details."; else echo "This project is open source."; fi)

## Contact

$GITHUB_USERNAME - [@$GITHUB_USERNAME](https://github.com/$GITHUB_USERNAME)

Project Link: [https://github.com/$GITHUB_USERNAME/$REPO_NAME](https://github.com/$GITHUB_USERNAME/$REPO_NAME)
EOF
    
    log_success "README.md created"
}

# Function to create local repository
create_local_repo() {
    log_step "Creating local repository: $REPO_NAME"
    
    # Check if directory already exists
    if [ -d "$REPO_NAME" ]; then
        log_error "Directory '$REPO_NAME' already exists"
        read -p "Do you want to continue and use the existing directory? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        mkdir "$REPO_NAME"
    fi
    
    cd "$REPO_NAME" || exit 1
    
    # Initialize git repository
    log_step "Initializing git repository..."
    git init
    
    # Create files
    create_readme
    create_gitignore
    create_license
    
    # Add and commit files
    log_step "Creating initial commit..."
    git add .
    git commit -m "$INIT_COMMIT_MESSAGE"
    
    log_success "Local repository created successfully"
}

# Function to create GitHub repository and push
create_github_repo() {
    log_step "Creating GitHub repository..."
    
    # Determine visibility
    local visibility_flag=""
    if [ "$PRIVATE" = true ]; then
        visibility_flag="--private"
        log_info "Creating private repository"
    else
        visibility_flag="--public"
        log_info "Creating public repository"
    fi
    
    # Create repository on GitHub
    if gh repo create "$REPO_NAME" $visibility_flag --description "$DESCRIPTION" --source=.; then
        log_success "GitHub repository created"
    else
        log_error "Failed to create GitHub repository"
        exit 1
    fi
    
    # Set main branch and push
    log_step "Pushing to GitHub..."
    git branch -M main
    
    if git push -u origin main; then
        log_success "Code pushed to GitHub successfully"
    else
        log_error "Failed to push to GitHub"
        exit 1
    fi
    
    # Display success information
    echo ""
    log_success "Repository created and published successfully!"
    echo -e "${CYAN}🔗 Repository URL: https://github.com/$GITHUB_USERNAME/$REPO_NAME${NC}"
    echo -e "${CYAN}📁 Local directory: $(pwd)${NC}"
}

# Main function
main() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    Git Repository Creator                    ║"
    echo "║                     Bash Script v1.0                        ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Check prerequisites
    check_prerequisites
    
    # Get GitHub username
    get_github_username
    
    # Set default description if empty
    if [ -z "$DESCRIPTION" ]; then
        DESCRIPTION="Repository $REPO_NAME created via automated bash script"
    fi
    
    # Display configuration
    echo ""
    log_info "Configuration:"
    echo "  Repository Name: $REPO_NAME"
    echo "  Description: $DESCRIPTION"
    echo "  GitHub Username: $GITHUB_USERNAME"
    echo "  Visibility: $(if [ "$PRIVATE" = true ]; then echo "Private"; else echo "Public"; fi)"
    echo "  Create .gitignore: $CREATE_GITIGNORE"
    echo "  Create LICENSE: $CREATE_LICENSE"
    echo ""
    
    # Confirm before proceeding
    read -p "Do you want to proceed? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        log_info "Operation cancelled"
        exit 0
    fi
    
    # Create repository
    create_local_repo
    create_github_repo
    
    echo ""
    log_success "🎉 All done! Your repository is ready to use."
}

# Parse command line arguments
REPO_NAME=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--description)
            DESCRIPTION="$2"
            shift 2
            ;;
        -u|--username)
            GITHUB_USERNAME="$2"
            shift 2
            ;;
        -p|--private)
            PRIVATE=true
            shift
            ;;
        -m|--message)
            INIT_COMMIT_MESSAGE="$2"
            shift 2
            ;;
        --no-gitignore)
            CREATE_GITIGNORE=false
            shift
            ;;
        --license)
            CREATE_LICENSE=true
            if [[ $2 && $2 != -* ]]; then
                LICENSE_TYPE="$2"
                shift 2
            else
                shift
            fi
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        -*)
            log_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
        *)
            if [ -z "$REPO_NAME" ]; then
                REPO_NAME="$1"
            else
                log_error "Multiple repository names provided: '$REPO_NAME' and '$1'"
                exit 1
            fi
            shift
            ;;
    esac
done

# Check if repository name is provided
if [ -z "$REPO_NAME" ]; then
    log_error "Repository name is required"
    echo ""
    show_usage
    exit 1
fi

# Validate repository name
if [[ ! "$REPO_NAME" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    log_error "Invalid repository name. Use only letters, numbers, dots, hyphens, and underscores."
    exit 1
fi

# Run main function
main
