package com.duitlah.api.subscriptions;

/**
 * Abstraction over the three purchase-verification backends the product spec asks Phase 13 to
 * "prepare" (section 78): Apple's App Store Server API, Google's Play Developer API, and a web
 * checkout (e.g. Stripe). Same "optional external provider, real interface, honest fallback" shape
 * as {@code receipts.ReceiptOcrService}/{@code common.mail.EmailSender} — {@link
 * UnavailableSubscriptionVerifier} is what's wired in today for every source, since this repository
 * has no real store credentials to verify against; a real implementation (calling out to each
 * provider's actual verification endpoint) is what "prepare the architecture" leaves for whoever
 * configures real store/payment accounts, not something to fake here.
 */
public interface SubscriptionVerifier {

  VerificationResult verify(SubscriptionSource source, String receiptData);
}
