import React from 'react';
import {dark, FONT, light, SERIF, tabular, type} from '../theme';
import {Icon, IconName} from './Icon';
import {Glass} from './primitives';

// Real destinations shown in the montage, recreated from their current previews:
// BudgetsScreen, GoalsScreen, AccountsScreen, BusinessDashboardScreen, MonthlyWrapped.

const Page: React.FC<{title: string; children: React.ReactNode; trailing?: React.ReactNode}> = ({title, children, trailing}) => (
  <div style={{position: 'absolute', inset: 0, background: dark.background, fontFamily: FONT, color: dark.textPrimary, padding: '66px 20px 0'}}>
    <div style={{display: 'flex', alignItems: 'center', height: 44, marginBottom: 16}}>
      <div style={{flex: 1, ...type.appBar}}>{title}</div>
      {trailing}
    </div>
    {children}
  </div>
);

const Card: React.FC<{children: React.ReactNode; style?: React.CSSProperties}> = ({children, style}) => (
  <div style={{background: dark.surface, borderRadius: 20, padding: 16, marginBottom: 12, ...style}}>{children}</div>
);

const Bar: React.FC<{p: number; color: string}> = ({p, color}) => (
  <div style={{height: 8, borderRadius: 4, background: dark.border, overflow: 'hidden'}}>
    <div style={{width: `${p * 100}%`, height: '100%', borderRadius: 4, background: color}} />
  </div>
);

export const BudgetsMini: React.FC = () => (
  <Page title="Budgets">
    <Card>
      <div style={{...type.titleMedium}}>Food</div>
      <div style={{...type.headlineMedium, fontSize: 28, marginTop: 6, ...tabular}}>RM 431.70</div>
      <div style={{...type.bodySmall, color: dark.textSecondary}}>Remaining this cycle</div>
      <div style={{...type.bodySmall, color: dark.textSecondary, margin: '14px 0 10px'}}>RM 1,368.30 spent of RM 1,800.00</div>
      <Bar p={0.76} color={dark.positive} />
      <div style={{...type.titleSmall, color: dark.positive, marginTop: 12}}>On track</div>
      <div style={{...type.bodySmall, color: dark.textSecondary, marginTop: 4}}>2026-08</div>
    </Card>
    <Card>
      <div style={{...type.titleMedium}}>Transport</div>
      <div style={{...type.headlineMedium, fontSize: 28, marginTop: 6, ...tabular}}>RM 87.40</div>
      <div style={{...type.bodySmall, color: dark.textSecondary}}>Remaining this cycle</div>
      <div style={{...type.bodySmall, color: dark.textSecondary, margin: '14px 0 10px'}}>RM 512.60 spent of RM 600.00</div>
      <Bar p={0.85} color={dark.positive} />
    </Card>
  </Page>
);

export const GoalsMini: React.FC = () => (
  <Page title="Goals">
    {[
      ['Japan trip', 'RM 3,280.00', 'of RM 8,000.00 · 41% saved', 0.41],
      ['Emergency fund', 'RM 6,500.00', 'of RM 10,000.00 · 65% saved', 0.65],
    ].map(([n, a, s, p]) => (
      <Card key={n as string}>
        <div style={{display: 'flex', alignItems: 'center'}}>
          <div style={{flex: 1, ...type.titleMedium}}>{n}</div>
          <div style={{...type.titleSmall, color: dark.primary}}>Contribute</div>
        </div>
        <div style={{...type.titleLarge, fontSize: 21, marginTop: 10, ...tabular}}>{a}</div>
        <div style={{...type.bodySmall, color: dark.textSecondary, margin: '2px 0 10px'}}>{s}</div>
        <Bar p={p as number} color={dark.primary} />
      </Card>
    ))}
  </Page>
);

export const AccountsMini: React.FC = () => (
  <Page title="Accounts">
    {[
      ['bank', 'Maybank Savings', 'savings', 'RM 4,120.35'],
      ['wallet', 'TNG eWallet', 'ewallet', 'RM 312.40'],
      ['wallet', 'Cash', 'cash', 'RM 418.00'],
    ].map(([i, n, k, a]) => (
      <Card key={n} style={{display: 'flex', gap: 12, padding: 20}}>
        <div style={{width: 40, height: 40, borderRadius: 20, background: dark.surfaceElevated, display: 'flex', alignItems: 'center', justifyContent: 'center'}}>
          <Icon name={i as IconName} size={20} color={dark.textPrimary} />
        </div>
        <div>
          <div style={{fontSize: 17, fontWeight: 500}}>{n}</div>
          <div style={{...type.bodySmall, color: dark.textSecondary, marginTop: 2}}>{k}</div>
          <div style={{...type.titleSmall, marginTop: 10, ...tabular}}>{a}</div>
        </div>
      </Card>
    ))}
  </Page>
);

export const BusinessMini: React.FC = () => (
  <Page
    title="Business"
    trailing={
      <Glass radius={14} style={{padding: '10px 12px', display: 'flex', gap: 8, alignItems: 'center'}}>
        <span style={{fontSize: 14, fontWeight: 700}}>Business</span>
        <Icon name="down" size={14} color={dark.textSecondary} />
      </Glass>
    }
  >
    <div style={{borderRadius: 20, padding: 24, background: 'linear-gradient(180deg, #1A2D46, #16263B)'}}>
      <div style={{fontSize: 15, fontWeight: 500}}>Business cash position</div>
      <div style={{...type.headlineMedium, fontSize: 28, marginTop: 6, ...tabular}}>RM 18,420.60</div>
      <div style={{...type.bodySmall, color: dark.balanceSecondary, marginTop: 6}}>Cash available across business accounts</div>
    </div>
    <div style={{display: 'flex', marginTop: 20}}>
      {[
        ['Receivables', 'RM 3,150.00', '2 open invoices'],
        ['Payables', 'RM 960.40', '1 unpaid expense'],
      ].map(([l, a, s]) => (
        <div key={l} style={{flex: 1}}>
          <div style={{...type.bodySmall, color: dark.textSecondary}}>{l}</div>
          <div style={{...type.titleMedium, ...tabular}}>{a}</div>
          <div style={{...type.bodySmall, color: dark.textSecondary}}>{s}</div>
        </div>
      ))}
    </div>
    <div style={{...type.titleLarge, marginTop: 28}}>People & business</div>
    {[
      ['people', 'Team'],
      ['person', 'Business Profile'],
      ['people', 'Customers'],
    ].map(([i, l]) => (
      <div key={l} style={{display: 'flex', alignItems: 'center', gap: 16, height: 56}}>
        <Icon name={i as IconName} size={24} color={dark.primary} />
        <div style={{flex: 1, fontSize: 16}}>{l}</div>
        <Icon name="right" size={20} color={dark.textSecondary} />
      </div>
    ))}
  </Page>
);

export const WrappedMini: React.FC = () => (
  <div style={{position: 'absolute', inset: 0, background: light.background, fontFamily: FONT, color: light.primaryDark, padding: '70px 24px 0'}}>
    <div style={{display: 'flex', gap: 6}}>
      {Array.from({length: 8}).map((_, i) => (
        <div key={i} style={{flex: 1, height: 3, borderRadius: 2, background: i < 2 ? light.primaryDark : '#D5D7D3'}} />
      ))}
    </div>
    <div style={{...type.labelMedium, letterSpacing: 1.6, color: light.textSecondary, marginTop: 44}}>AUGUST 2026</div>
    <div style={{fontFamily: SERIF, fontSize: 38, lineHeight: 1.08, marginTop: 10, letterSpacing: -0.5}}>Here’s how your month went.</div>
    <div style={{height: 20}} />
    {[
      ['wallet', 'Income', 'RM 6,200.00', light.positive, light.positiveSoft],
      ['out', 'Expenses', 'RM 3,420.75', light.negative, light.negativeSoft],
      ['equals', 'Net', 'RM 2,779.25', light.primaryDark, '#E3E5E8'],
      ['leaf', 'Saved toward goals', 'RM 500.00', light.information, light.informationSoft],
    ].map(([i, l, a, c, bg]) => (
      <div key={l} style={{display: 'flex', alignItems: 'center', gap: 16, background: light.surfaceSecondary, borderRadius: 20, padding: '16px 16px', marginBottom: 8}}>
        <div style={{width: 44, height: 44, borderRadius: 22, background: bg, display: 'flex', alignItems: 'center', justifyContent: 'center'}}>
          <Icon name={i as IconName} size={22} color={c} />
        </div>
        <div style={{flex: 1}}>
          <div style={{fontSize: 13, color: light.textSecondary}}>{l}</div>
          <div style={{fontSize: 24, fontWeight: 700, color: c, letterSpacing: -0.4, ...tabular}}>{a}</div>
        </div>
        <Icon name="right" size={18} color={light.primaryDark} />
      </div>
    ))}
  </div>
);
