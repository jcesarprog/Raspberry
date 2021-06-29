#!/bin/bash

# ? Colors variables
end="\e[0m"
red="\e[31m"
green="\e[32m"
bold="\e[1m"

suc_fail_func() {
    if [ $? -eq 0 ]; then
        echo -e $green"\nSuccess on installing $1\n"$end
    else
        echo -e $red"Failure on installing $1"$end 
        echo -e "Failure on installing $1" >>  ~/errors.log
    fi
}
# ? First system update
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade

# ? Global variables
user=$(who | awk '{print $1}')
user_home="/home/$user"
dist_name=$(lsb_release -sc)
# dist_name=$(cat /etc/*release | grep "DISTRIB_CODENAME" |  cut -d= -f2)
# ! master repo
# gitrepo="https://github.com/jcesarprog/Raspberry"
# ! dev repo
gitrepo="https://github.com/jcesarprog/Raspberry/tree/dev/scripts"

# ? VIM template

echo "Setting up vi theme.\nInstalling vimrc template."

echo -e $bold"Installing vimrc template"$end
sleep 2
echo -e $bold"Downloading vimrc template"$end
wget -P $user_home/ $gitrepo/.vimrc
suc_fail_func "Downloading .vimrc template"

version=$(ls /usr/share/vim/ | grep -P "vim[0-9]{2}")
echo -e $bold"vim-script version: $version"$end
echo -e $bold"Installing vimrc"$end
sed -i -E "s/vim[0-9]{2}/$version/g" ~/vimrc
mv ~/vimrc ~/.vimrc
sudo cp $user_home/.vimrc /root/.vimrc
suc_fail_func "Setting up vi theme"