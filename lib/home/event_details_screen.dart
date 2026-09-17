import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/event/event_cubit.dart';
import '../bloc/theme_cubit.dart';
import '../model/event_model.dart';
import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../utils/custom_svg_wrapper.dart';
import '../utils/size_utils.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  String _getEventImage(EventModel event, bool isDark) {
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
    final event = ModalRoute.of(context)!.settings.arguments as EventModel;
    final isDark = context.watch<ThemeCubit>().isDark;
    final activeColor = isDark ? AppColors.mainDarkColor : AppColors.mainLightColor;
    final textColor = isDark ? Colors.white : AppColors.blackColor;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgColor : AppColors.lightBgColor,
      appBar: AppBar(
        title: Text(
          tr('event_details'),
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: activeColor, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.arrow_back_ios_new, color: activeColor, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: CustomSvgWrapper(imagePath: AppAssets.editIcon, color: activeColor, height: 22, width: 22),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.editEventRouteName,
                arguments: event,
              );
            },
          ),
          IconButton(
            icon: CustomSvgWrapper(imagePath: AppAssets.trashIcon, color: AppColors.redColor, height: 22, width: 22),
            onPressed: () {
              context.read<EventCubit>().deleteEvent(event.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.width * 0.04,
            vertical: context.height * 0.015,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: context.height * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(_getEventImage(event, isDark)),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: activeColor, width: 1.5),
                ),
              ),
              SizedBox(height: context.height * 0.02),
              Text(
                event.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: activeColor,
                ),
              ),
              SizedBox(height: context.height * 0.02),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkInputColor : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: activeColor.withValues(alpha: 0.3), width: 1.5),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomSvgWrapper(imagePath: AppAssets.calendarIcon, color: activeColor, height: 24, width: 24),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('dd MMMM yyyy').format(event.date),
                          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CustomSvgWrapper(imagePath: AppAssets.clockIcon, color: activeColor, height: 24, width: 24),
                        const SizedBox(width: 12),
                        Text(
                          event.time,
                          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.height * 0.025),
              Text(
                tr('description'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              ),
              SizedBox(height: context.height * 0.008),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkInputColor : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: activeColor.withValues(alpha: 0.1), width: 1.5),
                ),
                child: Text(
                  event.description.isNotEmpty ? event.description : tr('event_description'),
                  style: TextStyle(fontSize: 15, color: isDark ? AppColors.whiteDarkColor : AppColors.greyColor, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
