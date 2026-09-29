#!/bin/sh
# Puts the narrated mix (public/audio/mix_vo.wav) onto the finished masters without re-rendering video.
# The first run keeps the music-only masters as *_noVO.mp4; later runs always start from those.
set -e
cd "$(dirname "$0")/.."
[ -f public/audio/mix_vo.wav ] || { echo "No public/audio/mix_vo.wav yet: run scripts/elevenlabs_vo.py, then scripts/make_audio.py"; exit 1; }
for L in 9x16 16x9; do
  master="out/Duitlah_Promo_$L.mp4"
  clean="out/Duitlah_Promo_${L}_noVO.mp4"
  [ -f "$clean" ] || { [ -f "$master" ] || { echo "Missing $master: run npm run master first"; exit 1; }; cp "$master" "$clean"; }
  npx remotion ffmpeg -loglevel error -y -i "$clean" -i public/audio/mix_vo.wav \
    -map 0:v -map 1:a -c:v copy -c:a aac -b:a 320k -shortest "$master"
  echo "narrated: $master"
done
