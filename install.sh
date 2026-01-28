sudo apt update
sudo apt install -y fish neovim git

chsh -s /usr/bin/fish

git config --global user.email "vossjanick62@gmail.com"
git config --global user.name "Glowman554"
git config --global credential.helper 'store --file ~/.my-credentials'


mkdir -p .config/nvim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

nvim +'PlugInstall --sync' +qa

fish install.fish