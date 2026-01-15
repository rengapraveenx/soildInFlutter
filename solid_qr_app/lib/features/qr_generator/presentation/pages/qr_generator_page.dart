import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:solid_qr_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:solid_qr_app/features/settings/presentation/bloc/settings_event.dart';
import 'package:solid_qr_app/features/sharing/domain/repositories/share_repository.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../history/presentation/bloc/history_bloc.dart';
import '../../../history/presentation/bloc/history_event.dart';
import '../bloc/qr_generator_bloc.dart';
import '../bloc/qr_generator_event.dart';
import '../bloc/qr_generator_state.dart';

class QrGeneratorPage extends StatelessWidget {
  const QrGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrGeneratorBloc(),
      child: const QrGeneratorView(),
    );
  }
}

class QrGeneratorView extends StatelessWidget {
  const QrGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: Assuming AppLocalizations is fixed/working. If not, fallback strings used.
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.qrGenerator ?? 'QR Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const _LanguageSelector(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: l10n?.enterText ?? 'Enter Text',
                        prefixIcon: const Icon(Icons.text_fields),
                      ),
                      onChanged: (value) {
                        context.read<QrGeneratorBloc>().add(
                          QrDataChanged(value),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Simple Color Selector
                    BlocBuilder<QrGeneratorBloc, QrGeneratorState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            Text(l10n?.selectColor ?? 'Color: '),
                            const SizedBox(width: 8),
                            _ColorOption(
                              color: Colors.black,
                              isSelected: state.color == Colors.black,
                            ),
                            _ColorOption(
                              color: Colors.red,
                              isSelected: state.color == Colors.red,
                            ),
                            _ColorOption(
                              color: Colors.blue,
                              isSelected: state.color == Colors.blue,
                            ),
                            _ColorOption(
                              color: Colors.green,
                              isSelected: state.color == Colors.green,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Generate Button
            BlocBuilder<QrGeneratorBloc, QrGeneratorState>(
              builder: (context, state) {
                return ElevatedButton.icon(
                  onPressed: state.status == QrStatus.loading
                      ? null
                      : () {
                          context.read<QrGeneratorBloc>().add(
                            const QrGenerateRequested(),
                          );
                        },
                  icon: state.status == QrStatus.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.qr_code),
                  label: Text(l10n?.generate ?? 'Generate'),
                );
              },
            ),

            const SizedBox(height: 32),

            // Result Section
            BlocBuilder<QrGeneratorBloc, QrGeneratorState>(
              builder: (context, state) {
                if (state.generatedQr != null) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: state.generatedQr!.data,
                          version: QrVersions.auto,
                          size: 200.0,
                          eyeStyle: QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: state.color,
                          ),
                          dataModuleStyle: QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: state.color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () async {
                              if (state.generatedQr != null) {
                                try {
                                  await context
                                      .read<ShareRepository>()
                                      .shareQrImage(
                                        state.generatedQr!,
                                        size: 200.0,
                                      );
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error sharing: $e'),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            icon: const Icon(Icons.share),
                            label: Text(l10n?.share ?? 'Share'),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<HistoryBloc>().add(
                                HistoryAdded(state.generatedQr!),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n?.saved ?? 'Saved to History',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.save),
                            label: Text(l10n?.save ?? 'Save'),
                          ),
                        ],
                      ),
                    ],
                  );
                } else if (state.status == QrStatus.failure) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'Error generating QR',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  const _ColorOption({required this.color, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<QrGeneratorBloc>().add(QrColorChanged(color));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, size: 20, color: Colors.white)
            : null,
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Language',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('English'),
            onTap: () {
              context.read<SettingsBloc>().add(
                const ChangeLocale(Locale('en')),
              );
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Tamil (தமிழ்)'),
            onTap: () {
              context.read<SettingsBloc>().add(
                const ChangeLocale(Locale('ta')),
              );
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Malayalam (മലയാളം)'),
            onTap: () {
              context.read<SettingsBloc>().add(
                const ChangeLocale(Locale('ml')),
              );
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Kannada (ಕನ್ನಡ)'),
            onTap: () {
              context.read<SettingsBloc>().add(
                const ChangeLocale(Locale('kn')),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
