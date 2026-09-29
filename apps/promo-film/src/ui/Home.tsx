import React from 'react';
import {dark, FONT, tabular, type} from '../theme';
import {dashboard, money, user} from '../data';
import {Glass} from './primitives';
import {Icon} from './Icon';
import {Trajectory} from './Trajectory';

// Port of HomeScreen (features/home/presentation/home_screen.dart), dark theme.

export type HomeState = {
  reveal: number[]; // [header, intro, canvas, commands, month]
  balance: number;
  trajectory: number;
  scroll: number;
  lift: number; // balance surface separating from the page, 0..1
};

export const HOME_CANVAS = {x: 24, y: 340, w: 342, h: 322};
export const HOME_AMOUNT = {x: 48, y: 422, h: 48};

const reveal = (v: number): React.CSSProperties => ({opacity: v, transform: `translateY(${12 * (1 - v)}px)`});

const Dots: React.FC<{w: number; h: number}> = ({w, h}) => {
  // DuitlahSignalField: static precision texture on the right half.
  const dots: React.ReactNode[] = [];
  for (let x = w * 0.55; x < w - 12; x += 18)
    for (let y = 20; y < h - 16; y += 18) dots.push(<circle key={`${x}-${y}`} cx={x} cy={y} r={0.7} fill={dark.balanceHighlight} fillOpacity={0.14} />);
  return (
    <svg width={w} height={h} style={{position: 'absolute', inset: 0}}>
      {dots}
      <line x1={w * 0.73} y1={20} x2={w - 24} y2={20} stroke={dark.balanceHighlight} strokeOpacity={0.22} strokeWidth={1} />
    </svg>
  );
};

export const FinancialCanvas: React.FC<{balance: number; trajectory: number; lift?: number}> = ({balance, trajectory, lift = 0}) => {
  const ratio = dashboard.monthExpense / dashboard.monthIncome;
  return (
    <div
      style={{
        position: 'relative',
        width: HOME_CANVAS.w,
        height: HOME_CANVAS.h,
        borderRadius: '28px 48px 12px 28px',
        background: dark.balanceBackground,
        overflow: 'hidden',
        transform: `scale(${1 + 0.025 * lift}) translateY(${-6 * lift}px)`,
        boxShadow: lift > 0 ? `0 ${30 * lift}px ${60 * lift}px rgba(0,0,0,${0.55 * lift}), 0 0 0 1px rgba(175,207,244,${0.08 * lift})` : undefined,
      }}
    >
      <Dots w={HOME_CANVAS.w} h={HOME_CANVAS.h} />
      <div style={{position: 'relative', padding: '20px 24px 24px'}}>
        <div style={{display: 'flex', alignItems: 'center'}}>
          <div style={{flex: 1, ...type.labelMedium, color: dark.balanceSecondary, letterSpacing: 1.4}}>AVAILABLE NOW</div>
          <Glass material="hero" radius={24} blur={false} style={{padding: 12}}>
            <Icon name="eye" size={20} color={dark.balanceSecondary} />
          </Glass>
        </div>
        <div style={{height: 18}} />
        <div style={{...type.displaySmall, color: dark.balanceText, lineHeight: '48px', ...tabular}}>{money(balance)}</div>
        <div style={{height: 14}} />
        <Glass material="hero" radius={12} blur={false} style={{display: 'inline-block', padding: '8px 10px'}}>
          <div style={{...type.bodySmall, color: dark.balanceSecondary}}>{money(dashboard.monthIncome)} income this month</div>
        </Glass>
        <div style={{height: 24}} />
        <Trajectory width={HOME_CANVAS.w - 48} progress={ratio * trajectory} ink={dark.balanceHighlight} track="rgba(175,207,244,0.18)" />
        <div style={{height: 8}} />
        <div style={{...type.bodySmall, color: dark.balanceSecondary}}>{Math.round(ratio * 100)}% of this month’s income spent</div>
      </div>
    </div>
  );
};

export const Home: React.FC<{s: HomeState}> = ({s}) => {
  const [rHeader, rIntro, rCanvas, rCommands, rMonth] = s.reveal;
  return (
    <div style={{position: 'absolute', inset: 0, background: dark.background, fontFamily: FONT, color: dark.textPrimary, overflow: 'hidden'}}>
      <div style={{position: 'absolute', left: 0, right: 0, top: 0, padding: '72px 24px 0', transform: `translateY(${-s.scroll}px)`}}>
        <div style={{display: 'flex', alignItems: 'center', height: 48, ...reveal(rHeader)}}>
          <div style={{flex: 1, ...type.bodySmall, color: dark.textSecondary}}>{dashboard.date}</div>
          <Glass material="standard" radius={14} elevated style={{padding: '12px 14px', display: 'flex', alignItems: 'center', gap: 10}}>
            <span style={{fontSize: 15, fontWeight: 700}}>Personal</span>
            <Icon name="down" size={16} color={dark.textSecondary} />
          </Glass>
          <div style={{width: 48, display: 'flex', justifyContent: 'center'}}>
            <Icon name="bell" size={21} color={dark.textPrimary} />
          </div>
        </div>
        <div style={{height: 20}} />
        <div style={reveal(rIntro)}>
          <div style={{...type.bodyMedium, lineHeight: '20px'}}>Evening, {user.firstName}.</div>
          <div style={{height: 10}} />
          <div style={{...type.displaySmall, lineHeight: 1.12}}>
            Your money,
            <br />
            at ease.
          </div>
          <div style={{height: 12}} />
          <div style={{height: 48, display: 'flex', alignItems: 'center', fontSize: 15, fontWeight: 600, color: dark.primary, paddingLeft: 12}}>
            Find a tool&nbsp;&nbsp;↗
          </div>
        </div>
        <div style={{height: 20}} />
        <div style={reveal(rCanvas)}>
          <FinancialCanvas balance={s.balance} trajectory={s.trajectory} lift={s.lift} />
        </div>
        <div style={{height: 20}} />
        <div style={reveal(rCommands)}>
          <Glass material="strong" radius={16} style={{padding: 18, display: 'flex', alignItems: 'center', gap: 8}}>
            <Icon name="plus" size={18} color={dark.textPrimary} />
            <div style={{flex: 1, fontSize: 14, fontWeight: 600}}>Add expense</div>
            <div>↗</div>
          </Glass>
          <div style={{height: 8}} />
          <div style={{display: 'flex', gap: 24, height: 48, alignItems: 'center', paddingLeft: 12, fontSize: 15, fontWeight: 600, color: dark.primary, whiteSpace: 'nowrap'}}>
            <span>Scan receipt ↗</span>
            <span>Add income</span>
            <span>Transfer</span>
            <span>Bills</span>
          </div>
        </div>
        <div style={{height: 44}} />
        <div style={reveal(rMonth)}>
          <div style={{...type.labelMedium, letterSpacing: 1.8, color: dark.textPrimary}}>THIS MONTH</div>
          <div style={{paddingTop: 24}}>
            <div style={{...type.displaySmall, fontSize: 56, lineHeight: 1.1}}>76%</div>
            <div style={{height: 8}} />
            <div style={{...type.titleMedium, lineHeight: 1.35}}>
              of your food budget
              <br />
              is already in use.
            </div>
            <div style={{height: 16}} />
            <Trajectory width={342} progress={0.76 * s.trajectory} ink={dark.primary} track={dark.border} />
            <div style={{height: 8}} />
            <div style={{...type.bodySmall, color: dark.textSecondary}}>RM 1,368.30 spent · RM 431.70 remaining</div>
          </div>
        </div>
      </div>
    </div>
  );
};
