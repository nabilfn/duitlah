import Link from "next/link";
import { Logo } from "@/components/brand/logo";

function MarketingFooter() {
  return (
    <footer className="border-border/60 border-t">
      <div className="mx-auto flex max-w-6xl flex-col gap-6 px-4 py-10 md:flex-row md:items-center md:justify-between md:px-8">
        <Logo />
        <nav className="text-muted-foreground flex flex-wrap gap-x-6 gap-y-2 text-sm">
          <Link href="/help" className="hover:text-foreground hover:underline">
            Help Centre
          </Link>
          <Link href="/faq" className="hover:text-foreground hover:underline">
            FAQ
          </Link>
          <Link href="/status" className="hover:text-foreground hover:underline">
            Status
          </Link>
          <Link href="/privacy" className="hover:text-foreground hover:underline">
            Privacy
          </Link>
          <Link href="/terms" className="hover:text-foreground hover:underline">
            Terms
          </Link>
          <a href="mailto:support@duitlah.app" className="hover:text-foreground hover:underline">
            Contact
          </a>
        </nav>
        <p className="text-muted-foreground text-xs">
          © {new Date().getFullYear()} Duitlah. Money made social.
        </p>
      </div>
    </footer>
  );
}

export { MarketingFooter };
