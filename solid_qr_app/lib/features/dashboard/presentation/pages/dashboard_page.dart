import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/stats_bloc.dart';
import '../bloc/stats_event.dart';
import '../bloc/stats_state.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. MultiBlocProvider: Injecting Multiple Blocs into the tree
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc()..add(LoadUserProfile())),
        BlocProvider(create: (context) => StatsBloc()..add(LoadStats())),
      ],
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. MultiBlocListener: Listening to multiple Blocs for side effects (Snackbars, Navigation)
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoaded && state.isPremium) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Welcome Premium User! 🌟')),
              );
            }
          },
        ),
        BlocListener<StatsBloc, StatsState>(
          listener: (context, state) {
            if (state is StatsLoaded) {
              // Maybe log analytics, or show a subtle toast
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Multi-Bloc Dashboard')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _UserProfileSection(),
              const SizedBox(height: 24),
              const _StatsSection(),
              const SizedBox(height: 24),
              const _ActionsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserProfileSection extends StatelessWidget {
  const _UserProfileSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'User Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // 3. BlocBuilder: Rebuilds ONLY this part when UserBloc changes
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return const CircularProgressIndicator();
                } else if (state is UserLoaded) {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: state.isPremium
                            ? Colors.amber
                            : Colors.grey,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.username,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(
                          state.isPremium ? 'Premium Member' : 'Free Tier',
                        ),
                        backgroundColor: state.isPremium
                            ? Colors.amber.withValues(alpha: 0.2)
                            : Colors.grey.withValues(alpha: 0.2),
                      ),
                    ],
                  );
                }
                return const Text('Something went wrong');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Statistics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () =>
                      context.read<StatsBloc>().add(RefreshStats()),
                ),
              ],
            ),
            const Divider(),
            // 4. Another BlocBuilder: Rebuilds ONLY this part when StatsBloc changes
            BlocBuilder<StatsBloc, StatsState>(
              builder: (context, state) {
                if (state is StatsLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  );
                } else if (state is StatsLoaded) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        label: 'Codes',
                        value: state.qrCount.toString(),
                      ),
                      _StatItem(
                        label: 'Scans',
                        value: state.scansCount.toString(),
                      ),
                    ],
                  );
                }
                return const Text('No stats available');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _ActionsSection extends StatelessWidget {
  const _ActionsSection();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.diamond),
        title: const Text('Toggle Premium Status'),
        subtitle: const Text('Simulates a state change in UserBloc'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.read<UserBloc>().add(TogglePremium());
        },
      ),
    );
  }
}
