import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/event/event_cubit.dart';
import '../../bloc/event/event_state.dart';
import '../../bloc/theme_cubit.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../widgets/event_card.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key});

  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().isDark;
    final activeColor = isDark ? AppColors.mainDarkColor : AppColors.mainLightColor;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgColor : AppColors.lightBgColor,
      appBar: AppBar(
        title: Text(
          tr('favorite'),
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : AppColors.blackColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              style: TextStyle(color: isDark ? Colors.white : AppColors.blackColor),
              decoration: InputDecoration(
                hintText: tr('Search for event'),
                hintStyle: const TextStyle(color: AppColors.greyColor),
                prefixIcon: Icon(Icons.search, color: activeColor),
                filled: true,
                fillColor: isDark ? AppColors.darkInputColor : AppColors.whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: activeColor, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: activeColor.withValues(alpha: 0.5), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: activeColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<EventCubit, EventState>(
                builder: (context, state) {
                  if (state is EventLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is EventLoaded) {
                    final favoriteEvents = state.events
                        .where((e) => e.isFavorite && e.title.toLowerCase().contains(_searchQuery))
                        .toList();

                    if (favoriteEvents.isEmpty) {
                      return Center(
                        child: Text(
                          "No favorites found",
                          style: TextStyle(
                            color: activeColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: favoriteEvents.length,
                      itemBuilder: (context, index) {
                        return EventCard(
                          event: favoriteEvents[index],
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.eventDetailsRouteName,
                              arguments: favoriteEvents[index],
                            );
                          },
                        );
                      },
                    );
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
