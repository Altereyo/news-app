import 'package:flutter/material.dart';
import 'package:news_app/presentation/theme/app_colors.dart';

final themeData = ThemeData(
  useMaterial3: false,
  scaffoldBackgroundColor: AppColors.backgroundColor,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.darkColor,
    titleTextStyle: TextStyle(
      color: AppColors.textColor,
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
  ),
  textTheme: TextTheme(
      titleMedium: TextStyle(
        color: AppColors.textColor,
        fontSize: 20,
        fontWeight: FontWeight.w500
      ),
      labelMedium: TextStyle(
        color: AppColors.textColor,
        fontSize: 14,
        fontWeight: FontWeight.w300,
      ),
    labelSmall: TextStyle(
        color: AppColors.textColor,
        fontSize: 18,
        fontWeight: FontWeight.w400
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkColor,
    selectedItemColor: AppColors.accentColor,
    unselectedItemColor: AppColors.textColor,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: AppColors.accentColor,
  )
);