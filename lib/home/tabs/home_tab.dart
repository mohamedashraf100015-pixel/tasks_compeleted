import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/event/event_cubit.dart';
import '../../bloc/event/event_state.dart';
import '../../bloc/theme_cubit.dart';
import '../../model/event_model.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../utils/custom_svg_wrapper.dart';
import '../../widgets/event_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String selectedCategory = 'all';
  final List<String> categories = [
    'all',
    'sport',
    'birthday',
    'meeting',
    'exhibition',
    'book_club'
  ];

  Widget _buildChipLabel(String cat, bool isSelected, bool isDark, Color activeColor) {
    Widget icon;
    final iconColor = isSelected ? Colors.white : activeColor;
    
    switch (cat.toLowerCase()) {
      case 'all':
        icon = Icon(Icons.grid_view, color: iconColor, size: 20);
        break;
      case 'sport':
        icon = CustomSvgWrapper(imagePath: AppAssets.bikeIcon, color: iconColor, height: 20, width: 20);
        break;
      case 'birthday':
        icon = CustomSvgWrapper(imagePath: AppAssets.birthdayIcon, color: iconColor, height: 20, width: 20);
        break;
      case 'meeting':
        icon = Icon(Icons.business_center_outlined, color: iconColor, size: 20);
        break;
      case 'exhibition':
        icon = Icon(Icons.palette_outlined, color: iconColor, size: 20);
        break;
      case 'book_club':
        icon = CustomSvgWrapper(imagePath: AppAssets.bookIcon, color: iconColor, height: 20, width: 20);
        break;
      default:
        icon = Icon(Icons.event, color: iconColor, size: 20);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 6),
        Text(
          tr(cat),
          style: TextStyle(
            color: isSelected ? Colors.white : activeColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeCubit = context.watch<ThemeCubit>();
    final isDark = themeCubit.isDark;
    final activeColor = isDark ? AppColors.mainDarkColor : AppColors.mainLightColor;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgColor : AppColors.lightBgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr('welcome_back'),
                        style: TextStyle(
                          color: isDark ? AppColors.whiteDarkColor : AppColors.greyColor,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isDark ? Icons.light_mode : Icons.dark_mode,
                              color: activeColor,
                            ),
                            onPressed: () {
                              themeCubit.changeTheme(
                                isDark ? ThemeMode.light : ThemeMode.dark,
                              );
                            },
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              if (context.locale == const Locale('en')) {
                                context.setLocale(const Locale('ar'));
                              } else {
                                context.setLocale(const Locale('en'));
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: activeColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                context.locale.languageCode.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    user?.displayName ?? "John Safwat",
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: _buildChipLabel(cat, isSelected, isDark, activeColor),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = cat;
                          });
                        },
                        selectedColor: activeColor,
                        backgroundColor: isDark ? AppColors.darkInputColor : AppColors.whiteColor,
                        showCheckmark: false,
                        labelPadding: EdgeInsets.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: activeColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<EventCubit, EventState>(
                builder: (context, state) {
                  if (state is EventLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is EventLoaded) {
                    final filteredEvents = selectedCategory == 'all'
                        ? state.events
                        : state.events
                            .where((e) => e.category.toLowerCase() == selectedCategory.toLowerCase())
                            .toList();

                    if (filteredEvents.isEmpty) {
                      return Center(
                        child: Text(
                          "No events found",
                          style: TextStyle(
                            color: activeColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        return EventCard(
                          event: filteredEvents[index],
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.eventDetailsRouteName,
                              arguments: filteredEvents[index],
                            );
                          },
                        );
                      },
                    );
                  } else if (state is EventError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
