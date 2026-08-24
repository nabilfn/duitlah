package com.duitlah.api.einvoice;

import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EInvoiceDocumentRepository extends JpaRepository<EInvoiceDocument, UUID> {

  Optional<EInvoiceDocument> findByIdAndSpaceId(UUID id, UUID spaceId);

  Optional<EInvoiceDocument> findByInvoiceIdAndSpaceId(UUID invoiceId, UUID spaceId);
}
