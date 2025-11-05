import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

class WidgetCard extends StatefulWidget {
  final String title;
  final List<Widget> initialWidgets;
  final VoidCallback? onEdit;
  final Widget Function()? onAddWidget; // opcjonalna "fabryka" nowego widgetu

  const WidgetCard({
    super.key,
    required this.title,
    this.initialWidgets = const [],
    this.onEdit,
    this.onAddWidget,
  });

  @override
  State<WidgetCard> createState() => _WidgetCardState();
}

class _WidgetCardState extends State<WidgetCard> {
  bool _expanded = false;
  bool _isEditing = false;
  late List<Widget> _widgets;

  @override
  void initState() {
    super.initState();
    _widgets = List.from(widget.initialWidgets);
  }

  /// Dodaje nowy widget
  void _addNewWidget() {
    if (!_isEditing) return;
    setState(() {
      if (widget.onAddWidget != null) {
        _widgets.add(widget.onAddWidget!());
      }
    });
  }

  /// Przełącza tryb edycji i aktualizuje wszystkie dzieci
  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;

      _widgets = _widgets.map((child) {
        // jeśli widget ma metodę copyWith z parametrem isEditable, zastosuj ją
        try {
          final dynamic dynWidget = child;
          final updated = dynWidget.copyWith(isEditable: _isEditing);
          return updated as Widget;
        } catch (_) {
          // jeśli widget nie ma copyWith/isEditable → zwróć bez zmian
          return child;
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Górny pasek
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.headline
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        _isEditing ? Icons.check : Icons.edit,
                        size: 20,
                        color: _isEditing ? Colors.green : colorScheme.primary,
                      ),
                      onPressed: _toggleEditMode,
                      tooltip: _isEditing ? 'Zakończ edycję' : 'Edytuj zawartość',
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (_isEditing)
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        color: colorScheme.primary,
                        tooltip: "Dodaj nowy widget",
                        onPressed: _addNewWidget,
                      ),
                    IconButton(
                      icon: Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: colorScheme.primary,
                      ),
                      onPressed: () => setState(() => _expanded = !_expanded),
                    ),
                  ],
                ),
              ],
            ),
            // Zawartość
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _widgets,
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
