#!/bin/sh
sqlogin='--defaults-extra-file=sql.conf -N laukums'

camname="cam004"
startdate="2017-07-10"
enddate="2018-04-20"
starttime="07:00:00"
endtime="19:00:00"

i=0 #file counter

tempdir=$(pwd)/pagaidu
rm -fr $tempdir
mkdir $tempdir

sql="SELECT
	npk,DATE_FORMAT(tstamp,'%Y-%m-%d'),DATE_FORMAT(tstamp,'%H-%i-%s')
	FROM $camname
	WHERE size > 1000
	AND DATE(tstamp) >= '$startdate'
	AND DATE(tstamp) <= '$enddate'
	AND TIME(tstamp) >= '$starttime'
	AND TIME(tstamp) <= '$endtime'
	ORDER BY npk ASC;"
echo $sql | mysql $sqlogin | while read fragments
do
  outfile=$(printf "f%011d" $i).jpg
  npk=$(echo "$fragments" | cut -f1 -d'	')
  dat=$(echo "$fragments" | cut -f2 -d'	')
  tim=$(echo "$fragments" | cut -f3 -d'	')
  basepath="../$camname/$dat"
  filename="$basepath/$npk-$tim.jpg"
  echo $i
  #  jpegtran -optimize -copy none -perfect -v "$filename" > "$tempdir/$outfile" 2>/dev/null

  jinfo=$(jpeginfo -c "$filename")
  chk=$(echo $jinfo | cut -f9 -d' ')
  if [ "$chk" = "[OK]" ]; then
    #ln "$filename" "$tempdir/$outfile"
    jpegtran -optimize -copy none -perfect -v "$filename" > "$tempdir/$outfile" 2>/dev/null
    rc=$?
    if [ $rc = 0 ] ; then
      i=$(($i + 1))
    fi
  else
    echo "$jinfo"
  fi;
done

#exit 0


vidfile="$camname"_"$startdate"-"$enddate"_\($(echo "$starttime" | tr : .)-$(echo "$endtime" | tr : .)\).mkv
ffmpeg -framerate 30 -i "$tempdir/f%011d.jpg" -codec copy "$vidfile" #2>/dev/null
vidfile="$camname"_"$startdate"-"$enddate"_\($(echo "$starttime" | tr : .)-$(echo "$endtime" | tr : .)\).mp4
ffmpeg -framerate 30 -i "$tempdir/f%011d.jpg"  "$vidfile"

exit 0

i=1;
while [ $i -le 100 ] ;
do
  echo $i;
  i=$((i+1));
done;
