#!/bin/bash

# creating folders for temporary files
mkdir tmp

index=0
for f in *;
do
	type=$(ffprobe -loglevel error -show_entries stream=codec_type -of default=nw=1 $f)
	# ffmpeg treats pictures as video
	if [[ $type == 'codec_type=video' ]]
	then
		index=$(( index + 1 ))
		# indexing and scaling pictures for further conversion
		filename=tmp/$(printf "%04d" $index)-picture.jpeg
		ffmpeg -i $f -loglevel error -vf scale=-1:800 -y $filename 
	fi
	if [[ $type == 'codec_type=audio' ]]
	then
		# transcoding audio
		filename=tmp/audio.ogg
		ffmpeg -i $f -loglevel error -c:a libopus -b:a 64k -y $filename
	fi
done

# checking the duration of audio
if [[ -f "tmp/audio.ogg" ]]
then
	audio_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 tmp/audio.ogg)
else
	audio_duration=10
fi

#in slow-mo because ffmpeg tend to lose last couple of frames when compiling video from pictures
ffmpeg -framerate 1/5 -i 'tmp/%04d-picture.jpeg' -loglevel error -c:v vp9 -crf 5 -vf fps=25 -pix_fmt yuv420p -y tmp/video.webm

video_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 tmp/video.webm)

ratio=$( awk "BEGIN{print $audio_duration / $video_duration}" )

# making video the same duration as audio
ffmpeg -i tmp/video.webm -filter:v "setpts=$ratio*PTS" -loglevel error -y tmp/output.webm

# making webm from video and audio
if [[ -f "tmp/audio.ogg" ]]
then
	ffmpeg -i tmp/audio.ogg -i tmp/output.webm -loglevel error -map 0:a -map 1:v -c:v copy -y deck_startup.webm
else
	mv tmp/output.webm deck_startup.webm
fi

rm -rf tmp
