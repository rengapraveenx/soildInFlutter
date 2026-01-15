import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/qr_entity.dart';
import 'qr_generator_event.dart';
import 'qr_generator_state.dart';

class QrGeneratorBloc extends Bloc<QrGeneratorEvent, QrGeneratorState> {
  QrGeneratorBloc() : super(const QrGeneratorState()) {
    on<QrDataChanged>(_onDataChanged);
    on<QrColorChanged>(_onColorChanged);
    on<QrGenerateRequested>(_onGenerateRequested);
  }

  void _onDataChanged(QrDataChanged event, Emitter<QrGeneratorState> emit) {
    emit(state.copyWith(data: event.text, status: QrStatus.initial));
  }

  void _onColorChanged(QrColorChanged event, Emitter<QrGeneratorState> emit) {
    emit(state.copyWith(color: event.color));
  }

  Future<void> _onGenerateRequested(
    QrGenerateRequested event,
    Emitter<QrGeneratorState> emit,
  ) async {
    if (state.data.isEmpty) {
      emit(
        state.copyWith(
          status: QrStatus.failure,
          errorMessage: 'Data cannot be empty',
        ),
      );
      return;
    }

    emit(state.copyWith(status: QrStatus.loading));

    // Simulate processing or save to history here
    // For now, just success
    await Future.delayed(const Duration(milliseconds: 500));

    emit(
      state.copyWith(
        status: QrStatus.success,
        generatedQr: QrEntity(data: state.data),
      ),
    );
  }
}
