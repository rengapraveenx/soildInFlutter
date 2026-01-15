import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../qr_generator/domain/entities/qr_entity.dart';
import '../../domain/repositories/storage_repository.dart';

class SharedPrefsStorageRepository implements StorageRepository {
  static const String _historyKey = 'qr_history';

  @override
  Future<void> saveQr(QrEntity qr) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_historyKey) ?? [];

    // Convert entity to JSON map, then to String
    final qrMap = {
      'data': qr.data,
      'label': qr.label,
      'timestamp': DateTime.now().toIso8601String(),
    };

    history.insert(0, jsonEncode(qrMap)); // Add to top
    await prefs.setStringList(_historyKey, history);

    // Update Widget Data
    try {
      await HomeWidget.saveWidgetData<String>('latest_qr_data', qr.data);
      await HomeWidget.saveWidgetData<String>(
        'latest_qr_label',
        qr.label ?? '',
      );
      await HomeWidget.updateWidget(
        name: 'SolidQrWidget', // Name of the iOS Widget or Android Receiver
        iOSName: 'SolidQrWidget',
        androidName: 'SolidQrWidget',
      );
    } catch (e) {
      // Ignore widget errors in debug/simulators without native setup
      debugPrint('Widget update failed: $e');
    }
  }

  @override
  Future<List<QrEntity>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_historyKey) ?? [];

    return history.map((e) {
      final map = jsonDecode(e) as Map<String, dynamic>;
      return QrEntity(
        data: map['data'] as String,
        label: map['label'] as String?,
      );
    }).toList();
  }

  @override
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
