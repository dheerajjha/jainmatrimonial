import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/parent_basic_details_screen.dart';
import 'screens/profile_created_screen.dart';
import 'screens/code_entry_screen.dart';
import 'screens/child_advanced_details_screen.dart';
import 'screens/profile_complete_success_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const JainMatrimonyApp());
}

class JainMatrimonyApp extends StatelessWidget {
  const JainMatrimonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jain Matrimony',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/role-selection': (context) => const RoleSelectionScreen(),
        '/parent-flow': (context) => const ParentBasicDetailsScreen(),
        '/profile-created': (context) => const ProfileCreatedScreen(),
        '/self-code-entry': (context) => const CodeEntryScreen(),
        '/child-advanced-details': (context) => const ChildAdvancedDetailsScreen(),
        '/profile-complete-success': (context) => const ProfileCompleteSuccessScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
