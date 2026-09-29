"""Deterministic score, sound design and guide voiceover for the Duitlah film.

Outputs (public/audio/):
  music.wav, sfx.wav, vo_guide.wav     stems
  mix_guide_vo.wav                     master with the scratch VO (timing guide only)
  mix_no_vo.wav                        master without VO, ready for a recorded narrator

Music: minimal modern electronic, 108 BPM, warm sub, restrained percussion.
Mix: VO dominant, music ~8 dB under VO, SFX under both, -14 LUFS integrated,
quieter 26-30 s section before the logo.
"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

import numpy as np
from scipy import signal
from scipy.io import wavfile

SR = 48000
DUR = 30.0
N = int(SR * DUR)
OUT = Path(__file__).resolve().parent.parent / 'public' / 'audio'
OUT.mkdir(parents=True, exist_ok=True)
rng = np.random.default_rng(7)  # fixed seed: every render is identical

t_all = np.arange(N) / SR
BPM = 108
BEAT = 60 / BPM
GRID0 = 3.55  # first downbeat lands as the entry curtain lifts into Home


def midi(n):
    return 440.0 * 2 ** ((n - 69) / 12)


def env_adsr(n, a, d, s, r, sr=SR):
    a, d, r = int(a * sr), int(d * sr), int(r * sr)
    sus = max(0, n - a - d - r)
    e = np.concatenate([
        np.linspace(0, 1, max(a, 1)),
        np.linspace(1, s, max(d, 1)),
        np.full(sus, s),
        np.linspace(s, 0, max(r, 1)),
    ])
    return e[:n] if len(e) >= n else np.pad(e, (0, n - len(e)))


def place(buf, x, at):
    i = int(at * SR)
    if i >= len(buf):
        return
    j = min(len(buf), i + len(x))
    buf[i:j] += x[: j - i]


def lp(x, fc, order=2):
    b, a = signal.butter(order, fc / (SR / 2), 'low')
    return signal.lfilter(b, a, x)


def hp(x, fc, order=2):
    b, a = signal.butter(order, fc / (SR / 2), 'high')
    return signal.lfilter(b, a, x)


def bp(x, lo, hi, order=2):
    b, a = signal.butter(order, [lo / (SR / 2), hi / (SR / 2)], 'band')
    return signal.lfilter(b, a, x)


def ramp(points):
    """Piecewise-linear automation curve over the whole film: [(sec, gain), ...]."""
    xs, ys = zip(*points)
    return np.interp(t_all, xs, ys)


def stereo_verb(x, decay=1.8, mix=0.25):
    """Cheap, deterministic diffuse tail: exponentially decaying filtered noise IR."""
    n = int(decay * SR)
    ir_rng = np.random.default_rng(11)
    tail = np.exp(-np.arange(n) / (SR * decay / 5))
    irL = lp(ir_rng.standard_normal(n) * tail, 6000)
    irR = lp(ir_rng.standard_normal(n) * tail, 6000)
    irL /= np.sqrt(np.sum(irL ** 2)); irR /= np.sqrt(np.sum(irR ** 2))
    wetL = signal.fftconvolve(x, irL)[: len(x)]
    wetR = signal.fftconvolve(x, irR)[: len(x)]
    return np.stack([x + mix * wetL, x + mix * wetR], axis=1)


# ------------------------------------------------------------------ music
CHORDS = [  # (bass midi, voicing)  D maj9 · B m9 · G maj9 · A6/9
    (38, [62, 66, 69, 73, 76]),
    (35, [59, 62, 66, 69, 73]),
    (31, [55, 59, 62, 66, 69]),
    (33, [57, 61, 64, 66, 71]),
]
BAR = 4 * BEAT
CHORD_LEN = 2 * BAR


def chord_at(sec):
    k = int(max(0, sec - GRID0) // CHORD_LEN) % len(CHORDS)
    return CHORDS[k]


def music():
    L = np.zeros(N)

    # Air: barely-there filtered noise so the opening isn't digital silence.
    air = bp(rng.standard_normal(N), 2500, 9000) * 0.004
    L += air * ramp([(0, 0), (0.6, 0.6), (3, 1), (26, 0.6), (29.5, 0.2), (30, 0)])

    # Warm sub drone following the chord roots.
    sub = np.zeros(N)
    phase = 0.0
    for i in range(N):
        pass
    freqs = np.array([midi(chord_at(s)[0] + 12) if s >= GRID0 else midi(38 + 12) for s in t_all[::480]])
    freqs = np.repeat(freqs, 480)[:N]
    freqs = lp(freqs, 3)  # glide between roots
    phase = np.cumsum(2 * np.pi * freqs / SR)
    sub = np.sin(phase) + 0.18 * np.sin(2 * phase)
    L += 0.16 * sub * ramp([(0, 0), (0.8, 0.25), (3.3, 0.55), (3.8, 1), (25.8, 1), (26.6, 0.55), (28.3, 0.45), (29.7, 0.12), (30, 0)])

    # Pad: detuned saws through a gentle low-pass, one voicing per chord.
    pad = np.zeros(N)
    for k in range(8):
        start = GRID0 - 0.6 + k * CHORD_LEN
        if start > 29.5:
            break
        dur = CHORD_LEN + 1.2
        n = int(dur * SR)
        tt = np.arange(n) / SR
        _, voicing = CHORDS[k % 4]
        x = np.zeros(n)
        for m in voicing:
            for det in (-0.07, 0.07):
                f = midi(m + det)
                x += signal.sawtooth(2 * np.pi * f * tt + rng.uniform(0, 6.28)) * 0.5
        x = lp(x, 1100, 2) * env_adsr(n, 1.2, 0.5, 0.85, 1.4)
        place(pad, x, max(0, start))
    L += 0.022 * pad * ramp([(0, 0), (2.8, 0), (4.2, 0.7), (10.8, 0.75), (11.6, 1.1), (15.8, 1.0), (16.5, 0.8), (23.0, 0.95), (25.8, 0.9), (26.6, 0.5), (28.2, 0.4), (29.6, 0.1), (30, 0)])

    # Clean synth pulses on eighths, arpeggiating the chord.
    pulses = np.zeros(N)
    step = BEAT / 2
    k = 0
    while GRID0 + k * step < 26.0:
        at = GRID0 + k * step
        _, voicing = chord_at(at + 0.01)
        note = voicing[[0, 2, 4, 1, 3, 2, 4, 1][k % 8]] + 12
        n = int(0.32 * SR)
        tt = np.arange(n) / SR
        f = midi(note)
        x = (np.sin(2 * np.pi * f * tt) + 0.3 * signal.sawtooth(2 * np.pi * f * tt, 0.5)) * np.exp(-tt * 14)
        x = lp(x, 3200)
        vel = 0.75 if k % 2 == 0 else 0.5
        place(pulses, x * vel, at)
        k += 1
    L += 0.03 * pulses * ramp([(0, 0), (3.5, 0), (4.4, 0.55), (7.2, 0.8), (11.2, 0.9), (16, 0.85), (23, 1.0), (25.6, 0.8), (26.1, 0), (30, 0)])

    # Restrained percussion: soft sine kick on 1 & 3, quiet shaker-tick offbeats.
    drums = np.zeros(N)
    b = 0
    while GRID0 + b * BEAT < 26.0:
        at = GRID0 + b * BEAT
        if at >= 7.35 and b % 2 == 0:
            n = int(0.35 * SR)
            tt = np.arange(n) / SR
            f = 46 + 70 * np.exp(-tt * 28)
            kick = np.sin(2 * np.pi * np.cumsum(f) / SR) * np.exp(-tt * 9)
            place(drums, kick * 0.9, at)
        if 7.35 <= at < 23.4:
            n = int(0.05 * SR)
            tt = np.arange(n) / SR
            tick = hp(rng.standard_normal(n), 7000) * np.exp(-tt * 90)
            place(drums, tick * 0.12, at + BEAT / 2)
        b += 1
    L += 0.2 * drums * ramp([(0, 1), (15.6, 1), (16.2, 0.6), (17.0, 1), (25.6, 1), (26, 0), (30, 0)])

    # Resolve: one warm D maj9 bloom under the logo, long tail into silence.
    n = int(2.2 * SR)
    tt = np.arange(n) / SR
    x = np.zeros(n)
    for m in [50, 57, 62, 66, 69, 76]:
        x += np.sin(2 * np.pi * midi(m) * tt) * (1.0 if m < 60 else 0.55)
    x *= env_adsr(n, 0.35, 0.4, 0.6, 1.3)
    bloom = np.zeros(N)
    place(bloom, lp(x, 2400), 28.35)
    L += 0.05 * bloom

    return stereo_verb(lp(L, 14000), decay=2.6, mix=0.35)


# ------------------------------------------------------------------ sfx
def sfx():
    S = np.zeros(N)

    def whoosh(at, dur, lo, hi, gain, reverse=False):
        n = int(dur * SR)
        tt = np.arange(n) / SR
        e = np.sin(np.pi * tt / dur) ** 2
        if reverse:
            e = (tt / dur) ** 2 * np.exp(-(1 - tt / dur) * 0)
            e *= np.where(tt > dur * 0.92, (dur - tt) / (dur * 0.08), 1)
        x = bp(rng.standard_normal(n), lo, hi) * e
        place(S, x * gain, at)

    def tone(at, freqs, dur, gain, decay=6.0, attack=0.004):
        n = int(dur * SR)
        tt = np.arange(n) / SR
        x = sum(np.sin(2 * np.pi * f * tt) * (0.6 ** i) for i, f in enumerate(freqs))
        e = np.minimum(1, tt / attack) * np.exp(-tt * decay)
        place(S, x * e * gain, at)

    def tick(at, gain=0.05, f=2600):
        n = int(0.03 * SR)
        tt = np.arange(n) / SR
        x = np.sin(2 * np.pi * f * tt) * np.exp(-tt * 260) + hp(rng.standard_normal(n), 4000) * np.exp(-tt * 400) * 0.3
        place(S, x * gain, at)

    def thock(at, gain=0.08):
        n = int(0.18 * SR)
        tt = np.arange(n) / SR
        f = 150 + 90 * np.exp(-tt * 40)
        x = np.sin(2 * np.pi * np.cumsum(f) / SR) * np.exp(-tt * 26)
        place(S, x * gain, at)
        tick(at, gain * 0.4, 3200)

    def glass(at, gain=0.03):
        tone(at, [2093, 3136, 4186, 5274], 1.4, gain, decay=3.2, attack=0.03)

    # 0:00 device movement and screen wake
    whoosh(0.7, 2.6, 60, 420, 0.05)
    glass(1.32, 0.018)
    tone(1.95, [880, 1320], 0.9, 0.012, decay=4)  # the `d.` ring closing
    # 0:03 dashboard
    whoosh(3.5, 0.9, 300, 3000, 0.008)
    tone(5.35, [1318.5, 1975.5], 0.6, 0.012, decay=7)  # balance settles
    # bridge: balance → transaction, placement
    whoosh(6.75, 0.8, 800, 5000, 0.01)
    thock(7.6, 0.06)
    tick(9.02, 0.035)  # tap on the dinner row
    # Bagilah
    whoosh(10.1, 1.0, 400, 6000, 0.018)
    glass(10.95, 0.014)
    for i, m in enumerate([74, 78, 81, 85]):
        tone(11.35 + i * 0.2, [midi(m)], 0.5, 0.009, decay=8)
    for i, m in enumerate([62, 69, 74, 78]):  # connections
        tone(12.4 + i * 0.1, [midi(m + 12)], 0.9, 0.008, decay=5, attack=0.01)
    for i in range(4):  # each share arrives
        tick(12.95 + i * 0.22 + 0.72, 0.03, 2200 + i * 180)
    whoosh(15.55, 1.1, 300, 4000, 0.016, reverse=True)
    # Analytics
    thock(17.02, 0.04)
    tone(17.05, [midi(81), midi(88)], 0.9, 0.008, decay=5)
    tick(18.95, 0.03)
    # Assistant
    whoosh(20.15, 0.8, 1200, 8000, 0.012)
    glass(20.25, 0.02)
    tick(21.25, 0.035, 3000)  # send
    tone(21.72, [midi(86), midi(90)], 0.7, 0.012, decay=6)  # answer arrives
    # Universe
    whoosh(23.05, 1.4, 150, 2500, 0.03)
    whoosh(25.2, 0.9, 200, 3500, 0.02, reverse=True)
    # End
    whoosh(28.0, 1.4, 60, 300, 0.03)
    tone(28.4, [midi(74), midi(81), midi(86)], 2.2, 0.012, decay=1.6, attack=0.05)
    return stereo_verb(S, decay=1.6, mix=0.3)


# ------------------------------------------------------------------ guide VO
LINES = json.loads((Path(__file__).resolve().parent / 'vo_lines.json').read_text())['lines']
VO_DIR = OUT / 'vo'


def vo_guide(voice='Karen', rate=158):
    V = np.zeros(N)
    cues = []
    with tempfile.TemporaryDirectory() as d:
        for i, line in enumerate(LINES):
            text, at = line['guide'], line['start']
            f = Path(d) / f'l{i}.wav'
            subprocess.run(['say', '-v', voice, '-r', str(rate), '--file-format=WAVE', '--data-format=LEI16@48000', '-o', str(f), text], check=True)
            import warnings
            with warnings.catch_warnings():
                warnings.simplefilter('ignore')
                sr, x = wavfile.read(f)
            x = x.astype(np.float64) / 32768
            if x.ndim > 1:
                x = x.mean(axis=1)
            nz = np.nonzero(np.abs(x) > 0.004)[0]
            x = x[nz[0]: nz[-1] + 1] if len(nz) else x
            x = hp(x, 90)
            place(V, x, at)
            cues.append({'text': line['text'], 'start': at, 'end': round(at + len(x) / SR, 2)})
    (OUT / 'vo_cues.json').write_text(json.dumps(cues, indent=2))
    return np.stack([V, V], axis=1), cues


def vo_recorded():
    """Narrator takes from public/audio/vo/<id>.wav (e.g. scripts/elevenlabs_vo.py), placed at cue times."""
    paths = [VO_DIR / f"{l['id']}.wav" for l in LINES]
    if not all(p.exists() for p in paths):
        return None, None
    V = np.zeros(N)
    cues = []
    for line, p in zip(LINES, paths):
        sr, x = wavfile.read(p)
        x = x.astype(np.float64) / 32768
        if x.ndim > 1:
            x = x.mean(axis=1)
        if sr != SR:
            x = signal.resample_poly(x, SR, sr)
        x = hp(x, 80)
        place(V, x, line['start'])
        cues.append({'text': line['text'], 'start': line['start'], 'end': round(line['start'] + len(x) / SR, 2)})
    return np.stack([V, V], axis=1), cues


# ------------------------------------------------------------------ loudness (ITU-R BS.1770-4)
def k_weight(x):
    # Pre-filter (high shelf) + RLB high-pass, coefficients for 48 kHz.
    b1 = [1.53512485958697, -2.69169618940638, 1.19839281085285]
    a1 = [1.0, -1.69065929318241, 0.73248077421585]
    b2 = [1.0, -2.0, 1.0]
    a2 = [1.0, -1.99004745483398, 0.99007225036621]
    return signal.lfilter(b2, a2, signal.lfilter(b1, a1, x, axis=0), axis=0)


def lufs(x):
    y = k_weight(x)
    blk, hop = int(0.4 * SR), int(0.1 * SR)
    powers = []
    for i in range(0, len(y) - blk, hop):
        seg = y[i: i + blk]
        powers.append(np.sum(np.mean(seg ** 2, axis=0)))
    powers = np.array(powers)
    loud = -0.691 + 10 * np.log10(powers + 1e-12)
    p = powers[loud > -70]
    rel = -0.691 + 10 * np.log10(np.mean(p)) - 10
    p = powers[(loud > -70) & (loud > rel)]
    return -0.691 + 10 * np.log10(np.mean(p))


def gain_to(x, target):
    return x * 10 ** ((target - lufs(x)) / 20)


def limit(x, ceiling_db=-1.0):
    c = 10 ** (ceiling_db / 20)
    # 4x oversampled peak estimate, then soft knee.
    return c * np.tanh(x / c)


def master(stems, target=-14.0):
    mix = sum(stems)
    # Dynamic space before the logo: the 26-30 s section sits ~3.5 dB lower.
    mix = mix * ramp([(0, 1), (25.8, 1), (26.6, 10 ** (-3.5 / 20)), (30, 10 ** (-3.5 / 20))])[:, None]
    mix = gain_to(mix, target)
    for _ in range(3):  # limiting lowers loudness a touch; converge
        mix = limit(mix)
        mix = gain_to(mix, target)
    mix = limit(mix)
    fade = np.ones(N)
    fade[-int(0.12 * SR):] = np.linspace(1, 0, int(0.12 * SR))
    return mix * fade[:, None]


def write(name, x):
    wavfile.write(OUT / name, SR, (np.clip(x, -1, 1) * 32767).astype(np.int16))


def with_vo(m, fx, v, cues):
    """VO dominant, music ~8 dB under it and ducked ~3 dB while speaking, SFX under both."""
    v = gain_to(v, -18.0)
    speaking = np.zeros(N)
    for c in cues:
        speaking[max(0, int((c['start'] - 0.15) * SR)): int((c['end'] + 0.2) * SR)] = 1
    duck = 10 ** (-3 / 20) + (1 - 10 ** (-3 / 20)) * (1 - lp(speaking, 4, 1))
    return master([m * duck[:, None], fx, v]), v


def report(name, x):
    tail = slice(int(26 * SR), N)
    head = slice(int(4 * SR), int(26 * SR))
    print(f'{name}: integrated {lufs(x):.1f} LUFS, peak {20*np.log10(np.max(np.abs(x))):.1f} dBFS, '
          f'4-26 s {lufs(x[head]):.1f} LUFS, 26-30 s {lufs(x[tail]):.1f} LUFS')


if __name__ == '__main__':
    m = gain_to(music(), -26.0)
    fx = gain_to(sfx(), -31.0)
    write('music.wav', m)
    write('sfx.wav', fx)

    novo = master([m, fx * 1.1])
    write('mix_no_vo.wav', novo)
    report('mix_no_vo', novo)

    g, gcues = vo_guide()
    guide, gv = with_vo(m, fx, g, gcues)
    write('vo_guide.wav', gv)
    write('mix_guide_vo.wav', guide)
    report('mix_guide_vo', guide)

    r, rcues = vo_recorded()
    if r is None:
        print('mix_vo: skipped (no narrator takes in public/audio/vo/ yet; run scripts/elevenlabs_vo.py)')
    else:
        final, rv = with_vo(m, fx, r, rcues)
        write('vo.wav', rv)
        write('mix_vo.wav', final)
        report('mix_vo', final)
        print(f'VO vs music: {lufs(rv) - lufs(m):.1f} dB')
        (OUT / 'vo_cues.json').write_text(json.dumps(rcues, indent=2))
