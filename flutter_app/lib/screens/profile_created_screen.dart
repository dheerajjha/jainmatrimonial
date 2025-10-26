import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';

class ProfileCreatedScreen extends StatelessWidget {
  const ProfileCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final profileCode = profile['profileCode'];
    final shareableLink = profile['shareableLink'];
    final childName = profile['childName'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Created'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: AppTheme.gradientDecoration,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 80,
                    color: AppTheme.success,
                  ),
                ),
                const SizedBox(height: 32),

                // Success Message
                Text(
                  'Your child\'s basic profile is ready!',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                Text(
                  'Share this code or link so ${childName ?? 'they'} can complete the rest',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Profile Code Card
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
                          'Profile Code',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              profileCode,
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                                letterSpacing: 4,
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: profileCode));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Code copied!')),
                                );
                              },
                              icon: const Icon(Icons.copy),
                              color: AppTheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Share Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Share.share(
                        'Complete your matrimony profile using this code: $profileCode\n'
                        'Or click this link: $shareableLink',
                        subject: 'Jain Matrimony Profile Completion',
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share Code & Link'),
                  ),
                ),
                const SizedBox(height: 16),

                // Done Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/welcome',
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.primary),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Done'),
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
