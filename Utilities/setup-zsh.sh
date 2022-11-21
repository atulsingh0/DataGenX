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
