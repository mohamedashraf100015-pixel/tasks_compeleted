import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/event/event_cubit.dart';
import 'home/add_event_screen.dart';
import 'home/edit_event_screen.dart';
import 'home/event_details_screen.dart';
import 'register/register_screen.dart';
import 'bloc/theme_cubit.dart';
import 'firebase_options.dart';
import 'forget/forget_password_screen.dart';
import 'home/home_screen.dart';
import 'login/login_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'utils/app_routes.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => EventCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            initialRoute: AppRoutes.onBoardingRouteName,
            routes: {
              AppRoutes.onBoardingRouteName: (_) => const OnboardingScreen(),
              AppRoutes.loginRouteName: (_) => const LoginScreen(),
              AppRoutes.registerRouteName: (_) => const RegisterScreen(),
              AppRoutes.forgetPasswordRouteName: (_) =>
                  const ForgetPasswordScreen(),
              AppRoutes.homeRouteName: (_) => const HomeScreen(),
              AppRoutes.addEventRouteName: (_) => const AddEventScreen(),
              AppRoutes.eventDetailsRouteName: (_) => const EventDetailsScreen(),
              AppRoutes.editEventRouteName: (_) => const EditEventScreen(),
            },
          );
        },
      ),
    );
  }
}
