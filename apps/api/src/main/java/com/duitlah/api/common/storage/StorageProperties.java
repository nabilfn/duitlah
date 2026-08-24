package com.duitlah.api.common.storage;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Points at any S3-compatible endpoint — MinIO locally (see docker-compose.yml), a real AWS S3
 * bucket or Supabase Storage's S3-compatible API in production. {@code pathStyleAccess} must stay
 * {@code true} for MinIO (it doesn't support virtual-hosted-style bucket addressing by default); a
 * real AWS bucket would typically set it {@code false}.
 *
 * <p>{@code endpoint} and {@code publicEndpoint} deliberately differ in local dev: the API talks to
 * MinIO over the Docker Compose network (the {@code minio} hostname), but a presigned URL is handed
 * to a browser running on the host, which can't resolve that hostname at all — it needs {@code
 * http://localhost:9000} instead. A real deployment (AWS S3, Supabase Storage) would set both to
 * the same public value.
 */
@ConfigurationProperties(prefix = "duitlah.storage")
public record StorageProperties(
    String endpoint,
    String publicEndpoint,
    String region,
    String bucket,
    String accessKey,
    String secretKey,
    boolean pathStyleAccess) {}
