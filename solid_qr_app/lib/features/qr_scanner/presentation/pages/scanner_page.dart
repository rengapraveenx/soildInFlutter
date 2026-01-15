import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../history/presentation/bloc/history_bloc.dart';
import '../../../history/presentation/bloc/history_event.dart';
import '../../../qr_generator/domain/entities/qr_entity.dart';
import '../../data/repositories/mobile_scanner_repository.dart';
import '../../domain/usecases/scan_result_handler.dart';
import '../bloc/scanner_bloc.dart';
import '../bloc/scanner_event.dart';
import '../bloc/scanner_state.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Repository and Bloc
    return RepositoryProvider(
      create: (context) => MobileScannerRepository(),
      child: BlocProvider(
        create: (context) => ScannerBloc(
          scannerRepository: context.read<MobileScannerRepository>(),
        )..add(const ScannerStarted()),
        child: const _ScannerView(),
      ),
    );
  }
}

class _ScannerView extends StatelessWidget {
  const _ScannerView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Listen for results
    return BlocListener<ScannerBloc, ScannerState>(
      listener: (context, state) {
        if (state.status == ScannerStatus.resultFound &&
            state.lastResult != null) {
          _handleResult(context, state.lastResult!);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n?.qrScanner ?? 'Scanner')),
        body: BlocBuilder<ScannerBloc, ScannerState>(
          builder: (context, state) {
            if (state.status == ScannerStatus.permissionDenied) {
              return Center(child: Text('Camera permission required'));
            }

            return Stack(
              children: [
                // Camera View
                MobileScanner(
                  controller: context
                      .read<MobileScannerRepository>()
                      .controller,
                  onDetect: (capture) {
                    // Handled by Repository stream, but controller needs to be attached
                  },
                ),
                // Overlay
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Scan a code',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleResult(BuildContext context, String code) async {
    // TODO: Move this logic to a structured handler in the next step

    // Stop scanning temporarily
    context.read<ScannerBloc>().add(const ScannerStopped());

    // Add to history
    context.read<HistoryBloc>().add(HistoryAdded(QrEntity(data: code)));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Result'),
        content: Text(code),
        actions: [
          TextButton(
            onPressed: () {
              // Resume
              Navigator.pop(context);
              context.read<ScannerBloc>().add(const ScannerStarted());
            },
            child: const Text('Scan Again'),
          ),
          FilledButton(
            onPressed: () async {
              await ScanResultHandler.handle(code);
            },
            child: const Text('Open/Action'),
          ),
        ],
      ),
    );
  }
}
