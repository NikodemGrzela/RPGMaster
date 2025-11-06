import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rpgmaster/models/campaign_model.dart';
import 'package:rpgmaster/ui/widgets/dice_row.dart';

class CampaignCreatorScreen extends StatefulWidget {
  const CampaignCreatorScreen({super.key});

  @override
  State<CampaignCreatorScreen> createState() => _CampaignCreatorScreenState();
}

class _CampaignCreatorScreenState extends State<CampaignCreatorScreen> {
  final _nameController = TextEditingController();

  int _tetra = 0;   // k4
  int _hexa = 0;    // k6
  int _octa = 0;    // k8
  int _deca = 0;    // k10
  int _dodeca = 0;  // k12
  int _icosa = 0;   // k20

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCampaign() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Podaj nazwę kampanii')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      await showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Brak zalogowanego użytkownika'),
          content: Text('Aby zapisać kampanię, musisz być zalogowany.'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();

      final campaign = Campaign(
        id: '',
        userId: user.uid,
        title: name,
        tetra: _tetra > 0 ? _tetra : null,
        hexa: _hexa > 0 ? _hexa : null,
        octa: _octa > 0 ? _octa : null,
        deca: _deca > 0 ? _deca : null,
        dodeca: _dodeca > 0 ? _dodeca : null,
        icosa: _icosa > 0 ? _icosa : null,
        createdAt: now,
      );

      await FirebaseFirestore.instance
          .collection('campaigns')
          .add(campaign.toMap());

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kampania "$name" została utworzona')),
      );
    } catch (e) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Błąd zapisu'),
          content: Text('Nie udało się zapisać kampanii: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Nowa kampania'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveCampaign,
            child: Text(
              'Zapisz',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: _isSaving
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Karta z nazwą kampanii
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nazwa kampanii',
                      hintText: 'np. Kampania w Shire',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Karta z dostępnymi kośćmi
              Card(
                elevation: 1,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dostępne kości:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ustaw maksymalną liczbę kości danego typu, '
                            'którymi można rzucać w tej kampanii.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),

                      DiceRow(
                        label: 'Kość czworościenna (k4)',
                        initialValue: _tetra,
                        onChanged: (value) =>
                            setState(() => _tetra = value),
                      ),
                      const SizedBox(height: 8),

                      DiceRow(
                        label: 'Kość sześciokątna (k6)',
                        initialValue: _hexa,
                        onChanged: (value) =>
                            setState(() => _hexa = value),
                      ),
                      const SizedBox(height: 8),

                      DiceRow(
                        label: 'Kość ośmiościenna (k8)',
                        initialValue: _octa,
                        onChanged: (value) =>
                            setState(() => _octa = value),
                      ),
                      const SizedBox(height: 8),

                      DiceRow(
                        label: 'Kość dziesięciościenna (k10)',
                        initialValue: _deca,
                        onChanged: (value) =>
                            setState(() => _deca = value),
                      ),
                      const SizedBox(height: 8),

                      DiceRow(
                        label: 'Kość dwunastościenna (k12)',
                        initialValue: _dodeca,
                        onChanged: (value) =>
                            setState(() => _dodeca = value),
                      ),
                      const SizedBox(height: 8),

                      DiceRow(
                        label: 'Kość dwudziestościenna (k20)',
                        initialValue: _icosa,
                        onChanged: (value) =>
                            setState(() => _icosa = value),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
