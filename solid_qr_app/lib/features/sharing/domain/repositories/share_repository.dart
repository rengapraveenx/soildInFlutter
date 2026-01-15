import '../../../qr_generator/domain/entities/qr_entity.dart';

abstract class ShareRepository {
  Future<void> shareText(String text);
  Future<void> shareQrImage(QrEntity qr, {required double size});
}
