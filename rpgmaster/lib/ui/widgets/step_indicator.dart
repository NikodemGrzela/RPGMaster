import 'package:flutter/material.dart';

/// Widget wskaźnika kroków z kółkami
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tekst "Krok X z Y"
        Text(
          'Krok $currentStep z $totalSteps',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),

        // Kółka kroków
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            totalSteps,
                (index) {
              final step = index + 1;
              final isActive = step == currentStep;
              final isCompleted = step < currentStep;

              return Padding(
                padding: EdgeInsets.only(
                  left: index > 0 ? 12 : 0,
                ),
                child: _buildStepCircle(
                  context,
                  step,
                  isActive,
                  isCompleted,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Pojedyncze kółko kroku
  Widget _buildStepCircle(
      BuildContext context,
      int step,
      bool isActive,
      bool isCompleted,
      ) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color textColor;

    if (isActive) {
      // Aktywny krok - primary color
      backgroundColor = colorScheme.primary;
      textColor = colorScheme.onPrimary;
    } else if (isCompleted) {
      // Ukończony krok - secondary/success color
      backgroundColor = colorScheme.primaryContainer;
      textColor = colorScheme.onPrimaryContainer;
    } else {
      // Nieaktywny krok - neutral
      backgroundColor = colorScheme.surfaceContainerHighest;
      textColor = colorScheme.onSurfaceVariant;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isCompleted
            ? Icon(
          Icons.check,
          color: textColor,
          size: 20,
        )
            : Text(
          step.toString(),
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}