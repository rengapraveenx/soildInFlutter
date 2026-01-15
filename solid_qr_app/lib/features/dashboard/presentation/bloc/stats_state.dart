import 'package:equatable/equatable.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object> get props => [];
}

class StatsInitial extends StatsState {}

class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState {
  final int qrCount;
  final int scansCount;

  const StatsLoaded({required this.qrCount, required this.scansCount});

  @override
  List<Object> get props => [qrCount, scansCount];
}
