import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class DotsIndicator extends StatelessWidget {
  final int totalDots;
  final int activeIndex;

  const DotsIndicator({
    super.key,
    required this.totalDots,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? AppColors.mainDarkColor : AppColors.mainLightColor)
                : AppColors.lightGreyColor,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
