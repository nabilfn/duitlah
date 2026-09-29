import React from 'react';
import {dark, FONT} from '../theme';
import {Glass} from './primitives';
import {Icon, IconName} from './Icon';

// Port of DuitlahNavigationDock: AssistantFab over DuitlahBottomNavigation.
const items: {icon: IconName; label: string}[] = [
  {icon: 'home', label: 'Home'},
  {icon: 'receipt', label: 'Transactions'},
  {icon: 'split', label: 'Bagilah'},
  {icon: 'chart', label: 'Analytics'},
  {icon: 'person', label: 'Profile'},
];

export const DOCK_TOP = 752;
export const FAB = {x: 232, y: 704, w: 142, h: 46};

export const AskDuitlah: React.FC<{glow?: number; style?: React.CSSProperties}> = ({glow = 0, style}) => (
  <div style={{position: 'absolute', left: FAB.x, top: FAB.y, width: FAB.w, height: FAB.h, zIndex: 30, ...style}}>
    <Glass
      material="strong"
      radius={16}
      elevated
      style={{
        width: '100%',
        height: '100%',
        boxShadow: `0 8px 28px rgba(0,0,0,0.22)${glow > 0 ? `, 0 0 0 ${1 + glow}px rgba(175,207,244,${0.35 * glow}), 0 0 ${28 * glow}px rgba(120,181,255,${0.28 * glow})` : ''}`,
      }}
    >
      <div style={{display: 'flex', alignItems: 'center', height: '100%', padding: '0 10px', gap: 8, fontFamily: FONT}}>
        <div
          style={{
            width: 30,
            height: 30,
            borderRadius: 10,
            background: dark.balanceBackground,
            color: dark.balanceText,
            fontSize: 19,
            fontWeight: 700,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            lineHeight: 1,
            paddingBottom: 2,
          }}
        >
          d.
        </div>
        <div style={{fontSize: 12, fontWeight: 600, color: dark.textPrimary}}>Ask Duitlah</div>
        <div style={{color: dark.textSecondary, fontSize: 14}}>↗</div>
      </div>
    </Glass>
  </div>
);

/** `slot` is continuous so the active lens glides between destinations. */
export const Dock: React.FC<{slot: number; fabGlow?: number; fabOpacity?: number}> = ({slot, fabGlow = 0, fabOpacity = 1}) => {
  const inner = 390 - 16;
  const cell = inner / 5;
  const lensX = 8 + cell * slot + cell / 2;
  return (
    <>
      <div style={{opacity: fabOpacity}}>
        <AskDuitlah glow={fabGlow} />
      </div>
      <div style={{position: 'absolute', left: 0, right: 0, top: DOCK_TOP, height: 110, zIndex: 20}}>
        <Glass material="strong" radius={18} elevated style={{height: '100%'}}>
          <div
            style={{
              position: 'absolute',
              top: 4,
              left: lensX - 23,
              width: 46,
              height: 28,
              borderRadius: 12,
              background: 'rgba(27,39,54,0.52)',
              border: '1px solid rgba(255,255,255,0.08)',
            }}
          />
          <div style={{position: 'absolute', top: 0, left: lensX - 12, width: 24, height: 2, background: dark.primary}} />
          <div style={{position: 'absolute', top: 4, left: 8, right: 8, display: 'flex'}}>
            {items.map((it, i) => {
              const sel = Math.max(0, 1 - Math.abs(slot - i) * 1.6);
              const centre = i === 2;
              const tint = sel > 0.5 ? dark.primary : 'rgba(245,247,250,0.8)';
              const iconColor = centre ? (sel > 0.5 ? dark.balanceText : dark.primary) : tint;
              return (
                <div key={it.label} style={{flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', paddingTop: 6}}>
                  <div
                    style={{
                      width: 46,
                      height: 26,
                      borderRadius: 12,
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      background: centre ? (sel > 0.5 ? dark.balanceBackground : dark.primarySubtle) : undefined,
                    }}
                  >
                    <Icon name={it.icon} size={23} color={iconColor} />
                  </div>
                  <div
                    style={{
                      marginTop: 5,
                      fontFamily: FONT,
                      fontSize: 11.5,
                      fontWeight: 600,
                      color: tint,
                      letterSpacing: -0.1,
                    }}
                  >
                    {it.label}
                  </div>
                </div>
              );
            })}
          </div>
        </Glass>
      </div>
    </>
  );
};
