#! /bin/bash
echo "Hello"

for i in {0..13};
do
echo "$[ i/3 ]:$[ (i*20)%60 ]:00"

if [ -e "out_$i.mp4" ]
    then echo "Already there"
else
ffmpeg -i vid1.mkv -vcodec copy -acodec copy -ss $[ i/3 ]:$[ (i*20)%60 ]:00 -t 00:20:00 out_$i.mkv
fi
done

