# Considering the base OS as ubuntu
# You have to use appropriate installed command (yum, dnf etc) for your OS

# Installing ZSH
sudo apt update
sudo apt install zsh -y

# Switch the default Shell
sudp chsh -s $(which zsh)

# To check if you are now using ZSH
echo $SHELL

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Insllating powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >>~/.zshrc

# Installing Plugins

## zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

## zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

## zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

## zsh-completions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

##  history-search-multi-word
git clone https://github.com/z-shell/H-S-MW.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/history-search-multi-word

# Update Plugin
grep ^plugins ~/.zshrc |
    sed 's_)_zsh-syntax-highlighting zsh-history-substring-search zsh-autosuggestions history-search-multi-word zsh-completions history-search-multi-word _' |
    cut -d'(' -f2 | tr ' ' '\n' | sort -u | tr '\n' ' '

# Open ~/.zshrc and replace the content of "plugins" from above command output
plugins=(... zsh-syntax-highlighting zsh-history-substring-search zsh-autosuggestions history-search-multi-word zsh-completions history-search-multi-word)
