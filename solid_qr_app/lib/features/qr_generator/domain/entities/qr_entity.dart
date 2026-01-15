import 'package:equatable/equatable.dart';

class QrEntity extends Equatable {
  final String data;
  final String? label;

  const QrEntity({required this.data, this.label});

  @override
  List<Object?> get props => [data, label];
}
