import 'package:flutter/material.dart';
import '../../ui/widgets/step_indicator.dart';
import '../../ui/theme/app_text_styles.dart';
import 'section_card.dart';
import 'add_section_sheet.dart';

class TemplateCreatorScreen extends StatefulWidget {
  final String templateName;

  const TemplateCreatorScreen({
    super.key,
    required this.templateName,
  });

  @override
  State<TemplateCreatorScreen> createState() => _TemplateCreatorScreenState();
}

class _TemplateCreatorScreenState extends State<TemplateCreatorScreen> {
  final List<Section> _sections = [];
  int? _expandedSectionIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBack,
        ),
        title: Text(widget.templateName, style: AppTextStyles.title),
        actions: [
          if (_sections.isNotEmpty)
            TextButton.icon(
              onPressed: _saveTemplate,
              icon: const Icon(Icons.check),
              label: const Text('Zapisz'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Header z krokami
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const StepIndicator(currentStep: 2, totalSteps: 2),
                const SizedBox(height: 16),
                Text(
                  'Zbuduj szablon z sekcji i pól',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Lista sekcji
          Expanded(
            child: _sections.isEmpty
                ? _buildEmptyState()
                : _buildSectionsList(),
          ),

          // Przycisk dodania sekcji
          _buildAddSectionButton(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_module_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Zacznij od dodania pierwszej sekcji',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Np. "Statystyki" z atrybutami liczbowymi.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionsList() {
    return ReorderableListView(
      padding: const EdgeInsets.all(12),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex -= 1;
          final section = _sections.removeAt(oldIndex);
          _sections.insert(newIndex, section);
          // Aktualizuj expanded index
          if (_expandedSectionIndex == oldIndex) {
            _expandedSectionIndex = newIndex;
          } else if (_expandedSectionIndex != null) {
            if (oldIndex < _expandedSectionIndex! &&
                newIndex >= _expandedSectionIndex!) {
              _expandedSectionIndex = _expandedSectionIndex! - 1;
            } else if (oldIndex > _expandedSectionIndex! &&
                newIndex <= _expandedSectionIndex!) {
              _expandedSectionIndex = _expandedSectionIndex! + 1;
            }
          }
        });
      },
      children: List.generate(_sections.length, (index) {
        final section = _sections[index];
        final isExpanded = _expandedSectionIndex == index;

        return SectionCard(
          key: ValueKey('section_$index'),
          index: index,
          section: section,
          isExpanded: isExpanded,
          onToggleExpanded: () {
            setState(() {
              _expandedSectionIndex = isExpanded ? null : index;
            });
          },
          onEdit: () => _editSectionName(index),
          onDelete: () => _deleteSection(index),
          onAddField: () => _addField(index),
          onRemoveField: (fieldIndex) => _removeField(index, fieldIndex),
        );
      }),
    );
  }

  Widget _buildAddSectionButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: FilledButton.icon(
        onPressed: _showAddSectionSheet,
        icon: const Icon(Icons.add),
        label: const Text('Dodaj sekcję'),
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
    );
  }

  void _showAddSectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return AddSectionSheet(
            scrollController: scrollController,
            onSectionAdded: (name, type, hasCheckboxes) {
              setState(() {
                final newIndex = _sections.length;
                _sections.add(Section(
                  name: name,
                  type: type,
                  hasCheckboxes: hasCheckboxes,
                ));
                _expandedSectionIndex = newIndex;
              });
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  void _editSectionName(int index) {
    final controller = TextEditingController(text: _sections[index].name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Zmień nazwę sekcji'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nazwa sekcji',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => _sections[index].name = controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Zapisz'),
          ),
        ],
      ),
    );
  }

  void _deleteSection(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usunąć sekcję?'),
        content: Text('Czy na pewno chcesz usunąć sekcję "${_sections[index].name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _sections.removeAt(index);
                if (_expandedSectionIndex == index) {
                  _expandedSectionIndex = null;
                } else if (_expandedSectionIndex != null && _expandedSectionIndex! > index) {
                  _expandedSectionIndex = _expandedSectionIndex! - 1;
                }
              });
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Usuń'),
          ),
        ],
      ),
    );
  }

  void _addField(int sectionIndex) {
    setState(() {
      _sections[sectionIndex].addField();
    });
  }

  void _removeField(int sectionIndex, int fieldIndex) {
    if (_sections[sectionIndex].fields.length > 1) {
      setState(() {
        _sections[sectionIndex].fields.removeAt(fieldIndex);
      });
    }
  }

  void _handleBack() {
    if (_sections.isEmpty) {
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cofnąć do kroku 1?'),
        content: const Text(
          'Wszystkie dodane sekcje zostaną utracone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Cofnij'),
          ),
        ],
      ),
    );
  }

  void _saveTemplate() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.check_circle_outline, size: 48, color: Theme.of(context).colorScheme.onPrimary),
        title: const Text('Szablon zapisany'),
        content: Text(
          'Szablon "${widget.templateName}" z ${_sections.length} ${_sections.length == 1 ? 'sekcją' : 'sekcjami'} został zapisany!',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}