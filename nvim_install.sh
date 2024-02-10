#!/bin/zsh

# Setup variables
HOME_DIR="$HOME"
NVIM_CONFIG_FILE="$HOME_DIR/m_nvim.zsh"
ZSHRC="$HOME_DIR/.zshrc"



# Function to print messages in green
print_green() {
    echo "\033[0;32m$1\033[0m"
}

# Create Neovim switcher config
print_green "Creating and updating Neovim switcher configuration..."
cat <<'EOF' > $NVIM_CONFIG_FILE
# Neovim Switcher configuration
alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
alias nvim-kick="NVIM_APPNAME=kickstart nvim"
alias nvim-chad="NVIM_APPNAME=NvChad nvim"
alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"

function nvims() {
  items=("default" "kickstart" "LazyVim" "NvChad" "AstroNvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

bindkey -s "^a" "nvims\n"

EOF

# Append sourcing line to .zshrc if not already present
if ! grep -q "source $NVIM_CONFIG_FILE" $ZSHRC; then
    print_green "source $NVIM_CONFIG_FILE" >> $ZSHRC
fi

print_green "Neovim switcher configuration updated."
source $ZSHRC

# Function to prompt for existing distribution removal
prompt_for_removal() {
    local distro_dir=$1
    local distro_name=$2
    if [[ -d $distro_dir ]]; then
        print_green "$distro_name distribution is already installed. Do you want to reinstall it from scratch? [y/N]:"
        read -r response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            rm -rf $distro_dir
            print_green "$distro_name indicate distribution reinstalled from scratch."
        else
            print_green "$distro_name existing distribution will be kept."
            return 1 # Return 1 to indicate no reinstallation needed
        fi
    fi
    return 0 # Return 0 to indicate installation can proceed
}

# Define distributions and their repositories
declare -A distros
distros=(
    ["kickstart"]="https://github.com/nvim-lua/kickstart.nvim.git"
    ["LazyVim"]="https://github.com/LazyVim/starter"
    ["NvChad"]="https://github.com/NvChad/NvChad"
    ["AstroNvim"]="https://github.com/AstroNvim/AstroNvim"
)

# Clean and reinstall Neovim function
clean_and_reinstall_nvim() {
    print_green "Checking and cleaning Neovim installation..."

    # Check if Neovim is installed via Homebrew and remove it
    if brew list neovim &>/dev/null; then
        print_green "Neovim is installed. Uninstalling..."
        brew uninstall neovim --ignore-dependencies || { print_green "Failed to uninstall Neovim."; return 1; }
    else
        print_green "Neovim is not installed via Homebrew. Skipping uninstallation."
    fi

    # Cleanup Homebrew and upgrade packages to ensure we're up to date
    print_green "Running Homebrew cleanup and upgrade..."
    brew cleanup
    brew update
    brew upgrade

    # Install Neovim with the latest HEAD version to get the most recent features and fixes
    print_green "Installing Neovim..."
    brew install --HEAD neovim || { print_green "Failed to install Neovim."; return 1; }
    print_green "Neovim installation completed successfully."
}

# Function to clone Neovim distribution
clone_distribution() {
    local url=$1
    local name=$2
    local dir="$HOME/.config/$name"
    if prompt_for_removal "$dir" "$name"; then
        print_green "Cloning $name..."
        git clone --depth 1 $url $dir && print_green "$name installed successfully." || print_green "Failed to clone $name."
    fi
}

# Main installation and configuration logic
print_green "Enter the distributions you want to manage (kickstart LazyVim NvChad AstroNvim). Press Enter for all:"
read -r user_input

# Split the user input into an array or use the default set if no input is given
if [[ -z "$user_input" ]]; then
    selected_distros=("${(@k)distros}") # Use the keys from the distros associative array
else
    IFS=' ' read -rA selected_distros <<< "$user_input"
fi


# Clean and reinstall Neovim only if required
clean_and_reinstall_nvim

# Install or update selected distributions
clone_distribution() {
    local name=$1
    local dir="$HOME/.config/$name"

    if prompt_for_removal "$dir" "$name"; then
        echo "Cloning $name..."
        case $name in
            "AstroNvim")
                git clone --depth 1 https://github.com/AstroNvim/AstroNvim "$dir" && print_green "$name installed successfully." || echo "Failed to clone $name."
                ;;
            "NvChad")
                git clone https://github.com/NvChad/NvChad "$dir" --depth 1 && print_green "$name installed successfully." || echo "Failed to clone $name."
                ;;
            "LazyVim")
                git clone https://github.com/LazyVim/starter "$dir" && print_green "$name installed successfully." || echo "Failed to clone $name."
                ;;
            "kickstart")
                git clone https://github.com/nvim-lua/kickstart.nvim.git "$dir" && print_green "$name installed successfully." || echo "Failed to clone $name."
                ;;
            *)
                echo "Invalid distribution: $name."
                ;;
        esac
    fi
}

# Install or update selected distributions
for distro in "${selected_distros[@]}"; do
    if [[ -n "${distros[$distro]}" ]]; then
        clone_distribution "$distro"
    else
        print_green "Invalid distribution: $distro. Skipping."
    fi
done


print_green "Neovim setup and configuration completed."

