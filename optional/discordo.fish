git clone https://github.com/ayn2op/discordo

cd discordo
git am < ../patches/0001-Change-how-tokens-are-stored.patch

go install -v
