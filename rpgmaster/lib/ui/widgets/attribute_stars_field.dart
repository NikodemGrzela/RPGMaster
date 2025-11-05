import 'package:flutter/material.dart';
import 'package:rpgmaster/ui/theme/app_text_styles.dart';
import 'counter_widget.dart';

class AttributeStarsField extends StatefulWidget {
  final bool isTemplate;
  final bool isEditable;
  final bool hasCheckbox;
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
    this.hasCheckbox = false,
    this.text,
    this.totalStars = 5,
    this.filledStars = 0,
    this.initialChecked = false,
    this.onCheckedChanged,
    this.onTextChanged,
    this.onStarsChanged,
  });

  AttributeStarsField copyWith({
    bool? isTemplate,
    bool? isEditable,
    bool? hasCheckbox,
    String? text,
    int? totalStars,
    int? filledStars,
    ValueChanged<bool>? onCheckedChanged,
    ValueChanged<String>? onTextChanged,
    ValueChanged<int>? onStarsChanged,
  }){
    return AttributeStarsField(
      key: key,
      isTemplate: isTemplate ?? this.isTemplate,
      isEditable: isEditable ?? this.isEditable,
      hasCheckbox: hasCheckbox ?? this.hasCheckbox,
      text: text ?? this.text,
      totalStars: totalStars ?? this.totalStars,
      filledStars: filledStars ?? this.filledStars,
      onCheckedChanged: onCheckedChanged ?? this.onCheckedChanged,
      onTextChanged: onTextChanged ?? this.onTextChanged,
      onStarsChanged: onStarsChanged ?? this.onStarsChanged,
    );
  }

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

  List<Widget> _buildStars({bool filled = true}) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color emptyStarColor = Theme.of(context).colorScheme.inversePrimary;
    return List.generate(_totalStars, (index) {
      bool isFilled = filled ? index < _filledStars : false;
      return Icon(
        Icons.star,
        color: isFilled ? primaryColor : emptyStarColor,
        size: 24,
      );
    });
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

    double verticalPadding = 12.0;
    if (widget.hasCheckbox) {
      verticalPadding = 0.0;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 8.0),
        child: child,
      ),
    );
  }

  /// Tryb 1 — isTemplate: checkbox + text field + counter (liczba gwiazdek)
  Widget _buildTemplateLayout() {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.hasCheckbox)
          Row(
            children: [
              Checkbox(
                value: _checked,
                onChanged: _toggleCheck,
                activeColor: primaryColor,
              ),
            ],
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                style: AppTextStyles.body,
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
            Row(children: _buildStars(filled: false)),
          ],
        ),
      ],
    );
  }

  /// Tryb 2 — isEditable: checkbox + tekst + przyciski +/-
  Widget _buildEditableLayout() {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.hasCheckbox)
              Checkbox(
                value: _checked,
                onChanged: _toggleCheck,
                activeColor: primaryColor,
              ),
            Text(
              widget.text ?? 'Brak nazwy',
              style: AppTextStyles.body,
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
        if (widget.hasCheckbox)
          Checkbox(
            value: _checked,
            onChanged: _toggleCheck,
            activeColor: primaryColor,
          ),
        Expanded(
          child: Text(
            widget.text ?? 'Brak nazwy',
            style: AppTextStyles.body,
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
