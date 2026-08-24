import {
  CalendarIcon,
  HandCoinsIcon,
  HomeIcon,
  LineChartIcon,
  PiggyBankIcon,
  ReceiptTextIcon,
  TargetIcon,
  UsersIcon,
  WalletIcon,
  type LucideIcon,
} from "lucide-react";

export interface NavItem {
  label: string;
  href: string;
  icon: LucideIcon;
}

/** Full desktop sidebar order. Bagilah is included here but rendered with
 * its own treatment, not looped in as a plain item — see DesktopSidebar. */
export const NAV_ITEMS: NavItem[] = [
  { label: "Home", href: "/dashboard", icon: HomeIcon },
  { label: "Transactions", href: "/transactions", icon: WalletIcon },
  { label: "Budget", href: "/budget", icon: PiggyBankIcon },
  { label: "Bagilah", href: "/bagilah", icon: ReceiptTextIcon },
  { label: "Groups", href: "/groups", icon: UsersIcon },
  { label: "Settlements", href: "/settlements", icon: HandCoinsIcon },
  { label: "Goals", href: "/goals", icon: TargetIcon },
  { label: "Calendar", href: "/calendar", icon: CalendarIcon },
  { label: "Insights", href: "/insights", icon: LineChartIcon },
];

/** Mobile bottom nav is a deliberate subset — Bagilah is the prominent
 * center action, everything else collapses under "More". */
export const MOBILE_PRIMARY_ITEMS: NavItem[] = [
  { label: "Home", href: "/dashboard", icon: HomeIcon },
  { label: "Transactions", href: "/transactions", icon: WalletIcon },
  { label: "Groups", href: "/groups", icon: UsersIcon },
];

export const BAGILAH_ITEM: NavItem = {
  label: "Bagilah",
  href: "/bagilah",
  icon: ReceiptTextIcon,
};
