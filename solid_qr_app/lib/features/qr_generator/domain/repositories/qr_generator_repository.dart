import '../entities/qr_entity.dart';

abstract class QrGeneratorRepository {
  Future<void> generateQr(QrEntity entity);
}
