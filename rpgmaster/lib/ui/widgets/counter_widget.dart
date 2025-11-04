import 'package:flutter/material.dart';
import 'package:rpgmaster/ui/theme/app_text_styles.dart';

/// Counter with two buttons (plus and minus) and changeable value.
class CounterWidget extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int>? onChanged;

  /// Konstruktor - przyjmuje wartość początkową
  const CounterWidget({
    super.key,
    this.initialValue = 0,
    this.onChanged,
  });

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  void _updateValue(int newValue) {
    setState(() => _currentValue = newValue);
    widget.onChanged?.call(_currentValue);
  }

  /// Zwraca aktualną wartość licznika
  int getValue() => _currentValue;

  void _increment() {
    setState(() {
      _updateValue(_currentValue + 1);
    });
  }

  void _decrement() {
    setState(() {
      if (_currentValue > 0) {
        _updateValue(_currentValue - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: _decrement,
          padding: EdgeInsets.zero,
          color: primaryColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$_currentValue',
            style: AppTextStyles.body,
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          onPressed: _increment,
          padding: EdgeInsets.zero,
          color: primaryColor,
        ),
      ],
    );
  }
}
