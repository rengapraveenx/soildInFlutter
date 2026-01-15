import 'package:equatable/equatable.dart';

import '../../../qr_generator/domain/entities/qr_entity.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
  @override
  List<Object?> get props => [];
}

class HistoryLoaded extends HistoryEvent {
  const HistoryLoaded();
}

class HistoryAdded extends HistoryEvent {
  final QrEntity qr;
  const HistoryAdded(this.qr);
  @override
  List<Object?> get props => [qr];
}

class HistoryCleared extends HistoryEvent {
  const HistoryCleared();
}
