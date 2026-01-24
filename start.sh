#! /bin/bash

cd ~ || exit
cpcd &> cpcd.log &

sleep 2

otbr-agent -d 6 -v -I wpan0 -B enp3s0 'spinel+cpc://cpcd_0?iid=2&iid-list=0'
