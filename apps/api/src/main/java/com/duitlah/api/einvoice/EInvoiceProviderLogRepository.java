package com.duitlah.api.einvoice;

import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EInvoiceProviderLogRepository extends JpaRepository<EInvoiceProviderLog, UUID> {

  List<EInvoiceProviderLog> findByEinvoiceDocumentIdOrderByCreatedAtDesc(UUID einvoiceDocumentId);
}
