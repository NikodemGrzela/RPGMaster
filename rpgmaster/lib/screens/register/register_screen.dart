import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rejestracja')),
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
                  await authController.signUp(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                  if (mounted) Navigator.pop(context); // wróć do logowania
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Błąd: $e')),
                  );
                } finally {
                  setState(() => isLoading = false);
                }
              },
              child: const Text('Zarejestruj się'),
            ),
          ],
        ),
      ),
    );
  }
}
