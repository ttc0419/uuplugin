#!/bin/sh
curl -O $(curl -s -H 'Accept:text/plain' 'https://router.uu.163.com/api/script/monitor?type=openwrt' | awk -F ',' '{print $1}')
