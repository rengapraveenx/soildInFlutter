import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class QrGeneratorEvent extends Equatable {
  const QrGeneratorEvent();

  @override
  List<Object?> get props => [];
}

class QrDataChanged extends QrGeneratorEvent {
  final String text;
  const QrDataChanged(this.text);

  @override
  List<Object?> get props => [text];
}

class QrColorChanged extends QrGeneratorEvent {
  final Color color;
  const QrColorChanged(this.color);

  @override
  List<Object?> get props => [color];
}

class QrGenerateRequested extends QrGeneratorEvent {
  const QrGenerateRequested();
}
