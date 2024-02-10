# Neovim Configuration Switcher

This repository hosts scripts for easy switching between different Neovim configurations. It is designed to help users quickly switch their Neovim environment to suit various coding needs or preferences. This work is inspired by the concepts shared in [this gist by Elijah Manor](https://gist.github.com/elijahmanor/b279553c0132bfad7eae23e34ceb593b). We are thankful to Elijah for the inspiration and guidance provided through his work.

## Contents

- `nvim_install.sh`: Script to install Neovim and set up the configuration switcher.
- `nvim_uninstall.sh`: Script to uninstall Neovim and remove the configuration switcher setup.


## Getting Started

### Prerequisites

- `zsh` should be your default shell.
- `git` and `brew` must be installed on your system.
- Ensure you have `fzf` installed for fuzzy finding capabilities within the switcher script.

### Installation

1. Clone this repository to your local machine.

    ```bash
    git clone https://github.com/MohamedElashri/nvim-switcher
    cd nvim-switcher
    ```
2. Run the `nvim_install.sh` script to set up the Neovim configuration switcher:
    ```zsh
    ./nvim_install.sh
    ```
3. This script will install Neovim (if not already installed), set up various aliases for Neovim configurations, and enable a function to switch configurations easily.

### Usage

After installation, you can switch between different Neovim configurations by using the following aliases:
- `nvim-lazy` for LazyVim configuration.
- `nvim-kick` for Kickstart configuration.
- `nvim-chad` for NvChad configuration.
- `nvim-astro` for AstroNvim configuration.

Additionally, you can use the `nvims` command to invoke a fuzzy finder interface and select your desired Neovim configuration.

[![asciicast](https://asciinema.org/a/a4FR0FqdlSfwg6YzG1pSjICZO.svg)](https://asciinema.org/a/a4FR0FqdlSfwg6YzG1pSjICZO)

### Uninstallation

To uninstall Neovim and remove the configuration switcher, run the `nvim_uninstall.sh` script:
```zsh
./nvim_uninstall.sh
```

This will revert the changes made by the installation script, including removing any installed Neovim configurations and cleaning up environment modifications.



## Acknowledgments

- Elijah Manor for the original [concept](https://gist.github.com/elijahmanor/b279553c0132bfad7eae23e34ceb593b).
- The creators and contributors of the Neovim configurations we support: `LazyVim`, `Kickstart.nvim`, `NvChad`, and `AstroNvim.`

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributions

Contributions are very welcome! If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement". Don't forget to give the project a star! Thanks again!
