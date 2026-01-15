import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:solid_qr_app/core/theme/theme.dart';
import 'package:solid_qr_app/features/history/data/repositories/shared_prefs_storage_repository.dart';
import 'package:solid_qr_app/features/history/domain/repositories/storage_repository.dart';
import 'package:solid_qr_app/features/history/presentation/bloc/history_bloc.dart';
import 'package:solid_qr_app/features/home/presentation/pages/main_page.dart';
import 'package:solid_qr_app/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:solid_qr_app/features/settings/presentation/bloc/settings_state.dart';
import 'package:solid_qr_app/features/sharing/data/repositories/share_plus_repository.dart';
import 'package:solid_qr_app/features/sharing/domain/repositories/share_repository.dart';
import 'package:solid_qr_app/l10n/app_localizations.dart';

void main() {
  runApp(const SolidQrApp());
}

class SolidQrApp extends StatelessWidget {
  const SolidQrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<StorageRepository>(
          create: (context) => SharedPrefsStorageRepository(),
        ),
        RepositoryProvider<ShareRepository>(
          create: (context) => SharePlusRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HistoryBloc>(
            create: (context) => HistoryBloc(
              storageRepository: context.read<StorageRepository>(),
            ),
          ),
          BlocProvider<SettingsBloc>(create: (context) => SettingsBloc()),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            return MaterialApp(
              title: 'Solid QR App',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              locale: settingsState.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: const MainPage(),
            );
          },
        ),
      ),
    );
  }
}
