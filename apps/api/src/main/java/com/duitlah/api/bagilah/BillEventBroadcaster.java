package com.duitlah.api.bagilah;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

/**
 * In-memory registry of live SSE connections per bill, so joined participants (real or guest) see
 * new items, claims, and joins without polling (product spec section 66). Deliberately
 * single-instance: emitters live in this process's heap, so a multi-instance deployment would need
 * this backed by Redis pub/sub instead of a local map. Not built that way now because nothing about
 * this app runs on more than one instance yet -- see docs/architecture.md.
 */
@Component
public class BillEventBroadcaster {

  private static final long EMITTER_TIMEOUT_MILLIS = 30 * 60 * 1000L;

  private final Map<UUID, List<SseEmitter>> emittersByBillId = new ConcurrentHashMap<>();

  public SseEmitter subscribe(UUID billId) {
    SseEmitter emitter = new SseEmitter(EMITTER_TIMEOUT_MILLIS);
    List<SseEmitter> emitters =
        emittersByBillId.computeIfAbsent(billId, id -> new CopyOnWriteArrayList<>());
    emitters.add(emitter);
    emitter.onCompletion(() -> emitters.remove(emitter));
    emitter.onTimeout(() -> emitters.remove(emitter));
    emitter.onError(e -> emitters.remove(emitter));
    try {
      emitter.send(SseEmitter.event().name("connected").data(Map.of("billId", billId)));
    } catch (IOException e) {
      emitters.remove(emitter);
    }
    return emitter;
  }

  public void publish(UUID billId, String eventType) {
    List<SseEmitter> emitters = emittersByBillId.get(billId);
    if (emitters == null || emitters.isEmpty()) {
      return;
    }
    for (SseEmitter emitter : emitters) {
      try {
        emitter.send(
            SseEmitter.event().name(eventType).data(Map.of("billId", billId, "type", eventType)));
      } catch (IOException e) {
        emitters.remove(emitter);
      }
    }
  }
}
