#! /bin/bash

cd ~ || exit
mdnsd -i enp3s0
otbr-agent -d 6 -v -I wpan0 -B enp3s0 'spinel+cpc://cpcd_0?iid=2&iid-list=0'
