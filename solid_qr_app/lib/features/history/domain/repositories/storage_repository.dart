import '../../../qr_generator/domain/entities/qr_entity.dart';

abstract class StorageRepository {
  Future<void> saveQr(QrEntity qr);
  Future<List<QrEntity>> getHistory();
  Future<void> clearHistory();
}
