import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solid_qr_app/features/history/presentation/bloc/history_bloc.dart';
import 'package:solid_qr_app/features/history/presentation/bloc/history_event.dart';
import 'package:solid_qr_app/features/history/presentation/bloc/history_state.dart';
import 'package:solid_qr_app/features/qr_scanner/presentation/bloc/scanner_bloc.dart';
import 'package:solid_qr_app/features/qr_scanner/presentation/bloc/scanner_event.dart';
import 'package:solid_qr_app/features/qr_scanner/presentation/bloc/scanner_state.dart';
import 'package:solid_qr_app/features/qr_scanner/presentation/pages/scanner_page.dart';
import 'package:solid_qr_app/l10n/app_localizations.dart';

class MockScannerBloc extends MockBloc<ScannerEvent, ScannerState>
    implements ScannerBloc {}

class MockHistoryBloc extends MockBloc<HistoryEvent, HistoryState>
    implements HistoryBloc {}

void main() {
  late MockScannerBloc mockScannerBloc;
  late MockHistoryBloc mockHistoryBloc;

  setUp(() {
    mockScannerBloc = MockScannerBloc();
    mockHistoryBloc = MockHistoryBloc();

    when(() => mockScannerBloc.state).thenReturn(const ScannerState());
    when(() => mockHistoryBloc.state).thenReturn(const HistoryState());
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScannerBloc>.value(value: mockScannerBloc),
        BlocProvider<HistoryBloc>.value(value: mockHistoryBloc),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScannerPage(),
      ),
    );
  }

  group('ScannerPage', () {
    testWidgets('renders initial state correctly', (tester) async {
      // MobileScanner might throw on missing platform channel.
      // We'll wrap in a try/catch or just see if it pumps.
      // Usually in tests, platform channels return null or default values,
      // but MobileScanner might try to access camera.
      // We can override the default binary messenger if needed.

      await tester.pumpWidget(createWidgetUnderTest());
      // pumpAndSettle might hang if the camera is initializing indedifinetely.
      // await tester.pumpAndSettle();
      await tester.pump();

      expect(find.text('QR Scanner'), findsOneWidget);
    });
  });
}
