import React from 'react';
import {Easing} from 'remotion';
import {entry, FONT} from '../theme';
import {lerp} from '../anim';

// Port of EntryFrame.at + EntryEnvironmentPainter + DuitlahSignalPainter
// (features/splash). Same stages and curve; the film plays it at 2x duration.
const curve = Easing.bezier(0.22, 1, 0.36, 1);
const outCubic = Easing.out(Easing.cubic);

export const entryFrame = (ms: number) => {
  const at = (a: number, b: number) => curve(Math.min(1, Math.max(0, (ms - a) / (b - a))));
  return {
    wordmark: at(0, 350) * (1 - at(430, 690)),
    wordmarkRise: 16 * (1 - at(0, 350)) - 22 * at(430, 690),
    wordmarkTracking: 3 * (1 - at(0, 430)),
    signal: at(370, 690) * (1 - at(1000, 1120)),
    signalScale: lerp(0.86, 1, at(370, 780)) * lerp(1, 0.92, at(1000, 1120)),
    ring: at(410, 860),
    travel: at(490, 990),
    pulse: at(850, 1170),
    glyph: at(400, 650),
    depth: at(0, 700),
    sweep: at(220, 1200),
    curtain: 1 - at(1100, 1320),
    rise: 40 * at(1100, 1320),
    child: at(1090, 1320),
    childScale: lerp(0.99, 1, at(1090, 1340)),
  };
};
export type EntryFrame = ReturnType<typeof entryFrame>;

const W = 390;
const H = 844;

const Signal: React.FC<{f: EntryFrame; d?: number}> = ({f, d = 88}) => {
  const r = d / 2 - 1;
  const c = d / 2;
  const circ = 2 * Math.PI * r;
  const segs = 14;
  const span = Math.PI * 0.38;
  const head = -Math.PI / 2 + Math.PI * 2 * f.travel;
  const pulseR = r * lerp(1, 1.34, outCubic(f.pulse));
  return (
    <div style={{position: 'relative', width: d, height: d}}>
      <svg width={d} height={d} style={{position: 'absolute', inset: 0, overflow: 'visible'}}>
        <defs>
          <radialGradient id="sigfill">
            <stop offset="0" stopColor={entry.blue} stopOpacity={0.1 * f.ring} />
            <stop offset="0.62" stopColor={entry.blue} stopOpacity={0.02 * f.ring} />
            <stop offset="1" stopColor={entry.blue} stopOpacity={0} />
          </radialGradient>
        </defs>
        <circle cx={c} cy={c} r={r} fill="url(#sigfill)" />
        {f.pulse > 0 && f.pulse < 1 && (
          <circle cx={c} cy={c} r={pulseR} fill="none" stroke={entry.blue} strokeOpacity={0.22 * (1 - f.pulse)} strokeWidth={1} />
        )}
        {f.ring > 0 && (
          <circle
            cx={c}
            cy={c}
            r={r}
            fill="none"
            stroke={entry.blue}
            strokeOpacity={0.42}
            strokeWidth={1.1}
            strokeLinecap="round"
            strokeDasharray={`${circ * f.ring} ${circ}`}
            transform={`rotate(-90 ${c} ${c})`}
          />
        )}
        {f.travel > 0 &&
          f.travel < 1 &&
          Array.from({length: segs}).map((_, i) => {
            const a0 = head - span + (span * i) / segs;
            const a1 = head - span + (span * (i + 1)) / segs;
            return (
              <path
                key={i}
                d={`M${c + r * Math.cos(a0)} ${c + r * Math.sin(a0)} A${r} ${r} 0 0 1 ${c + r * Math.cos(a1)} ${c + r * Math.sin(a1)}`}
                stroke={entry.text}
                strokeOpacity={(0.85 * (i + 1)) / segs}
                strokeWidth={1.4}
                strokeLinecap="round"
                fill="none"
              />
            );
          })}
      </svg>
      <div
        style={{
          position: 'absolute',
          inset: 0,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          fontFamily: FONT,
          fontWeight: 600,
          fontSize: d * 0.34,
          color: entry.text,
          opacity: f.glyph,
          lineHeight: 1,
          paddingBottom: d * 0.03,
        }}
      >
        d.
      </div>
    </div>
  );
};

export const EntryEnvironment: React.FC<{depth: number; sweep: number; w?: number; h?: number}> = ({
  depth,
  sweep,
  w = W,
  h = H,
}) => {
  const focusY = h * 0.42 + 4 * (1 - depth);
  const R = Math.min(w, h) * 0.92;
  const sweepY = h * (sweep * 1.4 - 0.2);
  return (
    <div style={{position: 'absolute', inset: 0, overflow: 'hidden'}}>
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background: `linear-gradient(180deg, ${entry.background} 0%, ${entry.background} 48%, ${entry.backgroundDeep} 100%)`,
        }}
      />
      <div
        style={{
          position: 'absolute',
          left: w / 2 - R,
          top: focusY - R,
          width: 2 * R,
          height: 2 * R,
          borderRadius: '50%',
          background: `radial-gradient(circle, rgba(120,181,255,${0.1 * depth}) 0%, rgba(120,181,255,${0.03 * depth}) 45%, rgba(0,0,0,0) 100%)`,
        }}
      />
      <svg width={w} height={h} style={{position: 'absolute', inset: 0}}>
        {[
          [1.35, 0.3],
          [1.9, 0.78],
        ].map(([scale, off], i) => {
          const rad = w * scale;
          const cx = w / 2;
          const cy = h * off + rad * 0.86;
          const a0 = Math.PI * 1.16;
          const a1 = a0 + Math.PI * 0.68;
          return (
            <path
              key={i}
              d={`M${cx + rad * Math.cos(a0)} ${cy + rad * Math.sin(a0)} A${rad} ${rad} 0 0 1 ${cx + rad * Math.cos(a1)} ${cy + rad * Math.sin(a1)}`}
              stroke={entry.blueSoft}
              strokeOpacity={0.05 * depth}
              fill="none"
              strokeWidth={1}
            />
          );
        })}
      </svg>
      {sweep > 0 && sweep < 1 && (
        <div
          style={{
            position: 'absolute',
            left: 0,
            right: 0,
            top: sweepY - h * 0.17,
            height: h * 0.34,
            background: `linear-gradient(180deg, rgba(0,0,0,0), rgba(120,181,255,${0.05 * Math.sin(sweep * Math.PI)}), rgba(0,0,0,0))`,
          }}
        />
      )}
    </div>
  );
};

/** The navy entry layer that sits above Home and lifts away. */
export const EntryLayer: React.FC<{f: EntryFrame; wake: number}> = ({f, wake}) => {
  if (f.curtain <= 0) return null;
  const y = H / 2 + -0.16 * (H / 2);
  return (
    <div style={{position: 'absolute', inset: 0, opacity: f.curtain, transform: `translateY(${-f.rise}px)`, zIndex: 40}}>
      <div style={{position: 'absolute', inset: 0, opacity: wake}}>
        <EntryEnvironment depth={f.depth} sweep={f.sweep} />
      </div>
      {f.signal > 0 && (
        <div
          style={{
            position: 'absolute',
            left: W / 2 - 44,
            top: y - 44,
            opacity: f.signal,
            transform: `scale(${f.signalScale})`,
          }}
        >
          <Signal f={f} />
        </div>
      )}
      {f.wordmark > 0 && (
        <div
          style={{
            position: 'absolute',
            left: 0,
            right: 0,
            top: y - 20,
            textAlign: 'center',
            fontFamily: FONT,
            fontWeight: 600,
            fontSize: 40,
            lineHeight: 1,
            color: entry.text,
            letterSpacing: f.wordmarkTracking,
            opacity: f.wordmark,
            transform: `translateY(${f.wordmarkRise}px)`,
          }}
        >
          duitlah.
        </div>
      )}
    </div>
  );
};

export {Signal};
