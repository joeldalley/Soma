#!/bin/sh
pkill -f 'starman'
nohup plackup -E deployment -s Starman --workers=10 -p 3000 -a dancer.pl &
