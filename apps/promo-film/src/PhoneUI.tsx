import React from 'react';
import {dark, FONT, tabular} from './theme';
import {dashboard, money} from './data';
import {T} from './timeline';
import {clamp01, ease, glide, inOut, lerp, prog, s} from './anim';
import {EntryLayer, entryFrame} from './ui/Entry';
import {Home, HOME_AMOUNT, HomeState} from './ui/Home';
import {rowTops, Transactions, TXN_AMOUNT_X, ROW_H} from './ui/Transactions';
import {BagilahTab} from './ui/Bagilah';
import {Analytics, DONUT, donutRadius} from './ui/Analytics';
import {AssistantPanel} from './ui/Assistant';
import {Dock, FAB} from './ui/Dock';
import {DynamicIsland, HomeIndicator, StatusBar} from './ui/primitives';

const P = (sec: number, a: number, b: number, e = ease) => prog(s(sec), a, b, e);
const range = (r: number[]) => r as [number, number];

export const homeState = (sec: number): HomeState => {
  const late = sec > 20;
  if (late) return {reveal: [1, 1, 1, 1, 1], balance: dashboard.availableBalance, trajectory: 1, scroll: 0, lift: 0};
  const h = T.homeHeader;
  const count = P(sec, ...range(T.balanceCount), glide);
  const tick = P(sec, T.peel[0], T.peel[0] + 0.4, inOut);
  const balance = lerp(lerp(4120, dashboard.openingBalance, count), dashboard.availableBalance, tick);
  return {
    reveal: [P(sec, h, h + 0.42), P(sec, h + 0.1, h + 0.6), P(sec, h + 0.25, h + 0.8), P(sec, h + 0.55, h + 1.05), P(sec, h + 0.8, h + 1.4)],
    balance,
    trajectory: P(sec, ...range(T.trajectory)),
    scroll: 150 * P(sec, ...range(T.homeScroll), inOut),
    lift: P(sec, ...range(T.canvasLift), inOut) * (1 - P(sec, T.peel[0] + 0.2, T.peel[1], inOut)),
  };
};

/** Rect (logical px) of the Hotpot dinner row, for the frame-space lift. */
export const liftedRowRect = (sec: number) => {
  const e = P(sec, ...range(T.rowExpand));
  const top = rowTops(1, e)[1];
  return {x: 8, y: top, w: 374, h: ROW_H + 62 * e};
};

export const dockSlot = (sec: number) =>
  P(sec, ...range(T.toTransactions), inOut) +
  P(sec, 10.6, 11.0, inOut) +
  P(sec, 15.8, 16.3, inOut) -
  3 * P(sec, 23.55, 24.05, inOut);

const Layer: React.FC<{o: number; x?: number; children: React.ReactNode}> = ({o, x = 0, children}) =>
  o <= 0.001 ? null : (
    <div style={{position: 'absolute', inset: 0, opacity: o, transform: x ? `translateX(${x}px)` : undefined}}>{children}</div>
  );

export const PhoneUI: React.FC<{sec: number; sheen: number}> = ({sec, sheen}) => {
  const f = entryFrame((sec - T.entryStart) * 500);
  const screenOn = P(sec, ...range(T.screenOn), inOut);

  // Screen visibility (crossfades between the app's own destinations).
  const toTx = P(sec, ...range(T.toTransactions), inOut);
  const toHomeLate = P(sec, 23.55, 24.05, inOut);
  const homeO = sec < 12 ? 1 - toTx : toHomeLate;
  const txO = toTx * (1 - P(sec, 10.6, 11.0, inOut));
  const bagO = P(sec, 10.6, 11.0, inOut) * (1 - P(sec, 15.8, 16.3, inOut));
  const anaO = P(sec, 15.8, 16.3, inOut) * (1 - toHomeLate);

  // Transactions.
  const rowsIn = [0, 1, 2, 3, 4, 5].map((i) => P(sec, T.rowsStart + i * 0.09, T.rowsStart + i * 0.09 + 0.55));
  const landed = P(sec, T.peel[1] - 0.05, T.peel[1] + 0.2);
  const amountsIn = rowsIn.map((r, i) => (i === 0 ? landed : P(sec, T.rowsStart + 0.2 + i * 0.09, T.rowsStart + 0.75 + i * 0.09)));
  const press = P(sec, ...range(T.rowPress)) * (1 - P(sec, 9.35, 9.8));
  const expand = P(sec, ...range(T.rowExpand));

  // Peel: "− RM 12.90" leaves the balance and lands as the first row's amount.
  const hs = homeState(sec);
  const peelT = P(sec, T.peel[0] + 0.1, T.peel[1], inOut);
  const peelVisible = sec > T.peel[0] + 0.08 && sec < T.peel[1] + 0.12;
  const row0 = rowTops()[0];
  const from = {x: HOME_AMOUNT.x + 170, y: HOME_AMOUNT.y - hs.scroll + 8, size: 26};
  const to = {x: TXN_AMOUNT_X, y: row0 + 24, size: 14};
  const arc = Math.sin(peelT * Math.PI) * 40;

  // Analytics.
  const kept = P(sec, ...range(T.kept), glide);
  const select = P(sec, ...range(T.select)) * (1 - toHomeLate);

  // Assistant.
  const closing = P(sec, ...range(T.collapseAssistant), inOut);
  const dim = P(sec, ...range(T.dim)) * (1 - closing);
  const expandA = P(sec, ...range(T.expand), ease) * (1 - closing);
  const pointT = P(sec, ...range(T.point), inOut);
  const segMid = -Math.PI / 2 + 0.4 * Math.PI;
  const pFrom = [DONUT.cx + donutRadius * Math.cos(segMid), DONUT.cy + donutRadius * Math.sin(segMid)];
  const pTo = [FAB.x + 22, FAB.y + 23];
  const fabGlow = P(sec, 19.95, 20.35) * (1 - P(sec, T.expand[0], T.expand[0] + 0.4));

  return (
    <div style={{position: 'absolute', inset: 0, background: '#000', overflow: 'hidden', borderRadius: 47, fontFamily: FONT}}>
      <div style={{position: 'absolute', inset: 0, opacity: screenOn}}>
        <div style={{position: 'absolute', inset: 0, transform: `scale(${f.childScale})`}}>
          <Layer o={homeO} x={-18 * toTx}>
            <Home s={hs} />
          </Layer>
          <Layer o={txO} x={18 * (1 - toTx)}>
            <Transactions headerIn={P(sec, 7.0, 7.5)} rowsIn={rowsIn} amountsIn={amountsIn} expand={expand} highlight={press} hideRow={sec >= T.lift[0] ? 1 : -1} />
          </Layer>
          <Layer o={bagO}>
            <BagilahTab />
          </Layer>
          <Layer o={anaO}>
            <Analytics
              headerIn={P(sec, 16.2, 16.75)}
              keptIn={P(sec, T.kept[0], T.kept[0] + 0.5)}
              keptValue={lerp(2400, 2779.25, kept)}
              donut={1}
              donutVisible={P(sec, T.ringLand[1] - 0.12, T.ringLand[1] + 0.02, (x) => x)}
              centreIn={P(sec, 17.1, 17.55)}
              legendIn={P(sec, 17.3, 18.2)}
              select={select}
            />
          </Layer>
          {peelVisible && (
            <div
              style={{
                position: 'absolute',
                left: lerp(from.x, to.x, peelT),
                top: lerp(from.y, to.y, peelT) - arc,
                fontSize: lerp(from.size, to.size, peelT),
                fontWeight: 700,
                color: dark.textPrimary,
                whiteSpace: 'nowrap',
                opacity: P(sec, T.peel[0] + 0.08, T.peel[0] + 0.3) * (1 - P(sec, T.peel[1] + 0.02, T.peel[1] + 0.12)),
                zIndex: 35,
                ...tabular,
              }}
            >
              {money(12.9, {sign: '−'})}
            </div>
          )}
          {dim > 0 && <div style={{position: 'absolute', inset: 0, background: `rgba(2,4,8,${0.72 * dim})`, zIndex: 28}} />}
          {pointT > 0 && pointT < 1 && (
            <div
              style={{
                position: 'absolute',
                left: lerp(pFrom[0], pTo[0], pointT) - 5,
                top: lerp(pFrom[1], pTo[1], pointT) - 5 - Math.sin(pointT * Math.PI) * 30,
                width: 10,
                height: 10,
                borderRadius: 5,
                background: dark.primary,
                boxShadow: '0 0 0 6px rgba(175,207,244,0.14), 0 0 18px rgba(120,181,255,0.6)',
                zIndex: 36,
              }}
            />
          )}
          <Dock slot={clamp01(dockSlot(sec) / 4) * 4} fabGlow={fabGlow} />
          <AssistantPanel
            expand={expandA}
            typed={P(sec, ...range(T.typed), (x) => x)}
            sent={P(sec, ...range(T.sent))}
            thinking={P(sec, T.thinking[0], T.thinking[0] + 0.1, (x) => x) * (1 - P(sec, T.thinking[1] - 0.05, T.thinking[1] + 0.05, (x) => x))}
            answer={P(sec, ...range(T.answer), (x) => x)}
            phase={sec}
          />
        </div>
        <EntryLayer f={f} wake={1} />
        <StatusBar />
        <HomeIndicator />
      </div>
      <DynamicIsland />
      {/* Front-glass sheen: a faint specular band that shifts with the device angle. */}
      <div
        style={{
          position: 'absolute',
          inset: -200,
          background: `linear-gradient(115deg, rgba(255,255,255,0) ${38 + sheen * 30}%, rgba(255,255,255,0.055) ${46 + sheen * 30}%, rgba(255,255,255,0) ${56 + sheen * 30}%)`,
          pointerEvents: 'none',
          zIndex: 80,
        }}
      />
    </div>
  );
};
