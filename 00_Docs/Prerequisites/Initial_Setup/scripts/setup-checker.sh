#!/bin/bash
# setup-checker.sh
# Checks for all required non-Python dependencies needed to setup and run the AIEO1 project

set -uo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track check results
CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNINGS=0

# Function to print success message
print_success() {
    echo -e "${GREEN}✅${NC} $1"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
}

# Function to print error message
print_error() {
    echo -e "${RED}❌${NC} $1"
    CHECKS_FAILED=$((CHECKS_FAILED + 1))
}

# Function to print warning message
print_warning() {
    echo -e "${YELLOW}⚠️ ${NC} $1"
    CHECKS_WARNINGS=$((CHECKS_WARNINGS + 1))
}

# Function to print info message
print_info() {
    echo -e "${BLUE}ℹ️ ${NC} $1"
}

# Function to print section header
print_section() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Function to check if command exists
check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Function to get version of a command
get_version() {
    if check_command "$1"; then
        "$1" --version 2>/dev/null | head -n1 || echo "installed"
    else
        echo "not installed"
    fi
}

# Function to check Python version
check_python_version() {
    local python_cmd="$1"
    if check_command "$python_cmd"; then
        local version
        version=$($python_cmd --version 2>&1 | awk '{print $2}')
        # Extract major and minor version (handle versions like 3.12.11)
        local major minor
        major=$(echo "$version" | cut -d. -f1)
        minor=$(echo "$version" | cut -d. -f2)
        
        # Use numeric comparison with proper error handling
        if [ "$major" -eq 3 ] 2>/dev/null && [ "$minor" -ge 8 ] 2>/dev/null; then
            if [ "$major" -eq 3 ] 2>/dev/null && [ "$minor" -eq 12 ] 2>/dev/null; then
                print_success "Python 3.12 is installed ($version)"
                return 0
            else
                print_warning "Python $version is installed (3.12 recommended, but >=3.8 acceptable)"
                return 0
            fi
        else
            print_error "Python $version is installed (requires Python >=3.8)"
            return 1
        fi
    else
        print_error "$python_cmd is not installed"
        return 1
    fi
}

# Function to check if file exists
check_file() {
    if [ -f "$1" ]; then
        return 0
    else
        return 1
    fi
}

# Function to check if directory exists
check_directory() {
    if [ -d "$1" ]; then
        return 0
    else
        return 1
    fi
}

# Header
clear
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                               ║"
echo "║                  🚀 AIEO2 Project Setup Checker 🚀                            ║"
echo "║                                                                               ║"
echo "║              Checking your development environment setup...                    ║"
echo "║                                                                               ║"
echo "╚═══════════════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Check 1: Shell
print_section "🔧 Shell Environment"
print_info "Checking shell environment..."
if [ -n "${ZSH_VERSION:-}" ]; then
    print_success "Using zsh shell (version: $ZSH_VERSION)"
elif [ -n "${BASH_VERSION:-}" ]; then
    print_success "Using bash shell (version: $BASH_VERSION)"
else
    print_warning "Unknown shell - script may not work correctly"
fi
echo ""

# Check 2: Operating System
print_section "💻 Operating System"
print_info "Checking operating system..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_success "macOS detected"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    print_success "Linux detected"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    print_warning "Windows detected (using Git Bash/Cygwin)"
    print_info "  Consider using WSL2 for better compatibility: https://ubuntu.com/desktop/wsl"
    
    # Check for WSL2
    print_info "Checking WSL2 (🐧 Windows Subsystem for Linux)..."
    if command -v wsl >/dev/null 2>&1; then
        wsl_version=$(wsl --version 2>/dev/null || echo "WSL installed")
        print_success "WSL is available ($wsl_version)"
    else
        print_warning "WSL is not installed (recommended for Windows development)"
        print_info "  Install with: wsl --install"
        print_info "  Or use PowerShell: wsl --install"
    fi
    echo ""
    
    # Check for Windows Terminal
    print_info "Checking Windows Terminal (🪟 terminal application)..."
    if [ -d "/mnt/c/Users/$USER/AppData/Local/Microsoft/WindowsApps/wt.exe" ] || command -v wt >/dev/null 2>&1; then
        print_success "Windows Terminal appears to be installed"
    else
        print_warning "Windows Terminal is not detected (optional but recommended)"
        print_info "  Install from: https://aka.ms/terminal"
    fi
    echo ""
else
    print_warning "Unknown OS: $OSTYPE"
fi
echo ""

# Check 2.5: Homebrew (macOS package manager)
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_info "Checking Homebrew (🍺 macOS package manager)..."
    if check_command "brew"; then
        brew_version=$(get_version "brew")
        print_success "Homebrew is installed ($brew_version)"
    else
        print_warning "Homebrew is not installed (recommended for macOS development)"
        print_info "  Install from: https://brew.sh/"
        print_info "  Install command: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    fi
    echo ""
fi

# Check 2.6: Xcode Command Line Tools (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_info "Checking Xcode Command Line Tools..."
    if xcode-select -p >/dev/null 2>&1; then
        print_success "Xcode Command Line Tools are installed"
    else
        print_warning "Xcode Command Line Tools are not installed (required for macOS development)"
        print_info "  Install with: xcode-select --install"
    fi
    echo ""
fi

# Check 3: Git
print_section "📦 Version Control & Tools"
print_info "Checking Git..."
if check_command "git"; then
    git_version=$(get_version "git")
    print_success "Git is installed ($git_version)"
    
    # Check Git configuration
    if git config --global user.name >/dev/null 2>&1 && git config --global user.email >/dev/null 2>&1; then
        print_success "Git is configured (user.name and user.email set)"
    else
        print_warning "Git user.name or user.email not configured"
        print_info "  Run: git config --global user.name 'Your Name'"
        print_info "  Run: git config --global user.email 'your.email@example.com'"
    fi
else
    print_error "Git is not installed"
    print_info "  Install from: https://git-scm.com/downloads"
fi
echo ""

# Check 4: Python
print_section "🐍 Python Environment"
print_info "Checking Python installation..."
PYTHON_FOUND=false

# Check python3.12 first (recommended)
if check_command "python3.12"; then
    if check_python_version "python3.12"; then
        PYTHON_FOUND=true
    fi
fi

# Check python3 if python3.12 not found
if [ "$PYTHON_FOUND" = false ]; then
    if check_command "python3"; then
        if check_python_version "python3"; then
            PYTHON_FOUND=true
        fi
    fi
fi

# Check python if python3 not found
if [ "$PYTHON_FOUND" = false ]; then
    if check_command "python"; then
        if check_python_version "python"; then
            PYTHON_FOUND=true
        fi
    fi
fi

if [ "$PYTHON_FOUND" = false ]; then
    print_error "Python 3.8+ is not installed"
    print_info "  Install from: https://www.python.org/downloads/"
    print_info "  Or use pyenv: https://github.com/pyenv/pyenv"
fi
echo ""

# Check 5: pip
print_info "Checking pip..."
if check_command "pip3"; then
    pip_version=$(get_version "pip3")
    print_success "pip3 is installed ($pip_version)"
elif check_command "pip"; then
    pip_version=$(get_version "pip")
    print_success "pip is installed ($pip_version)"
else
    print_error "pip is not installed"
    print_info "  Install pip: python3 -m ensurepip --upgrade"
fi
echo ""

# Check 5.5: wget (utility tool)
print_info "Checking wget utility..."
if check_command "wget"; then
    wget_version=$(get_version "wget")
    print_success "wget is installed ($wget_version)"
else
    print_warning "wget is not installed (optional utility tool)"
    if [[ "$OSTYPE" == "darwin"* ]] && check_command "brew"; then
        print_info "  Install with: brew install wget"
    else
        print_info "  Install from: https://www.gnu.org/software/wget/"
    fi
fi
echo ""

# Check 6: uv (package manager)
print_info "Checking uv (⚡ fast Python package manager)..."
if check_command "uv"; then
    uv_version=$(get_version "uv")
    print_success "uv is installed ($uv_version)"
else
    print_warning "uv is not installed (recommended for package management)"
    print_info "  Install from: https://docs.astral.sh/uv/"
    print_info "  Quick install: curl -LsSf https://astral.sh/uv/install.sh | sh"
fi
echo ""

# Check 7: Cursor IDE (optional)
print_section "📝 Development Environments"
print_info "Checking Cursor IDE..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -d "/Applications/Cursor.app" ]; then
        print_success "Cursor IDE is installed"
    else
        print_warning "Cursor IDE is not installed (optional but recommended)"
        print_info "  Install from: https://cursor.com/download"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if check_command "cursor" || [ -f "/usr/bin/cursor" ] || [ -f "/usr/local/bin/cursor" ]; then
        print_success "Cursor IDE is installed"
    else
        print_warning "Cursor IDE is not installed (optional but recommended)"
        print_info "  Install from: https://cursor.com/download"
    fi
else
    print_info "Cursor IDE check skipped (OS not supported for automatic detection)"
fi
echo ""

# Check 7.5: VS Code (optional)
print_info "Checking VS Code..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    if [ -d "/Applications/Visual Studio Code.app" ] || [ -d "/Applications/Code.app" ]; then
        print_success "VS Code is installed"
    else
        print_warning "VS Code is not installed (optional, alternative to Cursor)"
        print_info "  Install from: https://code.visualstudio.com/"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if check_command "code" || [ -f "/usr/bin/code" ] || [ -f "/usr/local/bin/code" ]; then
        print_success "VS Code is installed"
    else
        print_warning "VS Code is not installed (optional, alternative to Cursor)"
        print_info "  Install from: https://code.visualstudio.com/"
    fi
else
    print_info "VS Code check skipped (OS not supported for automatic detection)"
fi
echo ""

# Check 8: Cursor CLI (optional)
print_info "Checking Cursor CLI..."
# Note: 'cursor' command might be the IDE itself, so we check cursor-cli separately
if check_command "cursor-cli"; then
    print_success "Cursor CLI is available"
elif check_command "cursor" && [ -d "/Applications/Cursor.app" ]; then
    # On macOS, cursor command might exist but not be CLI
    print_warning "Cursor IDE found but CLI may not be configured"
    print_info "  Install CLI: https://cursor.com/docs/cli/overview"
else
    print_warning "Cursor CLI is not installed (optional but recommended)"
    print_info "  Install from: https://cursor.com/docs/cli/overview"
fi
echo ""

# Check 9: SSH keys for GitHub
print_section "🔐 Authentication & API Keys"
print_info "Checking SSH keys for GitHub..."
if [ -d "$HOME/.ssh" ]; then
    ssh_keys=$(find "$HOME/.ssh" -name "id_*.pub" 2>/dev/null | wc -l | tr -d ' ' || echo "0")
    if [ "${ssh_keys:-0}" -gt 0 ]; then
        print_success "SSH keys found ($ssh_keys public key(s))"
        
        # Check if SSH key is added to ssh-agent
        if ssh-add -l >/dev/null 2>&1; then
            print_success "SSH keys are loaded in ssh-agent"
        else
            print_warning "SSH keys exist but may not be loaded in ssh-agent"
            print_info "  Add key: ssh-add ~/.ssh/id_rsa (or your key file)"
        fi
        
        # Test GitHub SSH connection (with timeout to avoid hanging)
        # Use gtimeout on macOS if available, otherwise use timeout, or skip timeout
        if command -v gtimeout >/dev/null 2>&1; then
            SSH_TEST_CMD="gtimeout 3 ssh -T git@github.com 2>&1"
        elif command -v timeout >/dev/null 2>&1; then
            SSH_TEST_CMD="timeout 3 ssh -T git@github.com 2>&1"
        else
            SSH_TEST_CMD="ssh -o ConnectTimeout=3 -T git@github.com 2>&1"
        fi
        
        if eval "$SSH_TEST_CMD" | grep -q "successfully authenticated"; then
            print_success "GitHub SSH connection is working"
        else
            print_warning "GitHub SSH connection test failed or timed out (may need to add key to GitHub)"
            print_info "  Add SSH key to GitHub: https://github.com/settings/keys"
        fi
    else
        print_warning "No SSH keys found in ~/.ssh"
        print_info "  Generate SSH key: ssh-keygen -o -t rsa -C 'your_email@example.com'"
        print_info "  Or use: ssh-keygen -t ed25519 -C 'your_email@example.com'"
        print_info "  Add to GitHub: https://github.com/settings/keys"
    fi
else
    print_warning "~/.ssh directory not found"
    print_info "  Generate SSH key: ssh-keygen -o -t rsa -C 'your_email@example.com'"
    print_info "  Or use: ssh-keygen -t ed25519 -C 'your_email@example.com'"
fi
echo ""

# Check 10: OpenAI API Key
print_info "Checking OpenAI API Key (🤖 GPT models)..."
if [ -n "${OPENAI_API_KEY:-}" ]; then
    key_length=${#OPENAI_API_KEY}
    if [ "$key_length" -gt 20 ]; then
        print_success "OPENAI_API_KEY environment variable is set (length: $key_length chars)"
    else
        print_warning "OPENAI_API_KEY is set but seems too short (may be invalid)"
    fi
else
    print_warning "OPENAI_API_KEY environment variable is not set"
    print_info "  Get API key from: https://platform.openai.com/api-keys"
    print_info "  Set it: export OPENAI_API_KEY='your-key-here'"
    print_info "  Or add to .env file: echo 'OPENAI_API_KEY=your-key-here' > .env"
fi
echo ""

# Check 10.5: Claude API Key (optional)
print_info "Checking Claude API Key (🧠 Anthropic models)..."
if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
    key_length=${#ANTHROPIC_API_KEY}
    if [ "$key_length" -gt 20 ]; then
        print_success "ANTHROPIC_API_KEY environment variable is set (length: $key_length chars)"
    else
        print_warning "ANTHROPIC_API_KEY is set but seems too short (may be invalid)"
    fi
else
    print_warning "ANTHROPIC_API_KEY environment variable is not set (optional)"
    print_info "  Get API key from: https://console.anthropic.com/dashboard"
    print_info "  Set it: export ANTHROPIC_API_KEY='your-key-here'"
    print_info "  Or add to .env file: echo 'ANTHROPIC_API_KEY=your-key-here' >> .env"
fi
echo ""

# Check 10.7: GitHub Access Token (optional)
print_info "Checking GitHub Access Token (🔑 alternative to SSH)..."
if [ -n "${GITHUB_TOKEN:-}" ]; then
    token_length=${#GITHUB_TOKEN}
    if [ "$token_length" -gt 20 ]; then
        print_success "GITHUB_TOKEN environment variable is set (length: $token_length chars)"
    else
        print_warning "GITHUB_TOKEN is set but seems too short (may be invalid)"
    fi
else
    print_warning "GITHUB_TOKEN environment variable is not set (optional, alternative to SSH)"
    print_info "  Get token from: https://github.com/settings/tokens"
    print_info "  Set it: export GITHUB_TOKEN='your-token-here'"
    print_info "  Or add to .env file: echo 'GITHUB_TOKEN=your-token-here' >> .env"
fi
echo ""

# Check 11: .env file
print_info "Checking .env file..."
if check_file ".env"; then
    print_success ".env file exists"
    
    # Check for various API keys in .env file
    env_keys_found=0
    if grep -q "OPENAI_API_KEY" .env 2>/dev/null; then
        print_success ".env file contains OPENAI_API_KEY"
        env_keys_found=$((env_keys_found + 1))
    fi
    if grep -q "ANTHROPIC_API_KEY" .env 2>/dev/null; then
        print_success ".env file contains ANTHROPIC_API_KEY"
        env_keys_found=$((env_keys_found + 1))
    fi
    if grep -q "GITHUB_TOKEN" .env 2>/dev/null; then
        print_success ".env file contains GITHUB_TOKEN"
        env_keys_found=$((env_keys_found + 1))
    fi
    
    if [ "$env_keys_found" -eq 0 ]; then
        print_warning ".env file exists but doesn't contain common API keys"
        print_info "  Add keys to .env file as needed"
    fi
else
    print_warning ".env file not found (optional if using environment variables)"
    print_info "  Create .env file: touch .env"
    print_info "  Add API keys as needed: echo 'OPENAI_API_KEY=your-key-here' >> .env"
fi
echo ""

# Check 12: Virtual environment capability
print_info "Checking Python virtual environment capability..."
if check_command "python3.12"; then
    if python3.12 -m venv --help >/dev/null 2>&1; then
        print_success "python3.12 can create virtual environments"
    else
        print_error "python3.12 venv module not available"
    fi
elif check_command "python3"; then
    if python3 -m venv --help >/dev/null 2>&1; then
        print_success "python3 can create virtual environments"
    else
        print_error "python3 venv module not available"
    fi
else
    print_warning "Cannot check venv capability (Python not found)"
fi
echo ""

# Check 13: Jupyter (check if installed, optional)
print_info "Checking Jupyter (📓 notebook environment)..."
if check_command "jupyter"; then
    jupyter_version=$(get_version "jupyter")
    print_success "Jupyter is installed ($jupyter_version)"
else
    print_warning "Jupyter is not installed (will be installed via pip/uv)"
    print_info "  Install with: pip install jupyter ipykernel"
    print_info "  Or use: uv pip install jupyter ipykernel"
fi
echo ""

# Check 13.5: Docker Desktop (optional)
print_info "Checking Docker Desktop (🐳 containerization)..."
if check_command "docker"; then
    docker_version=$(get_version "docker")
    print_success "Docker is installed ($docker_version)"
    
    # Check if Docker daemon is running
    if docker info >/dev/null 2>&1; then
        print_success "Docker daemon is running"
    else
        print_warning "Docker is installed but daemon is not running"
        print_info "  Start Docker Desktop application"
    fi
else
    print_warning "Docker is not installed (optional, used for containerization)"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_info "  Install from: https://desktop.docker.com/mac/main/arm64/Docker.dmg"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_info "  Install from: https://docs.docker.com/desktop/install/ubuntu/"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        print_info "  Install from: https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
    else
        print_info "  Install from: https://www.docker.com/products/docker-desktop/"
    fi
fi
echo ""

# Check 14: Git repository status
print_section "📂 Repository Status"
print_info "Checking Git repository status..."
if [ -d ".git" ]; then
    print_success "This is a Git repository"
    
    # Check if there are remotes configured
    if git remote -v >/dev/null 2>&1; then
        remote_count=$(git remote | wc -l | tr -d ' ' || echo "0")
        if [ "${remote_count:-0}" -gt 0 ]; then
            print_success "Git remotes configured ($remote_count remote(s))"
            git remote -v | while IFS= read -r line; do
                print_info "  $line"
            done || true
        else
            print_warning "No Git remotes configured"
        fi
    fi
else
    print_warning "Not a Git repository (or not in repo root)"
    print_info "  Initialize: git init"
    print_info "  Or clone: git clone <repository-url>"
fi
echo ""

# Summary
echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                                               ║${NC}"
echo -e "${BLUE}║                            📊 CHECK SUMMARY 📊                               ║${NC}"
echo -e "${BLUE}║                                                                               ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Create visual summary
TOTAL_CHECKS=$((CHECKS_PASSED + CHECKS_WARNINGS + CHECKS_FAILED))

echo -e "${GREEN}✅ Passed:${NC}    $CHECKS_PASSED checks"
echo -e "${YELLOW}⚠️  Warnings:${NC}  $CHECKS_WARNINGS checks"
echo -e "${RED}❌ Failed:${NC}    $CHECKS_FAILED checks"
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Calculate percentage
if [ $TOTAL_CHECKS -gt 0 ]; then
    PASS_PERCENT=$((CHECKS_PASSED * 100 / TOTAL_CHECKS))
    echo -e "${BLUE}📈 Overall Status:${NC} $PASS_PERCENT% of checks passed"
    echo ""
fi

# Action Items Section
if [ $CHECKS_FAILED -gt 0 ] || [ $CHECKS_WARNINGS -gt 0 ]; then
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                                               ║${NC}"
    echo -e "${BLUE}║                        📝 ACTION ITEMS (Priority Order) 📝                    ║${NC}"
    echo -e "${BLUE}║                                                                               ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    action_priority=1

    # CRITICAL ITEMS (Failed checks)
    if [ $CHECKS_FAILED -gt 0 ]; then
        echo -e "${RED}🔴 CRITICAL (Must Fix):${NC}"
        echo ""

        # Check Python
        if ! check_command "python3" && ! check_command "python3.12" && ! check_command "python"; then
            echo -e "${RED}${action_priority}.${NC} ${RED}Install Python 3.8+ (3.12 recommended)${NC}"
            echo -e "   💡 Hint: Use pyenv or download from python.org"
            echo -e "   📚 Guide: https://www.python.org/downloads/"
            echo ""
            action_priority=$((action_priority + 1))
        fi

        # Check Git
        if ! check_command "git"; then
            echo -e "${RED}${action_priority}.${NC} ${RED}Install Git${NC}"
            echo -e "   💡 Hint: Essential for version control"
            echo -e "   📚 Download: https://git-scm.com/downloads"
            echo ""
            action_priority=$((action_priority + 1))
        fi

        # Check pip
        if ! check_command "pip3" && ! check_command "pip"; then
            echo -e "${RED}${action_priority}.${NC} ${RED}Install pip${NC}"
            echo -e "   💡 Hint: Run 'python3 -m ensurepip --upgrade'"
            echo ""
            action_priority=$((action_priority + 1))
        fi

        # Check Git config
        if check_command "git" && ! git config --global user.name >/dev/null 2>&1; then
            echo -e "${RED}${action_priority}.${NC} ${RED}Configure Git user${NC}"
            echo -e "   💡 Hint: git config --global user.name 'Your Name'"
            echo -e "   💡 Hint: git config --global user.email 'you@example.com'"
            echo ""
            action_priority=$((action_priority + 1))
        fi

        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
    fi

    # HIGH PRIORITY (Important warnings)
    if [ $CHECKS_WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}🟡 HIGH PRIORITY (Recommended):${NC}"
        echo ""

        # Check uv
        if ! check_command "uv"; then
            echo -e "${YELLOW}${action_priority}.${NC} ${YELLOW}Install uv (fast package manager)${NC}"
            echo -e "   💡 Hint: curl -LsSf https://astral.sh/uv/install.sh | sh"
            echo -e "   📚 Docs: https://docs.astral.sh/uv/"
            echo ""
            action_priority=$((action_priority + 1))
        fi

        # Check API keys
        if [ -z "${OPENAI_API_KEY:-}" ]; then
            echo -e "${YELLOW}${action_priority}.${NC} ${YELLOW}Set OPENAI_API_KEY${NC}"
            echo -e "   💡 Hint: Get key from https://platform.openai.com/api-keys"
            echo -e "   💡 Hint: Add to .env file or export in shell"
            echo ""
            action_priority=$((action_priority + 1))
        fi

        # Check SSH keys
        if [ ! -d "$HOME/.ssh" ] || [ $(find "$HOME/.ssh" -name "id_*.pub" 2>/dev/null | wc -l | tr -d ' ') -eq 0 ]; then
            echo -e "${YELLOW}${action_priority}.${NC} ${YELLOW}Generate SSH key for GitHub${NC}"
            echo -e "   💡 Hint: ssh-keygen -t ed25519 -C 'your_email@example.com'"
            echo -e "   💡 Hint: Add public key to https://github.com/settings/keys"
            echo ""
            action_priority=$((action_priority + 1))
        fi

        # Check Homebrew (macOS only)
        if [[ "$OSTYPE" == "darwin"* ]] && ! check_command "brew"; then
            echo -e "${YELLOW}${action_priority}.${NC} ${YELLOW}Install Homebrew (macOS package manager)${NC}"
            echo -e "   💡 Hint: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            echo -e "   📚 Website: https://brew.sh/"
            echo ""
            action_priority=$((action_priority + 1))
        fi

        # Check Xcode Command Line Tools (macOS only)
        if [[ "$OSTYPE" == "darwin"* ]] && ! xcode-select -p >/dev/null 2>&1; then
            echo -e "${YELLOW}${action_priority}.${NC} ${YELLOW}Install Xcode Command Line Tools${NC}"
            echo -e "   💡 Hint: xcode-select --install"
            echo ""
            action_priority=$((action_priority + 1))
        fi

        echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
    fi

    # OPTIONAL ITEMS (Nice to have)
    echo -e "${BLUE}🔵 OPTIONAL (Nice to Have):${NC}"
    echo ""

    # Check Cursor IDE
    if [[ "$OSTYPE" == "darwin"* ]] && [ ! -d "/Applications/Cursor.app" ]; then
        echo -e "${BLUE}${action_priority}.${NC} ${BLUE}Install Cursor IDE (AI-powered editor)${NC}"
        echo -e "   💡 Hint: Download from https://cursor.com/download"
        echo ""
        action_priority=$((action_priority + 1))
    elif [[ "$OSTYPE" == "linux-gnu"* ]] && ! check_command "cursor"; then
        echo -e "${BLUE}${action_priority}.${NC} ${BLUE}Install Cursor IDE${NC}"
        echo -e "   💡 Hint: https://cursor.com/download"
        echo ""
        action_priority=$((action_priority + 1))
    fi

    # Check Docker
    if ! check_command "docker"; then
        echo -e "${BLUE}${action_priority}.${NC} ${BLUE}Install Docker Desktop (containerization)${NC}"
        echo -e "   💡 Hint: https://www.docker.com/products/docker-desktop/"
        echo ""
        action_priority=$((action_priority + 1))
    fi

    # Check Jupyter
    if ! check_command "jupyter"; then
        echo -e "${BLUE}${action_priority}.${NC} ${BLUE}Install Jupyter (notebook environment)${NC}"
        echo -e "   💡 Hint: pip install jupyter ipykernel or uv pip install jupyter"
        echo ""
        action_priority=$((action_priority + 1))
    fi

    # Check Claude API
    if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
        echo -e "${BLUE}${action_priority}.${NC} ${BLUE}Set ANTHROPIC_API_KEY (Claude models)${NC}"
        echo -e "   💡 Hint: Get key from https://console.anthropic.com/dashboard"
        echo ""
        action_priority=$((action_priority + 1))
    fi

    # Check wget
    if ! check_command "wget"; then
        echo -e "${BLUE}${action_priority}.${NC} ${BLUE}Install wget utility${NC}"
        echo -e "   💡 Hint: brew install wget (macOS) or apt install wget (Linux)"
        echo ""
        action_priority=$((action_priority + 1))
    fi

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
fi

# Final message with emojis
if [ $CHECKS_FAILED -eq 0 ] && [ $CHECKS_WARNINGS -eq 0 ]; then
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                                               ║${NC}"
    echo -e "${GREEN}║          🎉 Perfect! All checks passed! You're ready to go! 🎉                ║${NC}"
    echo -e "${GREEN}║                                                                               ║${NC}"
    echo -e "${GREEN}║                    🚀 Happy coding! 🚀                                        ║${NC}"
    echo -e "${GREEN}║                                                                               ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    exit 0
elif [ $CHECKS_FAILED -eq 0 ]; then
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                                                                               ║${NC}"
    echo -e "${YELLOW}║           ⚠️  Some optional items are missing, but you can proceed! ⚠️          ║${NC}"
    echo -e "${YELLOW}║                                                                               ║${NC}"
    echo -e "${YELLOW}║     💡 Review the ACTION ITEMS above to improve your setup 💡                 ║${NC}"
    echo -e "${YELLOW}║                                                                               ║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    exit 0
else
    echo -e "${RED}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║                                                                               ║${NC}"
    echo -e "${RED}║        ❌ Some critical dependencies are missing! ❌                           ║${NC}"
    echo -e "${RED}║                                                                               ║${NC}"
    echo -e "${RED}║     📋 Please complete CRITICAL items in ACTION ITEMS above 📋                 ║${NC}"
    echo -e "${RED}║                                                                               ║${NC}"
    echo -e "${RED}║      💡 Follow the hints provided for each item 💡                            ║${NC}"
    echo -e "${RED}║                                                                               ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    exit 1
fi

