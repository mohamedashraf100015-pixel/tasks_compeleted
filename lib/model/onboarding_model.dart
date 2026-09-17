

import '../utils/app_assets.dart';

class OnboardingModel {
  final String titleKey;
  final String bodyKey;
  final String lightImage;
  final String darkImage;

  const OnboardingModel({
    required this.titleKey,
    required this.bodyKey,
    required this.lightImage,
    required this.darkImage,
  });

  static final List<OnboardingModel> list = [
    OnboardingModel(
      titleKey: "find_events_that_inspire_you",
      bodyKey: "dive_into_a_world_of_events",
      lightImage: AppAssets.onboardingLight2Image,
      darkImage: AppAssets.onboardingDark2Image,
    ),
    OnboardingModel(
      titleKey: "effortless_event_planning",
      bodyKey: "take_the_hassle",
      lightImage: AppAssets.onboardingLight3Image,
      darkImage: AppAssets.onboardingDark3Image,
    ),
    OnboardingModel(
      titleKey: "connect_with_friends_&_share_moments",
      bodyKey: "make_every_event",
      lightImage: AppAssets.onboardingLight4Image,
      darkImage: AppAssets.onboardingDark4Image,
    ),
  ];
}