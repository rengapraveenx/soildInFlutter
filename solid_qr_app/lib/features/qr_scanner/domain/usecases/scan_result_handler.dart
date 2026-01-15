import 'package:url_launcher/url_launcher.dart';

class ScanResultHandler {
  static Future<void> handle(String code) async {
    final Uri? uri = Uri.tryParse(code);
    if (uri != null) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    // Fallback or specific scheme handling (tel:, mailto:, etc.)
    // For now, simpler URL launch covers most.
  }

  static bool isUrl(String code) {
    return Uri.tryParse(code)?.hasAbsolutePath ?? false;
  }
}
