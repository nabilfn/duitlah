import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../config/env.dart';

/// Consumes the backend's existing Server-Sent Events endpoints
/// (`BillEventBroadcaster` — see docs/bagilah-engine.md) by streaming a Dio
/// response and splitting on blank lines, the same buffering approach as
/// the web app's `use-bill-events.ts` hook, just reimplemented in Dart.
/// Reused rather than replaced per the Phase 9.5 migration doc's "prefer
/// whatever realtime mechanism already exists" instruction — no WebSocket,
/// no new backend endpoint, no polling loop.
///
/// Events here are content-free signals ("something changed") — the caller
/// is expected to refetch, not to parse a payload out of the event.
class SseSubscription {
  SseSubscription._(this._dio, this._cancelToken, this._controller);

  final Dio _dio;
  final CancelToken _cancelToken;
  final StreamController<void> _controller;

  Stream<void> get events => _controller.stream;

  static SseSubscription connect(
    String path, {
    String? accessToken,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: Env.apiBaseUrl,
      responseType: ResponseType.stream,
      connectTimeout: const Duration(seconds: 15),
    ));
    final cancelToken = CancelToken();
    final controller = StreamController<void>.broadcast();
    final sub = SseSubscription._(dio, cancelToken, controller);
    sub._start(path, accessToken);
    return sub;
  }

  Future<void> _start(String path, String? accessToken) async {
    var buffer = '';
    try {
      final response = await _dio.get<ResponseBody>(
        path,
        cancelToken: _cancelToken,
        options: Options(
          headers: {
            if (accessToken != null) 'Authorization': 'Bearer $accessToken',
            'Accept': 'text/event-stream',
          },
        ),
      );
      final stream = response.data!.stream;
      await for (final chunk in stream) {
        if (_controller.isClosed) return;
        buffer += utf8.decode(chunk, allowMalformed: true);
        final parts = buffer.split('\n\n');
        buffer = parts.removeLast();
        if (parts.isNotEmpty && !_controller.isClosed) {
          _controller.add(null);
        }
      }
    } catch (_) {
      // A dropped SSE connection degrades to "no live updates until the
      // user pulls to refresh" rather than a crash — the bill screen's own
      // data (fetched normally over the JSON API) is unaffected.
    } finally {
      if (!_controller.isClosed) {
        await _controller.close();
      }
    }
  }

  void close() {
    _cancelToken.cancel();
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}
