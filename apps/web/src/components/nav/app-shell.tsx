import { DesktopSidebar } from "./desktop-sidebar";
import { MobileBottomNav } from "./mobile-bottom-nav";

function AppShell({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex min-h-dvh">
      <DesktopSidebar />
      <main id="main-content" tabIndex={-1} className="min-w-0 flex-1 pb-24 md:pb-0">
        {children}
      </main>
      <MobileBottomNav />
    </div>
  );
}

export { AppShell };
