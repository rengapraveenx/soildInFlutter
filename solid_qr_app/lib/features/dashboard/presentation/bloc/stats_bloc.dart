import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'stats_event.dart';
import 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc() : super(StatsInitial()) {
    on<LoadStats>((event, emit) async {
      emit(StatsLoading());
      await Future.delayed(const Duration(seconds: 1));
      emit(const StatsLoaded(qrCount: 12, scansCount: 45));
    });

    on<RefreshStats>((event, emit) async {
      final random = Random();
      emit(StatsLoading());
      await Future.delayed(const Duration(milliseconds: 500));
      emit(
        StatsLoaded(
          qrCount: 10 + random.nextInt(20),
          scansCount: 40 + random.nextInt(50),
        ),
      );
    });
  }
}
