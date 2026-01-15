import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solid_qr_app/features/qr_generator/domain/entities/qr_entity.dart';
import 'package:solid_qr_app/features/qr_generator/presentation/bloc/qr_generator_bloc.dart';
import 'package:solid_qr_app/features/qr_generator/presentation/bloc/qr_generator_event.dart';
import 'package:solid_qr_app/features/qr_generator/presentation/bloc/qr_generator_state.dart';

void main() {
  group('QrGeneratorBloc', () {
    late QrGeneratorBloc bloc;

    setUp(() {
      bloc = QrGeneratorBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is correct', () {
      expect(bloc.state, const QrGeneratorState());
    });

    blocTest<QrGeneratorBloc, QrGeneratorState>(
      'emits [state with data] when QrDataChanged is added',
      build: () => bloc,
      act: (bloc) => bloc.add(const QrDataChanged('Test Data')),
      expect: () => [const QrGeneratorState(data: 'Test Data')],
    );

    blocTest<QrGeneratorBloc, QrGeneratorState>(
      'emits [state with color] when QrColorChanged is added',
      build: () => bloc,
      act: (bloc) => bloc.add(const QrColorChanged(Colors.red)),
      expect: () => [const QrGeneratorState(color: Colors.red)],
    );

    blocTest<QrGeneratorBloc, QrGeneratorState>(
      'emits [loading, success] when QrGenerateRequested is added with valid data',
      build: () => bloc,
      seed: () => const QrGeneratorState(data: 'Valid Data'),
      act: (bloc) => bloc.add(const QrGenerateRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const QrGeneratorState(status: QrStatus.loading, data: 'Valid Data'),
        const QrGeneratorState(
          status: QrStatus.success,
          data: 'Valid Data',
          generatedQr: QrEntity(data: 'Valid Data'),
        ),
      ],
    );

    blocTest<QrGeneratorBloc, QrGeneratorState>(
      'emits [failure] when QrGenerateRequested is added with empty data',
      build: () => bloc,
      seed: () => const QrGeneratorState(data: ''),
      act: (bloc) => bloc.add(const QrGenerateRequested()),
      expect: () => [
        const QrGeneratorState(
          status: QrStatus.failure,
          data: '',
          errorMessage: 'Data cannot be empty',
        ),
      ],
    );
  });
}
