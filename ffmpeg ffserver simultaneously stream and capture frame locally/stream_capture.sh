#!/bin/sh
# do not forget sudo usermod -a -G video username
ffmpeg -f video4linux2 -i /dev/video0 -video_size 640x480 http://localhost:8090/feed1.ffm -r 0.1 output_%04d.png
