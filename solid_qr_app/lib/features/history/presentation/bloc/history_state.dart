import 'package:equatable/equatable.dart';

import '../../../qr_generator/domain/entities/qr_entity.dart';

enum HistoryStatus { initial, loading, success, failure }

class HistoryState extends Equatable {
  final HistoryStatus status;
  final List<QrEntity> history;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.history = const [],
  });

  HistoryState copyWith({HistoryStatus? status, List<QrEntity>? history}) {
    return HistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props => [status, history];
}
