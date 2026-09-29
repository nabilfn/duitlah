// Master timeline in seconds. One continuous journey; scenes overlap at bridges.

export const T = {
  // 0:00–0:03 wake
  wakePool: [0.35, 1.6],
  streak: [0.35, 2.1],
  screenOn: [1.25, 1.55],
  entryStart: 1.35, // entry clock runs at half speed (x2 duration)
  // 0:03–0:07 dashboard
  homeHeader: 3.55,
  balanceCount: [4.0, 5.4],
  trajectory: [4.3, 5.5],
  canvasLift: [4.9, 5.7],
  homeScroll: [5.3, 6.5],
  // bridge: balance → transaction row
  peel: [6.7, 7.6],
  toTransactions: [6.9, 7.4],
  // 0:07–0:11 transactions
  rowsStart: 7.15,
  rowPress: [9.0, 9.3],
  rowExpand: [9.2, 9.75],
  // bridge: row → Bagilah bill
  lift: [10.15, 11.0],
  phoneBlur: [10.2, 10.9],
  // 0:11–0:16 Bagilah
  nodes: [11.3, 12.3],
  links: [12.35, 13.0],
  divide: [12.95, 14.3],
  collapse: [15.55, 16.6],
  // 0:16–0:20 analytics
  phoneFocus: [16.0, 16.9],
  ringLand: [16.3, 17.05],
  kept: [16.9, 18.1],
  select: [18.9, 19.3],
  point: [19.45, 20.15],
  // 0:20–0:23 assistant
  dim: [19.8, 20.3],
  expand: [20.2, 20.85],
  typed: [20.8, 21.2],
  sent: [21.25, 21.5],
  thinking: [21.45, 21.75],
  answer: [21.7, 22.45],
  // 0:23–0:26 feature universe
  collapseAssistant: [23.05, 23.55],
  fragmentsOut: [23.2, 24.4],
  fragmentsIn: [25.2, 26.0],
  // 0:26–0:28 hero, 0:28–0:30 end
  recede: [27.95, 28.9],
  logo: [28.5, 29.5],
};

/** Headlines: [start, end] in seconds. Each holds ≥1.3 s fully on screen. */
export const COPY: {h: string; sub?: string; at: [number, number]; subAt?: number; size?: number}[] = [
  {h: 'Where did it all go?', sub: 'Your money moves fast.', at: [1.85, 3.65], subAt: 2.15},
  {h: 'See everything.', sub: 'Your money, in one place.', at: [4.0, 6.95], subAt: 4.3},
  {h: 'Know where it went.', sub: 'Every transaction. Clear.', at: [7.45, 10.55], subAt: 7.75},
  {h: 'Bagilah.', at: [11.15, 13.0], size: 1.25},
  {h: 'Split without the mess.', sub: 'Everyone knows their part.', at: [13.2, 15.9], subAt: 13.5},
  {h: 'Understand the pattern.', sub: 'Not just the numbers.', at: [16.7, 19.8], subAt: 17.05},
  {h: 'Just ask.', sub: 'Your money, explained.', at: [20.25, 22.95], subAt: 20.55},
  {h: 'More than tracking.', at: [23.5, 25.95]},
  {h: 'Duitlah.', sub: 'Money, understood.', at: [26.35, 28.15], subAt: 26.7, size: 1.15},
];

/** One representative still per scene (seconds). */
export const STILLS: {name: string; t: number}[] = [
  {name: '01_wake', t: 2.2},
  {name: '02_dashboard', t: 5.6},
  {name: '03_transactions', t: 9.6},
  {name: '04_bagilah', t: 14.8},
  {name: '05_analytics', t: 18.6},
  {name: '06_assistant', t: 22.6},
  {name: '07_universe', t: 24.8},
  {name: '08_hero', t: 27.4},
  {name: '09_end', t: 29.8},
];
