# Vim Pack
This is a package that gives you some of the most useful vim plugins as well as additional themes. By following the instructions below you can avoid the hasstle of tracking down various plugins and easily setup a function vim environment. 

## Plugin Installation
These commands are meant for a linux distribution, make sure you run them from the home directory. 
If you already have .vim or .vimrc files then you would need to remove those: 
```
rm -r ~/.vim
rm ~/.vimrc
```
Next clone the config repo and move the new vimrc file: 
```
git clone https://github.com/hmccarty/vim-config.git .vim
cp .vim/vimrc .vimrc
```
Lastly init and update the plugin submodules:
```
cd .vim
git init
git submodule init
git submodule update
```
## Nord Theme Installation
This can vary based on the user's operating system. This current configuration is only meant for the GNOME Terminal. 
Start by installing the nord terminal color scheme: 
```
cd ~/.vim/nord-gnome-terminal/src/
./nord.sh
```
After it installs, **right click the terminal** -> select **preferences** -> **click the Nord profile drop-down** -> select **set as default**. 

Then **restart the terminal**. 

## Plugin List

* [Pathogen Package Manager](https://github.com/tpope/vim-pathogen)
* [Comfortable Motion](https://github.com/yuttie/comfortable-motion.vim)
* [Vim Typescript](https://github.com/leafgarland/typescript-vim)
* [Vim Fugitive](https://github.com/tpope/vim-fugitive)
* [Tabular](https://github.com/godlygeek/tabular)
* [Git Gutter](https://github.com/airblade/vim-gitgutter)
* [Vim Airline](https://github.com/vim-airline/vim-airline)
* [Nord Theme](https://www.nordtheme.com/)
* [TComment](https://github.com/tomtom/tcomment_vim)

