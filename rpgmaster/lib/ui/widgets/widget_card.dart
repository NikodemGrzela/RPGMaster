import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';
import 'simple_text_field.dart';
import 'attribute_text_field.dart';
import 'attribute_number_field.dart';
import 'attribute_stars_field.dart';

class WidgetCard extends StatefulWidget {
  final String title;
  final List<Widget> initialWidgets;
  final Widget Function()? onAddWidget; // opcjonalna "fabryka" nowego widgetu

  const WidgetCard({
    super.key,
    required this.title,
    this.initialWidgets = const [],
    this.onAddWidget,
  });

  @override
  State<WidgetCard> createState() => _WidgetCardState();
}

class _WidgetCardState extends State<WidgetCard> {
  bool _expanded = false;
  bool _isEditing = false;
  late List<Widget> _widgets;

  // Mapy na wartości z widgetów (dla różnych typów)
  final Map<int, dynamic> _values = {};

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

  /// Przełącza tryb edycji i aktualizuje dzieci
  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;

      _widgets = List.generate(_widgets.length, (index) {
        final child = _widgets[index];

        try {
          if (child is SimpleTextField) {
            return child.copyWith(
              isEditable: _isEditing,
              text: _values[index]?.toString() ?? child.text,
              onChanged: (val) => _values[index] = val,
            );
          } else if (child is AttributeTextField) {
            return child.copyWith(
              isEditable: _isEditing,
              textValue: _values[index]?.toString() ?? child.textValue,
              onValueChanged: (val) => _values[index] = val,
            );
          } else if (child is AttributeStarsField) {
            return child.copyWith(
              isEditable: _isEditing,
              filledStars: _values[index] is int ? _values[index] : child.filledStars,
              onStarsChanged: (val) => _values[index] = val,
            );
          } else {
            return child;
          }
        } catch (e) {
          debugPrint('Nie można zaktualizować widgetu: $e');
          return child;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                    Text(widget.title, style: AppTextStyles.headline),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        _isEditing ? Icons.check : Icons.edit,
                        size: 20,
                        color: _isEditing ? Colors.green : colorScheme.primary,
                      ),
                      onPressed: _toggleEditMode,
                      tooltip:
                      _isEditing ? 'Zakończ edycję' : 'Edytuj zawartość',
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
                  children: List.generate(_widgets.length, (index) {
                    final child = _widgets[index];

                    // Dodaj callbacki jeśli nie były ustawione
                    if (child is SimpleTextField &&
                        child.onChanged == null) {
                      return child.copyWith(
                        onChanged: (val) => _values[index] = val,
                      );
                    } else if (child is AttributeTextField &&
                        child.onValueChanged == null) {
                      return child.copyWith(
                        onValueChanged: (val) => _values[index] = val,
                      );
                    } else if (child is AttributeNumberField &&
                        child.onValueChanged == null) {
                      return child.copyWith(
                        onValueChanged: (val) => _values[index] = val,
                      );
                    } else if (child is AttributeStarsField &&
                        child.onStarsChanged == null) {
                      return child.copyWith(
                        onStarsChanged: (val) => _values[index] = val,
                      );
                    }

                    return child;
                  }),
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
