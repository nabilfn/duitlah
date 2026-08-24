package com.duitlah.api.personaltax;

import jakarta.validation.Valid;
import java.util.List;
import java.util.UUID;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PcbController {

  private final PcbService pcbService;

  public PcbController(PcbService pcbService) {
    this.pcbService = pcbService;
  }

  @PostMapping("/api/v1/personal-tax/pcb")
  public PcbPaymentResponse record(
      @AuthenticationPrincipal UUID userId, @Valid @RequestBody RecordPcbPaymentRequest request) {
    return pcbService.record(userId, request);
  }

  @GetMapping("/api/v1/personal-tax/pcb")
  public List<PcbPaymentResponse> list(
      @AuthenticationPrincipal UUID userId, @RequestParam int yearOfAssessment) {
    return pcbService.list(userId, yearOfAssessment);
  }
}
