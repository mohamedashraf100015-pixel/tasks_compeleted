import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/event/event_cubit.dart';
import '../bloc/theme_cubit.dart';
import '../model/event_model.dart';
import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/custom_svg_wrapper.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  String _getEventImage(bool isDark) {
    switch (event.category.toLowerCase()) {
      case 'sport':
        return isDark ? AppAssets.sportDarkImage : AppAssets.sportLightImage;
      case 'birthday':
        return isDark ? AppAssets.birthdayDarkImage : AppAssets.birthdayLightImage;
      case 'meeting':
        return isDark ? AppAssets.meetingDarkImage : AppAssets.meetingLightImage;
      case 'exhibition':
        return isDark ? AppAssets.exhibitionDarkImage : AppAssets.exhibitionLightImage;
      case 'book_club':
        return isDark ? AppAssets.bookClubDarkImage : AppAssets.bookClubLightImage;
      default:
        return isDark ? AppAssets.sportDarkImage : AppAssets.sportLightImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().isDark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(_getEventImage(isDark)),
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: isDark ? AppColors.mainDarkColor : AppColors.mainLightColor,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('dd').format(event.date),
                      style: TextStyle(
                        color: AppColors.mainLightColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      DateFormat('MMM').format(event.date),
                      style: TextStyle(
                        color: AppColors.mainLightColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        event.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: event.isFavorite 
                            ? (isDark ? AppColors.mainDarkColor : AppColors.mainLightColor) 
                            : (isDark ? AppColors.mainDarkColor : AppColors.mainLightColor),
                      ),
                      onPressed: () {
                        context.read<EventCubit>().toggleFavorite(event);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
