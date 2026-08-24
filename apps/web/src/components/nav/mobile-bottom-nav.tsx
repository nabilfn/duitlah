"use client";

import { MoreHorizontalIcon } from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";
import { BAGILAH_ITEM, MOBILE_PRIMARY_ITEMS } from "./nav-items";

function MobileBottomNav() {
  const pathname = usePathname();
  const [home, transactions, groups] = MOBILE_PRIMARY_ITEMS;
  const bagilahActive = pathname === BAGILAH_ITEM.href;

  return (
    <nav
      className="border-border bg-background/95 fixed inset-x-0 bottom-0 z-50 border-t pb-[env(safe-area-inset-bottom)] backdrop-blur md:hidden"
      aria-label="Primary"
    >
      <div className="relative grid grid-cols-5 items-center px-2">
        <NavLink item={home} active={pathname === home.href} />
        <NavLink item={transactions} active={pathname === transactions.href} />

        {/* Center slot stays empty in the grid — the raised button is
            positioned on top of it so it can overflow the bar upward. */}
        <div />

        <NavLink item={groups} active={pathname === groups.href} />
        <Link
          href="/more"
          className={cn(
            "flex flex-col items-center gap-1 py-2 text-[0.6875rem] font-medium",
            pathname === "/more" ? "text-foreground" : "text-muted-foreground",
          )}
        >
          <MoreHorizontalIcon className="size-5" />
          More
        </Link>

        <Link
          href={BAGILAH_ITEM.href}
          aria-current={bagilahActive ? "page" : undefined}
          className="absolute left-1/2 col-start-3 flex -translate-x-1/2 -translate-y-4.5 flex-col items-center gap-1"
        >
          <span
            className={cn(
              "bg-bagilah text-bagilah-foreground border-background flex size-13 items-center justify-center rounded-full border-4 shadow-lg transition-transform active:scale-95",
            )}
          >
            <BAGILAH_ITEM.icon className="size-6" />
          </span>
          <span
            className={cn("text-[0.6875rem] font-semibold", bagilahActive && "text-foreground")}
          >
            {BAGILAH_ITEM.label}
          </span>
        </Link>
      </div>
    </nav>
  );
}

function NavLink({
  item,
  active,
}: {
  item: (typeof MOBILE_PRIMARY_ITEMS)[number];
  active: boolean;
}) {
  const Icon = item.icon;
  return (
    <Link
      href={item.href}
      aria-current={active ? "page" : undefined}
      className={cn(
        "flex flex-col items-center gap-1 py-2 text-[0.6875rem] font-medium",
        active ? "text-foreground" : "text-muted-foreground",
      )}
    >
      <Icon className="size-5" />
      {item.label}
    </Link>
  );
}

export { MobileBottomNav };
