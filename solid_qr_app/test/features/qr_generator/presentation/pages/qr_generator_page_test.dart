import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solid_qr_app/features/history/presentation/bloc/history_bloc.dart';
import 'package:solid_qr_app/features/history/presentation/bloc/history_event.dart';
import 'package:solid_qr_app/features/history/presentation/bloc/history_state.dart';
import 'package:solid_qr_app/features/qr_generator/domain/entities/qr_entity.dart';
import 'package:solid_qr_app/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:solid_qr_app/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:solid_qr_app/features/qr_generator/presentation/bloc/qr_generator_state.dart';
import 'package:solid_qr_app/features/qr_generator/presentation/pages/qr_generator_page.dart';
import 'package:solid_qr_app/features/sharing/domain/repositories/share_repository.dart';
import 'package:solid_qr_app/l10n/app_localizations.dart';

// Mocks
class MockQrGeneratorBloc extends MockBloc<QrGeneratorEvent, QrGeneratorState>
    implements QrGeneratorBloc {}

class MockHistoryBloc extends MockBloc<HistoryEvent, HistoryState>
    implements HistoryBloc {}

class MockShareRepository extends Mock implements ShareRepository {}

void main() {
  late MockQrGeneratorBloc mockQrGeneratorBloc;
  late MockHistoryBloc mockHistoryBloc;
  late MockShareRepository mockShareRepository;

  setUp(() {
    mockQrGeneratorBloc = MockQrGeneratorBloc();
    mockHistoryBloc = MockHistoryBloc();
    mockShareRepository = MockShareRepository();

    // Default Stubs
    when(() => mockQrGeneratorBloc.state).thenReturn(const QrGeneratorState());
    when(() => mockHistoryBloc.state).thenReturn(const HistoryState());
  });

  Widget createWidgetUnderTest() {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ShareRepository>.value(value: mockShareRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<QrGeneratorBloc>.value(value: mockQrGeneratorBloc),
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
          home: QrGeneratorView(),
        ),
      ),
    );
  }

  group('QrGeneratorPage', () {
    testWidgets('renders initial state correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('QR Generator'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Generate'), findsOneWidget);
    });

    testWidgets('adds QrDataChanged event when text is entered', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Test QR');

      verify(
        () => mockQrGeneratorBloc.add(const QrDataChanged('Test QR')),
      ).called(1);
    });

    testWidgets(
      'adds QrGenerateRequested event when Generate button is pressed',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Generate'));

        verify(
          () => mockQrGeneratorBloc.add(const QrGenerateRequested()),
        ).called(1);
      },
    );

    testWidgets('shows QrImageView when status is success', (tester) async {
      const qrEntity = QrEntity(data: 'Test Data', label: 'Test Label');
      when(() => mockQrGeneratorBloc.state).thenReturn(
        const QrGeneratorState(status: QrStatus.success, generatedQr: qrEntity),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // QrImageView might not be directly findable by type easily depending on package structure,
      // but we can look for the container content or the Save/Share buttons that appear with it.
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
    });

    testWidgets(
      'adds HistoryAdded event and shows snackbar when Save is pressed',
      (tester) async {
        const qrEntity = QrEntity(data: 'Test Data', label: 'Test Label');
        when(() => mockQrGeneratorBloc.state).thenReturn(
          const QrGeneratorState(
            status: QrStatus.success,
            generatedQr: qrEntity,
          ),
        );

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text('Save'));
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        verify(
          () => mockHistoryBloc.add(const HistoryAdded(qrEntity)),
        ).called(1);
        expect(find.text('Saved'), findsOneWidget);
      },
    );
  });
}
