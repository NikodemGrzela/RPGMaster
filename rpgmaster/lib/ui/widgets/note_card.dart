import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

class NoteCard extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback? onEdit;

  const NoteCard({
    super.key,
    required this.title,
    required this.content,
    this.onEdit,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorScheme.surface, // 👈 automatyczny kolor karty
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Górny wiersz
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      widget.title,
                      style: AppTextStyles.headline.copyWith(
                        color: colorScheme.onSurface, // 👈 kolor tekstu dynamicznie
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      color: colorScheme.primary, // 👈 kolor z motywu
                      onPressed: widget.onEdit,
                    ),
                  ],
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
            // Treść
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  widget.content
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
