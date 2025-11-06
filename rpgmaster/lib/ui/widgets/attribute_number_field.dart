import 'package:flutter/material.dart';
import './counter_widget.dart';
import '../theme/app_text_styles.dart';


/// Widget with scheme key : value with text fields.
/// Make [isTemplate] == true if you want to make key settable.
/// Default: [text] is a key, value is a counter field.
/// Usage: As a character number attribute of given kind.
class AttributeNumberField extends StatefulWidget {
  final bool isTemplate;
  final bool isEditable;
  final bool hasCheckbox;
  final String? text;
  final int? number;
  final bool initialChecked;
  final ValueChanged<String>? onKeyChanged;
  final ValueChanged<int>? onValueChanged;
  final ValueChanged<bool>? onCheckedChanged;

  const AttributeNumberField({
    super.key,
    this.isTemplate = false,
    this.isEditable = false,
    this.hasCheckbox = false,
    this.text,
    this.number,
    this.initialChecked = false,
    this.onKeyChanged,
    this.onValueChanged,
    this.onCheckedChanged,
  });

  AttributeNumberField copyWith({
    bool? isTemplate,
    bool? isEditable,
    bool? hasCheckbox,
    String? text,
    int? number,
    bool? initialChecked,
    ValueChanged<String>? onKeyChanged,
    ValueChanged<int>? onValueChanged,
    ValueChanged<bool>? onCheckedChanged,
  }){
    return AttributeNumberField(
      key: key,
      isTemplate: isTemplate ?? this.isTemplate,
      isEditable: isEditable ?? this.isEditable,
      hasCheckbox: hasCheckbox ?? this.hasCheckbox,
      text: text ?? this.text,
      number: number ?? this.number,
      initialChecked: initialChecked ?? this.initialChecked,
      onKeyChanged: onKeyChanged ?? this.onKeyChanged,
      onValueChanged: onValueChanged ?? this.onValueChanged,
      onCheckedChanged: onCheckedChanged ?? this.onCheckedChanged,
    );
  }

  @override
  _AttributeNumberFieldState createState() => _AttributeNumberFieldState();
}

class _AttributeNumberFieldState extends State<AttributeNumberField> {
  late final TextEditingController _keyController =
  TextEditingController(text: widget.text ?? '');
  late int _currentNumber;
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _currentNumber = widget.number ?? 15;
    _checked = widget.initialChecked;
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

  void _toggleCheck(bool? value) {
    setState(() => _checked = value ?? false);
    widget.onCheckedChanged?.call(_checked);
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double verticalPadding = 4.0;
    if (widget.hasCheckbox && (widget.isEditable || !widget.isTemplate)) {
      verticalPadding = 0.0;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 8.0),
        child: widget.isTemplate ? _buildTemplateLayout() : _buildNormalLayout(),
      ),
    );
  }

  Widget _buildTemplateLayout() {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        if (widget.hasCheckbox)
          Checkbox(
            value: _checked,
            onChanged: _toggleCheck,
            activeColor: primaryColor,
          ),
        Expanded(
          // Edytowalne pole - wyrównane do lewej
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
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        if (widget.hasCheckbox)
          Checkbox(
            value: _checked,
            onChanged: _toggleCheck,
            activeColor: primaryColor,
          ),
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

  // Metody do uzyskania wartości z zewnątrz
  String getCurrentKey() {
    return _keyController.text;
  }

  int getCurrentValue() {
    return _currentNumber;
  }

  bool getCheckedState() {
    return _checked;
  }
}