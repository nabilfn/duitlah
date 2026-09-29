import {Easing, interpolate} from 'remotion';

export const FPS = 30;
export const s = (sec: number) => Math.round(sec * FPS);

// The app's single motion curve: cubic-bezier(0.22, 1, 0.36, 1). Soft, no overshoot.
export const ease = Easing.bezier(0.22, 1, 0.36, 1);
// Long camera moves: symmetric, weighted.
export const glide = Easing.bezier(0.45, 0, 0.2, 1);
export const settle = Easing.bezier(0.33, 0, 0.12, 1);
export const inOut = Easing.bezier(0.65, 0, 0.35, 1);

/** 0→1 progress of `frame` between two times in seconds, eased. */
export const prog = (frame: number, from: number, to: number, easing = ease) =>
  interpolate(frame / FPS, [from, to], [0, 1], {
    extrapolateLeft: 'clamp',
    extrapolateRight: 'clamp',
    easing,
  });

export const lerp = (a: number, b: number, t: number) => a + (b - a) * t;
export const clamp01 = (v: number) => Math.min(1, Math.max(0, v));

/** Visible window with eased in/out fades, in seconds. */
export const windowed = (frame: number, a: number, b: number, fadeIn = 0.4, fadeOut = 0.4) =>
  prog(frame, a, a + fadeIn) * (1 - prog(frame, b - fadeOut, b, inOut));

export type Key = {t: number; v: number[]; e?: (x: number) => number};

/** Keyframed vector with per-segment easing (easing belongs to the segment ending at a key). */
export const track = (keys: Key[], sec: number): number[] => {
  if (sec <= keys[0].t) return keys[0].v;
  for (let i = 1; i < keys.length; i++) {
    const a = keys[i - 1];
    const b = keys[i];
    if (sec <= b.t) {
      const raw = (sec - a.t) / (b.t - a.t);
      const t = (b.e ?? glide)(raw);
      return a.v.map((x, j) => lerp(x, b.v[j], t));
    }
  }
  return keys[keys.length - 1].v;
};
