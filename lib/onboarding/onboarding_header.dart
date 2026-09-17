import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme_cubit.dart';
import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/size_utils.dart';

class OnboardingHeader extends StatelessWidget {
  final bool showBack;
  final bool showSkip;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  const OnboardingHeader({
    super.key,
    this.showBack = false,
    this.showSkip = false,
    this.onBack,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        showBack
            ? IconButton(
                onPressed: onBack,
                icon: Container(
                  padding: EdgeInsets.all(context.width * 0.02),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark
                          ? AppColors.strokeDarkColor
                          : AppColors.strokeWhiteColor,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: context.width * 0.045,
                    color: isDark ? AppColors.whiteColor : AppColors.blackColor,
                  ),
                ),
              )
            : SizedBox(width: context.width * 0.12),
        Image.asset(
          isDark ? AppAssets.logoEventlyDarkImage : AppAssets.logoEventlyLightImage,
          height: context.height * 0.1,
          width: context.width*0.4,
        ),
        showSkip
            ? TextButton(
                onPressed: onSkip,
                child: Text(
                  'skip'.tr(),
                  style: isDark
                      ? AppStyles.medium16White
                      : AppStyles.medium16MainColor,
                ),
              )
            : SizedBox(width: context.width * 0.12),
      ],
    );
  }
}
