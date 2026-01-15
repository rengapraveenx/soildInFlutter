import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUserProfile>((event, emit) async {
      emit(UserLoading());
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      emit(const UserLoaded(username: 'FlutterDev', isPremium: false));
    });

    on<TogglePremium>((event, emit) {
      if (state is UserLoaded) {
        final currentState = state as UserLoaded;
        emit(
          UserLoaded(
            username: currentState.username,
            isPremium: !currentState.isPremium,
          ),
        );
      }
    });
  }
}
