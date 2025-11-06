import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rpgmaster/ui/widgets/note_card.dart';
import '../../providers/notes_provider.dart';
import '../../models/note_model.dart';

class CampaignNotesScreen extends ConsumerWidget {
  final String campaignId;
  const CampaignNotesScreen({super.key,
  required this.campaignId,});

  void _editNoteDialog(BuildContext context, WidgetRef ref, NoteModel note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surfaceContainerHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edytuj notatkę',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Tytuł
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Tytuł'),
              ),
              const SizedBox(height: 12),

              // Treść
              TextField(
                controller: contentController,
                maxLines: 6,
                decoration: const InputDecoration(labelText: 'Treść'),
              ),
              const SizedBox(height: 24),

              // Przycisk usuń
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: Icon(Icons.delete, color: colorScheme.error),
                  label: Text(
                    'Usuń notatkę',
                    style: TextStyle(color: colorScheme.error),
                  ),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Potwierdzenie'),
                        content: const Text(
                          'Czy na pewno chcesz usunąć tę notatkę?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Anuluj'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: colorScheme.error,
                            ),
                            child: const Text('Usuń'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await ref.read(notesActionsProvider(campaignId)).deleteNote(note.id);
                      Navigator.pop(context); // zamknij bottom sheet
                    }
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Przyciski na dole (anuluj / zapisz)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Anuluj'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await ref.read(notesActionsProvider(campaignId)).editNote(
                        note.id,
                        titleController.text.trim(),
                        contentController.text.trim(),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Zapisz'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(userNotesProvider(campaignId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Twoje notatki'),
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Text(
                'Brak notatek'
              ),
            );
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(
                title: note.title,
                content: note.content,
                onEdit: () => _editNoteDialog(context, ref, note),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Błąd: $e', style: TextStyle(color: colorScheme.error)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await ref
              .read(notesActionsProvider(campaignId))
              .addNote('Nowa notatka', 'Treść...');
        },
        icon: const Icon(Icons.add),
        label: const Text('Dodaj notatkę'),
      ),
    );
  }
}
