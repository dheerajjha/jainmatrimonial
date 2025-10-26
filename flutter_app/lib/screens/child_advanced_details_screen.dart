import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class ChildAdvancedDetailsScreen extends StatefulWidget {
  const ChildAdvancedDetailsScreen({super.key});

  @override
  State<ChildAdvancedDetailsScreen> createState() => _ChildAdvancedDetailsScreenState();
}

class _ChildAdvancedDetailsScreenState extends State<ChildAdvancedDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lifeGoalsController = TextEditingController();
  final _travelPlacesController = TextEditingController();
  final _educationController = TextEditingController();
  final _professionController = TextEditingController();
  final _currentCityController = TextEditingController();
  final _familyDetailsController = TextEditingController();

  String? _religiousPractice = 'moderate'; // Prefilled
  String? _foodHabits = 'strict_jain'; // Prefilled
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Prefill form with test data
    _lifeGoalsController.text = 'Start my own sustainable fashion business and promote Jain values through ethical practices';
    _travelPlacesController.text = 'Delhi, Mumbai, Dubai, Singapore, Palitana';
    _educationController.text = 'MBA from IIM Ahmedabad';
    _professionController.text = 'Product Manager at Tech Startup';
    _currentCityController.text = 'Bangalore';
    _familyDetailsController.text = 'Joint family with strong Jain values. Father is a businessman and mother is a homemaker. One younger brother studying engineering.';
  }

  @override
  void dispose() {
    _lifeGoalsController.dispose();
    _travelPlacesController.dispose();
    _educationController.dispose();
    _professionController.dispose();
    _currentCityController.dispose();
    _familyDetailsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final code = args['code'];

      // Parse travelled places (comma-separated)
      final travelledPlaces = _travelPlacesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final data = {
        'lifeGoals': _lifeGoalsController.text,
        'travelledPlaces': travelledPlaces,
        'education': _educationController.text,
        'profession': _professionController.text,
        'currentCity': _currentCityController.text,
        'religiousPractice': _religiousPractice,
        'foodHabits': _foodHabits,
        'familyDetails': _familyDetailsController.text,
      };

      final response = await ApiService.completeProfile(code, data);

      setState(() {
        _isLoading = false;
      });

      if (response['success']) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/profile-complete-success',
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Failed to complete profile')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
      ),
      body: Container(
        decoration: AppTheme.gradientDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tell us about yourself',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Step 2 of 3 • Be yourself, share your story',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Life Goals
                  TextFormField(
                    controller: _lifeGoalsController,
                    decoration: const InputDecoration(
                      labelText: 'What are your life goals / ambitions?',
                      hintText: 'Share your dreams and aspirations...',
                      prefixIcon: Icon(Icons.star),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please share your life goals';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Travelled Places
                  TextFormField(
                    controller: _travelPlacesController,
                    decoration: const InputDecoration(
                      labelText: 'Places you\'ve travelled to',
                      hintText: 'e.g., Mumbai, Paris, Dubai (comma-separated)',
                      prefixIcon: Icon(Icons.flight_takeoff),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please share places you\'ve visited';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Education
                  TextFormField(
                    controller: _educationController,
                    decoration: const InputDecoration(
                      labelText: 'Your Education',
                      hintText: 'e.g., MBA from IIM',
                      prefixIcon: Icon(Icons.school),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your education';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Profession
                  TextFormField(
                    controller: _professionController,
                    decoration: const InputDecoration(
                      labelText: 'Your Job/Profession',
                      hintText: 'e.g., Software Engineer at Google',
                      prefixIcon: Icon(Icons.work),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your profession';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Current City
                  TextFormField(
                    controller: _currentCityController,
                    decoration: const InputDecoration(
                      labelText: 'Current City',
                      hintText: 'Where do you live now?',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current city';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Religious Practice
                  DropdownButtonFormField<String>(
                    value: _religiousPractice,
                    decoration: const InputDecoration(
                      labelText: 'Religious Practice',
                      prefixIcon: Icon(Icons.temple_hindu),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'strict', child: Text('Strict')),
                      DropdownMenuItem(value: 'moderate', child: Text('Moderate')),
                      DropdownMenuItem(value: 'flexible', child: Text('Flexible')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _religiousPractice = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select religious practice';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Food Habits
                  DropdownButtonFormField<String>(
                    value: _foodHabits,
                    decoration: const InputDecoration(
                      labelText: 'Food Habits',
                      prefixIcon: Icon(Icons.restaurant),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'strict_jain', child: Text('Strict Jain')),
                      DropdownMenuItem(value: 'vegan', child: Text('Vegan')),
                      DropdownMenuItem(value: 'vegetarian', child: Text('Vegetarian')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _foodHabits = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select food habits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Family Details (Optional)
                  TextFormField(
                    controller: _familyDetailsController,
                    decoration: const InputDecoration(
                      labelText: 'Family Details (Optional)',
                      hintText: 'Share about your family...',
                      prefixIcon: Icon(Icons.family_restroom),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Complete Profile'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Affirmation
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Namokar Mantra blessings for your journey ahead',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
