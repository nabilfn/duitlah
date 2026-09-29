import React from 'react';
import {dark, FONT, tabular, type} from '../theme';
import {money, transactions, Txn} from '../data';
import {Glass, Divider} from './primitives';
import {Icon} from './Icon';

// Port of TransactionsScreen + TransactionRow (dark).

export const TXN_LIST_TOP = 224;
export const ROW_H = 66;
export const TXN_AMOUNT_X = 218;
const EXPAND_H = 62;

/** Logical y of each row's top, accounting for date headers and one expanded row. */
export const rowTops = (expandIndex = -1, expand = 0) => {
  const tops: number[] = [];
  let y = TXN_LIST_TOP;
  let prev: string | null = null;
  transactions.forEach((t, i) => {
    if (t.day !== prev) {
      y += 20 + 18 + 4;
      prev = t.day;
    }
    tops.push(y);
    y += ROW_H + 1;
    if (i === expandIndex) y += EXPAND_H * expand;
  });
  return tops;
};

const Row: React.FC<{t: Txn; amountIn: number; expand: number}> = ({t, amountIn, expand}) => {
  const sign = t.incoming ? '+' : '−';
  return (
    <div>
      <div style={{display: 'flex', alignItems: 'flex-start', padding: '14px 0', height: ROW_H, boxSizing: 'border-box'}}>
        <div style={{width: 190}}>
          <div style={{...type.titleSmall, lineHeight: '18px'}}>{t.merchant}</div>
          <div style={{height: 3}} />
          <div style={{...type.bodySmall, color: dark.textSecondary, lineHeight: '17px'}}>
            {t.incoming ? 'Income' : 'Expense'} · {t.account}
          </div>
        </div>
        <div style={{width: 8}} />
        <div
          style={{
            ...type.titleSmall,
            ...tabular,
            lineHeight: '18px',
            marginTop: 10,
            color: t.incoming ? dark.positive : dark.textPrimary,
            opacity: amountIn,
            transform: `translateY(${6 * (1 - amountIn)}px)`,
          }}
        >
          {money(t.amount, {sign})}
        </div>
      </div>
      {expand > 0 && (
        <div style={{height: EXPAND_H * expand, overflow: 'hidden'}}>
          <div style={{opacity: expand, paddingBottom: 20}}>
            <div style={{...type.bodySmall, color: dark.textSecondary}}>{t.day}</div>
            {t.note && <div style={{...type.bodyMedium, marginTop: 8}}>{t.note}</div>}
          </div>
        </div>
      )}
    </div>
  );
};

export const Transactions: React.FC<{
  headerIn: number;
  rowsIn: number[];
  amountsIn: number[];
  expand?: number;
  hideRow?: number;
  highlight?: number;
}> = ({headerIn, rowsIn, amountsIn, expand = 0, hideRow = -1, highlight = 0}) => {
  let prev: string | null = null;
  return (
    <div style={{position: 'absolute', inset: 0, background: dark.background, fontFamily: FONT, color: dark.textPrimary, overflow: 'hidden'}}>
      <div style={{opacity: headerIn, transform: `translateY(${10 * (1 - headerIn)}px)`}}>
        <div style={{position: 'absolute', left: 16, top: 66, ...type.appBar, lineHeight: '32px'}}>Transactions</div>
        <div style={{position: 'absolute', left: 20, right: 20, top: 108, display: 'flex', gap: 12, alignItems: 'center'}}>
          <Glass material="standard" radius={14} style={{flex: 1, height: 48, display: 'flex', alignItems: 'center', gap: 14, padding: '0 16px'}}>
            <Icon name="search" size={20} color={dark.textSecondary} />
            <span style={{fontSize: 16, color: dark.textSecondary}}>Search this page…</span>
          </Glass>
          <div style={{width: 40, height: 40, borderRadius: 20, background: dark.primarySoft, display: 'flex', alignItems: 'center', justifyContent: 'center'}}>
            <Icon name="filter" size={20} color={dark.primary} />
          </div>
        </div>
        <Glass material="standard" radius={14} style={{position: 'absolute', left: 20, right: 20, top: 160, height: 48, display: 'flex', alignItems: 'center', padding: 3}}>
          {['All', 'Income', 'Expenses', 'Transfer'].map((l, i) => (
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
      </div>
      <div style={{position: 'absolute', left: 20, right: 20, top: TXN_LIST_TOP}}>
        {transactions.map((t, i) => {
          const header = t.day !== prev;
          prev = t.day;
          const r = rowsIn[i] ?? 1;
          return (
            <div key={i} style={{opacity: r, transform: `translateY(${14 * (1 - r)}px)`}}>
              {header && <div style={{paddingTop: 20, paddingBottom: 4, ...type.titleSmall, lineHeight: '18px'}}>{t.day}</div>}
              <div
                style={{
                  opacity: i === hideRow ? 0 : 1,
                  background: i === 1 && highlight > 0 ? `rgba(29,53,83,${0.55 * highlight})` : undefined,
                  margin: '0 -12px',
                  padding: '0 12px',
                  borderRadius: 14,
                }}
              >
                <Row t={t} amountIn={amountsIn[i] ?? 1} expand={i === 1 ? expand : 0} />
              </div>
              <Divider />
            </div>
          );
        })}
      </div>
      <div
        style={{
          position: 'absolute',
          left: 197,
          top: 632,
          width: 177,
          height: 55,
          borderRadius: 20,
          background: dark.primary,
          color: dark.textOnPrimary,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          gap: 10,
          fontSize: 15,
          fontWeight: 600,
          opacity: headerIn,
          boxShadow: '0 4px 14px rgba(0,0,0,0.25)',
          zIndex: 25,
        }}
      >
        <Icon name="plus" size={22} color={dark.textOnPrimary} />
        Add transaction
      </div>
    </div>
  );
};
