import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duitlah_mobile/features/wrapped/services/wrapped_share_service.dart';
import 'package:duitlah_mobile/features/wrapped/presentation/widgets/wrapped_share_card.dart';

import 'wrapped_fixture.dart';

void main() {
  for (final fail in [false, true]) {
    testWidgets(
      'native share exports 1080x1920 and cleans temporary files, failure=$fail',
      (t) async {
        t.view.physicalSize = const Size(390, 844);
        t.view.devicePixelRatio = 1;
        addTearDown(() {
          t.view.resetPhysicalSize();
          t.view.resetDevicePixelRatio();
        });
        final key = GlobalKey();
        String? exported;
        await t.pumpWidget(
          MaterialApp(
            home: Center(
              child: RepaintBoundary(
                key: key,
                child: const WrappedShareCard(
                  result: wrappedFixture,
                  kind: WrappedShareKind.persona,
                ),
              ),
            ),
          ),
        );
        await t.pumpAndSettle();
        final service = WrappedShareService(
          nativeShare: (file, origin) async {
            exported = file.path;
            final bytes = await file.readAsBytes();
            final data = ByteData.sublistView(bytes);
            expect(data.getUint32(16), 1080);
            expect(data.getUint32(20), 1920);
            expect(origin, const Rect.fromLTWH(10, 10, 100, 100));
            if (fail) throw StateError('share unavailable');
          },
        );
        await t.runAsync(() async {
          final action = service.share(
            key.currentContext!.findRenderObject() as RenderRepaintBoundary,
            const Rect.fromLTWH(10, 10, 100, 100),
          );
          if (fail) {
            await expectLater(action, throwsStateError);
          } else {
            await action;
          }
          expect(exported, isNotNull);
          expect(await File(exported!).exists(), false);
        });
      },
    );
  }
}
