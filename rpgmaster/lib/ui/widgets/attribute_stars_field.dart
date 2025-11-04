import 'package:flutter/material.dart';
import 'counter_widget.dart';

class AttributeStarsField extends StatefulWidget {
  final bool isTemplate;
  final bool isEditable;
  final String? text;
  final int totalStars;
  final int filledStars;
  final bool initialChecked;
  final ValueChanged<bool>? onCheckedChanged;
  final ValueChanged<String>? onTextChanged;
  final ValueChanged<int>? onStarsChanged;

  const AttributeStarsField({
    super.key,
    this.isTemplate = false,
    this.isEditable = false,
    this.text,
    this.totalStars = 5,
    this.filledStars = 0,
    this.initialChecked = false,
    this.onCheckedChanged,
    this.onTextChanged,
    this.onStarsChanged,
  });

  @override
  State<AttributeStarsField> createState() => _AttributeStarsFieldState();
}

class _AttributeStarsFieldState extends State<AttributeStarsField> {
  late bool _checked;
  late int _filledStars;
  late int _totalStars;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _checked = widget.initialChecked;
    _filledStars = widget.filledStars;
    _totalStars = widget.totalStars;
    _textController = TextEditingController(text: widget.text ?? '');
    _textController.addListener(() {
      if (widget.isTemplate && widget.onTextChanged != null) {
        widget.onTextChanged!(_textController.text);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _toggleCheck(bool? value) {
    setState(() => _checked = value ?? false);
    widget.onCheckedChanged?.call(_checked);
  }

  void _increaseStars() {
    if (_filledStars < widget.totalStars) {
      setState(() => _filledStars++);
      widget.onStarsChanged?.call(_filledStars);
    }
  }

  void _decreaseStars() {
    if (_filledStars > 0) {
      setState(() => _filledStars--);
      widget.onStarsChanged?.call(_filledStars);
    }
  }

  List<Widget> _buildStars() {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color emptyStarColor = Theme.of(context).colorScheme.inversePrimary;
    return List.generate(_totalStars, (index) {
      bool filled = index < _filledStars;
      return Icon(
        Icons.star,
        color: filled ? primaryColor : emptyStarColor,
        size: 24,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isTemplate) return _buildTemplateLayout();
    if (widget.isEditable) return _buildEditableLayout();
    return _buildReadOnlyLayout();
  }

  /// Tryb 1 — isTemplate: checkbox + text field + counter (liczba gwiazdek)
  Widget _buildTemplateLayout() {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _checked,
              onChanged: _toggleCheck,
              activeColor: primaryColor,
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nazwa atrybutu...',
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CounterWidget(
              initialValue: _totalStars,
              onChanged: (value) {
                setState(() => _totalStars = value);
                widget.onStarsChanged?.call(value);
              },
            ),
            Row(children: _buildStars()),
          ],
        ),
      ],
    );
  }

  /// Tryb 2 — isEditable: checkbox + tekst + przyciski +/- + WYŚRODKOWANE gwiazdki
  Widget _buildEditableLayout() {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: _checked,
                  onChanged: _toggleCheck,
                  activeColor: primaryColor,
                ),
                Text(
                  widget.text ?? 'Brak nazwy',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _decreaseStars,
                  icon: const Icon(Icons.remove_circle_outline),
                  color: primaryColor,
                ),
                IconButton(
                  onPressed: _increaseStars,
                  icon: const Icon(Icons.add_circle_outline),
                  color: primaryColor,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildStars(),
          ),
        ),
      ],
    );
  }

  /// Tryb 3 — tylko do wyświetlania
  Widget _buildReadOnlyLayout() {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        Checkbox(
          value: _checked,
          onChanged: _toggleCheck,
          activeColor: primaryColor,
        ),
        Expanded(
          child: Text(
            widget.text ?? 'Brak nazwy',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Row(children: _buildStars()),
      ],
    );
  }

  // Metody dostępu
  bool getCheckedState() => _checked;
  String getCurrentText() => _textController.text;
  int getCurrentFilledStars() => _filledStars;
  int getCurrentTotalStars() => _totalStars;
}
