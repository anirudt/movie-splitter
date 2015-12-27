#! /bin/bash
echo "Hello"
mkdir series/

for i in {0..13};
do
  echo "$[ i/3 ]:$[ (i*20)%60 ]:00"

  if [ -e "out_$i.mp4" ]
    then echo "Already there"
  else
    # Copying twenty minute section and doing the math
    ffmpeg -i vid1.mkv -vcodec copy -acodec copy -ss $[ i/3 ]:$[ (i*20)%60 ]:00 -t 00:20:00 series/out_$i.mkv
  fi
done


mkdir recap/
for i in {0..13};
do
  for j in {0..6};
  do
    echo "Sampling for recapitulation"

    # Take from an already existing file, if we have input
    # Else randomize
    ffmpeg -i vid1.mkv -vcodec copy -acodec copy -ss $[]:$[]:00 -t 00:00:05 recap/out_$j.mkv

  done
done
