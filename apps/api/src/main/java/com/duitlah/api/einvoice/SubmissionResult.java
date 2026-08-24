package com.duitlah.api.einvoice;

public record SubmissionResult(
    boolean accepted, String submissionUid, String documentUuid, String errorMessage) {}
