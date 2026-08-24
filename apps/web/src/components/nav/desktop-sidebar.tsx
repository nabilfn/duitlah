"use client";

import { BellIcon, SettingsIcon } from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { Logo } from "@/components/brand/logo";
import { ThemeToggle } from "@/components/theme-toggle";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { cn } from "@/lib/utils";
import { BAGILAH_ITEM, NAV_ITEMS } from "./nav-items";

function DesktopSidebar() {
  const pathname = usePathname();
  const items = NAV_ITEMS.filter((item) => item.href !== BAGILAH_ITEM.href);

  return (
    <aside className="bg-sidebar text-sidebar-foreground border-sidebar-border sticky top-0 hidden h-dvh w-60 shrink-0 flex-col border-r px-3 py-4 md:flex">
      <Link href="/dashboard" className="px-2 py-2">
        <Logo />
      </Link>

      <nav className="mt-4 flex flex-1 flex-col gap-1">
        {items.map((item) => {
          const active = pathname === item.href;
          const Icon = item.icon;
          return (
            <Link
              key={item.href}
              href={item.href}
              aria-current={active ? "page" : undefined}
              className={cn(
                "flex items-center gap-2.5 rounded-lg px-2.5 py-2 text-sm font-medium transition-colors",
                active
                  ? "bg-sidebar-accent text-sidebar-accent-foreground"
                  : "text-sidebar-foreground/70 hover:bg-sidebar-accent hover:text-sidebar-accent-foreground",
              )}
            >
              <Icon className="size-4.5" />
              {item.label}
            </Link>
          );
        })}

        {/* Bagilah gets its own color, not the sidebar's active-state
            treatment — it's the flagship feature and should read as one,
            even resting in a list of otherwise-equal nav items. */}
        <Link
          href={BAGILAH_ITEM.href}
          className={cn(
            "mt-1 flex items-center gap-2.5 rounded-lg px-2.5 py-2 text-sm font-semibold transition-colors",
            pathname === BAGILAH_ITEM.href
              ? "bg-bagilah text-bagilah-foreground"
              : "bg-bagilah/15 text-bagilah-foreground hover:bg-bagilah/25 dark:text-bagilah",
          )}
        >
          <BAGILAH_ITEM.icon className="size-4.5" />
          {BAGILAH_ITEM.label}
        </Link>
      </nav>

      <div className="border-sidebar-border flex items-center gap-1 border-t pt-3">
        <Link
          href="/notifications"
          className="text-sidebar-foreground/70 hover:bg-sidebar-accent hover:text-sidebar-accent-foreground flex size-8 items-center justify-center rounded-lg"
          aria-label="Notifications"
        >
          <BellIcon className="size-4.5" />
        </Link>
        <Link
          href="/settings"
          className="text-sidebar-foreground/70 hover:bg-sidebar-accent hover:text-sidebar-accent-foreground flex size-8 items-center justify-center rounded-lg"
          aria-label="Settings"
        >
          <SettingsIcon className="size-4.5" />
        </Link>
        <div className="flex-1" />
        <ThemeToggle />
        <Link href="/profile" aria-label="Profile" className="ml-1">
          <Avatar className="size-8">
            <AvatarFallback className="text-xs">D</AvatarFallback>
          </Avatar>
        </Link>
      </div>
    </aside>
  );
}

export { DesktopSidebar };
