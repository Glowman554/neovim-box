curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# NodeJS (also needed for coc)
sudo apt install nodejs npm -y
nvim +'CocInstall -sync coc-tsserver' +qa
nvim +'CocInstall -sync coc-json' +qa
nvim +'CocInstall -sync coc-html' +qa
nvim +'CocInstall -sync coc-css' +qa

# Deno
curl -fsSL https://deno.land/install.sh | sh

# Java
sudo apt install maven openjdk-21-jdk -y
nvim +'CocInstall -sync coc-java' +qa

# GO
sudo apt install golang-go -y
echo "fish_add_path ~/go/bin" >> ~/.config/fish/config.fish
nvim +'CocInstall -sync coc-go' +qa
go install golang.org/x/tools/gopls@latest

# C
sudo apt install build-essential clang clangd meson cmake -y
nvim +'CocInstall -sync coc-clangd' +qa

# MicroOS
sudo apt install xorriso mtools grub-pc-bin gcc-i686-linux-gnu qemu-system-x86 nasm -y