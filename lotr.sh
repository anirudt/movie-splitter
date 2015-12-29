#! /bin/bash
echo "Hello"
echo "Issue initial cleanup"
make clean

mkdir series/

NUMBER_MINS=`ffprobe -i $1 -show_entries format=duration -v quiet -of csv="p=0"`
NUMBER_MINS=$((${NUMBER_MINS%.*}/60))
NUMBER_PARTS=$(($NUMBER_MINS/20+1))
file=$1

if [[ $1 == *$EXTENSION ]]
then
  EXTENSION="$EXTENSION"
else
  if [[ $1 == *.mp4 ]]
  then
    EXTENSION=".mp4"
  else
    EXTENSION=".avi"
  fi
fi
echo "$EXTENSION file reported"

for (( i=0; i<$NUMBER_PARTS; i++ ))
do
  echo "$[ i/3 ]:$[ (i*20)%60 ]:00"

  # Copying twenty minute section and doing the math
  ffmpeg -y -i $1 -vcodec copy -acodec copy -ss $[ i/3 ]:$[ (i*20)%60 ]:00 -t 00:20:00 series/out_$i$EXTENSION
done


mkdir recap/
# Computing from the 2nd episode
for (( i=1; i<$NUMBER_PARTS; i++ ))
do
  touch list.txt
  rm -rf list.txt
  for j in {0..3};
  do
    echo "Sampling for recapitulation"

    # Take from an already existing file, if we have input
    # Else randomize
    ffmpeg -y -i series/out_$[ i-1 ]$EXTENSION -vcodec copy -acodec copy -ss 00:$[ ( 4 + j * 5 ) ]:00 -t 00:00:15 recap/out_$j$EXTENSION
    echo "file 'recap/out_$j$EXTENSION'" >> list.txt
  done
  echo "file 'series/out_$[ i ]$EXTENSION'" >> list.txt
  ffmpeg -y -f concat -i list.txt -vcodec copy -acodec copy -c copy series/outre_$i$EXTENSION
  rm -rf list.txt
done
mv series/out_0$EXTENSION series/outre_0$EXTENSION

echo "Cleaning up.. "
for(( i=1; i<$NUMBER_PARTS; i++ ))
do
  rm -rf series/out_$i$EXTENSION
done
