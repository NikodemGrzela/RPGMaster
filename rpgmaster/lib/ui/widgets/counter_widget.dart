import 'package:flutter/material.dart';
import 'package:rpgmaster/ui/theme/app_text_styles.dart';

/// Counter with two buttons (plus and minus) and changeable value.
class CounterWidget extends StatefulWidget {
  final int initialValue;
  final int? minValue;
  final int? maxValue;
  final ValueChanged<int>? onChanged;

  /// Konstruktor - przyjmuje wartość początkową oraz opcjonalne min/max
  const CounterWidget({
    super.key,
    this.initialValue = 0,
    this.minValue,
    this.maxValue,
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
      int newValue = _currentValue + 1;
      // Sprawdź czy nie przekracza maxValue
      if (widget.maxValue != null && newValue > widget.maxValue!) {
        return;
      }
      _updateValue(newValue);
    });
  }

  void _decrement() {
    setState(() {
      int newValue = _currentValue - 1;
      // Sprawdź czy nie spada poniżej minValue (domyślnie 0)
      int minLimit = widget.minValue ?? 0;
      if (newValue < minLimit) {
        return;
      }
      _updateValue(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;

    // Sprawdź czy przyciski powinny być aktywne
    bool canDecrement = widget.minValue == null
        ? _currentValue > 0
        : _currentValue > widget.minValue!;
    bool canIncrement = widget.maxValue == null
        ? true
        : _currentValue < widget.maxValue!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: canDecrement ? _decrement : null,
          padding: EdgeInsets.zero,
          color: canDecrement ? primaryColor : primaryColor.withOpacity(0.3),
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
          onPressed: canIncrement ? _increment : null,
          padding: EdgeInsets.zero,
          color: canIncrement ? primaryColor : primaryColor.withOpacity(0.3),
        ),
      ],
    );
  }
}