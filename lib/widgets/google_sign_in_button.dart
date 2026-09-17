import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/theme_cubit.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/size_utils.dart';

class GoogleSignInButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return SizedBox(
      width: double.infinity,
      height: context.height * 0.065,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor:
          isDark ? AppColors.darkInputColor : AppColors.whiteColor,
          side: BorderSide(
            color: isDark
                ? AppColors.strokeDarkColor
                : AppColors.strokeWhiteColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            color: AppColors.mainLightColor,
            strokeWidth: 2.5,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.googleLogo,
              height: context.height * 0.032,
            ),
            SizedBox(width: context.width * 0.03),
            Text(
              label,
              style: isDark
                  ? AppStyles.medium16White
                  : AppStyles.medium16Black,
            ),
          ],
        ),
      ),
    );
  }
}