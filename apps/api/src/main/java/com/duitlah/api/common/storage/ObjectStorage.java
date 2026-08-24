package com.duitlah.api.common.storage;

import java.time.Duration;

/**
 * Abstraction over the object storage provider, so receipt-image code never depends on a specific
 * vendor's SDK directly. The only implementation is {@link S3ObjectStorage} (S3-compatible — works
 * against real AWS S3, Supabase Storage, or the MinIO container this repo runs locally); unlike
 * {@link com.duitlah.api.common.mail.EmailSender}'s logging-only stand-in, there's no no-op version
 * here, since a receipt scan with no way to display the uploaded image back to the user isn't a
 * usable feature to begin with.
 */
public interface ObjectStorage {

  /** Uploads content under {@code key}, overwriting whatever was there before. */
  void put(String key, byte[] content, String contentType);

  /** A time-limited, signed URL for privately reading {@code key} — never a public link. */
  String presignedGetUrl(String key, Duration ttl);
}
