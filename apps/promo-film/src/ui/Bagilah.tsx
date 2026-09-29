import React from 'react';
import {dark, FONT, tabular, type} from '../theme';
import {money} from '../data';
import {Icon} from './Icon';

// Port of _ParticipantNode + SharedMoneyComposition (features/bagilah).

export const ParticipantNode: React.FC<{
  name: string;
  selected?: number;
  size?: number;
  amount?: string;
  amountIn?: number;
  labelColor?: string;
}> = ({name, selected = 0, amount, amountIn = 0, labelColor = dark.textSecondary}) => {
  const d = 60 + 12 * selected;
  return (
    <div style={{width: 96, display: 'flex', flexDirection: 'column', alignItems: 'center', fontFamily: FONT}}>
      <div style={{height: 72, display: 'flex', alignItems: 'center'}}>
        <div
          style={{
            width: d,
            height: d,
            borderRadius: '50%',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            background:
              selected > 0
                ? `rgba(22,38,59,${selected})`
                : 'linear-gradient(180deg, rgba(255,255,255,0.025), rgba(255,255,255,0.005)), rgba(27,39,54,0.52)',
            border: `1px solid ${selected > 0.5 ? dark.balanceHighlight : dark.border}`,
            boxShadow: '0 8px 28px rgba(0,0,0,0.22)',
            fontSize: 22,
            fontWeight: 600,
            color: dark.textPrimary,
          }}
        >
          {name[0].toUpperCase()}
        </div>
      </div>
      <div style={{height: 2}} />
      <div style={{...type.bodySmall, color: labelColor, textAlign: 'center'}}>{name}</div>
      {amount !== undefined && (
        <div
          style={{
            ...type.titleSmall,
            ...tabular,
            marginTop: 4,
            color: dark.textPrimary,
            opacity: amountIn,
            transform: `translateY(${6 * (1 - amountIn)}px)`,
          }}
        >
          {amount}
        </div>
      )}
    </div>
  );
};

const people = ['Aisyah', 'Daniel', 'Hana', 'Farid'];
const positions = [
  [0.05, 0],
  [0.9, 0.05],
  [0.02, 0.9],
  [0.82, 1],
];

export const BagilahTab: React.FC<{inP?: number}> = ({inP = 1}) => (
  <div style={{position: 'absolute', inset: 0, background: dark.background, fontFamily: FONT, color: dark.textPrimary, overflow: 'hidden'}}>
    <div style={{position: 'absolute', left: 0, right: 0, top: 66, textAlign: 'center', ...type.titleLarge, lineHeight: '32px'}}>Bagilah</div>
    <div style={{position: 'absolute', right: 16, top: 70}}>
      <Icon name="scan" size={24} color={dark.textPrimary} />
    </div>
    <div style={{position: 'absolute', left: 20, right: 20, top: 104, height: 372}}>
      <div style={{position: 'absolute', left: 0, right: 0, top: 125, textAlign: 'center', opacity: inP}}>
        <div style={{...type.displaySmall, ...tabular}}>{money(38)}</div>
        <div style={{height: 8}} />
        <div style={type.bodyMedium}>for you to settle</div>
        <div style={{height: 12}} />
        <div style={{...type.bodySmall, color: dark.textSecondary}}>{money(139.3)} owed to you</div>
      </div>
      {people.map((p, i) => (
        <div key={p} style={{position: 'absolute', left: 254 * positions[i][0], top: 258 * positions[i][1], opacity: inP}}>
          <ParticipantNode name={p} />
        </div>
      ))}
    </div>
    <div style={{position: 'absolute', left: 20, right: 20, top: 490, textAlign: 'center', ...type.bodySmall, color: dark.textSecondary}}>
      Choose a person to see your shared balance.
    </div>
    <div style={{position: 'absolute', left: 20, top: 548, ...type.headlineMedium}}>Good times, shared.</div>
    <div style={{position: 'absolute', left: 20, right: 30, top: 586, ...type.bodyLarge, color: dark.textSecondary, lineHeight: 1.45}}>
      Share expenses with friends, family or housemates, no awkward conversations.
    </div>
    <div
      style={{
        position: 'absolute',
        left: 20,
        top: 650,
        padding: '15px 24px',
        borderRadius: 16,
        background: dark.balanceBackground,
        fontSize: 15,
        fontWeight: 600,
      }}
    >
      New split +
    </div>
  </div>
);
