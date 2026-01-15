import 'package:equatable/equatable.dart';

enum ScannerStatus { initial, scanning, permissionDenied, resultFound }

class ScannerState extends Equatable {
  final ScannerStatus status;
  final String? lastResult;

  const ScannerState({this.status = ScannerStatus.initial, this.lastResult});

  ScannerState copyWith({ScannerStatus? status, String? lastResult}) {
    return ScannerState(
      status: status ?? this.status,
      lastResult: lastResult ?? this.lastResult,
    );
  }

  @override
  List<Object?> get props => [status, lastResult];
}
