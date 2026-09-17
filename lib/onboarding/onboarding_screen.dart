import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/onboarding_cubit.dart';
import '../model/onboarding_model.dart';
import '../utils/app_routes.dart';
import 'onboarding_body.dart';
import 'onboarding_page_view.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  void _finishOnboarding(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.loginRouteName);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();

    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: cubit.pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: cubit.onPageChanged,
          children: [
            OnboardingBody(onStartPressed: cubit.nextPage),
            OnboardingPageView(
              model: OnboardingModel.list[0],
              slideIndex: 0,
              totalSlides: 3,
              onNext: cubit.nextPage,
              onBack: cubit.previousPage,
              onSkip: () => _finishOnboarding(context),
            ),
            OnboardingPageView(
              model: OnboardingModel.list[1],
              slideIndex: 1,
              totalSlides: 3,
              onNext: cubit.nextPage,
              onBack: cubit.previousPage,
              onSkip: () => _finishOnboarding(context),
            ),
            OnboardingPageView(
              model: OnboardingModel.list[2],
              slideIndex: 2,
              totalSlides: 3,
              onNext: () => _finishOnboarding(context),
              onBack: cubit.previousPage,
              onSkip: () => _finishOnboarding(context),
            ),
          ],
        ),
      ),
    );
  }
}