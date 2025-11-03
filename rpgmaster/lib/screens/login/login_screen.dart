import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../register/register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Logowanie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Hasło'),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                setState(() => isLoading = true);
                try {
                  await authController.signIn(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Błąd: $e')),
                  );
                } finally {
                  setState(() => isLoading = false);
                }
              },
              child: const Text('Zaloguj się'),
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Image.asset(
                'assets/google_logo.jpeg', // dodaj logo Google w assets
                height: 24,
              ),
              label: const Text('Zaloguj przez Google'),
              onPressed: () async {
                setState(() => isLoading = true);
                try {
                  await authController.signInWithGoogle();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Błąd logowania Google: $e')),
                  );
                } finally {
                  setState(() => isLoading = false);
                }
              },
            ),

            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text('Nie masz konta? Zarejestruj się'),
            ),
          ],
        ),
      ),
    );
  }
}
