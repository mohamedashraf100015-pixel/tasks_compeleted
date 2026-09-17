import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme_cubit.dart';
import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/custom_svg_wrapper.dart';
import '../utils/size_utils.dart';
import 'onboarding_header.dart';

class OnboardingBody extends StatelessWidget {
  final VoidCallback onStartPressed;

  const OnboardingBody({
    super.key,
    required this.onStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    final currentThemeMode = context.watch<ThemeCubit>().state;
    final isDark = currentThemeMode == ThemeMode.dark;
    final currentLocale = context.locale.languageCode;
    final activeColor = isDark ? AppColors.mainDarkColor : AppColors.mainLightColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      child: Column(
        children: [
          const OnboardingHeader(),
          const Spacer(),
          Image.asset(
            isDark ? AppAssets.onboardingDark1Image : AppAssets.onboardingLight1Image,
            height: context.height * 0.32,
          ),
          const Spacer(),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'personalize_your_experience'.tr(),
              style: isDark ? AppStyles.semi24White : AppStyles.semi24MainLightColor,
            ),
          ),
          SizedBox(height: context.height * 0.01),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'choose_your_preferred'.tr(),
              style: isDark ? AppStyles.regular16WhiteDarkColor : AppStyles.regular16Gray,
            ),
          ),
          SizedBox(height: context.height * 0.025),

          // Language Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'language'.tr(),
                style: isDark ? AppStyles.medium18White : AppStyles.medium18MainColor,
              ),
              Row(
                children: [
                  _buildOptionBtn(
                    context: context,
                    label: 'english'.tr(),
                    isSelected: currentLocale == 'en',
                    onTap: () => context.setLocale(const Locale('en')),
                    isDark: isDark,
                  ),
                  SizedBox(width: context.width * 0.02),
                  _buildOptionBtn(
                    context: context,
                    label: 'arabic'.tr(),
                    isSelected: currentLocale == 'ar',
                    onTap: () => context.setLocale(const Locale('ar')),
                    isDark: isDark,
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: context.height * 0.015),

          // Theme Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'theme'.tr(),
                style: isDark ? AppStyles.medium18White : AppStyles.medium18MainColor,
              ),
              Row(
                children: [
                  _buildIconOptionBtn(
                    context: context,
                    iconPath: AppAssets.dayIcon,
                    isSelected: currentThemeMode == ThemeMode.light,
                    onTap: () => context.read<ThemeCubit>().changeTheme(ThemeMode.light),
                    isDark: isDark,
                  ),
                  SizedBox(width: context.width * 0.02),
                  _buildIconOptionBtn(
                    context: context,
                    iconPath: AppAssets.nightIcon,
                    isSelected: currentThemeMode == ThemeMode.dark,
                    onTap: () => context.read<ThemeCubit>().changeTheme(ThemeMode.dark),
                    isDark: isDark,
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: context.height * 0.06,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: activeColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: onStartPressed,
              child: Text('let’s_start'.tr(), style: AppStyles.medium18White),
            ),
          ),
          SizedBox(height: context.height * 0.03),
        ],
      ),
    );
  }

  Widget _buildOptionBtn({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final activeColor = isDark ? AppColors.mainDarkColor : AppColors.mainLightColor;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.width * 0.04,
            vertical: context.height * 0.01,
          ),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : AppColors.transparentColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: activeColor),
          ),
          child: Text(
            label,
            style: isSelected
                ? AppStyles.medium16White
                : (isDark ? AppStyles.medium16White : AppStyles.medium16MainColor),
          ),
        ),
      ),
    );
  }

  Widget _buildIconOptionBtn({
    required BuildContext context,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final activeColor = isDark ? AppColors.mainDarkColor : AppColors.mainLightColor;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(context.width * 0.02),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : AppColors.transparentColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: activeColor),
          ),
          child: CustomSvgWrapper(
            imagePath: iconPath,
            height: context.height * 0.025,
            width: context.height * 0.025,
            color: isSelected ? AppColors.whiteColor : activeColor,
          ),
        ),
      ),
    );
  }
}