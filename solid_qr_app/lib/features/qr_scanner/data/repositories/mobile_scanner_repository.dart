import 'dart:async';

import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/repositories/scanner_repository.dart';

class MobileScannerRepository implements ScannerRepository {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  final _scannedDataController = StreamController<String>.broadcast();

  MobileScannerRepository() {
    _controller.barcodes.listen((capture) {
      if (capture.barcodes.isNotEmpty) {
        final code = capture.barcodes.first.rawValue;
        if (code != null) {
          _scannedDataController.add(code);
        }
      }
    });
  }

  @override
  Stream<String> get scannedData => _scannedDataController.stream;

  @override
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  @override
  Future<void> startScan() async {
    if (await requestCameraPermission()) {
      await _controller.start();
    }
  }

  @override
  Future<void> stopScan() async {
    await _controller.stop();
  }

  MobileScannerController get controller => _controller;

  void dispose() {
    _scannedDataController.close();
    _controller.dispose();
  }
}
