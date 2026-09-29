import React from 'react';
import {entry, FONT} from '../theme';
import {T} from '../timeline';
import {ease, inOut, lerp, prog, s} from '../anim';
import {Layout} from '../camera';
import {Signal} from '../ui/Entry';
import {Easing} from 'remotion';

// The end lockup reuses the app's own `d.` signal (ring draws once, one
// highlight travels, one pulse) above the `duitlah.` wordmark.
const curve = Easing.bezier(0.22, 1, 0.36, 1);

export const EndCard: React.FC<{sec: number; layout: Layout; w: number; h: number}> = ({sec, layout, w, h}) => {
  const f = s(sec);
  if (sec < T.logo[0]) return null;
  const at = (a: number, b: number) => curve(Math.min(1, Math.max(0, (sec - a) / (b - a))));
  const L = T.logo[0];
  const sig = {
    wordmark: 0,
    wordmarkRise: 0,
    wordmarkTracking: 0,
    signal: at(L, L + 0.5),
    signalScale: lerp(0.9, 1, at(L, L + 0.7)),
    ring: at(L + 0.05, L + 0.75),
    travel: at(L + 0.15, L + 1.05),
    pulse: at(L + 0.75, L + 1.25),
    glyph: at(L + 0.05, L + 0.45),
    depth: 1,
    sweep: 0,
    curtain: 1,
    rise: 0,
    child: 1,
    childScale: 1,
  };
  const portrait = layout === 'portrait';
  const d = portrait ? 170 : 140;
  const word = prog(f, L + 0.2, L + 0.75, ease);
  const tag = prog(f, L + 0.35, L + 0.95, ease);
  const cy = portrait ? h * 0.44 : h * 0.4;
  return (
    <div style={{position: 'absolute', inset: 0, fontFamily: FONT, zIndex: 95}}>
      <div style={{position: 'absolute', left: w / 2 - d / 2, top: cy - d - 40, opacity: sig.signal, transform: `scale(${sig.signalScale})`}}>
        <div style={{width: 88, height: 88, zoom: d / 88}}>
          <Signal f={sig} />
        </div>
      </div>
      <div
        style={{
          position: 'absolute',
          left: 0,
          right: 0,
          top: cy + 10,
          textAlign: 'center',
          fontSize: portrait ? 132 : 112,
          fontWeight: 600,
          letterSpacing: `${lerp(0.04, -0.01, word)}em`,
          lineHeight: 1,
          color: entry.text,
          opacity: word,
          transform: `translateY(${16 * (1 - word)}px)`,
        }}
      >
        duitlah.
      </div>
      <div
        style={{
          position: 'absolute',
          left: 80,
          right: 80,
          top: cy + (portrait ? 190 : 160),
          textAlign: 'center',
          fontSize: portrait ? 40 : 36,
          fontWeight: 500,
          color: entry.textMuted,
          opacity: tag,
          transform: `translateY(${12 * (1 - tag)}px)`,
        }}
      >
        Your money. Finally makes sense.
      </div>
    </div>
  );
};
