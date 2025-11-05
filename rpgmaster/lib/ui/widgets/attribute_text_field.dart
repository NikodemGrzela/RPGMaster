import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Widget with scheme key : value.
///
/// Modes:
/// 1. [isTemplate] == true → editable key, value = placeholder.
/// 2. [isEditable] == true → key from parameters, editable value.
/// 3. both == false → readonly
class AttributeTextField extends StatefulWidget {
  final bool isTemplate;
  final bool isEditable;
  final String? textKey;
  final String? textValue;
  final ValueChanged<String>? onKeyChanged;
  final ValueChanged<String>? onValueChanged;

  const AttributeTextField({
    super.key,
    this.isTemplate = false,
    this.isEditable = false,
    this.textKey,
    this.textValue,
    this.onKeyChanged,
    this.onValueChanged,
  });

  @override
  _AttributeTextFieldState createState() => _AttributeTextFieldState();
}

class _AttributeTextFieldState extends State<AttributeTextField> {
  late final TextEditingController _keyController;
  late final TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController(text: widget.textKey ?? '');
    _valueController = TextEditingController(text: widget.textValue ?? '');

    _keyController.addListener(() {
      if (widget.isTemplate && widget.onKeyChanged != null) {
        widget.onKeyChanged!(_keyController.text);
      }
    });

    _valueController.addListener(() {
      if (widget.isEditable && widget.onValueChanged != null) {
        widget.onValueChanged!(_valueController.text);
      }
    });
  }

  @override
  void didUpdateWidget(AttributeTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.textKey != oldWidget.textKey &&
        widget.textKey != _keyController.text) {
      _keyController.text = widget.textKey ?? '';
    }
    if (widget.textValue != oldWidget.textValue &&
        widget.textValue != _valueController.text) {
      _valueController.text = widget.textValue ?? '';
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (widget.isTemplate) {
      child = _buildTemplateLayout();
    } else if (widget.isEditable) {
      child = _buildEditableLayout();
    } else {
      child = _buildReadOnlyLayout();
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: child,
      ),
    );
  }


  /// Tryb 1: szablon (klucz edytowalny)
  Widget _buildTemplateLayout() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _keyController,
            style: AppTextStyles.body,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Wprowadź nazwę atrybutu...',
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Text(
            'wartość tekstowa',
            textAlign: TextAlign.right,
            style: AppTextStyles.body,
          ),
        ),
      ],
    );
  }

  /// Tryb 2: edytowalna wartość
  Widget _buildEditableLayout() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.textKey ?? 'Brak klucza',
            style: AppTextStyles.body,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _valueController,
            style: AppTextStyles.body,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Wprowadź wartość...',
            ),
          ),
        ),
      ],
    );
  }

  /// Tryb 3: tylko podgląd
  Widget _buildReadOnlyLayout() {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.textKey ?? 'Brak klucza',
            style: AppTextStyles.body,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            widget.textValue ?? 'Brak wartości',
            textAlign: TextAlign.right,
            style: AppTextStyles.body,
          ),
        ),
      ],
    );
  }

  // Metody do uzyskania aktualnych wartości
  String getCurrentKey() => _keyController.text;
  String getCurrentValue() => _valueController.text;
}
