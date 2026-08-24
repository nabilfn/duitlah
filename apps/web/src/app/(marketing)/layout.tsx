import { MarketingFooter } from "@/components/marketing/marketing-footer";
import { MarketingHeader } from "@/components/marketing/marketing-header";

/** Public, logged-out surfaces — landing page, privacy, terms, help, FAQ, status. No
 * `RequireAuth`, no `AppShell`: these have to render correctly for a visitor with no
 * session at all, since that's exactly who's meant to land here. */
export default function MarketingLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex min-h-dvh flex-col">
      <MarketingHeader />
      <main id="main-content" tabIndex={-1} className="flex-1">
        {children}
      </main>
      <MarketingFooter />
    </div>
  );
}
