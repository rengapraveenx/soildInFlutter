import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final String username;
  final bool isPremium;

  const UserLoaded({required this.username, required this.isPremium});

  @override
  List<Object> get props => [username, isPremium];
}
