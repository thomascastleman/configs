#!/usr/bin/env bash

# Bring in stdout.sh so we can print things nicely
source ~/configs/bin/stdout.sh

function install_homebrew() {
  which brew >/dev/null
  if [[ $? != 0 ]] ; then
    dotsay "@green installing homebrew"

    /bin/bash -c "$(curl -fsSL \
      https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    
    # Setup environment variables for Homebrew
    # (from https://docs.brew.sh/Homebrew-on-Linux#install)
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" \
      >>~/.bash_profile
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>~/.profile
  else
    dotsay "@magenta updating homebrew..."
    brew update > /dev/null 2>&1
  fi
}

function brew_package_installed() {
  local package=$1
  brew list "$package" > /dev/null 2>&1
}

function install_fzf() {
  if brew_package_installed fzf ; then
    dotsay "@green fzf is already installed"
  else
    dotsay "@yellow installing fzf..."

    brew install fzf
    $(brew --prefix)/opt/fzf/install
  fi
}

function install_zsh() {
  which zsh >/dev/null
  if [[ $? != 0 ]] ; then
    dotsay "@yellow installing zsh..."
    sudo apt-get install zsh -y
  else
    dotsay "@green zsh is already installed"
  fi
}

function install_ohmyzsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    dotsay "@yellow installing ohmyzsh..."

    sh -c "$(curl -fsSL \
      https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else 
    dotsay "@green ohmyzsh already installed" 
  fi
}

function install_zsh_autosuggestions() {
	if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
		dotsay "@green zsh-autosuggestions already installed"
	else
		dotsay "@yellow installing zsh_autosuggestions..."

		# NOTE: This clones into the ohmyzsh plugins directory
		git clone https://github.com/zsh-users/zsh-autosuggestions \
			${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	fi
}

function install_zsh_syntax_highlighting() {
	if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
		dotsay "@green zsh-syntax-highlighting already installed"
	else
		dotsay "@yellow installing zsh_syntax_highlighting..."

		# NOTE: This clones into the ohmyzsh plugins directory
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
			${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	fi
}

function install_powerlevel10k() {
  if [ -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    dotsay "@yellow installing powerlevel10k theme"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k

    dotsay "@white run \`p10k configure\` to set up"
  else 
    dotsay "@green powerlevel10k already installed"
  fi

  if [ "$(fc-list | grep 'MesloLGS NF')" = "" ]; then
    dotsay "@yellow downloading MesloGS NF fonts to ~/Downloads (please install these)"
    local P10K_FONT_PATH=https://github.com/romkatv/powerlevel10k-media/raw/master

    wget -P $HOME/Downloads/ >/dev/null 2>&1 \
      $P10K_FONT_PATH/MesloLGS%20NF%20Regular.ttf \
      $P10K_FONT_PATH/MesloLGS%20NF%20Bold.ttf \
      $P10K_FONT_PATH/MesloLGS%20NF%20Italic.ttf \
      $P10K_FONT_PATH/MesloLGS%20NF%20Bold%20Italic.ttf
  else
		dotsay "@green MesloGS NF fonts are already installed!"
  fi
}

function install_base16_shell() {
  if [ ! -d ~/.config/base16-shell ]; then
    mkdir -p ~/.config
    git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
  else
    dotsay "@green base16 already installed"
  fi
}

function select_base16_theme() {
  dotsay "@magenta selected base16 color theme"
  ln -sf ~/.config/base16-shell/scripts/base16-chalk.sh ~/.base16_theme
}

function install_tmux() {
  if brew_package_installed tmux; then
    dotsay "@green tmux already installed"
  else
    dotsay "@yellow installing tmux..."
    sudo apt install tmux	
  fi
}

function install_alacritty() {
  which alacritty >/dev/null
  if [[ $? != 0 ]]; then
    dotsay "@yellow installing alacritty..."
    sudo snap install alacritty --classic
  else
    dotsay "@green alacritty already installed"
  fi
}

function install_neovim() {
  if brew_package_installed neovim ; then
    dotsay "@green neovim already installed"
  else
    dotsay "@yellow installing neovim..."
    brew install neovim
  fi
}

dotheader "Installing..."

# Link config files to their actual locations 
dotsay "@blue setting up zsh config"
ln -sf ~/configs/zsh/zshrc ~/.zshrc

dotsay "@blue setting up tmux config"
ln -sf ~/configs/.tmux.conf ~/.tmux.conf

dotsay "@blue setting up git config"
ln -sf ~/configs/git/config ~/.gitconfig

dotsay "@blue setting up neovim config"
if [ ! -d ~/.config/nvim ]; then 
	ln -sf ~/configs/nvim ~/.config/nvim
fi

dotsay "@blue setting up alacritty config"
mkdir -p ~/.config/alacritty
ln -sf ~/configs/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml

# Ucomment if I use fish again
# dotsay "@blue setting up fish config"
# ln -sf ~/configs/fish/config.fish ~/.config/fish/config.fish

# Install everything
install_homebrew
install_fzf
install_zsh
install_ohmyzsh
install_zsh_autosuggestions
install_zsh_syntax_highlighting
install_powerlevel10k
install_base16_shell
select_base16_theme
install_alacritty
install_neovim
