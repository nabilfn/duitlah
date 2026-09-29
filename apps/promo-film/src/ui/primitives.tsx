import React from 'react';
import {dark, FONT, glass} from '../theme';

type Material = 'standard' | 'strong' | 'soft' | 'hero';

// Port of DuitlahGlassSurface: gradient already carries the material opacity,
// thin border, a 1px internal highlight inset from the corners, optional blur.
export const Glass: React.FC<{
  material?: Material;
  radius?: number;
  blur?: boolean;
  elevated?: boolean;
  style?: React.CSSProperties;
  children?: React.ReactNode;
}> = ({material = 'standard', radius = 18, blur = true, elevated = false, style, children}) => {
  const fill = glass[material];
  const hero = material === 'hero';
  return (
    <div
      style={{
        position: 'relative',
        borderRadius: radius,
        border: `1px solid ${hero ? glass.heroBorder : glass.border}`,
        background: `linear-gradient(180deg, rgba(255,255,255,0.025), rgba(255,255,255,0.005)), ${fill}`,
        backdropFilter: blur ? `blur(${material === 'strong' ? 22 : hero ? 10 : 18}px) saturate(1.3)` : undefined,
        WebkitBackdropFilter: blur ? `blur(${material === 'strong' ? 22 : 18}px) saturate(1.3)` : undefined,
        boxShadow: elevated ? glass.shadow : undefined,
        overflow: 'hidden',
        ...style,
      }}
    >
      <div
        style={{
          position: 'absolute',
          top: 0,
          left: radius * 0.6,
          right: radius * 0.6,
          height: 1,
          background: hero ? glass.heroHighlight : glass.highlight,
        }}
      />
      {children}
    </div>
  );
};

export const StatusBar: React.FC<{color?: string}> = ({color = dark.textPrimary}) => (
  <div
    style={{
      position: 'absolute',
      top: 0,
      left: 0,
      right: 0,
      height: 54,
      zIndex: 50,
      fontFamily: FONT,
      color,
    }}
  >
    <div style={{position: 'absolute', left: 50, top: 18, fontSize: 16, fontWeight: 600, letterSpacing: -0.2}}>9:41</div>
    <svg width={78} height={14} viewBox="0 0 78 14" style={{position: 'absolute', right: 26, top: 21}}>
      {[0, 1, 2, 3].map((i) => (
        <rect key={i} x={i * 5} y={9 - i * 2.6} width={3.2} height={3.4 + i * 2.6} rx={0.9} fill={color} />
      ))}
      <path d="M31 4.6a9 9 0 0 1 12 0M33.3 7.2a5.6 5.6 0 0 1 7.4 0" stroke={color} strokeWidth={1.6} fill="none" strokeLinecap="round" />
      <circle cx={37} cy={10.3} r={1.4} fill={color} />
      <rect x={50.5} y={1.5} width={22} height={11} rx={3.3} stroke={color} strokeOpacity={0.4} fill="none" />
      <rect x={52.5} y={3.5} width={16} height={7} rx={1.8} fill={color} />
      <rect x={73.8} y={5} width={1.6} height={4} rx={0.8} fill={color} fillOpacity={0.4} />
    </svg>
  </div>
);

export const DynamicIsland: React.FC = () => (
  <div
    style={{
      position: 'absolute',
      top: 11,
      left: '50%',
      width: 122,
      height: 35,
      marginLeft: -61,
      borderRadius: 20,
      background: '#000',
      zIndex: 60,
    }}
  />
);

export const HomeIndicator: React.FC<{color?: string}> = ({color = dark.textPrimary}) => (
  <div
    style={{
      position: 'absolute',
      bottom: 8,
      left: '50%',
      width: 134,
      marginLeft: -67,
      height: 5,
      borderRadius: 3,
      background: color,
      opacity: 0.85,
      zIndex: 60,
    }}
  />
);

export const Divider: React.FC<{color?: string}> = ({color = dark.borderSubtle}) => (
  <div style={{height: 1, background: color}} />
);
