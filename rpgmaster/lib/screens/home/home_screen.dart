import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(authControllerProvider);
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            Text(
              'RPG\nMaster',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontFamily: 'UncialAntiqua',
                fontWeight: FontWeight.w300,
                height: 1.1,
              ),
            ),

            const Spacer(flex: 3),

            // Przycisk Graj
            FilledButton(
              onPressed: () {
                // TODO: Nawigacja do gry
              },
              child: const Text('Graj'),
            ),

            const SizedBox(height: 16),

            // Przycisk Szablony
            FilledButton(
              onPressed: () {
                // TODO: Nawigacja do szablonów
              },
              child: const Text('Szablony'),
            ),

            const Spacer(flex: 2),

            if (user?.email != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  user!.email!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}