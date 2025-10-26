import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class ParentBasicDetailsScreen extends StatefulWidget {
  const ParentBasicDetailsScreen({super.key});

  @override
  State<ParentBasicDetailsScreen> createState() => _ParentBasicDetailsScreenState();
}

class _ParentBasicDetailsScreenState extends State<ParentBasicDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _parentNameController = TextEditingController();
  final _parentContactController = TextEditingController();
  final _childNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _educationController = TextEditingController();

  String? _relation = 'father'; // Prefilled
  String? _gender = 'female'; // Prefilled
  DateTime? _dateOfBirth = DateTime(1998, 5, 15); // Prefilled
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Prefill form with test data
    _parentNameController.text = 'Rajesh Shah';
    _parentContactController.text = '+919876543210';
    _childNameController.text = 'Priya Shah';
    _cityController.text = 'Mumbai';
    _educationController.text = 'MBA';
  }

  @override
  void dispose() {
    _parentNameController.dispose();
    _parentContactController.dispose();
    _childNameController.dispose();
    _cityController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 21)),
      firstDate: DateTime(1960),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_dateOfBirth == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date of birth')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final data = {
        'parentName': _parentNameController.text,
        'relation': _relation,
        'parentContact': _parentContactController.text,
        'childFullName': _childNameController.text,
        'childGender': _gender,
        'dateOfBirth': _dateOfBirth!.toIso8601String(),
        'city': _cityController.text,
        'basicEducation': _educationController.text,
      };

      final response = await ApiService.createBasicProfile(data);

      setState(() {
        _isLoading = false;
      });

      if (response['success']) {
        if (mounted) {
          Navigator.pushNamed(
            context,
            '/profile-created',
            arguments: response['profile'],
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Failed to create profile')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Details'),
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
                    'Tell us about yourself and your child',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Step 1 of 3',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Parent Name
                  TextFormField(
                    controller: _parentNameController,
                    decoration: const InputDecoration(
                      labelText: 'Your Name',
                      hintText: 'Enter your full name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Relation
                  DropdownButtonFormField<String>(
                    value: _relation,
                    decoration: const InputDecoration(
                      labelText: 'Your Relation',
                      prefixIcon: Icon(Icons.family_restroom),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'father', child: Text('Father')),
                      DropdownMenuItem(value: 'mother', child: Text('Mother')),
                      DropdownMenuItem(value: 'guardian', child: Text('Guardian')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _relation = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select your relation';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Parent Contact
                  TextFormField(
                    controller: _parentContactController,
                    decoration: const InputDecoration(
                      labelText: 'Your Contact Number',
                      hintText: 'Enter your phone number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your contact number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  const Divider(),
                  const SizedBox(height: 16),

                  Text(
                    'Child\'s Information',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Child Name
                  TextFormField(
                    controller: _childNameController,
                    decoration: const InputDecoration(
                      labelText: 'Child\'s Full Name',
                      hintText: 'Enter full name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter child\'s name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Gender
                  DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.wc),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date of Birth
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _dateOfBirth == null
                            ? 'Select date of birth'
                            : DateFormat('dd MMM yyyy').format(_dateOfBirth!),
                        style: GoogleFonts.lato(
                          color: _dateOfBirth == null
                              ? AppTheme.textSecondary.withOpacity(0.5)
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // City
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City of Residence',
                      hintText: 'Enter city name',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter city';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Education (Optional)
                  TextFormField(
                    controller: _educationController,
                    decoration: const InputDecoration(
                      labelText: 'Basic Education/Profession (Optional)',
                      hintText: 'e.g., MBA, Engineer',
                      prefixIcon: Icon(Icons.school),
                    ),
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
                          : const Text('Create Profile'),
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
