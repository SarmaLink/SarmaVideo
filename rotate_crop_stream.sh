#!/bin/sh
# rotate, crop, deinterlace, and stream from v4l2 device using vlc
# before running this as normal user do the following as root
# apt install vlc
# usermod -a -G video username
# ufw allow 8554/tcp
# systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
cvlc v4l2:///dev/video0:standard=PAL --transform-type=180 --sout '#transcode{vcodec=mp4v,vb=0,scale=1,deinterlace,vfilter=transform:croppadd{croptop=8,cropbottom=8,cropleft=16,cropright=16}}: rtp{sdp=rtsp://@:8554/}'
