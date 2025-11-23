import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpgmaster/screens/templateEdit/template_edit_screen.dart';
import 'package:rpgmaster/ui/widgets/selection_button.dart';
import '../templateCreator/template_name_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TemplateSelectionScreen extends ConsumerWidget {
  const TemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TemplateNameScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Dodaj Szablon'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Tytuł
            Text(
              'Wybierz\nszablon \nkarty postaci',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),

            const SizedBox(height: 12),
            Divider(
              color: Theme.of(context).colorScheme.outlineVariant,
              height: 0.0,
              thickness: 2.0,
            ),

            // Lista szablonów
            Expanded(
              child: user == null
                  ? const Center(
                child: Text(
                  'Musisz być zalogowany, aby zobaczyć swoje szablony.',
                  textAlign: TextAlign.center,
                ),
              )
                  : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('templates')
                    .where('uid', isEqualTo: user.uid)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Błąd wczytywania szablonów'),
                    );
                  }

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nie masz jeszcze żadnych szablonów.\n'
                            'Kliknij „Dodaj Szablon”, aby stworzyć pierwszy.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data =
                          doc.data() as Map<String, dynamic>? ?? {};
                      final name = data['name'] as String? ?? 'Bez nazwy';

                      final sectionsData =
                      (data['sections'] as List<dynamic>? ?? [])
                          .cast<Map<String, dynamic>>();

                      return Padding(
                        padding: EdgeInsets.only(top: index == 0 ? 12 : 0),
                        child:SelectionButton(
                          label: name,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TemplateEditScreen(
                                  templateName: name,
                                  templateId: doc.id,
                                  initialSectionsData: sectionsData,
                                ),
                              ),
                            );
                          },
                        )
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
