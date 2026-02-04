sudo apt install opam -y

opam init -y
eval $(opam env)

mkdir ~/ocaml-switch
cd ~/ocaml-switch
    
opam switch create . 5.1.0
eval $(opam env)

opam install reason dune
