import 'package:flutter/material.dart';

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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: _decrement,
          padding: EdgeInsets.zero,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$_currentValue',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _increment,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
