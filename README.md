debian-preseed
==============

Debian seed file with xfc4 post install geared towards fast VirtualBox installation 

Usage:
=======

1- Clone this repo and serve the files via http

2- Modify `PRESEED_SERVER` value at the begining of `post-install.sh` with the ip address of your http server.

3- Boot from iso:

    boot: install auto=true preseed/url=http://ip.address/testing-amd64.preseed

4- After first install, login with `user1/1234` credentials and run:

    bash post-install.sh

When asked for sudo password, use `1234`.

5 - Now grab a cup of tea while everything is getting installed.

Included packages
=====================

From `official debian testing`:

    localepurge 
    curl 
    mc 
    bash-completion
    tar 
    bzip2 
    zip 
    unzip
    openssh-server
    debconf-utils
    $LINUX_HEADERS
    build-essential
    module-assistant
    xorg htop
    tinyca
    default-jre
    fonts-droid-fallback
    unrar-free 
    subversion 
    git 
    locate 
    cifs-utils 
    lsof 
    xfce4 
    xdg-utils 
    desktop-base 
    dmz-cursor-theme 
    xfce4-cpugraph-plugin 
    lxterminal 
    thunar-archive-plugin 
    faenza-icon-theme 
    gtk2-engines-murrine 
    gnome-icon-theme 
    gpicview nomacs 
    leafpad 
    geany 
    xarchiver 
    cabextract 
    apache2 
    ssl-cert 
    libapache2-mod-php 
    php-mysql 
    php-sqlite3 
    php-gd 
    php-cli 
    php-curl 
    php-mcrypt 
    php-xdebug 
    default-mysql-server 
    adminer
    libgconf-2-4
    qcachegrind


From `deb.nodesource.com`:

    nodejs


From `Steve Pusser's software.opensuse.org`:

    palemoon

From `download.virtualbox.org`

    VBoxGuestAdditions_$VBOX_VER.iso

From `eclipse.org`:

    eclipse
    org.eclipse.php.feature.group
    com.spket.ui.feature.group (spket.com)



