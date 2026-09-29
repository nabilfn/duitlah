// Fictional demo state. No real user data. Totals reconcile to the cent.

export const user = {firstName: 'Amir'};

export const dashboard = {
  date: '28 August',
  // Before today's coffee; the film peels RM 12.90 off it.
  openingBalance: 4863.65,
  availableBalance: 4850.75,
  monthIncome: 6200.0,
  monthExpense: 3420.75,
};

export type Txn = {
  merchant: string;
  account: string;
  amount: number;
  incoming?: boolean;
  day: 'Today' | 'Yesterday' | '25 Aug 2026';
  note?: string;
};

export const transactions: Txn[] = [
  {merchant: 'ZUS Coffee', account: 'Maybank', amount: 12.9, day: 'Today'},
  {merchant: 'Hotpot dinner', account: 'Maybank', amount: 186.4, day: 'Today', note: 'With Aisyah, Daniel and Hana'},
  {merchant: 'Grab', account: 'TNG eWallet', amount: 18.4, day: 'Today'},
  {merchant: 'Jaya Grocer', account: 'Maybank', amount: 67.2, day: 'Yesterday'},
  {merchant: 'Tenaga Nasional', account: 'Maybank', amount: 142.35, day: 'Yesterday'},
  {merchant: 'Salary', account: 'Maybank', amount: 6200, incoming: true, day: '25 Aug 2026'},
];

// One Bagilah bill, claimed item by item. 52.30 + 41.90 + 45.10 + 47.10 = 186.40.
export const bill = {
  merchant: 'Hotpot dinner',
  total: 186.4,
  people: [
    {name: 'Aisyah', amount: 52.3},
    {name: 'Daniel', amount: 41.9},
    {name: 'Hana', amount: 45.1},
    {name: 'You', amount: 47.1},
  ],
};

// Category spending for August. Sums to 3,420.75.
export const categories = [
  {name: 'Food', amount: 1368.3},
  {name: 'Bills', amount: 598.35},
  {name: 'Transport', amount: 512.6},
  {name: 'Lifestyle', amount: 342.3},
  {name: 'Shopping', amount: 342.1},
  {name: 'Education', amount: 257.1},
];

export const analytics = {
  monthTitle: 'August,\nat a glance.',
  month: 'August 2026',
  kept: 2779.25,
  totalExpenses: 3420.75,
};

export const assistant = {
  question: 'Where did most of my money go this month?',
  answer:
    'Food, at RM 1,368.30. That is 40% of the RM 3,420.75 you spent in August, mostly restaurants and groceries.',
};

export const money = (n: number, opts: {sign?: '+' | '−'} = {}) => {
  const s = n.toLocaleString('en-MY', {minimumFractionDigits: 2, maximumFractionDigits: 2});
  return `${opts.sign ? opts.sign + ' ' : ''}RM ${s}`;
};
