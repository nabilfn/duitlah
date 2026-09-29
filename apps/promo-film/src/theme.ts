// Tokens mirrored 1:1 from the Flutter app (apps/mobile/lib/core/theme/*).
// The film uses the dark palette plus the navy entry environment.

export const dark = {
  background: '#070A10',
  surface: '#101721',
  surfaceSecondary: '#0C1118',
  surfaceElevated: '#141D29',
  primary: '#AFCFF4',
  primaryDark: '#73B8FF',
  primarySoft: '#1D3553',
  primarySubtle: '#182C45',
  textPrimary: '#F5F7FA',
  textSecondary: '#ABB4C0',
  textTertiary: '#8893A2',
  textOnPrimary: '#09131F',
  border: '#28313D',
  borderSubtle: '#1E2733',
  positive: '#72A68F',
  negative: '#D98272',
  balanceBackground: '#16263B',
  balanceText: '#F5F7FA',
  balanceSecondary: '#AFCFF4',
  balanceMuted: '#ABB4C0',
  balanceHighlight: '#AFCFF4',
} as const;

export const light = {
  background: '#F5F5F2',
  surface: '#FCFCFA',
  surfaceSecondary: '#EFEFEB',
  primaryDark: '#09131F',
  textPrimary: '#111317',
  textSecondary: '#6B7280',
  positive: '#34705A',
  positiveSoft: '#E5F0EB',
  negative: '#B85C4B',
  negativeSoft: '#F5E8E4',
  information: '#526C89',
  informationSoft: '#E8EDF2',
  warning: '#B68435',
} as const;

// EntryPalette — the deep-navy door.
export const entry = {
  background: '#081321',
  backgroundDeep: '#06101B',
  blue: '#78B5FF',
  blueSoft: '#A9C8EE',
  text: '#F7F9FC',
  textMuted: '#90A1B6',
} as const;

// DuitlahColors.chartColors (dark) — chart marks.
export const chartDark = ['#AFCDF0', '#73B8FF', '#8EA4BC', '#6989AB', '#7896B0', '#769799'];

// GlassTokens (dark).
export const glass = {
  standard: 'rgba(17,24,35,0.62)',
  strong: 'rgba(18,27,40,0.76)',
  soft: 'rgba(27,39,54,0.52)',
  hero: 'rgba(255,255,255,0.08)',
  border: 'rgba(255,255,255,0.08)',
  heroBorder: 'rgba(255,255,255,0.12)',
  highlight: 'rgba(255,255,255,0.10)',
  heroHighlight: 'rgba(255,255,255,0.20)',
  shadow: '0 8px 28px rgba(0,0,0,0.22)',
} as const;

export const FONT = "'Plus Jakarta Sans', system-ui, sans-serif";
export const SERIF = "'Bodoni Moda', serif";

// AppTheme text scale (logical px).
export const type = {
  displaySmall: {fontSize: 40, fontWeight: 800, letterSpacing: -0.6},
  headlineMedium: {fontSize: 26, fontWeight: 700, letterSpacing: -0.4},
  headlineSmall: {fontSize: 21, fontWeight: 700, letterSpacing: -0.3},
  titleLarge: {fontSize: 18, fontWeight: 700},
  titleMedium: {fontSize: 16, fontWeight: 600},
  titleSmall: {fontSize: 14, fontWeight: 600},
  bodyLarge: {fontSize: 16, fontWeight: 400},
  bodyMedium: {fontSize: 14, fontWeight: 400},
  bodySmall: {fontSize: 13, fontWeight: 500},
  labelMedium: {fontSize: 12, fontWeight: 600},
  appBar: {fontSize: 24, fontWeight: 700, letterSpacing: -0.2},
} as const;

export const tabular = {fontVariantNumeric: 'tabular-nums' as const};
