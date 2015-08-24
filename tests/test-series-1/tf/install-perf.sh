#!/bin/bash

sudo apt-get update 
sudo apt-get install python-dev python-pip vim git dtrx curl wget build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev -y 
wget -qO- https://get.docker.com/ | sh
sudo pip install locustio
