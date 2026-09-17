import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/event/event_cubit.dart';
import '../bloc/theme_cubit.dart';
import '../model/event_model.dart';
import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/custom_svg_wrapper.dart';
import '../utils/size_utils.dart';
import '../utils/toast_utils.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String selectedCategory;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late EventModel event;
  bool isInitialized = false;

  final List<String> categories = [
    'book_club',
    'sport',
    'birthday',
    'meeting',
    'exhibition'
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      event = ModalRoute.of(context)!.settings.arguments as EventModel;
      _titleController = TextEditingController(text: event.title);
      _descriptionController = TextEditingController(text: event.description);
      selectedCategory = event.category;
      selectedDate = event.date;
      selectedTime = TimeOfDay.now(); 
      isInitialized = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _getCategoryHeaderImage(bool isDark) {
    switch (selectedCategory) {
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

  Widget _buildChipLabel(String cat, bool isSelected, bool isDark, Color activeColor) {
    Widget icon;
    final iconColor = isSelected ? Colors.white : activeColor;
    
    switch (cat.toLowerCase()) {
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
    final isDark = context.watch<ThemeCubit>().isDark;
    final activeColor = isDark ? AppColors.mainDarkColor : AppColors.mainLightColor;
    final labelColor = isDark ? Colors.white : AppColors.blackColor;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgColor : AppColors.lightBgColor,
      appBar: AppBar(
        title: Text(
          tr('edit_event'),
          style: TextStyle(color: isDark ? Colors.white : AppColors.blackColor, fontWeight: FontWeight.bold),
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
                    image: AssetImage(_getCategoryHeaderImage(isDark)),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: activeColor, width: 1.5),
                ),
              ),
              SizedBox(height: context.height * 0.02),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: _buildChipLabel(cat, isSelected, isDark, activeColor),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              selectedCategory = cat;
                            });
                          }
                        },
                        selectedColor: activeColor,
                        backgroundColor: isDark ? AppColors.darkInputColor : AppColors.whiteColor,
                        showCheckmark: false,
                        labelPadding: EdgeInsets.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: StadiumBorder(
                          side: BorderSide(color: activeColor, width: 1.5),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: context.height * 0.02),
              Text(
                tr('title'),
                style: TextStyle(color: labelColor, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: context.height * 0.008),
              TextField(
                controller: _titleController,
                style: TextStyle(color: isDark ? Colors.white : AppColors.blackColor),
                decoration: InputDecoration(
                  hintText: tr('event_title'),
                  hintStyle: const TextStyle(color: AppColors.greyColor),
                  filled: true,
                  fillColor: isDark ? AppColors.darkInputColor : AppColors.whiteColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: activeColor.withValues(alpha: 0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: activeColor.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: activeColor, width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: context.height * 0.02),
              Text(
                tr('description'),
                style: TextStyle(color: labelColor, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: context.height * 0.008),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                style: TextStyle(color: isDark ? Colors.white : AppColors.blackColor),
                decoration: InputDecoration(
                  hintText: tr('event_description'),
                  hintStyle: const TextStyle(color: AppColors.greyColor),
                  filled: true,
                  fillColor: isDark ? AppColors.darkInputColor : AppColors.whiteColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: activeColor.withValues(alpha: 0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: activeColor.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: activeColor, width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: context.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomSvgWrapper(imagePath: AppAssets.calendarIcon, color: labelColor, height: 24, width: 24),
                      SizedBox(width: context.width * 0.02),
                      Text(
                        tr('event_date'),
                        style: TextStyle(color: labelColor, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        locale: const Locale('en'),
                      );
                      if (date != null) {
                        setState(() => selectedDate = date);
                      }
                    },
                    child: Text(
                      selectedDate == null
                          ? tr('choose_date')
                          : DateFormat('dd MMM yyyy').format(selectedDate!),
                      style: TextStyle(color: activeColor, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomSvgWrapper(imagePath: AppAssets.clockIcon, color: labelColor, height: 24, width: 24),
                      SizedBox(width: context.width * 0.02),
                      Text(
                        tr('event_time'),
                        style: TextStyle(color: labelColor, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() => selectedTime = time);
                      }
                    },
                    child: Text(
                      selectedTime == null
                          ? tr('choose_time')
                          : selectedTime!.format(context),
                      style: TextStyle(color: activeColor, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.height * 0.04),
              SizedBox(
                width: double.infinity,
                height: context.height * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_titleController.text.trim().isNotEmpty &&
                        selectedDate != null &&
                        selectedTime != null) {
                      final updatedEvent = event.copyWith(
                        title: _titleController.text.trim(),
                        description: _descriptionController.text.trim(),
                        date: selectedDate!,
                        time: selectedTime!.format(context),
                        category: selectedCategory,
                      );
                      context.read<EventCubit>().updateEvent(updatedEvent);
                      ToastUtils.showToastMessage(
                        message: "Event updated successfully",
                        backgroundColor: AppColors.greenColor,
                        textColor: Colors.white,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    tr('update_event'),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
