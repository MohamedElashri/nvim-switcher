#!/bin/zsh

# Function to print messages in red for visibility
print_red() {
    echo "\033[0;31m$1\033[0m"
}

# Define the directories of the Neovim distributions
declare -a nvim_dirs=("$HOME/.config/kickstart" "$HOME/.config/LazyVim" "$HOME/.config/NvChad" "$HOME/.config/AstroNvim")

# Remove Neovim distributions
for dir in "${nvim_dirs[@]}"; do
    if [[ -d $dir ]]; then
        print_red "Removing $dir..."
        rm -rf "$dir"
    else
        print_red "$dir not found. Skipping..."
    fi
done

# Restore the original .zshrc if a backup exists
ZSHRC="$HOME/.zshrc"
ZSHRC_BACKUP="$HOME/.zshrc.backup"

if [[ -f $ZSHRC_BACKUP ]]; then
    print_red "Restoring original .zshrc from backup..."
    mv $ZSHRC_BACKUP $ZSHRC
else
    # If no backup exists, simply remove the source line
    print_red "Removing Neovim switcher configuration from .zshrc..."
    sed -i '' '/source $HOME\/m_nvim.zsh/d' $ZSHRC
fi

# Optionally, uninstall Neovim if installed via Homebrew
if brew list neovim &>/dev/null; then
    print_red "Uninstalling Neovim..."
    brew uninstall neovim --ignore-dependencies
fi

print_red "Neovim removal and cleanup completed."
print_red "Restart the shell to apply changes."

# restart the shell
source ~/.zshrc

