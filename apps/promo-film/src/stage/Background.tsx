import React from 'react';
import {T} from '../timeline';
import {inOut, prog, s} from '../anim';
import {Layout} from '../camera';

// Near-black navy studio. The only light in the room is a soft blue pool,
// matching the entry environment's radial depth. No particles, no loops.
export const Background: React.FC<{sec: number; layout: Layout; w: number; h: number}> = ({sec, layout, w, h}) => {
  const f = s(sec);
  const wake = prog(f, T.wakePool[0], T.wakePool[1], inOut);
  const hero = prog(f, 26.0, 27.2, inOut) * (1 - prog(f, 28.6, 29.8, inOut)) * 0.35;
  const end = prog(f, 28.4, 29.4, inOut);
  const portrait = layout === 'portrait';
  const cx = portrait ? 50 : 66;
  const cy = portrait ? 60 : 50;
  const endCx = 50;
  const endCy = portrait ? 40 : 38;
  const x = cx + (endCx - cx) * end;
  const y = cy + (endCy - cy) * end;
  return (
    <div style={{position: 'absolute', inset: 0, background: '#03050A', overflow: 'hidden'}}>
      <div
        style={{
          position: 'absolute',
          inset: 0,
          opacity: 0.35 + 0.65 * wake,
          background: `radial-gradient(ellipse ${portrait ? '85% 55%' : '55% 80%'} at ${x}% ${y}%, rgba(22,44,72,${0.55 + hero}) 0%, rgba(10,22,38,0.55) 38%, rgba(3,5,10,0) 75%)`,
        }}
      />
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background: `radial-gradient(ellipse 120% 90% at 50% 50%, rgba(0,0,0,0) 55%, rgba(0,0,0,0.55) 100%)`,
        }}
      />
      {/* Before the wake, everything but a faint reflection is black. */}
      <div style={{position: 'absolute', inset: 0, background: '#000', opacity: 1 - wake * 0.92 - 0.08}} />
      <div style={{width: w, height: h}} />
    </div>
  );
};
