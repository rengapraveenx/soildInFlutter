import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:solid_qr_app/features/history/domain/repositories/storage_repository.dart';
import 'package:solid_qr_app/features/history/presentation/bloc/history_bloc.dart';
import 'package:solid_qr_app/features/history/presentation/bloc/history_event.dart';
import 'package:solid_qr_app/features/history/presentation/bloc/history_state.dart';
import 'package:solid_qr_app/features/qr_generator/domain/entities/qr_entity.dart';

class MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  late StorageRepository storageRepository;
  late HistoryBloc historyBloc;

  setUp(() {
    storageRepository = MockStorageRepository();
    historyBloc = HistoryBloc(storageRepository: storageRepository);
  });

  tearDown(() {
    historyBloc.close();
  });

  group('HistoryBloc', () {
    const qrItem = QrEntity(data: 'test', label: 'label');

    test('initial state is correct', () {
      expect(historyBloc.state.status, HistoryStatus.initial);
    });

    blocTest<HistoryBloc, HistoryState>(
      'emits [loading, success] when data is loaded successfully',
      build: () {
        when(
          () => storageRepository.getHistory(),
        ).thenAnswer((_) async => [qrItem]);
        return historyBloc;
      },
      act: (bloc) => bloc.add(const HistoryLoaded()),
      expect: () => [
        const HistoryState(status: HistoryStatus.loading),
        const HistoryState(status: HistoryStatus.success, history: [qrItem]),
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'emits [loading, failure] when loading fails',
      build: () {
        when(() => storageRepository.getHistory()).thenThrow(Exception());
        return historyBloc;
      },
      act: (bloc) => bloc.add(const HistoryLoaded()),
      expect: () => [
        const HistoryState(status: HistoryStatus.loading),
        const HistoryState(status: HistoryStatus.failure),
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'saves data and reloads when HistoryAdded is added',
      build: () {
        when(() => storageRepository.saveQr(qrItem)).thenAnswer((_) async {});
        when(
          () => storageRepository.getHistory(),
        ).thenAnswer((_) async => [qrItem]);
        return historyBloc;
      },
      act: (bloc) => bloc.add(const HistoryAdded(qrItem)),
      expect: () => [
        // It triggers a reload, so we expect loading then success
        const HistoryState(status: HistoryStatus.loading),
        const HistoryState(status: HistoryStatus.success, history: [qrItem]),
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'clears history when HistoryCleared is added',
      build: () {
        when(() => storageRepository.clearHistory()).thenAnswer((_) async {});
        return historyBloc;
      },
      act: (bloc) => bloc.add(const HistoryCleared()),
      expect: () => [
        const HistoryState(status: HistoryStatus.success, history: []),
      ],
    );
  });
}
