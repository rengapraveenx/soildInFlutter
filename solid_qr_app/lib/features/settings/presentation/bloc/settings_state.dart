import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final Locale locale;

  const SettingsState({this.locale = const Locale('en')});

  SettingsState copyWith({Locale? locale}) {
    return SettingsState(locale: locale ?? this.locale);
  }

  @override
  List<Object?> get props => [locale];
}
