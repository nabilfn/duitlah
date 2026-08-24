package com.duitlah.api.statements;

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
public class StatementImportController {

  private final StatementImportService statementImportService;

  public StatementImportController(StatementImportService statementImportService) {
    this.statementImportService = statementImportService;
  }

  @PostMapping("/api/v1/statement-imports")
  @ResponseStatus(HttpStatus.CREATED)
  public StatementImportResponse upload(
      @AuthenticationPrincipal UUID userId,
      @RequestParam UUID accountId,
      @RequestParam("file") MultipartFile file) {
    try {
      return statementImportService.upload(
          userId, accountId, file.getOriginalFilename(), file.getContentType(), file.getBytes());
    } catch (IOException e) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST, "UNREADABLE_UPLOAD", "Couldn't read the uploaded file.");
    }
  }

  @GetMapping("/api/v1/statement-imports")
  public List<StatementImportResponse> list(@AuthenticationPrincipal UUID userId) {
    return statementImportService.list(userId);
  }

  @GetMapping("/api/v1/statement-imports/{importId}")
  public StatementImportResponse get(
      @AuthenticationPrincipal UUID userId, @PathVariable UUID importId) {
    return statementImportService.get(userId, importId);
  }
}
