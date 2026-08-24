import Link from "next/link";
import { Logo } from "@/components/brand/logo";
import { Button } from "@/components/ui/button";

function MarketingHeader() {
  return (
    <header className="border-border/60 sticky top-0 z-10 border-b bg-background/80 backdrop-blur-sm">
      <div className="mx-auto flex max-w-6xl items-center justify-between px-4 py-4 md:px-8">
        <Link href="/">
          <Logo />
        </Link>
        <nav className="flex items-center gap-2">
          <Button variant="ghost" nativeButton={false} render={<Link href="/login">Log in</Link>} />
          <Button nativeButton={false} render={<Link href="/register">Get started</Link>} />
        </nav>
      </div>
    </header>
  );
}

export { MarketingHeader };
