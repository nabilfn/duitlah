import 'package:flutter/material.dart';

/// Original 24-unit rounded line drawings. IconData is only a semantic adapter
/// for existing feature code; no icon font is rendered by this widget.
class DuitlahIcon extends StatelessWidget {
  const DuitlahIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });
  final IconData? icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final extent = size ?? theme.size ?? 24;
    return Semantics(
      label: semanticLabel,
      child: Center(
        widthFactor: 1,
        heightFactor: 1,
        child: SizedBox.square(
          dimension: extent,
          child: CustomPaint(
            painter: _GlyphPainter(
              _glyphs[icon] ?? 'document',
              color ?? theme.color ?? Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  const _GlyphPainter(this.glyph, this.color);
  final String glyph;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24, size.height / 24);
    final pen = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    void line(double x, double y, double x2, double y2) =>
        canvas.drawLine(Offset(x, y), Offset(x2, y2), pen);
    void circle(double x, double y, double r) =>
        canvas.drawCircle(Offset(x, y), r, pen);
    void box(double x, double y, double w, double h, [double r = 2]) =>
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, w, h),
            Radius.circular(r),
          ),
          pen,
        );
    void path(List<Offset> points) {
      final p = Path()..moveTo(points.first.dx, points.first.dy);
      for (final o in points.skip(1)) {
        p.lineTo(o.dx, o.dy);
      }
      canvas.drawPath(p, pen);
    }

    switch (glyph) {
      case 'home':
        path([const Offset(3, 10), const Offset(12, 3), const Offset(21, 10)]);
        path([
          const Offset(5, 9),
          const Offset(5, 21),
          const Offset(10, 21),
          const Offset(10, 14),
          const Offset(14, 14),
          const Offset(14, 21),
          const Offset(19, 21),
          const Offset(19, 9),
        ]);
      case 'person':
        circle(12, 7, 3.5);
        canvas.drawPath(
          Path()
            ..moveTo(4, 21)
            ..cubicTo(4, 11, 20, 11, 20, 21)
            ..close(),
          pen,
        );
      case 'people':
        circle(9, 7, 3);
        circle(18, 8, 2.2);
        canvas.drawPath(
          Path()
            ..moveTo(2, 21)
            ..cubicTo(2, 12, 16, 12, 16, 21)
            ..close(),
          pen,
        );
        canvas.drawPath(
          Path()
            ..moveTo(17, 14)
            ..quadraticBezierTo(22, 14, 22, 21),
          pen,
        );
      case 'chart':
        box(4, 13, 3, 8, 1.5);
        box(10.5, 8, 3, 13, 1.5);
        box(17, 3, 3, 18, 1.5);
      case 'wallet':
        box(3, 6, 18, 15, 3);
        path([const Offset(4, 6), const Offset(17, 3), const Offset(17, 6)]);
        box(14, 11, 7, 5, 1.5);
        circle(17, 13.5, .5);
      case 'bank':
        path([
          const Offset(3, 8),
          const Offset(12, 3),
          const Offset(21, 8),
          const Offset(3, 8),
        ]);
        line(3, 21, 21, 21);
        for (final x in [6.0, 12.0, 18.0]) {
          line(x, 11, x, 18);
        }
      case 'card':
        box(3, 5, 18, 14, 3);
        line(3, 10, 21, 10);
        line(6, 15, 10, 15);
      case 'receipt':
        path([
          const Offset(5, 3),
          const Offset(19, 3),
          const Offset(19, 21),
          const Offset(15, 19),
          const Offset(12, 21),
          const Offset(9, 19),
          const Offset(5, 21),
          const Offset(5, 3),
        ]);
        line(8, 8, 16, 8);
        line(8, 12, 16, 12);
      case 'document':
        box(5, 3, 14, 18, 2);
        line(8, 8, 16, 8);
        line(8, 12, 16, 12);
        line(8, 16, 13, 16);
      case 'split':
        circle(12, 5, 2);
        circle(5, 19, 2);
        circle(19, 19, 2);
        path([
          const Offset(12, 7),
          const Offset(12, 11),
          const Offset(5, 11),
          const Offset(5, 17),
        ]);
        path([
          const Offset(12, 11),
          const Offset(19, 11),
          const Offset(19, 17),
        ]);
      case 'transfer':
        path([const Offset(3, 7), const Offset(20, 7), const Offset(16, 3)]);
        path([const Offset(21, 17), const Offset(4, 17), const Offset(8, 21)]);
      case 'search':
        circle(10, 10, 6);
        line(14.5, 14.5, 21, 21);
      case 'filter':
        for (final y in [5.0, 12.0, 19.0]) {
          line(3, y, 21, y);
        }
        box(7, 3, 3, 4, 1);
        box(15, 10, 3, 4, 1);
        box(8, 17, 3, 4, 1);
      case 'bell':
        canvas.drawPath(
          Path()
            ..moveTo(4, 18)
            ..lineTo(6, 14)
            ..lineTo(6, 9)
            ..cubicTo(6, 1, 18, 1, 18, 9)
            ..lineTo(18, 14)
            ..lineTo(20, 18)
            ..close(),
          pen,
        );
        line(10, 21, 14, 21);
      case 'calendar':
        box(3, 5, 18, 16, 3);
        line(3, 10, 21, 10);
        line(8, 3, 8, 7);
        line(16, 3, 16, 7);
        box(7, 14, 3, 3, 1);
        line(14, 15, 17, 15);
      case 'clock':
        circle(12, 12, 9);
        path([const Offset(12, 6), const Offset(12, 12), const Offset(16, 15)]);
      case 'goal':
        circle(12, 12, 9);
        circle(12, 12, 4.5);
        line(12, 12, 21, 3);
        line(17, 3, 21, 3);
        line(21, 3, 21, 7);
      case 'pie':
        canvas.drawArc(const Rect.fromLTWH(3, 3, 18, 18), 0.1, 4.5, false, pen);
        path([const Offset(12, 3), const Offset(12, 12), const Offset(21, 12)]);
      case 'shield':
        canvas.drawPath(
          Path()
            ..moveTo(12, 2)
            ..lineTo(21, 6)
            ..lineTo(19, 16)
            ..quadraticBezierTo(16, 20, 12, 22)
            ..quadraticBezierTo(8, 20, 5, 16)
            ..lineTo(3, 6)
            ..close(),
          pen,
        );
        path([const Offset(8, 12), const Offset(11, 15), const Offset(16, 9)]);
      case 'lock':
        box(5, 10, 14, 12, 3);
        canvas.drawArc(
          const Rect.fromLTWH(8, 2, 8, 13),
          3.14,
          3.14,
          false,
          pen,
        );
        line(12, 15, 12, 18);
      case 'scan':
        for (final x in [3.0, 16.0]) {
          box(x, 3, 5, 5, 1);
        }
        box(3, 16, 5, 5, 1);
        path([
          const Offset(16, 13),
          const Offset(16, 17),
          const Offset(21, 17),
          const Offset(21, 21),
        ]);
        line(3, 12, 21, 12);
        line(12, 3, 12, 7);
        line(12, 17, 12, 21);
      case 'camera':
        box(2, 6, 20, 15, 3);
        path([
          const Offset(7, 6),
          const Offset(9, 3),
          const Offset(15, 3),
          const Offset(17, 6),
        ]);
        circle(12, 13.5, 4);
      case 'leaf':
        canvas.drawPath(
          Path()
            ..moveTo(12, 20)
            ..cubicTo(1, 19, 2, 8, 3, 7)
            ..cubicTo(12, 7, 13, 12, 12, 20)
            ..cubicTo(11, 5, 18, 3, 22, 3)
            ..cubicTo(22, 13, 15, 14, 12, 14),
          pen,
        );
        line(12, 14, 12, 22);
      case 'help':
        circle(12, 12, 9);
        canvas.drawPath(
          Path()
            ..moveTo(9, 8)
            ..cubicTo(9, 3, 18, 5, 14, 10)
            ..quadraticBezierTo(12, 11, 12, 14),
          pen,
        );
        circle(12, 18, .4);
      case 'info':
        circle(12, 12, 9);
        line(12, 11, 12, 17);
        circle(12, 7, .4);
      case 'warning':
        path([
          const Offset(12, 3),
          const Offset(22, 21),
          const Offset(2, 21),
          const Offset(12, 3),
        ]);
        line(12, 9, 12, 14);
        circle(12, 18, .4);
      case 'check':
        path([const Offset(4, 12), const Offset(9, 17), const Offset(20, 6)]);
      case 'plus':
        line(12, 4, 12, 20);
        line(4, 12, 20, 12);
      case 'close':
        line(5, 5, 19, 19);
        line(19, 5, 5, 19);
      case 'right':
        path([const Offset(9, 5), const Offset(16, 12), const Offset(9, 19)]);
      case 'left':
        path([const Offset(15, 5), const Offset(8, 12), const Offset(15, 19)]);
      case 'down':
        path([const Offset(5, 9), const Offset(12, 16), const Offset(19, 9)]);
      case 'in':
        line(12, 3, 12, 21);
        path([const Offset(5, 14), const Offset(12, 21), const Offset(19, 14)]);
      case 'out':
        line(12, 21, 12, 3);
        path([const Offset(5, 10), const Offset(12, 3), const Offset(19, 10)]);
      case 'more':
        for (final x in [5.0, 12.0, 19.0]) {
          circle(x, 12, 1);
        }
      case 'delete':
        box(6, 7, 12, 15, 2);
        line(3, 6, 21, 6);
        line(9, 3, 15, 3);
        line(10, 11, 10, 18);
        line(14, 11, 14, 18);
      case 'edit':
        path([
          const Offset(4, 15),
          const Offset(16, 3),
          const Offset(21, 8),
          const Offset(9, 20),
          const Offset(3, 21),
          const Offset(4, 15),
        ]);
        line(13, 6, 18, 11);
      case 'share':
        box(4, 11, 16, 11, 2);
        line(12, 16, 12, 2);
        path([const Offset(7, 7), const Offset(12, 2), const Offset(17, 7)]);
      case 'repeat':
        canvas.drawArc(const Rect.fromLTWH(4, 4, 16, 16), -.5, 4.9, false, pen);
        path([const Offset(14, 3), const Offset(20, 3), const Offset(20, 9)]);
      case 'exit':
        path([
          const Offset(10, 3),
          const Offset(4, 3),
          const Offset(4, 21),
          const Offset(10, 21),
        ]);
        line(9, 12, 22, 12);
        path([const Offset(17, 7), const Offset(22, 12), const Offset(17, 17)]);
      case 'box':
        box(3, 6, 18, 15, 2);
        path([
          const Offset(3, 6),
          const Offset(7, 2),
          const Offset(17, 2),
          const Offset(21, 6),
        ]);
        line(9, 11, 15, 11);
      case 'eye':
        canvas.drawPath(
          Path()
            ..moveTo(2, 12)
            ..quadraticBezierTo(12, -1, 22, 12)
            ..quadraticBezierTo(12, 25, 2, 12),
          pen,
        );
        circle(12, 12, 3);
      case 'eyeOff':
        canvas.drawPath(
          Path()
            ..moveTo(2, 12)
            ..quadraticBezierTo(12, -1, 22, 12)
            ..quadraticBezierTo(12, 25, 2, 12),
          pen,
        );
        line(3, 3, 21, 21);
      case 'mail':
        box(2, 5, 20, 15, 3);
        path([const Offset(3, 7), const Offset(12, 14), const Offset(21, 7)]);
      case 'assistant':
        // Duitlah's own assistant mark: the existing 'chart' bars (ascending
        // rounded strokes) spoken from a rounded speech form — "your money,
        // explained". Deliberately not a sparkle, star, wand or robot: it is
        // built from geometry this icon set already uses elsewhere.
        box(3, 3.5, 18, 13, 4);
        path([
          const Offset(8.5, 16.5),
          const Offset(8.5, 20.5),
          const Offset(12.5, 16.5),
        ]);
        line(9, 12.5, 9, 10);
        line(12, 12.5, 12, 9);
        line(15, 12.5, 15, 7);
      default:
        box(3, 3, 7, 7, 2);
        box(14, 3, 7, 7, 2);
        box(3, 14, 7, 7, 2);
        box(14, 14, 7, 7, 2);
    }
  }

  @override
  bool shouldRepaint(_GlyphPainter oldDelegate) =>
      glyph != oldDelegate.glyph || color != oldDelegate.color;
}

final _glyphs = <IconData, String>{
  Icons.account_balance_outlined: 'bank',
  Icons.account_balance_wallet_outlined: 'wallet',
  Icons.account_tree_outlined: 'document',
  Icons.add: 'plus',
  Icons.add_a_photo_outlined: 'camera',
  Icons.add_circle_outline: 'plus',
  Icons.archive_outlined: 'box',
  Icons.arrow_back: 'left',
  Icons.arrow_downward: 'in',
  Icons.arrow_downward_rounded: 'in',
  Icons.arrow_forward_rounded: 'right',
  Icons.arrow_upward: 'out',
  Icons.arrow_upward_rounded: 'out',
  Icons.assessment_outlined: 'chart',
  Icons.assignment_return_outlined: 'document',
  Icons.attach_file: 'document',
  Icons.auto_awesome: 'chart',
  Icons.badge_outlined: 'person',
  Icons.balance_outlined: 'document',
  Icons.block: 'lock',
  Icons.book_outlined: 'document',
  Icons.business_outlined: 'bank',
  Icons.calculate_outlined: 'document',
  Icons.calendar_month_outlined: 'calendar',
  Icons.calendar_today_outlined: 'calendar',
  Icons.call_split: 'split',
  Icons.camera_alt_outlined: 'camera',
  Icons.chair_outlined: 'box',
  Icons.check: 'check',
  Icons.check_circle: 'check',
  Icons.check_circle_outline: 'check',
  Icons.chevron_left: 'left',
  Icons.chevron_right: 'right',
  Icons.circle: 'document',
  Icons.close: 'close',
  Icons.copy_outlined: 'document',
  Icons.credit_card: 'card',
  Icons.date_range_outlined: 'calendar',
  Icons.delete_forever_outlined: 'delete',
  Icons.delete_outline: 'delete',
  Icons.description_outlined: 'document',
  Icons.devices_outlined: 'document',
  Icons.download_outlined: 'in',
  Icons.edit_outlined: 'edit',
  Icons.error_outline: 'warning',
  Icons.error_outline_rounded: 'warning',
  Icons.event_busy_outlined: 'calendar',
  Icons.event_note_outlined: 'calendar',
  Icons.event_repeat_outlined: 'calendar',
  Icons.expand_more: 'down',
  Icons.fact_check_outlined: 'check',
  Icons.favorite_outline: 'leaf',
  Icons.feedback_outlined: 'document',
  Icons.filter_list: 'filter',
  Icons.flag_outlined: 'goal',
  Icons.folder_outlined: 'box',
  Icons.folder_special_outlined: 'box',
  Icons.gavel_outlined: 'bank',
  Icons.group_add_outlined: 'people',
  Icons.groups: 'people',
  Icons.groups_outlined: 'people',
  Icons.handshake_outlined: 'people',
  Icons.help_outline: 'help',
  Icons.home: 'home',
  Icons.home_outlined: 'home',
  Icons.info_outline: 'info',
  Icons.insert_drive_file_outlined: 'document',
  Icons.insights_outlined: 'chart',
  Icons.inventory_2_outlined: 'box',
  Icons.ios_share: 'share',
  Icons.ios_share_outlined: 'share',
  Icons.lightbulb_outline: 'chart',
  Icons.link: 'transfer',
  Icons.link_off: 'transfer',
  Icons.link_outlined: 'transfer',
  Icons.local_shipping_outlined: 'document',
  Icons.lock_outline: 'lock',
  Icons.logout: 'exit',
  Icons.mail_outline: 'mail',
  Icons.menu_book_outlined: 'document',
  Icons.more_horiz: 'more',
  Icons.notifications: 'bell',
  Icons.notifications_none: 'bell',
  Icons.notifications_off_outlined: 'bell',
  Icons.notifications_outlined: 'bell',
  Icons.pause_circle_outline: 'document',
  Icons.payments_outlined: 'wallet',
  Icons.people_alt_outlined: 'people',
  Icons.percent_outlined: 'document',
  Icons.person_add_alt_1_outlined: 'person',
  Icons.person_outline: 'person',
  Icons.photo_library_outlined: 'camera',
  Icons.picture_as_pdf_outlined: 'document',
  Icons.pie_chart_outline: 'pie',
  Icons.play_circle_outline: 'document',
  Icons.privacy_tip_outlined: 'shield',
  Icons.qr_code_scanner_rounded: 'scan',
  Icons.quiz_outlined: 'help',
  Icons.receipt_long: 'receipt',
  Icons.receipt_long_outlined: 'receipt',
  Icons.receipt_long_rounded: 'receipt',
  Icons.receipt_outlined: 'receipt',
  Icons.receipt_rounded: 'receipt',
  Icons.refresh: 'repeat',
  Icons.repeat_rounded: 'repeat',
  Icons.replay_outlined: 'repeat',
  Icons.request_page_outlined: 'receipt',
  Icons.request_quote_outlined: 'receipt',
  Icons.restaurant_menu_outlined: 'document',
  Icons.rocket_launch_outlined: 'document',
  Icons.rule_outlined: 'document',
  Icons.savings_outlined: 'wallet',
  Icons.schedule_outlined: 'clock',
  Icons.search: 'search',
  Icons.settings_outlined: 'filter',
  Icons.smart_toy_outlined: 'assistant',
  Icons.store_outlined: 'document',
  Icons.storefront_outlined: 'document',
  Icons.swap_horiz_outlined: 'transfer',
  Icons.timeline_outlined: 'chart',
  Icons.trending_up_outlined: 'chart',
  Icons.tune_outlined: 'filter',
  Icons.upload_file_outlined: 'out',
  Icons.upload_outlined: 'out',
  Icons.visibility_off_outlined: 'eyeOff',
  Icons.visibility_outlined: 'eye',
  Icons.volunteer_activism_outlined: 'people',
  Icons.warehouse_outlined: 'box',
  Icons.warning_amber_outlined: 'warning',
  Icons.warning_amber_rounded: 'warning',
  Icons.water_drop_outlined: 'leaf',
  Icons.wifi_off_rounded: 'document',
  Icons.workspace_premium: 'document',
  Icons.workspace_premium_outlined: 'document',
  Icons.workspaces_outlined: 'document',
};
