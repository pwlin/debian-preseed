#!/bin/bash

VBOX_VER=5.1.22
PRESEED_SERVER=http://192.168.0.21
POSTINSTALL_DIR=/home/user1/Downloads/post-install
OS_ARCH=`uname -m`

function create-user-dirs() {
	sudo rm -rf $POSTINSTALL_DIR > /dev/null
	mkdir -p $POSTINSTALL_DIR
	mkdir -p /home/user1/Desktop
	mkdir -p /home/user1/Media/Documents
	mkdir -p /home/user1/Media/Templates
	mkdir -p /home/user1/Media/Pictures
	mkdir -p /home/user1/Media/Music
	mkdir -p /home/user1/Media/Videos
	mkdir -p /home/user1/Media/Public
	mkdir -p /home/user1/bin
	mkdir -p /home/user1/Programs
	mkdir -p /home/user1/workspace/eclipse
	mkdir -p /home/user1/workspace/projects
}

function apt-init() {
	sudo rm -r /var/lib/apt/lists/* 
	curl $PRESEED_SERVER/files/etc/apt/apt.conf.d/00InstallRecommends > $POSTINSTALL_DIR/00InstallRecommends
	sudo cp $POSTINSTALL_DIR/00InstallRecommends /etc/apt/apt.conf.d/00InstallRecommends
	sudo chown root:root /etc/apt/apt.conf.d/00InstallRecommends
	sudo apt-get update
	sudo apt-get -y autoremove
}

function apt-init-remove() {
	sudo apt-get -y remove --purge \
		task-english \
		ispell \
		wamerican \
		ienglish-common \
		iamerican \
		ibritish \
		dictionaries-common \
		util-linux-locales \
		vim-tiny \
		vim-common \
		xxd \
		manpages \
		manpages-dev \
		tcpd \
		unar
	sudo apt-get update
	sudo apt-get -y autoremove
}

function apt-init-install() {
	LINUX_HEADERS=linux-headers-686-pae
	if [ ${OS_ARCH} == 'x86_64' ]; then
		LINUX_HEADERS=linux-headers-amd64
	fi
	# greybird-gtk-theme dirmngr tightvncserver default-jdk
	sudo apt-get -y install \
		$LINUX_HEADERS \
		build-essential \
		module-assistant \
		xorg htop \
		tinyca \
		default-jre \
		fonts-droid-fallback\
		unrar-free \
		subversion \
		git \
		locate \
		cifs-utils \
		lsof \
		xfce4 \
		xdg-utils \
		desktop-base \
		dmz-cursor-theme \
		xfce4-cpugraph-plugin \
		lxterminal \
		thunar-archive-plugin \
		faenza-icon-theme \
		gtk2-engines-murrine \
		gnome-icon-theme \
		gpicview nomacs \
		leafpad \
		geany \
		xarchiver \
		cabextract \
		apache2 \
		ssl-cert \
		libapache2-mod-php \
		php-mysql \
		php-sqlite3 \
		php-gd \
		php-cli \
		php-curl \
		php-mcrypt \
		php-mbstring \
		php-dom \
		composer \
		php-xdebug \
		default-mysql-server \
		adminer \
		libgconf-2-4 \
		qcachegrind
}

function install-nodejs() {
	curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
	sudo apt-get install -y nodejs
}

function install-palemoon() {
	curl $PRESEED_SERVER/files/etc/apt/sources.list.d/palemoon.list > $POSTINSTALL_DIR/palemoon.list
	sudo cp $POSTINSTALL_DIR/palemoon.list /etc/apt/sources.list.d/palemoon.list
	sudo chown root:root /etc/apt/sources.list.d/palemoon.list
	wget -nv http://download.opensuse.org/repositories/home:stevenpusser/Debian_8.0/Release.key -O $POSTINSTALL_DIR/Release.key
	sudo apt-key add - < $POSTINSTALL_DIR/Release.key
	sudo apt-get update
	sudo apt-get install -y palemoon
	curl $PRESEED_SERVER/files/backups/palemoon-profile.zip > $POSTINSTALL_DIR/palemoon-profile.zip
	unzip -u -q $POSTINSTALL_DIR/palemoon-profile.zip -d /home/user1
}

function apt-configure-localepurge {
	curl $PRESEED_SERVER/files/etc/locale.nopurge > $POSTINSTALL_DIR/locale.nopurge
	sudo cp $POSTINSTALL_DIR/locale.nopurge /etc/locale.nopurge
	sudo chown root:root /etc/locale.nopurge
	sudo localepurge
}

function apt-finish() {
	sudo apt-get update
	sudo ap-get -y upgrade
	sudo apt-get -y dist-upgrade
	sudo apt-get -y autoremove
	sudo aptitude forget-new 
	sudo aptitude clean
	sudo aptitude autoclean
}

function install-themes-faenza-cupertino() {
	curl $PRESEED_SERVER/files/themes/129008-Faenza-Cupertino.tar.gz > $POSTINSTALL_DIR/faenza-cupertino.tar.gz
	tar xvzf $POSTINSTALL_DIR/faenza-cupertino.tar.gz -C $POSTINSTALL_DIR > /dev/null
	sudo rm -rf /usr/share/icons/Faenza-Cupertino > /dev/null
	sudo mkdir -p /usr/share/icons/Faenza-Cupertino 
	sudo cp -r $POSTINSTALL_DIR/Faenza-Cupertino/* /usr/share/icons/Faenza-Cupertino/ > /dev/null
	sudo gtk-update-icon-cache /usr/share/icons/Faenza-Cupertino/
}

function install-wallpapers() {
	curl $PRESEED_SERVER/files/wallpapers/xubuntu-yakkety.png > $POSTINSTALL_DIR/xubuntu-yakkety.png
	sudo cp $POSTINSTALL_DIR/xubuntu-yakkety.png /usr/share/images/desktop-base/xubuntu-yakkety.png
	sudo chown root:root /usr/share/images/desktop-base/xubuntu-yakkety.png
	
	curl $PRESEED_SERVER/files/wallpapers/desktop-grub.png > $POSTINSTALL_DIR/desktop-grub.png
	sudo cp $POSTINSTALL_DIR/desktop-grub.png /usr/share/images/desktop-base/desktop-grub.png
	sudo chown root:root /usr/share/images/desktop-base/desktop-grub.png
	sudo update-grub
}

function install-fonts() {
	curl -L "https://download.microsoft.com/download/E/6/7/E675FFFC-2A6D-4AB0-B3EB-27C9F8C8F696/PowerPointViewer.exe" > /home/user1/Downloads/post-install/PowerPointViewer.exe
	cabextract -d $POSTINSTALL_DIR -L -F ppviewer.cab $POSTINSTALL_DIR/PowerPointViewer.exe
	cabextract -d $POSTINSTALL_DIR -L -F '*.TTF' $POSTINSTALL_DIR/ppviewer.cab

	font_files=( andale32.exe arial32.exe arialb32.exe comic32.exe courie32.exe georgi32.exe impact32.exe times32.exe trebuc32.exe verdan32.exe webdin32.exe )
	for i in "${font_files[@]}"
	do
		curl -L https://downloads.sourceforge.net/corefonts/$i > $POSTINSTALL_DIR/$i
		cabextract -d $POSTINSTALL_DIR -L -F '*.TTF' $POSTINSTALL_DIR/$i
	done

	sudo mkdir -p /usr/share/fonts/truetype/ms-ttf
	sudo cp $POSTINSTALL_DIR/*.ttf /usr/share/fonts/truetype/ms-ttf
	
	# https://www.linuxbabe.com/desktop-linux/improve-font-rendering-on-debian-8-by-install-infinality-and-google-fonts
	curl $PRESEED_SERVER/files/fonts/ttf-ubuntu-font-family_0.83-0ubuntu2_all.deb > $POSTINSTALL_DIR/ttf-ubuntu-font-family_0.83-0ubuntu2_all.deb
	dpkg -x $POSTINSTALL_DIR/ttf-ubuntu-font-family_0.83-0ubuntu2_all.deb $POSTINSTALL_DIR
	sudo mkdir -p /usr/share/fonts/truetype/ubuntu-family
	sudo cp $POSTINSTALL_DIR/usr/share/fonts/truetype/ubuntu-font-family/*.ttf /usr/share/fonts/truetype/ubuntu-family
	
	curl $PRESEED_SERVER/files/fonts/fontconfig-infinality_20130104-0ubuntu0ppa1_all.deb > $POSTINSTALL_DIR/fontconfig-infinality_20130104-0ubuntu0ppa1_all.deb
	sudo dpkg -i $POSTINSTALL_DIR/fontconfig-infinality_20130104-0ubuntu0ppa1_all.deb
	sudo bash /etc/fonts/infinality/infctl.sh setstyle linux
	sudo sed -i -e 's/USE_STYLE="DEFAULT"/USE_STYLE="UBUNTU"/g' /etc/profile.d/infinality-settings.sh
	
	fc-cache -fv /usr/share/fonts/truetype
}

function setup-vnc() {
	curl $PRESEED_SERVER/files/vnc/tightvncserver.service > $POSTINSTALL_DIR/tightvncserver.service
	sudo cp $POSTINSTALL_DIR/tightvncserver.service /etc/systemd/system/tightvncserver.service
	sudo chown root:root /etc/systemd/system/tightvncserver.service
	sudo chmod 755 /etc/systemd/system/tightvncserver.service
	sudo systemctl enable tightvncserver.service
	sudo su -s /bin/bash user1 -c 'umask 0077;mkdir -p "$HOME/.vnc";chmod go-rwx "$HOME/.vnc";vncpasswd -f <<<"12345678" >"$HOME/.vnc/passwd"'
	curl $PRESEED_SERVER/files/vnc/vnc-xstartup > /home/user1/.vnc/xstartup
	chmod +x /home/user1/.vnc/xstartup
	sudo systemctl restart tightvncserver.service
}

function fix-keyboard-auto-completion() {
	curl $PRESEED_SERVER/files/tweaks/fix-keyboard-auto-completion > $POSTINSTALL_DIR/fix-keyboard-auto-completion.php
	php $POSTINSTALL_DIR/fix-keyboard-auto-completion.php
}

function configure-bash-aliases() {
	curl $PRESEED_SERVER/files/profile/.bash_aliases > $POSTINSTALL_DIR/.bash_aliases
	cp $POSTINSTALL_DIR/.bash_aliases /home/user1/.bash_aliases
}

function enable-color-prompt() {
	sed -i -e 's/#force_color_prompt=yes/force_color_prompt=yes/g' /home/user1/.bashrc
}

function configure-console-setup() {
	curl $PRESEED_SERVER/files/etc/default/console-setup > $POSTINSTALL_DIR/console-setup
	sudo cp $POSTINSTALL_DIR/console-setup /etc/default/console-setup
	sudo chown root:root /etc/default/console-setup	
}

function restore-config-dir() {
	sudo rm -rf /home/user1/.config > /dev/null
	curl $PRESEED_SERVER/files/backups/user-config.zip > $POSTINSTALL_DIR/user-config.zip
	unzip -u -q $POSTINSTALL_DIR/user-config.zip -d /home/user1
}

function restore-desktop-icons() {
	icon_files=( exo-terminal-emulator eclipse palemoon )
	for i in "${icon_files[@]}"
	do
		curl $PRESEED_SERVER/files/profile/$i.desktop > $POSTINSTALL_DIR/$i.desktop
		cp $POSTINSTALL_DIR/$i.desktop /home/user1/Desktop/$i.desktop
		chmod +x /home/user1/Desktop/$i.desktop
	done
}

function enable-auto-login() {
	# http://forums.debian.net/viewtopic.php?f=16&t=123694
	curl $PRESEED_SERVER/files/etc/systemd/system/getty@tty1.service.d/override.conf > $POSTINSTALL_DIR/autologin-override.conf
	sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
	sudo cp $POSTINSTALL_DIR/autologin-override.conf /etc/systemd/system/getty@tty1.service.d/override.conf
	sudo chown root:root /etc/systemd/system/getty@tty1.service.d/override.conf
	sudo systemctl set-default multi-user.target
	printf "\n\n[[ -z \$DISPLAY && \$XDG_VTNR -eq 1 ]] && exec startx\n\n" >> /home/user1/.profile
}

function restore-geany-icons() {
	icon_files=( 16 22 24 32 48 64 96 )
	for i in "${icon_files[@]}"
	do
		curl $PRESEED_SERVER/files/icons/geany/geany-$i.png > $POSTINSTALL_DIR/geany-$i.png
		sudo cp $POSTINSTALL_DIR/geany-$i.png /usr/share/icons/Faenza/apps/$i/geany.png
		sudo chown root:root /usr/share/icons/Faenza/apps/$i/geany.png
	done
	curl $PRESEED_SERVER/files/icons/geany/geany-48.svg > $POSTINSTALL_DIR/geany-48.svg
	sudo cp $POSTINSTALL_DIR/geany-48.svg /usr/share/icons/Faenza/apps/scalable/geany.svg
	sudo chown root:root /usr/share/icons/Faenza/apps/scalable/geany.svg
}

function configure-LAMP() {
	curl $PRESEED_SERVER/files/etc/php/7.0/apache2/php.ini > $POSTINSTALL_DIR/php-apache.ini
	sudo cp $POSTINSTALL_DIR/php-apache.ini /etc/php/7.0/apache2/php.ini
	sudo chown root:root /etc/php/7.0/apache2/php.ini
	curl $PRESEED_SERVER/files/etc/php/7.0/cli/php.ini > $POSTINSTALL_DIR/php-cli.ini
	sudo cp $POSTINSTALL_DIR/php-cli.ini /etc/php/7.0/cli/php.ini
	sudo chown root:root /etc/php/7.0/cli/php.ini
	sudo mysql -uroot -p1234 -e "CREATE USER user1@localhost IDENTIFIED BY '1234';"
	sudo mysql -uroot -p1234 -e "GRANT ALL PRIVILEGES ON *.* TO user1@localhost;"
	sudo mysql -uroot -p1234 -e "FLUSH PRIVILEGES;"
	sudo chgrp -R user1 /var/www/html/
	sudo chmod -R 775 /var/www/html
	curl $PRESEED_SERVER/files/var/www/html/info.php.txt > $POSTINSTALL_DIR/info.php
	cp $POSTINSTALL_DIR/info.php /var/www/html/info.php
	ln -sf /usr/share/adminer/adminer /var/www/html/adminer
	sudo a2enmod rewrite
}

function install-vbox-guest-additions() {
	curl -L http://download.virtualbox.org/virtualbox/$VBOX_VER/VBoxGuestAdditions_$VBOX_VER.iso > $POSTINSTALL_DIR/VBoxGuestAdditions.iso
	sudo mkdir -p $POSTINSTALL_DIR/media-iso
	sudo mount -o loop $POSTINSTALL_DIR/VBoxGuestAdditions.iso $POSTINSTALL_DIR/media-iso
	sudo sh $POSTINSTALL_DIR/media-iso/VBoxLinuxAdditions.run
	sudo umount $POSTINSTALL_DIR/media-iso
}

function install-eclipse() {
	curl -L "http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/eclipse/downloads/drops4/R-4.6.3-201703010400/eclipse-platform-4.6.3-linux-gtk-x86_64.tar.gz" > $POSTINSTALL_DIR/eclipse.tar.gz
	tar xvzf $POSTINSTALL_DIR/eclipse.tar.gz -C /home/user1/Programs > /dev/null
	/home/user1/Programs/eclipse/eclipse \
		-nosplash \
		-application org.eclipse.equinox.p2.director \
		-repository http://download.eclipse.org/releases/neon,http://download.eclipse.org/eclipse/updates/4.6 \
		-installIU org.eclipse.php.feature.group

	/home/user1/Programs/eclipse/eclipse \
		-nosplash \
		-application org.eclipse.equinox.p2.director \
		-repository http://download.eclipse.org/releases/neon,http://download.eclipse.org/eclipse/updates/4.6,http://www.agpad.com/update/ \
		-installIU com.spket.ui.feature.group 
	
	curl $PRESEED_SERVER/files/backups/eclipse-metadata.zip > $POSTINSTALL_DIR/eclipse-metadata.zip
	unzip -u -q $POSTINSTALL_DIR/eclipse-metadata.zip -d /home/user1/workspace/eclipse
}

create-user-dirs
apt-init
apt-init-remove
apt-init-install
install-nodejs
install-palemoon
apt-configure-localepurge
apt-finish
install-themes-faenza-cupertino
install-wallpapers
install-fonts
#setup-vnc
fix-keyboard-auto-completion
configure-bash-aliases
enable-color-prompt
configure-console-setup
restore-config-dir
restore-desktop-icons
enable-auto-login
restore-geany-icons
configure-LAMP
install-vbox-guest-additions
install-eclipse

sudo rm -rf $POSTINSTALL_DIR
sudo rm /home/user1/post-install.sh > /dev/null
sudo localepurge
history -cw

sudo reboot
