import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/storage_repository.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final StorageRepository _storageRepository;

  HistoryBloc({required StorageRepository storageRepository})
    : _storageRepository = storageRepository,
      super(const HistoryState()) {
    on<HistoryLoaded>(_onLoaded);
    on<HistoryAdded>(_onAdded);
    on<HistoryCleared>(_onCleared);
  }

  Future<void> _onLoaded(
    HistoryLoaded event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(status: HistoryStatus.loading));
    try {
      final history = await _storageRepository.getHistory();
      emit(state.copyWith(status: HistoryStatus.success, history: history));
    } catch (_) {
      emit(state.copyWith(status: HistoryStatus.failure));
    }
  }

  Future<void> _onAdded(HistoryAdded event, Emitter<HistoryState> emit) async {
    await _storageRepository.saveQr(event.qr);
    add(const HistoryLoaded());
  }

  Future<void> _onCleared(
    HistoryCleared event,
    Emitter<HistoryState> emit,
  ) async {
    await _storageRepository.clearHistory();
    emit(state.copyWith(status: HistoryStatus.success, history: []));
  }
}
