import 'package:equatable/equatable.dart';

abstract class ScannerEvent extends Equatable {
  const ScannerEvent();

  @override
  List<Object?> get props => [];
}

class ScannerStarted extends ScannerEvent {
  const ScannerStarted();
}

class ScannerStopped extends ScannerEvent {
  const ScannerStopped();
}

class ScannerCodeDetected extends ScannerEvent {
  final String code;
  const ScannerCodeDetected(this.code);

  @override
  List<Object?> get props => [code];
}
