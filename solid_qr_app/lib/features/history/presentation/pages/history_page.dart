import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:solid_qr_app/features/sharing/domain/repositories/share_repository.dart';

import '../../../../l10n/app_localizations.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Trigger load on build
    context.read<HistoryBloc>().add(const HistoryLoaded());

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.history ?? 'History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              context.read<HistoryBloc>().add(const HistoryCleared());
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state.status == HistoryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.history.isEmpty) {
            return const Center(child: Text('No history yet'));
          }

          return ListView.builder(
            itemCount: state.history.length,
            itemBuilder: (context, index) {
              final item = state.history[index];
              return ListTile(
                leading: QrImageView(
                  data: item.data,
                  version: QrVersions.auto,
                  size: 40.0,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Colors.black,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Colors.black,
                  ),
                ),
                title: Text(item.data),
                subtitle: item.label != null ? Text(item.label!) : null,
                trailing: IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    context.read<ShareRepository>().shareQrImage(
                      item,
                      size: 200.0,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
