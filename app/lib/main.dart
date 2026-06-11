import 'package:flutter/material.dart';

import 'theme/app_colors.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/pet_register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/capture_guide_screen.dart';
import 'screens/analysis_loading_screen.dart';
import 'screens/result_screen.dart';
import 'screens/hospital_map_screen.dart';
import 'screens/history_screen.dart';
import 'screens/mypage_screen.dart';

void main() {
  runApp(const PetSkinApp());
}

class PetSkinApp extends StatelessWidget {
  const PetSkinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 앱 제목
      title: '멍냥케어',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardColor: AppColors.surface,
        dividerColor: AppColors.border,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: AppColors.textPrimary,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textPrimary,
          ),
          titleLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
          labelStyle: const TextStyle(
            color: AppColors.textSecondary,
          ),
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
          ),
          prefixIconColor: AppColors.primary,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
            side: const BorderSide(color: AppColors.border),
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      // 앱 실행 시 첫 화면
      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/pet-register': (context) => const PetRegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/capture-guide': (context) => const CaptureGuideScreen(),
        '/analysis-loading': (context) => const AnalysisLoadingScreen(),
        '/result': (context) => const ResultScreen(),
        '/hospital-map': (context) => const HospitalMapScreen(),
        '/history': (context) => const HistoryScreen(),
        '/mypage': (context) => const MyPageScreen(),
      },
    );
  }
}