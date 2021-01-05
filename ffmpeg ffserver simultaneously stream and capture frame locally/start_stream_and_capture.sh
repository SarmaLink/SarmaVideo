/usr/bin/ffserver 1> /home/sarma/ffserver.log 2> /home/sarma/ffserver.err &
sleep 10 && /usr/bin/ffmpeg -f video4linux2 -i /dev/video0 -video_size 640x480 http://localhost:8090/feed1.ffm -r 0.1 /home/sarma/cap_frames0/output_%04d.png 1> /home/sarma/ffmpeg.log 2> /home/sarma/ffmpeg.err &



