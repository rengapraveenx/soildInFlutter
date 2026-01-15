import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../history/presentation/pages/history_page.dart';
import '../../../qr_generator/presentation/pages/qr_generator_page.dart';
import '../../../qr_scanner/presentation/pages/scanner_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const QrGeneratorPage(),
    const ScannerPage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n?.appTitle ?? 'Solid QR App')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Text(
                'Solid QR Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard (Multi-Bloc Demo)'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.qr_code_rounded),
            label: l10n?.qrGenerator ?? 'Generate',
          ),
          NavigationDestination(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            label: l10n?.scan ?? 'Scan',
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_rounded),
            label: l10n?.history ?? 'History',
          ),
        ],
      ),
    );
  }
}
