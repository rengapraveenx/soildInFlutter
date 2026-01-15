import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../qr_generator/domain/entities/qr_entity.dart';
import '../../domain/repositories/share_repository.dart';

class SharePlusRepository implements ShareRepository {
  @override
  Future<void> shareText(String text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Future<void> shareQrImage(QrEntity qr, {required double size}) async {
    try {
      final image = await QrPainter(
        data: qr.data,
        version: QrVersions.auto,
        gapless: false,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Colors.black,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Colors.black,
        ),
      ).toImage(size);

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/qr_share.png').create();
      await file.writeAsBytes(pngBytes);

      await SharePlus.instance.share(
        ShareParams(text: qr.data, files: [XFile(file.path)]),
      );
    } catch (e) {
      debugPrint('Error sharing QR image: $e');
      rethrow;
    }
  }
}
