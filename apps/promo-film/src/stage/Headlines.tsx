import React from 'react';
import {entry, FONT} from '../theme';
import {COPY} from '../timeline';
import {ease, inOut, prog, s} from '../anim';
import {Layout} from '../camera';

// One idea per scene. Masked rise-in, quiet fade-out.
const Line: React.FC<{text: string; p: number; out: number; style: React.CSSProperties}> = ({text, p, out, style}) => (
  <div style={{overflow: 'hidden', paddingBottom: '0.08em', marginBottom: '-0.08em'}}>
    <div
      style={{
        ...style,
        transform: `translateY(${(1 - p) * 105 - out * 18}%)`,
        opacity: Math.min(1, p * 1.6) * (1 - out),
        filter: p < 1 ? `blur(${(1 - p) * 6}px)` : undefined,
      }}
    >
      {text}
    </div>
  </div>
);

export const Headlines: React.FC<{sec: number; layout: Layout; w: number; h: number}> = ({sec, layout, w, h}) => {
  const f = s(sec);
  const portrait = layout === 'portrait';
  return (
    <>
      {COPY.map((c, i) => {
        const [a, b] = c.at;
        if (sec < a - 0.05 || sec > b + 0.05) return null;
        const pin = prog(f, a, a + 0.75, ease);
        const out = prog(f, b - 0.45, b, inOut);
        const sub = c.sub ? prog(f, c.subAt ?? a + 0.3, (c.subAt ?? a + 0.3) + 0.7, ease) : 0;
        const size = (portrait ? 88 : 80) * (c.size ?? 1);
        // Landscape recomposition: copy sits left of the device; the montage headline spans the top.
        const centred = portrait || c.h === 'More than tracking.';
        const box: React.CSSProperties = portrait
          ? {left: 90, right: 90, top: 262, textAlign: 'center'}
          : centred
            ? {left: 160, right: 160, top: 72, textAlign: 'center'}
            : {left: 150, width: 820, top: h / 2 - (c.sub ? 120 : 70), textAlign: 'left'};
        return (
          <div key={i} style={{position: 'absolute', ...box, fontFamily: FONT, zIndex: 90}}>
            <Line
              text={c.h}
              p={pin}
              out={out}
              style={{
                fontSize: size,
                fontWeight: 800,
                letterSpacing: '-0.035em',
                lineHeight: 1.04,
                color: entry.text,
                textWrap: 'balance',
              }}
            />
            {c.sub && (
              <div
                style={{
                  marginTop: portrait ? 22 : 24,
                  fontSize: portrait ? 36 : 32,
                  fontWeight: 500,
                  letterSpacing: '-0.01em',
                  color: entry.textMuted,
                  opacity: sub * (1 - out),
                  transform: `translateY(${(1 - sub) * 14}px)`,
                }}
              >
                {c.sub}
              </div>
            )}
          </div>
        );
      })}
    </>
  );
};
