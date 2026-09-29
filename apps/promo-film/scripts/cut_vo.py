"""Cut a single narration recording into the film's cues.

    python3 scripts/cut_vo.py            # uses source_file from scripts/vo_lines.json

Each line's `source` [start, end] (seconds in the recording) is cut out with short fades and
saved as public/audio/vo/<id>.wav (48 kHz mono); scripts/make_audio.py then places each one at
its `start` in the film. To re-time a line, change its `start`; to re-cut it, change `source`.
"""
import json
import subprocess
import tempfile
from pathlib import Path

import numpy as np
from scipy.io import wavfile

ROOT = Path(__file__).resolve().parent.parent
DOC = json.loads((ROOT / 'scripts' / 'vo_lines.json').read_text())
OUT = ROOT / 'public' / 'audio' / 'vo'
SR = 48000
FADE = int(0.008 * SR)


def main():
    src = ROOT / DOC['source_file']
    with tempfile.TemporaryDirectory() as d:
        wav = Path(d) / 'vo.wav'
        # Remotion ships its own ffmpeg, so no system install is needed to decode the mp3.
        subprocess.run(['npx', 'remotion', 'ffmpeg', '-loglevel', 'error', '-y', '-i', str(src),
                        '-ar', str(SR), '-ac', '1', '-c:a', 'pcm_s16le', str(wav)], check=True, cwd=ROOT)
        sr, x = wavfile.read(wav)
    x = x.astype(np.float64) / 32768
    OUT.mkdir(parents=True, exist_ok=True)
    for line in DOC['lines']:
        a, b = (int(t * SR) for t in line['source'])
        seg = x[a:b].copy()
        ramp = np.linspace(0, 1, FADE)
        seg[:FADE] *= ramp
        seg[-FADE:] *= ramp[::-1]
        wavfile.write(OUT / f"{line['id']}.wav", SR, (np.clip(seg, -1, 1) * 32767).astype(np.int16))
        print(f"{line['id']}  {line['start']:5.2f}s → {line['start'] + len(seg) / SR:5.2f}s  {line['text']}")


if __name__ == '__main__':
    main()
