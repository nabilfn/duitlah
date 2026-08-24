package com.duitlah.api.common.storage;

import jakarta.annotation.PostConstruct;
import java.net.URI;
import java.time.Duration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.S3Configuration;
import software.amazon.awssdk.services.s3.model.CreateBucketRequest;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.HeadBucketRequest;
import software.amazon.awssdk.services.s3.model.NoSuchBucketException;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.GetObjectPresignRequest;

@Component
public class S3ObjectStorage implements ObjectStorage {

  private static final Logger log = LoggerFactory.getLogger(S3ObjectStorage.class);

  private final S3Client client;
  private final S3Presigner presigner;
  private final String bucket;

  public S3ObjectStorage(StorageProperties properties) {
    AwsBasicCredentials credentials =
        AwsBasicCredentials.create(properties.accessKey(), properties.secretKey());
    S3Configuration serviceConfiguration =
        S3Configuration.builder().pathStyleAccessEnabled(properties.pathStyleAccess()).build();

    this.client =
        S3Client.builder()
            .endpointOverride(URI.create(properties.endpoint()))
            .region(Region.of(properties.region()))
            .credentialsProvider(StaticCredentialsProvider.create(credentials))
            .serviceConfiguration(serviceConfiguration)
            .build();
    // Signed against the *public* endpoint, not the internal one the client above uses --
    // SigV4 signs the request's Host header, so a URL meant for a browser to fetch must be
    // signed as if it were requested from that public host, or the signature won't validate.
    this.presigner =
        S3Presigner.builder()
            .endpointOverride(URI.create(properties.publicEndpoint()))
            .region(Region.of(properties.region()))
            .credentialsProvider(StaticCredentialsProvider.create(credentials))
            .serviceConfiguration(serviceConfiguration)
            .build();
    this.bucket = properties.bucket();
  }

  // Not allowed to fail application startup: a transient storage outage, or a test context that
  // genuinely has no use for receipt uploads and never configured a reachable endpoint, shouldn't
  // take down the whole app/every unrelated test. The tradeoff is that a real misconfiguration
  // (wrong bucket, wrong credentials) only surfaces the first time something actually tries to
  // upload, not at boot -- an acceptable price for not coupling every other module's tests to
  // this one having a live MinIO.
  @PostConstruct
  void ensureBucketExists() {
    try {
      client.headBucket(HeadBucketRequest.builder().bucket(bucket).build());
    } catch (NoSuchBucketException e) {
      log.info("Creating storage bucket \"{}\" (not found on startup)", bucket);
      client.createBucket(CreateBucketRequest.builder().bucket(bucket).build());
    } catch (RuntimeException e) {
      log.warn(
          "Could not verify storage bucket \"{}\" on startup ({}); will retry on first real use.",
          bucket,
          e.getMessage());
    }
  }

  @Override
  public void put(String key, byte[] content, String contentType) {
    try {
      client.putObject(
          PutObjectRequest.builder().bucket(bucket).key(key).contentType(contentType).build(),
          RequestBody.fromBytes(content));
    } catch (NoSuchBucketException e) {
      // The startup check (above) couldn't reach the endpoint, or the bucket was deleted since —
      // either way, create it now and retry once rather than failing this upload outright.
      client.createBucket(CreateBucketRequest.builder().bucket(bucket).build());
      client.putObject(
          PutObjectRequest.builder().bucket(bucket).key(key).contentType(contentType).build(),
          RequestBody.fromBytes(content));
    }
  }

  @Override
  public String presignedGetUrl(String key, Duration ttl) {
    GetObjectRequest getObjectRequest = GetObjectRequest.builder().bucket(bucket).key(key).build();
    GetObjectPresignRequest presignRequest =
        GetObjectPresignRequest.builder()
            .signatureDuration(ttl)
            .getObjectRequest(getObjectRequest)
            .build();
    return presigner.presignGetObject(presignRequest).url().toString();
  }
}
