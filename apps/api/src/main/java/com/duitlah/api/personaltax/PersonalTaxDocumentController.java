package com.duitlah.api.personaltax;

import com.duitlah.api.common.error.ApiException;
import jakarta.validation.Valid;
import java.io.IOException;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class PersonalTaxDocumentController {

  private final PersonalTaxDocumentService documents;

  public PersonalTaxDocumentController(PersonalTaxDocumentService documents) {
    this.documents = documents;
  }

  @PostMapping("/api/v1/personal-tax/documents")
  @ResponseStatus(HttpStatus.CREATED)
  public PersonalTaxDocumentResponse linkReceipt(
      @AuthenticationPrincipal UUID userId,
      @Valid @RequestBody CreatePersonalTaxDocumentRequest request) {
    return documents.linkReceipt(userId, request);
  }

  @PostMapping("/api/v1/personal-tax/documents/upload")
  @ResponseStatus(HttpStatus.CREATED)
  public PersonalTaxDocumentResponse upload(
      @AuthenticationPrincipal UUID userId,
      @RequestParam int yearOfAssessment,
      @RequestParam TaxDocumentType type,
      @RequestParam(required = false) String notes,
      @RequestParam("file") MultipartFile file) {
    try {
      return documents.upload(
          userId, yearOfAssessment, type, file.getBytes(), file.getContentType(), notes);
    } catch (IOException e) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "UNREADABLE_UPLOAD", "Couldn't read the uploaded file.");
    }
  }

  @GetMapping("/api/v1/personal-tax/documents")
  public List<PersonalTaxDocumentResponse> list(
      @AuthenticationPrincipal UUID userId, @RequestParam int yearOfAssessment) {
    return documents.list(userId, yearOfAssessment);
  }

  @DeleteMapping("/api/v1/personal-tax/documents/{documentId}")
  public void delete(@AuthenticationPrincipal UUID userId, @PathVariable UUID documentId) {
    documents.delete(userId, documentId);
  }
}
