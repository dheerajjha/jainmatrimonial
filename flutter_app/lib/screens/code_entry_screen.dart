import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class CodeEntryScreen extends StatefulWidget {
  const CodeEntryScreen({super.key});

  @override
  State<CodeEntryScreen> createState() => _CodeEntryScreenState();
}

class _CodeEntryScreenState extends State<CodeEntryScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submitCode() async {
    final code = _codeController.text.trim().toUpperCase();

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-character code')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await ApiService.getProfileByCode(code);

    setState(() {
      _isLoading = false;
    });

    if (response['success']) {
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/child-advanced-details',
          arguments: {
            'profile': response['profile'],
            'code': code,
          },
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Invalid code')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Code'),
      ),
      body: Container(
        decoration: AppTheme.gradientDecoration,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter Your Profile Code',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Your parent should have shared a 6-character code with you',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Code Input
                TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Profile Code',
                    hintText: 'e.g., ABC123',
                    prefixIcon: Icon(Icons.qr_code),
                  ),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 6,
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitCode,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Continue'),
                  ),
                ),
                const SizedBox(height: 16),

                // Skip for now option
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'I don\'t have a code yet',
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
