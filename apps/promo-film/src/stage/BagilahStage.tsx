import React from 'react';
import {dark, FONT, tabular, type} from '../theme';
import {bill, money} from '../data';
import {T} from '../timeline';
import {ease, glide, inOut, lerp, prog, s, settle} from '../anim';
import {Layout} from '../camera';
import {ParticipantNode} from '../ui/Bagilah';
import {DonutRing} from '../ui/Analytics';
import {liftedRowRect} from '../PhoneUI';

// Frame-space Bagilah: the Hotpot dinner row lifts off the device and becomes the
// bill (ForestSurface card from BillDetailScreen). Participants arrive as the app's
// own spatial nodes, the total divides along the connections, then the nodes
// collapse into the Analytics ring.

type Geo = {k: number; card: [number, number]; nodes: [number, number][]};
const geo = (layout: Layout): Geo =>
  layout === 'portrait'
    ? {k: 2.1, card: [540, 1085], nodes: [[250, 705], [838, 760], [226, 1455], [846, 1500]]}
    : {k: 1.55, card: [1300, 575], nodes: [[905, 300], [1700, 285], [925, 850], [1690, 865]]};

const CARD_W = 300;
const CARD_H = 142;

export const BagilahStage: React.FC<{
  sec: number;
  layout: Layout;
  project: (x: number, y: number) => number[];
  projectLand: (x: number, y: number) => number[];
}> = ({sec, layout, project, projectLand}) => {
  const f = s(sec);
  if (sec < T.lift[0] || sec > T.ringLand[1] + 0.1) return null;
  const g = geo(layout);
  const {k} = g;

  // 1) Row → card morph.
  const lift = prog(f, T.lift[0], T.lift[1], glide);
  const r = liftedRowRect(T.lift[0]);
  const a = project(r.x, r.y);
  const b = project(r.x + r.w, r.y + r.h);
  const from = {x: a[0], y: a[1], w: b[0] - a[0], h: b[1] - a[1]};
  const cw = CARD_W * k;
  const ch = CARD_H * k;
  const to = {x: g.card[0] - cw / 2, y: g.card[1] - ch / 2, w: cw, h: ch};
  const box = {x: lerp(from.x, to.x, lift), y: lerp(from.y, to.y, lift), w: lerp(from.w, to.w, lift), h: lerp(from.h, to.h, lift)};
  const rowFade = 1 - prog(f, T.lift[0] + 0.1, T.lift[0] + 0.4);
  const cardFade = prog(f, T.lift[0] + 0.35, T.lift[1] + 0.1);

  // 5) Collapse into the ring.
  const collapse = prog(f, T.collapse[0], T.collapse[1], inOut);
  const cardOut = 1 - prog(f, T.collapse[0], T.collapse[0] + 0.45, inOut);
  const ringReveal = prog(f, T.collapse[0] + 0.3, T.ringLand[1] - 0.1, glide);
  const land = prog(f, T.ringLand[0], T.ringLand[1], settle);
  const ringR0 = (220 * k) / 2;
  const target = projectLand(195, 632);
  const edge = projectLand(195 + 110, 632);
  const ringSize = lerp(220 * k * 1.05, (edge[0] - target[0]) * 2, land);
  const ringC = [lerp(g.card[0], target[0], land), lerp(g.card[1], target[1], land)];
  const ringOpacity = prog(f, T.collapse[0] + 0.25, T.collapse[0] + 0.55) * (1 - prog(f, T.ringLand[1] - 0.04, T.ringLand[1] + 0.08, (x) => x));

  const linksIn = prog(f, T.links[0], T.links[1], inOut);
  const linksOut = prog(f, 14.5, 15.3, inOut);

  const circleCentre = (n: [number, number]) => [n[0], n[1] - (72 / 2 + 22) * k + 36 * k];

  return (
    <div style={{position: 'absolute', inset: 0, fontFamily: FONT, zIndex: 70}}>
      {/* Connections */}
      <svg style={{position: 'absolute', inset: 0, width: '100%', height: '100%', overflow: 'visible'}}>
        {g.nodes.map((n, i) => {
          const cc = circleCentre(n);
          // Stop at the circle's edge: the node is translucent glass.
          const full = Math.hypot(cc[0] - g.card[0], cc[1] - g.card[1]);
          const trim = (30 + 3) * k;
          const c = [cc[0] - ((cc[0] - g.card[0]) / full) * trim, cc[1] - ((cc[1] - g.card[1]) / full) * trim];
          const len = full - trim;
          const p = Math.min(1, Math.max(0, linksIn * 1.4 - i * 0.12));
          return (
            <line
              key={i}
              x1={g.card[0]}
              y1={g.card[1]}
              x2={c[0]}
              y2={c[1]}
              stroke={dark.balanceHighlight}
              strokeOpacity={0.32 * (1 - linksOut) * (1 - collapse)}
              strokeWidth={1.6 * k}
              strokeDasharray={`${len * p} ${len}`}
            />
          );
        })}
      </svg>

      {/* Row → bill card */}
      {cardOut > 0.001 && (
        <div
          style={{
            position: 'absolute',
            left: box.x,
            top: box.y,
            width: box.w,
            height: box.h,
            borderRadius: lerp(14 * (from.w / 374), 22 * k, lift),
            background: `rgba(22,38,59,${lerp(0.55, 1, lift)})`,
            boxShadow: `0 ${40 * lift}px ${90 * lift}px rgba(0,0,0,${0.5 * lift})`,
            opacity: cardOut,
            transform: `scale(${lerp(1, 0.8, 1 - cardOut)})`,
            overflow: 'hidden',
          }}
        >
          {rowFade > 0 && (
            <div style={{position: 'absolute', left: 0, top: 0, width: 374, opacity: rowFade, padding: '14px 12px', zoom: from.w / 374}}>
              <div style={{display: 'flex', color: dark.textPrimary}}>
                <div style={{width: 190}}>
                  <div style={type.titleSmall}>{bill.merchant}</div>
                  <div style={{...type.bodySmall, color: dark.textSecondary, marginTop: 3}}>Expense · Maybank</div>
                </div>
                <div style={{...type.titleSmall, marginLeft: 8, marginTop: 10}}>{money(bill.total, {sign: '−'})}</div>
              </div>
            </div>
          )}
          <div style={{position: 'absolute', left: 0, top: 0, width: CARD_W, height: CARD_H, zoom: k, opacity: cardFade}}>
            <div style={{padding: 24, color: dark.balanceText}}>
              <div style={{fontSize: 16}}>{bill.merchant}</div>
              <div style={{height: 8}} />
              <div style={{...type.headlineMedium, ...tabular}}>{money(bill.total)}</div>
              <div style={{height: 8}} />
              <div style={{fontSize: 13, color: dark.balanceSecondary}}>Your shared expense, all in one place.</div>
            </div>
          </div>
        </div>
      )}

      {/* Participants */}
      {g.nodes.map((n, i) => {
        const t0 = T.nodes[0] + i * 0.2;
        const appear = prog(f, t0, t0 + 0.75, ease);
        if (appear <= 0) return null;
        const drift = Math.sin(sec * 0.9 + i * 1.7) * 5 * k * 0.4;
        const out = [lerp(g.card[0], n[0], 0.55 + 0.45 * appear), lerp(g.card[1], n[1], 0.55 + 0.45 * appear) + drift];
        // Collapse: each node travels onto the ring and dissolves into a segment.
        const ang = -Math.PI / 2 + (i / g.nodes.length) * Math.PI * 2 + 0.4;
        const ringPt = [g.card[0] + ringR0 * 0.85 * Math.cos(ang), g.card[1] + ringR0 * 0.85 * Math.sin(ang) + 36 * k];
        const pos = [lerp(out[0], ringPt[0], collapse), lerp(out[1], ringPt[1], collapse)];
        const t1 = T.divide[0] + i * 0.22;
        const arrived = prog(f, t1 + 0.55, t1 + 0.85);
        const person = bill.people[i];
        return (
          <div
            key={person.name}
            style={{
              position: 'absolute',
              left: pos[0] - 48 * k,
              top: pos[1] - 36 * k,
              opacity: appear * (1 - prog(f, T.collapse[0] + 0.2, T.collapse[0] + 0.7)),
              transform: `scale(${lerp(0.72, 1, appear) * lerp(1, 0.4, collapse)})`,
              transformOrigin: `${48 * k}px ${36 * k}px`,
            }}
          >
            <div style={{zoom: k}}>
            <ParticipantNode
              name={person.name}
              selected={person.name === 'You' ? 0.001 : 0}
              amount={money(person.amount)}
              amountIn={arrived * (1 - prog(f, 15.2, 15.6))}
              labelColor={dark.textSecondary}
            />
            </div>
          </div>
        );
      })}

      {/* The total divides: each share travels the connection to its person. */}
      {bill.people.map((p, i) => {
        const t1 = T.divide[0] + i * 0.22;
        const m = prog(f, t1, t1 + 0.8, inOut);
        if (m <= 0 || m >= 1) return null;
        const c = circleCentre(g.nodes[i]);
        // Leave from the card's edge along the connection, never across its copy.
        const x = lerp(lerp(g.card[0], c[0], 0.42), c[0], m);
        const y = lerp(lerp(g.card[1], c[1], 0.42), c[1] + 50 * k, m);
        return (
          <div key={p.name} style={{position: 'absolute', left: x, top: y, transform: 'translate(-50%, -50%)'}}>
          <div
            style={{
              zoom: k,
              padding: '6px 10px',
              borderRadius: 12,
              background: 'rgba(22,38,59,0.92)',
              border: '1px solid rgba(175,207,244,0.25)',
              color: dark.balanceText,
              fontSize: 13,
              fontWeight: 600,
              whiteSpace: 'nowrap',
              opacity: Math.min(1, m * 5) * Math.min(1, (1 - m) * 5),
              ...tabular,
            }}
          >
            {money(p.amount)}
          </div>
          </div>
        );
      })}

      {/* Ring that becomes Analytics */}
      {ringOpacity > 0 && (
        <div
          style={{
            position: 'absolute',
            left: ringC[0] - ringSize / 2,
            top: ringC[1] + lerp(36 * k, 0, land) - ringSize / 2,
            width: ringSize,
            height: ringSize,
            opacity: ringOpacity,
          }}
        >
          <div style={{width: 220, height: 220, zoom: ringSize / 220}}>
            <DonutRing reveal={ringReveal} />
          </div>
        </div>
      )}
    </div>
  );
};
