package com.duitlah.api.reconciliation;

import com.duitlah.api.common.error.ApiException;
import java.io.IOException;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class BusinessStatementImportController {

  private final BusinessStatementImportService imports;

  public BusinessStatementImportController(BusinessStatementImportService imports) {
    this.imports = imports;
  }

  @PostMapping("/api/v1/spaces/{spaceId}/reconciliation/statement-imports")
  @ResponseStatus(HttpStatus.CREATED)
  public BusinessStatementImportResponse upload(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @RequestParam UUID businessAccountId,
      @RequestParam("file") MultipartFile file) {
    try {
      return imports.upload(
          userId,
          spaceId,
          businessAccountId,
          file.getOriginalFilename(),
          file.getContentType(),
          file.getBytes());
    } catch (IOException e) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "UNREADABLE_UPLOAD", "Couldn't read the uploaded file.");
    }
  }

  @GetMapping("/api/v1/spaces/{spaceId}/reconciliation/statement-imports")
  public List<BusinessStatementImportResponse> list(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID spaceId) {
    return imports.list(userId, spaceId);
  }

  @GetMapping("/api/v1/spaces/{spaceId}/reconciliation/statement-imports/{importId}/lines")
  public List<StatementLineResponse> listLines(
      @AuthenticationPrincipal UUID userId,
      @PathVariable UUID spaceId,
      @PathVariable UUID importId) {
    return imports.listLines(userId, spaceId, importId);
  }
}
