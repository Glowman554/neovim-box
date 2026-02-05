git clone https://github.com/Glowman554/FireStorm
cd FireStorm

cd fire && go install -v && cd ..
cd flc && make install && cd ..
cd flvm && gcc main.c vm.c -g -o ~/go/bin/flvm && cd ..

cd syntax/neovim && bash install.sh && cd ../..
