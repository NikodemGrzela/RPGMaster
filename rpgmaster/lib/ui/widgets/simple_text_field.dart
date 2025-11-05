import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Widget z pojedynczym tekstem.
///
/// Tryby:
/// 1. [isEditable] == true → edytowalne pole tekstowe.
/// 2. [isEditable] == false → tylko wyświetlanie tekstu.
class SimpleTextField extends StatefulWidget {
  final bool isEditable;
  final String? text;
  final ValueChanged<String>? onChanged;

  const SimpleTextField({
    super.key,
    this.isEditable = false,
    this.text,
    this.onChanged,
  });

  SimpleTextField copyWith({
    bool? isEditable,
    String? text,
    ValueChanged<String>? onChanged,
  }) {
    return SimpleTextField(
      key: key,
      isEditable: isEditable ?? this.isEditable,
      text: text ?? this.text,
      onChanged: onChanged ?? this.onChanged,
    );
  }

  @override
  State<SimpleTextField> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text ?? '');
    _controller.addListener(() {
      if (widget.isEditable && widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
    });
  }

  @override
  void didUpdateWidget(SimpleTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text && widget.text != _controller.text) {
      _controller.text = widget.text ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: widget.isEditable
            ? _buildEditableLayout()
            : _buildReadOnlyLayout(),
      ),
    );
  }

  /// Tryb 1 — edytowalne pole
  Widget _buildEditableLayout() {
    return TextField(
      controller: _controller,
      style: AppTextStyles.body,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Wprowadź tekst...',
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  /// Tryb 2 — tylko wyświetlanie tekstu
  Widget _buildReadOnlyLayout() {
    return Text(
      widget.text ?? 'Brak tekstu',
      style: AppTextStyles.body,
    );
  }

  /// Pobiera aktualną wartość
  String getCurrentValue() => _controller.text;
}
