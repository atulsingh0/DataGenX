# Considering the base OS as ubuntu

# change the installer based on your OS
inst="apt"

# Installing ZSH
sudo $inst update
sudo $inst install zsh -y

# Switch the default Shell
sudp chsh -s $(which zsh)

# To check if you are now using ZSH
echo $SHELL
