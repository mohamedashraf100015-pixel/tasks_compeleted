import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/theme_cubit.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeCubit = context.watch<ThemeCubit>();
    final isDark = themeCubit.isDark;
    
    final borderColor = !isDark ? AppColors.mainLightColor.withValues(alpha: 0.2) : AppColors.strokeDarkColor;
    final cardBgColor = isDark ? AppColors.darkInputColor : AppColors.whiteColor;
    final textStyle = TextStyle(
      color: isDark ? Colors.white : AppColors.blackColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgColor : AppColors.lightBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Center Profile Avatar Logo
              CircleAvatar(
                radius: 50,
                child: Image.asset(
                  AppAssets.logoRouteProfile,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 16),
              // User Name
              Text(
                user?.displayName ?? "John Safwat",
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.blackColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              // User Email
              Text(
                user?.email ?? "johnsafwat.route@gmail.com",
                style: TextStyle(
                  color: isDark ? AppColors.whiteDarkColor : AppColors.greyColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Dark Mode Tile
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(tr('dark_mode'), style: textStyle),
                  trailing: Switch(
                    value: isDark,
                    activeThumbColor: AppColors.whiteColor,
                    activeTrackColor: AppColors.mainDarkColor,
                    onChanged: (value) {
                      themeCubit.changeTheme(value ? ThemeMode.dark : ThemeMode.light);
                    },
                  ),
                ),
              ),
              
              // Language Tile
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(tr('language'), style: textStyle),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: isDark ? AppColors.mainDarkColor : AppColors.mainLightColor,
                  ),
                  onTap: () {
                    _showLanguageBottomSheet(context);
                  },
                ),
              ),
              
              // Logout Tile
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(tr('logout'), style: textStyle),
                  trailing: const Icon(
                    Icons.logout,
                    color: AppColors.redColor,
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.loginRouteName, (route) => false);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final isDark = context.read<ThemeCubit>().isDark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkInputColor : AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        final textStyle = TextStyle(
          color: isDark ? Colors.white : AppColors.blackColor,
          fontSize: 16,
        );
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(tr('english'), style: textStyle),
                trailing: context.locale == const Locale('en') 
                    ? Icon(Icons.check, color: isDark ? AppColors.mainDarkColor : AppColors.mainLightColor)
                    : null,
                onTap: () {
                  context.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(tr('arabic'), style: textStyle),
                trailing: context.locale == const Locale('ar') 
                    ? Icon(Icons.check, color: isDark ? AppColors.mainDarkColor : AppColors.mainLightColor)
                    : null,
                onTap: () {
                  context.setLocale(const Locale('ar'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
