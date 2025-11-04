import 'package:flutter/material.dart';


/// Widget with scheme key : value with text fields.
/// Make [isTemplate] == true if you want to make key settable.
/// Default: [text] is a key, value is a text field.
/// Usage: As a character text attribute of given kind.
class AttributeTextField extends StatefulWidget {
  final bool isTemplate;
  final String? text;
  final ValueChanged<String>? onChanged;

  const AttributeTextField({
    super.key,
    required this.isTemplate,
    this.text,
    this.onChanged,
  });

  @override
  _AttributeTextFieldState createState() => _AttributeTextFieldState();
}

class _AttributeTextFieldState extends State<AttributeTextField> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.text ?? '');
    _textController.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(AttributeTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && widget.text != _textController.text) {
      _textController.text = widget.text ?? '';
    }
  }

  void _onTextChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(_textController.text);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: widget.isTemplate ? _buildTemplateLayout() : _buildNormalLayout(),
    );
  }

  Widget _buildTemplateLayout() {
    return Row(
      children: [
        // Edytowalne pole - wyrównane do lewej
        Expanded(
          child: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Wprowadź tekst...',
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        // Tekst "wartość tekstowa" - wyrównany do prawej
        const Expanded(
          child: Text(
            'wartość tekstowa',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 16.0),
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
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        const SizedBox(width: 16.0),
        // Edytowalne pole - wyrównane do prawej
        Expanded(
          child: TextField(
            controller: _textController,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Wprowadź tekst...',
            ),
          ),
        ),
      ],
    );
  }

  // Metoda do uzyskania wartości z zewnątrz
  String getCurrentValue() {
    return _textController.text;
  }
}