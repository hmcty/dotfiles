# Vim Configuration
This is a repo to store settings and plugins for my vim environment. Below you can find the plugin list, as well as an installation guide. 

## Installation
These commands are meant for a linux distribution, make sure you run them from the home directory. 
If you already have .vim or .vimrc files then you would need to remove those: 
```
rm -r ~/.vim
rm ~/.vimrc
```
Then clone the config repo and move the new vimrc file: 
```
git clone https://github.com/hmccarty/vim-config.git .vim
mv .vim/vimrc .vimrc
```
Lastly init and update the plugin submodules:
```
cd .vim
git init
git submodule init
git submodule update
```

## Plugin List

* [Pathogen Package Manager](https://github.com/tpope/vim-pathogen)
* [Comfortable Motion](https://github.com/yuttie/comfortable-motion.vim)
* [Vim Typescript](https://github.com/leafgarland/typescript-vim)
