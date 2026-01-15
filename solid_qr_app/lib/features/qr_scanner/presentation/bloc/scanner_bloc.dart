import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/scanner_repository.dart';
import 'scanner_event.dart';
import 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  final ScannerRepository _scannerRepository;
  StreamSubscription<String>? _scanSubscription;

  ScannerBloc({required ScannerRepository scannerRepository})
    : _scannerRepository = scannerRepository,
      super(const ScannerState()) {
    on<ScannerStarted>(_onStarted);
    on<ScannerStopped>(_onStopped);
    on<ScannerCodeDetected>(_onCodeDetected);
  }

  Future<void> _onStarted(
    ScannerStarted event,
    Emitter<ScannerState> emit,
  ) async {
    final granted = await _scannerRepository.requestCameraPermission();
    if (!granted) {
      emit(state.copyWith(status: ScannerStatus.permissionDenied));
      return;
    }

    await _scannerRepository.startScan();
    emit(state.copyWith(status: ScannerStatus.scanning));

    _scanSubscription?.cancel();
    _scanSubscription = _scannerRepository.scannedData.listen((code) {
      add(ScannerCodeDetected(code));
    });
  }

  Future<void> _onStopped(
    ScannerStopped event,
    Emitter<ScannerState> emit,
  ) async {
    await _scannerRepository.stopScan();
    _scanSubscription?.cancel();
    emit(state.copyWith(status: ScannerStatus.initial));
  }

  void _onCodeDetected(ScannerCodeDetected event, Emitter<ScannerState> emit) {
    if (state.status == ScannerStatus.resultFound &&
        state.lastResult == event.code) {
      // Avoid duplicate emissions for same code
      return;
    }
    emit(
      state.copyWith(status: ScannerStatus.resultFound, lastResult: event.code),
    );
  }

  @override
  Future<void> close() {
    _scanSubscription?.cancel();
    _scannerRepository.stopScan();
    return super.close();
  }
}
