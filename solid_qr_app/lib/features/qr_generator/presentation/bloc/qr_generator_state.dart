import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/qr_entity.dart';

enum QrStatus { initial, loading, success, failure }

class QrGeneratorState extends Equatable {
  final QrStatus status;
  final String data;
  final Color color;
  final QrEntity? generatedQr;
  final String? errorMessage;

  const QrGeneratorState({
    this.status = QrStatus.initial,
    this.data = '',
    this.color = Colors.black,
    this.generatedQr,
    this.errorMessage,
  });

  QrGeneratorState copyWith({
    QrStatus? status,
    String? data,
    Color? color,
    QrEntity? generatedQr,
    String? errorMessage,
  }) {
    return QrGeneratorState(
      status: status ?? this.status,
      data: data ?? this.data,
      color: color ?? this.color,
      generatedQr: generatedQr ?? this.generatedQr,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, data, color, generatedQr, errorMessage];
}
