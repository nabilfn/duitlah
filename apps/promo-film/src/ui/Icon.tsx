import React from 'react';

// Port of DuitlahIcon (core/widgets/duitlah_icon.dart): original 24-unit rounded
// line drawings, stroke 1.7, round caps/joins. No icon font.

const arc = (x: number, y: number, w: number, h: number, start: number, sweep: number) => {
  const cx = x + w / 2, cy = y + h / 2, rx = w / 2, ry = h / 2;
  const x1 = cx + rx * Math.cos(start), y1 = cy + ry * Math.sin(start);
  const x2 = cx + rx * Math.cos(start + sweep), y2 = cy + ry * Math.sin(start + sweep);
  const large = Math.abs(sweep) > Math.PI ? 1 : 0;
  return `M${x1} ${y1} A${rx} ${ry} 0 ${large} ${sweep > 0 ? 1 : 0} ${x2} ${y2}`;
};
const L = (x: number, y: number, x2: number, y2: number) => `M${x} ${y}L${x2} ${y2}`;
const P = (pts: number[][]) => 'M' + pts.map((p) => p.join(' ')).join('L');
const C = (x: number, y: number, r: number) => `M${x - r} ${y}a${r} ${r} 0 1 0 ${2 * r} 0a${r} ${r} 0 1 0 ${-2 * r} 0`;
const B = (x: number, y: number, w: number, h: number, r = 2) =>
  `M${x + r} ${y}H${x + w - r}Q${x + w} ${y} ${x + w} ${y + r}V${y + h - r}Q${x + w} ${y + h} ${x + w - r} ${y + h}H${x + r}Q${x} ${y + h} ${x} ${y + h - r}V${y + r}Q${x} ${y} ${x + r} ${y}Z`;

const glyphs: Record<string, string[]> = {
  home: [P([[3, 10], [12, 3], [21, 10]]), P([[5, 9], [5, 21], [10, 21], [10, 14], [14, 14], [14, 21], [19, 21], [19, 9]])],
  person: [C(12, 7, 3.5), 'M4 21C4 11 20 11 20 21Z'],
  people: [C(9, 7, 3), C(18, 8, 2.2), 'M2 21C2 12 16 12 16 21Z', 'M17 14Q22 14 22 21'],
  chart: [B(4, 13, 3, 8, 1.5), B(10.5, 8, 3, 13, 1.5), B(17, 3, 3, 18, 1.5)],
  wallet: [B(3, 6, 18, 15, 3), P([[4, 6], [17, 3], [17, 6]]), B(14, 11, 7, 5, 1.5), C(17, 13.5, 0.5)],
  bank: [P([[3, 8], [12, 3], [21, 8], [3, 8]]), L(3, 21, 21, 21), L(6, 11, 6, 18), L(12, 11, 12, 18), L(18, 11, 18, 18)],
  receipt: [P([[5, 3], [19, 3], [19, 21], [15, 19], [12, 21], [9, 19], [5, 21], [5, 3]]), L(8, 8, 16, 8), L(8, 12, 16, 12)],
  document: [B(5, 3, 14, 18, 2), L(8, 8, 16, 8), L(8, 12, 16, 12), L(8, 16, 13, 16)],
  split: [C(12, 5, 2), C(5, 19, 2), C(19, 19, 2), P([[12, 7], [12, 11], [5, 11], [5, 17]]), P([[12, 11], [19, 11], [19, 17]])],
  search: [C(10, 10, 6), L(14.5, 14.5, 21, 21)],
  filter: [L(3, 5, 21, 5), L(3, 12, 21, 12), L(3, 19, 21, 19), B(7, 3, 3, 4, 1), B(15, 10, 3, 4, 1), B(8, 17, 3, 4, 1)],
  bell: ['M4 18L6 14L6 9C6 1 18 1 18 9L18 14L20 18Z', L(10, 21, 14, 21)],
  calendar: [B(3, 5, 18, 16, 3), L(3, 10, 21, 10), L(8, 3, 8, 7), L(16, 3, 16, 7), B(7, 14, 3, 3, 1), L(14, 15, 17, 15)],
  goal: [C(12, 12, 9), C(12, 12, 4.5), L(12, 12, 21, 3), L(17, 3, 21, 3), L(21, 3, 21, 7)],
  pie: [arc(3, 3, 18, 18, 0.1, 4.5), P([[12, 3], [12, 12], [21, 12]])],
  scan: [B(3, 3, 5, 5, 1), B(16, 3, 5, 5, 1), B(3, 16, 5, 5, 1), P([[16, 13], [16, 17], [21, 17], [21, 21]]), L(3, 12, 21, 12), L(12, 3, 12, 7), L(12, 17, 12, 21)],
  camera: [B(2, 6, 20, 15, 3), P([[7, 6], [9, 3], [15, 3], [17, 6]]), C(12, 13.5, 4)],
  leaf: ['M12 20C1 19 2 8 3 7C12 7 13 12 12 20C11 5 18 3 22 3C22 13 15 14 12 14', L(12, 14, 12, 22)],
  check: [P([[4, 12], [9, 17], [20, 6]])],
  plus: [L(12, 4, 12, 20), L(4, 12, 20, 12)],
  right: [P([[9, 5], [16, 12], [9, 19]])],
  left: [P([[15, 5], [8, 12], [15, 19]])],
  down: [P([[5, 9], [12, 16], [19, 9]])],
  in: [L(12, 3, 12, 21), P([[5, 14], [12, 21], [19, 14]])],
  out: [L(12, 21, 12, 3), P([[5, 10], [12, 3], [19, 10]])],
  equals: [L(4, 8, 20, 8), L(4, 16, 20, 16)],
  eye: ['M2 12Q12 -1 22 12Q12 25 2 12', C(12, 12, 3)],
  box: [B(3, 6, 18, 15, 2), P([[3, 6], [7, 2], [17, 2], [21, 6]]), L(9, 11, 15, 11)],
  assistant: [B(3, 3.5, 18, 13, 4), P([[8.5, 16.5], [8.5, 20.5], [12.5, 16.5]]), L(9, 12.5, 9, 10), L(12, 12.5, 12, 9), L(15, 12.5, 15, 7)],
  repeat: [arc(4, 4, 16, 16, -0.5, 4.9), P([[14, 3], [20, 3], [20, 9]])],
};

export type IconName = keyof typeof glyphs;

export const Icon: React.FC<{name: IconName; size?: number; color?: string; style?: React.CSSProperties}> = ({
  name,
  size = 24,
  color = 'currentColor',
  style,
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" style={{display: 'block', flexShrink: 0, ...style}}>
    {glyphs[name].map((d, i) => (
      <path key={i} d={d} fill="none" stroke={color} strokeWidth={1.7} strokeLinecap="round" strokeLinejoin="round" />
    ))}
  </svg>
);
