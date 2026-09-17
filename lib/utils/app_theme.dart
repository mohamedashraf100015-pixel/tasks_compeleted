import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.lightBgColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.whiteColor,
      selectedItemColor: AppColors.mainLightColor,
      unselectedItemColor: AppColors.lightGreyColor,
      selectedLabelStyle: AppStyles.regular12MainLightColor,
      unselectedLabelStyle: AppStyles.regular12GreyColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.mainLightColor,
      shape: StadiumBorder(), //to make it rounded
    ),
    cardColor: AppColors.mainLightColor,
    dividerColor: AppColors.strokeWhiteColor,
    highlightColor: AppColors.whiteColor,
    textTheme: TextTheme(
      headlineLarge: AppStyles.semi20Black,
      headlineMedium: AppStyles.medium16Black,
      bodyLarge: AppStyles.regular16Gray,
      headlineSmall: AppStyles.semi24MainLightColor,
      labelMedium: AppStyles.medium16MainColor,
      labelSmall: AppStyles.medium18MainColor,
      labelLarge: AppStyles.semi14MainLightColor,
      bodyMedium: AppStyles.semi16MainLightColor,
      bodySmall: AppStyles.medium14Black,
      titleLarge: AppStyles.regular14MainLightColor,
      titleMedium: AppStyles.medium20Black,
      titleSmall: AppStyles.medium18Black,
      displaySmall: AppStyles.medium18MainColor,
      displayLarge: AppStyles.medium16Black,
    ),
  );
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.darkBgColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.mainDarkColor,
      shape: StadiumBorder(),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkBgColor,
      selectedItemColor: AppColors.mainDarkColor,
      unselectedItemColor: AppColors.lightGreyColor,
      selectedLabelStyle: AppStyles.regular12MainDarkColor,
      unselectedLabelStyle: AppStyles.regular12GreyColor,
    ),
    cardColor: AppColors.mainDarkColor,
    dividerColor: AppColors.mainLightColor,
    highlightColor: AppColors.darkInputColor,

    textTheme: TextTheme(
      headlineLarge: AppStyles.semi20White,
      headlineMedium: AppStyles.medium16White,
      bodyLarge: AppStyles.regular16WhiteDarkColor,
      headlineSmall: AppStyles.semi24White,
      labelMedium: AppStyles.medium16MainDarkColor,
      labelSmall: AppStyles.medium18MainDarkColor,
      labelLarge: AppStyles.semi14MainDarkColor,
      bodyMedium: AppStyles.semi16MainDark,
      bodySmall: AppStyles.medium14White,
      titleLarge: AppStyles.regular14MainDarkColor,
      titleMedium: AppStyles.medium20WhiteDarkColor,
      titleSmall: AppStyles.medium18White,
      displaySmall: AppStyles.medium18White,
      displayLarge: AppStyles.medium16MainDarkColor,
    ),
  );
}
