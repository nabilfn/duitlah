import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

typedef WrappedNativeShare = Future<void> Function(XFile file, ui.Rect origin);

/// Captures only the dedicated 9:16 card. Temporary private exports are removed after sharing.
class WrappedShareService {
  WrappedShareService({WrappedNativeShare? nativeShare})
    : _nativeShare = nativeShare ?? _share;
  final WrappedNativeShare _nativeShare;
  static Future<void> _share(XFile file, ui.Rect origin) async {
    await Share.shareXFiles(
      [file],
      text: 'My Duitlah Wrapped',
      sharePositionOrigin: origin,
    );
  }

  Future<void> share(RenderRepaintBoundary boundary, ui.Rect origin) async {
    ui.Image? image;
    Directory? directory;
    try {
      image = await boundary.toImage(pixelRatio: 3);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) throw StateError('Image export unavailable');
      directory = await Directory.systemTemp.createTemp('duitlah-wrapped-');
      final file = File('${directory.path}/story.png');
      await file.writeAsBytes(bytes.buffer.asUint8List());
      await _nativeShare(XFile(file.path), origin);
    } finally {
      image?.dispose();
      if (directory != null) {
        try {
          await directory.delete(recursive: true);
        } catch (_) {}
      }
    }
  }
}
