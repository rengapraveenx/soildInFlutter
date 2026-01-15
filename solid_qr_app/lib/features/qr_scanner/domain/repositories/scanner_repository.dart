abstract class ScannerRepository {
  /// Stream of scanned data strings
  Stream<String> get scannedData;

  /// Start scanning
  Future<void> startScan();

  /// Stop scanning
  Future<void> stopScan();

  /// Check and Request Camera Permission
  Future<bool> requestCameraPermission();
}
