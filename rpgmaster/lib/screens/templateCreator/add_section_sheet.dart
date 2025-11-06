import 'package:flutter/material.dart';
import 'section_card.dart';

/// Bottom sheet do dodawania sekcji
class AddSectionSheet extends StatefulWidget {
  final ScrollController scrollController;
  final Function(String name, FieldType type, bool hasCheckboxes) onSectionAdded;

  const AddSectionSheet({
    super.key,
    required this.scrollController,
    required this.onSectionAdded,
  });

  @override
  State<AddSectionSheet> createState() => _AddSectionSheetState();
}

class _AddSectionSheetState extends State<AddSectionSheet> {
  FieldType? _selectedType;
  bool _hasCheckboxes = false;
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canHaveCheckboxes =>
      _selectedType == FieldType.numberAttribute ||
          _selectedType == FieldType.starsAttribute;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ListView(
        controller: widget.scrollController,
        padding: const EdgeInsets.all(24),
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Nowa sekcja',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Wybierz typ pól i nazwij sekcję',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Wybór typu
          Text(
            'Typ pól',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ...FieldType.values.map((type) {
            final isSelected = _selectedType == type;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: isSelected
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedType = type;
                      if (!_canHaveCheckboxes) {
                        _hasCheckboxes = false;
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          type.icon,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                type.label,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.onPrimaryContainer
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                type.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8)
                                      : Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          // Opcja checkboxa (tylko dla number i stars)
          if (_canHaveCheckboxes) ...[
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: CheckboxListTile(
                title: const Text('Dodaj checkboxy do pól'),
                subtitle: const Text('Każde pole będzie miało pole wyboru z przodu'),
                value: _hasCheckboxes,
                onChanged: (value) {
                  setState(() => _hasCheckboxes = value ?? false);
                },
                secondary: Icon(
                  Icons.check_box_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Nazwa sekcji
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nazwa sekcji',
                hintText: 'np. Statystyki postaci',
                border: const OutlineInputBorder(),
                suffixIcon: _nameController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => _nameController.clear()),
                )
                    : null,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Podaj nazwę sekcji';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
          ),

          const SizedBox(height: 24),

          // Przycisk dodania
          FilledButton.icon(
            onPressed: _selectedType == null || _nameController.text.trim().isEmpty
                ? null
                : () {
              if (_formKey.currentState!.validate()) {
                widget.onSectionAdded(
                  _nameController.text.trim(),
                  _selectedType!,
                  _hasCheckboxes,
                );
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Dodaj sekcję'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
        ],
      ),
    );
  }
}