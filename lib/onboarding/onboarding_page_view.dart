import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../bloc/theme_cubit.dart';
import '../model/onboarding_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/size_utils.dart';
import 'onboarding_header.dart';


class OnboardingPageView extends StatelessWidget {
  final OnboardingModel model;
  final int slideIndex;
  final int totalSlides;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const OnboardingPageView({
    super.key,
    required this.model,
    required this.slideIndex,
    required this.totalSlides,
    required this.onNext,
    required this.onBack,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final isLastSlide = slideIndex == totalSlides - 1;
    final activeColor = isDark ? AppColors.mainDarkColor : AppColors.mainLightColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      child: Column(
        children: [
          OnboardingHeader(
            showBack: true,
            showSkip: !isLastSlide,
            onBack: onBack,
            onSkip: onSkip,
          ),
          const Spacer(),
          Image.asset(
            isDark ? model.darkImage : model.lightImage,
            height: context.height * 0.30,
          ),
          const Spacer(),
          // Smooth Page Indicator
          AnimatedSmoothIndicator(
            activeIndex: slideIndex,
            count: totalSlides,
            effect: ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3.5,
              spacing: 6,
              activeDotColor: activeColor,
              dotColor: isDark
                  ? AppColors.whiteColor.withValues(alpha: 0.3)
                  : AppColors.mainLightColor.withValues(alpha: 0.3),
            ),
          ),
          SizedBox(height: context.height * 0.025),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              model.titleKey.tr(),
              style: isDark ? AppStyles.semi24White : AppStyles.semi24MainLightColor,
            ),
          ),
          SizedBox(height: context.height * 0.015),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              model.bodyKey.tr(),
              style: isDark ? AppStyles.regular16WhiteDarkColor : AppStyles.regular16Gray,
            ),
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
              onPressed: onNext,
              child: Text(
                isLastSlide ? 'get_started'.tr() : 'next'.tr(),
                style: AppStyles.medium18White,
              ),
            ),
          ),
          SizedBox(height: context.height * 0.03),
        ],
      ),
    );
  }
}