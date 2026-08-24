package com.duitlah.api.businesstax;

import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.SpaceService;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;

/**
 * Spec section 54's own field list — "tax rate" — served from the versioned {@link SstRate} table
 * rather than a hardcoded constant. See package-info's honesty note.
 */
@Service
public class SstRateService {

  private final SstRateRepository rates;
  private final SpaceService spaceService;

  public SstRateService(SstRateRepository rates, SpaceService spaceService) {
    this.rates = rates;
    this.spaceService = spaceService;
  }

  /**
   * Global reference data, not space-specific — {@code spaceId}/{@code userId} exist only to
   * confirm the caller belongs to some real space, matching every other endpoint under {@code
   * /spaces/{spaceId}/...}.
   */
  public List<SstRateResponse> listAll(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return rates.findAllByOrderByTaxTypeAscEffectiveFromDesc().stream()
        .map(SstRateResponse::of)
        .toList();
  }

  public SstRateResponse currentRate(SstTaxType taxType) {
    SstRate rate =
        rates
            .findCurrentRate(taxType, LocalDate.now())
            .orElseThrow(
                () ->
                    new NotFoundException(
                        "SST_RATE_NOT_FOUND", "No current " + taxType + " rate is seeded."));
    return SstRateResponse.of(rate);
  }
}
