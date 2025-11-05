import 'package:flutter/material.dart';
import './counter_widget.dart';
import '../theme/app_text_styles.dart';


/// Widget with scheme key : value with text fields.
/// Make [isTemplate] == true if you want to make key settable.
/// Default: [text] is a key, value is a counter field.
/// Usage: As a character number attribute of given kind.
class AttributeNumberField extends StatefulWidget {
  final bool isTemplate;
  final String? text;
  final int? number;
  final ValueChanged<String>? onKeyChanged;
  final ValueChanged<int>? onValueChanged;

  const AttributeNumberField({
    super.key,
    this.isTemplate = false,
    this.text,
    this.number,
    this.onKeyChanged,
    this.onValueChanged,
  });

  @override
  _AttributeNumberFieldState createState() => _AttributeNumberFieldState();
}

class _AttributeNumberFieldState extends State<AttributeNumberField> {
  late final TextEditingController _keyController =
  TextEditingController(text: widget.text ?? '');
  late int _currentNumber = 0;

  @override
  void initState() {
    super.initState();
    _currentNumber = widget.number ?? 15;

    _keyController.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(AttributeNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text && widget.text != _keyController.text) {
      _keyController.text = widget.text ?? '';
    }
    if (widget.number != oldWidget.number) {
      _currentNumber = widget.number ?? 0;
    }
  }

  void _onTextChanged() {
    if (widget.onKeyChanged != null) {
      widget.onKeyChanged!(_keyController.text);
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
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
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: widget.isTemplate ? _buildTemplateLayout() : _buildNormalLayout(),
      ),
    );
  }
  Widget _buildTemplateLayout() {
    return Row(
      children: [
        // Edytowalne pole - wyrównane do lewej
        Expanded(
          child: TextField(
            controller: _keyController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Wprowadź tekst...',
            ),
          ),
        ),
        // Tekst "wartość liczbowa" - wyrównany do prawej
        Expanded(
          child: Text(
            'wartość liczbowa',
            textAlign: TextAlign.right,
            style: AppTextStyles.body,
          ),
        ),
      ],
    );
  }

  Widget _buildNormalLayout() {
    return Row(
      children: [
        // Tekst z parametrów - wyrównany do lewej
        Expanded(
          child: Text(
            widget.text ?? 'Brak tekstu',
            textAlign: TextAlign.left,
            style: AppTextStyles.body,
          ),
        ),
        // Edytowalne pole - wyrównane do prawej
        Expanded(
          child: CounterWidget(
            initialValue: _currentNumber,
            onChanged: (value) {
            setState(() => _currentNumber = value);
            widget.onValueChanged?.call(value);
            },
          ),
        ),
      ],
    );
  }

  // Metoda do uzyskania wartości z zewnątrz
  String getCurrentKey() {
    return _keyController.text;
  }

  int getCurrentValue() {
    return _currentNumber;
  }
}