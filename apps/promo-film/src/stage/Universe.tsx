import React from 'react';
import {dark} from '../theme';
import {T} from '../timeline';
import {ease, inOut, lerp, prog, s} from '../anim';
import {cssPerspective, Layout, poseAt} from '../camera';
import {AccountsMini, BudgetsMini, BusinessMini, GoalsMini, WrappedMini} from '../ui/MiniScreens';
import {BagilahTab} from '../ui/Bagilah';

// "More than tracking": real destinations briefly occupy different depths around
// the device, then converge back into it. World units, same camera as the phone.

type Frag = {C: React.FC; p: number[]; ry: number; crop: number};
const portraitFrags: Frag[] = [
  {C: BudgetsMini, p: [-3.35, 2.4, -5], ry: 14, crop: 520},
  {C: GoalsMini, p: [3.45, 3.1, -7], ry: -14, crop: 440},
  {C: WrappedMini, p: [-3.15, -2.7, -3.5], ry: 12, crop: 560},
  {C: BusinessMini, p: [3.25, -3.1, -4.5], ry: -12, crop: 540},
  {C: AccountsMini, p: [-1.25, 5.1, -15], ry: 6, crop: 420},
  {C: BagilahTab, p: [1.7, -7.3, -13.5], ry: -6, crop: 520},
];
const landscapeFrags: Frag[] = [
  {C: BudgetsMini, p: [-5.6, 1.4, -4], ry: 16, crop: 520},
  {C: GoalsMini, p: [6.3, 1.7, -6], ry: -16, crop: 440},
  {C: WrappedMini, p: [-10.4, -0.6, -8], ry: 18, crop: 560},
  {C: BusinessMini, p: [9.6, -1.6, -3.5], ry: -14, crop: 540},
  {C: AccountsMini, p: [-4.3, -3.4, -2], ry: 10, crop: 420},
  {C: BagilahTab, p: [4.4, -4.6, -12], ry: -12, crop: 520},
];

export const Universe: React.FC<{sec: number; layout: Layout; w: number; h: number; layer: 'back' | 'front'}> = ({
  sec,
  layout,
  w,
  h,
  layer,
}) => {
  const f = s(sec);
  if (sec < T.fragmentsOut[0] || sec > T.fragmentsIn[1] + 0.05) return null;
  const {pxPerUnit, perspective} = cssPerspective(h);
  const phone = poseAt(layout, sec);
  const frags = layout === 'portrait' ? portraitFrags : landscapeFrags;
  const scale = layout === 'portrait' ? 0.54 : 1.1;
  return (
    <div style={{position: 'absolute', inset: 0, perspective, perspectiveOrigin: '50% 50%', overflow: 'hidden'}}>
      {frags.map((fr, i) => {
        const behind = fr.p[2] < phone[2];
        if ((layer === 'back') !== behind) return null;
        const out = prog(f, T.fragmentsOut[0] + i * 0.1, T.fragmentsOut[0] + i * 0.1 + 1.0, ease);
        const back = prog(f, T.fragmentsIn[0] + (5 - i) * 0.06, T.fragmentsIn[0] + (5 - i) * 0.06 + 0.62, inOut);
        const drift = prog(f, T.fragmentsOut[1], T.fragmentsIn[0] + 0.3, (x) => x);
        const origin = [phone[0], phone[1], phone[2]];
        const target = [fr.p[0], fr.p[1], fr.p[2] + 0.9 * drift];
        const t = out * (1 - back);
        const pos = [lerp(origin[0], target[0], t), lerp(origin[1], target[1], t), lerp(origin[2], target[2], t)];
        const sc = lerp(0.35, 1, t);
        const cw = 390;
        const chh = fr.crop;
        const zoom = pxPerUnit * 0.01 * scale;
        return (
          <div
            key={i}
            style={{
              position: 'absolute',
              left: w / 2 - (cw * zoom) / 2,
              top: h / 2 - (chh * zoom) / 2,
              width: cw * zoom,
              height: chh * zoom,
              transform: `translate3d(${pos[0] * pxPerUnit}px, ${-pos[1] * pxPerUnit}px, ${pos[2] * pxPerUnit}px) rotateY(${fr.ry * t + drift * 3}deg) scale(${sc})`,
              opacity: Math.min(1, t * 1.8),
            }}
          >
            <div
              style={{
                width: cw,
                height: chh,
                zoom,
                position: 'relative',
                borderRadius: 30,
                overflow: 'hidden',
                border: '1px solid rgba(255,255,255,0.09)',
                boxShadow: '0 30px 80px rgba(0,0,0,0.55)',
                background: dark.background,
              }}
            >
              <div style={{position: 'absolute', left: 0, top: -24, width: 390, height: 844}}>
                <fr.C />
              </div>
              <div style={{position: 'absolute', left: 0, right: 0, top: 0, height: 1, background: 'rgba(255,255,255,0.12)'}} />
            </div>
          </div>
        );
      })}
    </div>
  );
};
