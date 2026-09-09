import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duitlah_mobile/core/api/providers.dart';
import 'package:duitlah_mobile/core/storage/secure_storage.dart';
import 'package:duitlah_mobile/core/theme/appearance_provider.dart';
import 'package:duitlah_mobile/core/theme/app_theme.dart';
import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:duitlah_mobile/core/widgets/appearance_preference.dart';

class _Storage extends SecureStorage {
  String? value;
  bool failRead = false, failWrite = false;
  Completer<void>? hold;
  final writes = <String>[];
  @override Future<String?> read(String key) async {
    expect(key, appearanceStorageKey);
    if(failRead) throw StateError('Unavailable');
    return value;
  }
  @override Future<void> write(String key, String value) async {
    expect(key, appearanceStorageKey);
    await hold?.future;
    if(failWrite) throw StateError('Unavailable');
    writes.add(value);
    this.value=value;
  }
}
Widget _app(_Storage storage,{ThemeMode initial=ThemeMode.system}) => ProviderScope(
  overrides:[secureStorageProvider.overrideWithValue(storage),initialAppearanceProvider.overrideWithValue(initial)],
  child:Consumer(builder:(context,ref,_)=>MaterialApp(
    theme:AppTheme.light(),darkTheme:AppTheme.dark(),themeMode:ref.watch(appearanceProvider),
    home:const Scaffold(body:AppearancePreference()),
  )),
);
Brightness _brightness(WidgetTester tester)=>Theme.of(tester.element(find.byType(AppearancePreference))).brightness;

void main(){
  test('Restores saved choices; missing, invalid and inaccessible values use System',()async{
    final storage=_Storage();
    for(final mode in ThemeMode.values){storage.value=mode.name;expect(await loadAppearance(storage),mode);}
    for(final value in [null,'unknown','DARK']){storage.value=value;expect(await loadAppearance(storage),ThemeMode.system);}
    storage.failRead=true;expect(await loadAppearance(storage),ThemeMode.system);
  });
  test('Writes exact persisted values and restores them on reopening',()async{
    final storage=_Storage();final controller=AppearanceController(storage,ThemeMode.system);addTearDown(controller.dispose);
    for(final mode in [ThemeMode.light,ThemeMode.dark,ThemeMode.system]){
      await controller.setMode(mode);expect(await loadAppearance(storage),mode);
    }
    expect(storage.writes,['light','dark','system']);
  });
  test('Rapid selections remain ordered and the latest choice persists',()async{
    final storage=_Storage()..hold=Completer<void>();
    final controller=AppearanceController(storage,ThemeMode.system);addTearDown(controller.dispose);
    final light=controller.setMode(ThemeMode.light);final dark=controller.setMode(ThemeMode.dark);final system=controller.setMode(ThemeMode.system);
    expect(controller.state,ThemeMode.system);expect(storage.writes,isEmpty);
    storage.hold!.complete();await Future.wait([light,dark,system]);
    expect(storage.writes,['light','dark','system']);expect(storage.value,'system');
  });
  test('Failed persistence rolls back and later writes still work',()async{
    final storage=_Storage()..failWrite=true;
    final controller=AppearanceController(storage,ThemeMode.dark);addTearDown(controller.dispose);
    await expectLater(controller.setMode(ThemeMode.light),throwsStateError);expect(controller.state,ThemeMode.dark);
    storage.failWrite=false;await controller.setMode(ThemeMode.light);expect(storage.value,'light');
  });
  testWidgets('Light/Dark override the device; System reacts without a restart',(tester)async{
    final storage=_Storage();
    tester.platformDispatcher.platformBrightnessTestValue=Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(_app(storage));await tester.pumpAndSettle();
    expect(_brightness(tester),Brightness.light);
    await tester.tap(find.text('Dark'));await tester.pumpAndSettle();expect(_brightness(tester),Brightness.dark);expect(storage.value,'dark');
    tester.platformDispatcher.platformBrightnessTestValue=Brightness.dark;await tester.pumpAndSettle();
    await tester.tap(find.text('Light'));await tester.pumpAndSettle();expect(_brightness(tester),Brightness.light);
    await tester.tap(find.text('System'));await tester.pumpAndSettle();expect(_brightness(tester),Brightness.dark);
    tester.platformDispatcher.platformBrightnessTestValue=Brightness.light;await tester.pumpAndSettle();expect(_brightness(tester),Brightness.light);
    expect(find.text('Light'),findsOneWidget);expect(find.text('Dark'),findsOneWidget);expect(find.text('System'),findsOneWidget);
  });
  testWidgets('Saved dark mode is dark on its first frame even with a light device',(tester)async{
    final storage=_Storage()..value='dark';
    tester.platformDispatcher.platformBrightnessTestValue=Brightness.light;addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    final initial=await loadAppearance(storage);await tester.pumpWidget(_app(storage,initial:initial));
    expect(_brightness(tester),Brightness.dark);
    expect(Theme.of(tester.element(find.byType(AppearancePreference))).scaffoldBackgroundColor,DuitlahColors.dark.background);
  });
  testWidgets('Persistence errors are recoverable in the selector',(tester)async{
    final storage=_Storage()..failWrite=true;
    await tester.pumpWidget(_app(storage));await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));await tester.pumpAndSettle();
    expect(find.text('Could not save appearance. Please try again.'),findsOneWidget);
    expect(storage.value,isNull);expect(tester.takeException(),isNull);
  });
  test('Participant foregrounds retain readable contrast in both modes',(){
    for(final palette in [DuitlahColors.light,DuitlahColors.dark]){
      for(final background in DuitlahColors.participants){
        final fg=palette.onParticipant(background).computeLuminance();final bg=background.computeLuminance();
        final ratio=(fg>bg?fg+.05:bg+.05)/(fg>bg?bg+.05:fg+.05);
        expect(ratio,greaterThanOrEqualTo(4.5));
      }
    }
  });
}
