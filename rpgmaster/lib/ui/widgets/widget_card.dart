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
  late List<Widget> _widgets;

  @override
  void initState() {
    super.initState();
    _widgets = List.from(widget.initialWidgets);
  }

  void _addNewWidget() {
    setState(() {
      if (widget.onAddWidget != null) {
        _widgets.add(widget.onAddWidget!());
      } else {
        // domyślny widget, jeśli nie zdefiniowano fabryki
        _widgets.add(
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: const Text("Nowy widget"),
          ),
        );
      }
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
      color: colorScheme.surfaceContainer,
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
                      icon: const Icon(Icons.edit, size: 18),
                      color: colorScheme.primary,
                      onPressed: widget.onEdit,
                    ),
                  ],
                ),
                Row(
                  children: [
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
