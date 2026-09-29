"""Record the film's narration with ElevenLabs, one file per cue.

    export ELEVENLABS_API_KEY=...        # from elevenlabs.io → Profile → API keys
    export ELEVENLABS_VOICE_ID=...       # the voice to use (see README)
    python3 scripts/elevenlabs_vo.py             # fetch missing lines
    python3 scripts/elevenlabs_vo.py --force 04  # re-take line 04 only
    python3 scripts/elevenlabs_vo.py --force all # re-take everything

Optional: ELEVENLABS_MODEL (default eleven_multilingual_v2), ELEVENLABS_SPEED (0.7-1.2, default 0.95),
ELEVENLABS_STABILITY (default 0.5), ELEVENLABS_STYLE (default 0.15), ELEVENLABS_SEED (default 7).

Lines come from scripts/vo_lines.json (edit 'tts' to fix pronunciation). Each take is saved as
public/audio/vo/<id>.wav (48 kHz mono) and reused until you --force it, so you only pay for
lines you change. Then run `python3 scripts/make_audio.py` to remix.
"""
import json
import os
import sys
import urllib.error
import urllib.request
from pathlib import Path

import numpy as np
from scipy import signal
from scipy.io import wavfile

ROOT = Path(__file__).resolve().parent.parent
LINES = json.loads((ROOT / 'scripts' / 'vo_lines.json').read_text())['lines']
OUT = ROOT / 'public' / 'audio' / 'vo'
API = 'https://api.elevenlabs.io/v1/text-to-speech/{voice}?output_format=pcm_24000'
SRC_SR, SR = 24000, 48000  # pcm_24000 works on every plan; upsampled for the 48 kHz mix


def fetch(line, prev_text, next_text):
    key = os.environ.get('ELEVENLABS_API_KEY')
    voice = os.environ.get('ELEVENLABS_VOICE_ID')
    if not key or not voice:
        sys.exit('Set ELEVENLABS_API_KEY and ELEVENLABS_VOICE_ID first (see the docstring at the top of this file).')
    body = {
        'text': line['tts'],
        'model_id': os.environ.get('ELEVENLABS_MODEL', 'eleven_multilingual_v2'),
        'voice_settings': {
            'stability': float(os.environ.get('ELEVENLABS_STABILITY', 0.5)),
            'similarity_boost': 0.75,
            'style': float(os.environ.get('ELEVENLABS_STYLE', 0.15)),
            'use_speaker_boost': True,
            'speed': float(os.environ.get('ELEVENLABS_SPEED', 0.95)),
        },
        # Neighbouring lines keep intonation continuous across separately generated cues.
        'previous_text': prev_text,
        'next_text': next_text,
        'seed': int(os.environ.get('ELEVENLABS_SEED', 7)),
    }
    req = urllib.request.Request(
        API.format(voice=voice),
        data=json.dumps(body).encode(),
        headers={'xi-api-key': key, 'Content-Type': 'application/json', 'Accept': 'audio/pcm'},
        method='POST',
    )
    try:
        with urllib.request.urlopen(req, timeout=120) as r:
            raw = r.read()
    except urllib.error.HTTPError as e:
        sys.exit(f'ElevenLabs returned {e.code} for line {line["id"]}: {e.read().decode(errors="replace")[:500]}')
    pcm = np.frombuffer(raw, dtype='<i2').astype(np.float64) / 32768
    return signal.resample_poly(pcm, SR, SRC_SR)


def trim(x, floor=0.004, pad=0.03):
    nz = np.nonzero(np.abs(x) > floor)[0]
    if not len(nz):
        return x
    a = max(0, nz[0] - int(pad * SR))
    b = min(len(x), nz[-1] + int(pad * SR))
    return x[a:b]


def main():
    force = sys.argv[sys.argv.index('--force') + 1] if '--force' in sys.argv else None
    OUT.mkdir(parents=True, exist_ok=True)
    for i, line in enumerate(LINES):
        path = OUT / f'{line["id"]}.wav'
        if path.exists() and force not in ('all', line['id']):
            print(f'{line["id"]}  kept      {line["text"]}')
            continue
        prev_text = ' '.join(l['tts'] for l in LINES[:i])[-300:] or None
        next_text = ' '.join(l['tts'] for l in LINES[i + 1:])[:300] or None
        x = trim(fetch(line, prev_text, next_text))
        wavfile.write(path, SR, (np.clip(x, -1, 1) * 32767).astype(np.int16))
        print(f'{line["id"]}  recorded  {len(x) / SR:.2f}s  {line["text"]}')

    # Timing check against the film: each line should end before the next begins.
    print()
    for i, line in enumerate(LINES):
        path = OUT / f'{line["id"]}.wav'
        if not path.exists():
            continue
        dur = wavfile.read(path)[1].shape[0] / SR
        end = line['start'] + dur
        limit = LINES[i + 1]['start'] - 0.1 if i + 1 < len(LINES) else 29.6
        flag = '' if end <= limit else f'   ⚠ overruns by {end - limit:.2f}s: raise ELEVENLABS_SPEED or move "start" in vo_lines.json'
        print(f'{line["id"]}  {line["start"]:5.2f}s → {end:5.2f}s{flag}')


if __name__ == '__main__':
    main()
