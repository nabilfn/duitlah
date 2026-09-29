import React from 'react';
import {chartDark, dark, FONT, tabular, type} from '../theme';
import {analytics, categories, money} from '../data';
import {Glass} from './primitives';
import {Icon} from './Icon';

// Port of InsightsScreen ("Analytics") + SpendingDonut (dark palette).

export const DONUT = {cx: 195, cy: 632, size: 220, stroke: 30};
export const donutRadius = (DONUT.size - 32) / 2;

const total = categories.reduce((a, c) => a + c.amount, 0);

/** Segment angles (radians, 0 = 12 o'clock direction handled by caller). */
export const segments = () => {
  let start = -Math.PI / 2;
  return categories.map((c, i) => {
    const sweep = (c.amount / total) * Math.PI * 2;
    const seg = {start, sweep, color: chartDark[i % chartDark.length]};
    start += sweep;
    return seg;
  });
};

export const DonutRing: React.FC<{reveal: number; size?: number; stroke?: number; selected?: number; selectAmt?: number}> = ({
  reveal,
  size = DONUT.size,
  stroke = DONUT.stroke,
  selected = -1,
  selectAmt = 0,
}) => {
  const r = (size - 32) / 2;
  const c = size / 2;
  let start = -Math.PI / 2;
  return (
    <svg width={size} height={size} style={{display: 'block', overflow: 'visible'}}>
      {categories.map((cat, i) => {
        const sweep = (cat.amount / total) * Math.PI * 2 * reveal;
        const a0 = start;
        const a1 = start + sweep;
        start = a1;
        if (sweep <= 0.0001) return null;
        const large = sweep > Math.PI ? 1 : 0;
        const alpha = selected < 0 || selected === i ? 1 : 1 - 0.65 * selectAmt;
        return (
          <path
            key={cat.name}
            d={`M${c + r * Math.cos(a0)} ${c + r * Math.sin(a0)} A${r} ${r} 0 ${large} 1 ${c + r * Math.cos(a1)} ${c + r * Math.sin(a1)}`}
            stroke={chartDark[i % chartDark.length]}
            strokeOpacity={alpha}
            strokeWidth={stroke}
            fill="none"
          />
        );
      })}
    </svg>
  );
};

export const Analytics: React.FC<{
  headerIn: number;
  keptIn: number;
  keptValue: number;
  donut: number;
  donutVisible?: number;
  centreIn: number;
  legendIn: number;
  select?: number;
}> = ({headerIn, keptIn, keptValue, donut, donutVisible = 1, centreIn, legendIn, select = 0}) => {
  const top = (v: number, d = 12): React.CSSProperties => ({opacity: v, transform: `translateY(${d * (1 - v)}px)`});
  const selName = categories[0].name;
  return (
    <div style={{position: 'absolute', inset: 0, background: dark.background, fontFamily: FONT, color: dark.textPrimary, overflow: 'hidden'}}>
      <div style={top(headerIn)}>
        <div style={{position: 'absolute', left: 16, top: 66, ...type.appBar, lineHeight: '32px'}}>Analytics</div>
        <div style={{position: 'absolute', left: 20, top: 108, ...type.displaySmall, lineHeight: 1.12, whiteSpace: 'pre-line'}}>{analytics.monthTitle}</div>
        <Glass material="standard" radius={14} style={{position: 'absolute', left: 20, right: 20, top: 222, height: 48, display: 'flex', alignItems: 'center', padding: 3}}>
          {['Expenses', 'Income', 'Net worth'].map((l, i) => (
            <div
              key={l}
              style={{
                flex: 1,
                height: 42,
                borderRadius: 12,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: 13,
                fontWeight: i === 0 ? 700 : 500,
                color: i === 0 ? dark.textPrimary : dark.textSecondary,
                background: i === 0 ? 'rgba(27,39,54,0.9)' : undefined,
                border: i === 0 ? '1px solid rgba(255,255,255,0.08)' : undefined,
              }}
            >
              {l}
            </div>
          ))}
        </Glass>
        <div style={{position: 'absolute', left: 20, right: 20, top: 286, height: 48, display: 'flex', alignItems: 'center', gap: 12}}>
          <Icon name="left" size={20} color={dark.textSecondary} />
          <Glass material="standard" radius={14} style={{flex: 1, height: 48, display: 'flex', alignItems: 'center', padding: '0 16px'}}>
            <span style={{flex: 1, fontSize: 15, fontWeight: 500}}>{analytics.month}</span>
            <Icon name="calendar" size={20} color={dark.textSecondary} />
          </Glass>
          <Icon name="right" size={20} color={dark.textSecondary} />
        </div>
      </div>
      <div style={{position: 'absolute', left: 20, top: 378, ...top(keptIn)}}>
        <div style={{fontSize: 15, fontWeight: 500}}>You kept</div>
        <div style={{height: 8}} />
        <div style={{...type.displaySmall, lineHeight: '48px', ...tabular}}>{money(keptValue)}</div>
        <div style={{height: 10}} />
        <div style={{...type.bodySmall, color: dark.textSecondary}}>after this month’s expenses.</div>
      </div>
      <div style={{position: 'absolute', left: DONUT.cx - DONUT.size / 2, top: DONUT.cy - DONUT.size / 2, opacity: donutVisible}}>
        <DonutRing reveal={donut} selected={0} selectAmt={select} />
        <div
          style={{
            position: 'absolute',
            inset: 45,
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            opacity: centreIn,
          }}
        >
          <div style={{...type.titleLarge, ...tabular}}>{money(select > 0.5 ? categories[0].amount : analytics.totalExpenses)}</div>
          <div style={{height: 4}} />
          <div style={{...type.bodySmall, color: dark.textSecondary}}>{select > 0.5 ? selName : 'Total expenses'}</div>
        </div>
      </div>
      <div style={{position: 'absolute', left: 20, right: 20, top: 770}}>
        {categories.slice(0, 3).map((c, i) => {
          const v = Math.min(1, Math.max(0, legendIn * 3 - i));
          return (
            <div key={c.name} style={{display: 'flex', alignItems: 'center', padding: '10px 4px', opacity: v}}>
              <div style={{width: 12, height: 12, borderRadius: 6, background: chartDark[i]}} />
              <div style={{width: 10}} />
              <div style={{flex: 1, ...type.bodySmall}}>{c.name}</div>
              <div style={{...type.bodySmall, color: dark.textSecondary}}>{Math.round((c.amount / total) * 100)}%</div>
              <div style={{width: 12}} />
              <div style={{...type.bodySmall, color: dark.textSecondary, ...tabular}}>{money(c.amount)}</div>
            </div>
          );
        })}
      </div>
    </div>
  );
};
