#!/bin/sh
sudo /sbin/brctl addbr hana0
sudo /sbin/brctl addbr hana1
sudo /sbin/brctl addbr hana2
sudo /sbin/brctl addbr hana3
sudo ip addr add 10.0.31.10 dev hana0
sudo ip addr add 10.0.31.11 dev hana1
sudo ip addr add 10.0.31.12 dev hana2
sudo ip addr add 10.0.31.13 dev hana3
