import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ProfileCompleteSuccessScreen extends StatelessWidget {
  const ProfileCompleteSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientDecoration,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Animation
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.celebration,
                    size: 100,
                    color: AppTheme.success,
                  ),
                ),
                const SizedBox(height: 32),

                // Success Message
                Text(
                  'Profile Completed!',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                Text(
                  'Your profile is now active and ready to connect with potential matches',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Blessing Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'ॐ',
                          style: GoogleFonts.notoSans(
                            fontSize: 48,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'May you find the perfect life partner with blessings from above',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Browse Profiles Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    },
                    child: const Text('Browse Profiles'),
                  ),
                ),
                const SizedBox(height: 16),

                // Return to Welcome
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/welcome',
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Return to Home',
                    style: GoogleFonts.lato(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
