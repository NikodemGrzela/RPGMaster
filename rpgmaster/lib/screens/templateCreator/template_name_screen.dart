import 'package:flutter/material.dart';
import 'template_creator_screen.dart';
import '../../ui/widgets/step_indicator.dart';

/// Ekran wprowadzania nazwy szablonu (Krok 1/2)
class TemplateNameScreen extends StatefulWidget {
  const TemplateNameScreen({super.key});

  @override
  State<TemplateNameScreen> createState() => _TemplateNameScreenState();
}

class _TemplateNameScreenState extends State<TemplateNameScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_nameController.text
        .trim()
        .isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Podaj nazwę szablonu'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TemplateCreatorScreen(
              templateName: _nameController.text.trim(),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nowy szablon'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const StepIndicator(currentStep: 1, totalSteps: 2),
                    const SizedBox(height: 48),

                    Text(
                      'Podaj nazwę szablonu',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineMedium,
                    ),

                    const SizedBox(height: 32),

                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nazwa szablonu',
                        hintText: 'np. Frodo',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _continue(),
                    ),

                    const Spacer(),

                    FilledButton(
                      onPressed: _continue,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text('Kontynuuj'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}