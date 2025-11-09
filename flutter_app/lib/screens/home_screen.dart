import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/profile.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Profile> _profiles = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Search and filter state
  final TextEditingController _searchController = TextEditingController();
  String _selectedGender = 'All';
  String _selectedCity = '';
  String _selectedEducation = '';
  int? _minAge;
  int? _maxAge;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProfiles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Build query parameters
      final Map<String, String> params = {};

      if (_selectedGender != 'All') {
        params['gender'] = _selectedGender;
      }
      if (_selectedCity.isNotEmpty) {
        params['city'] = _selectedCity;
      }
      if (_selectedEducation.isNotEmpty) {
        params['education'] = _selectedEducation;
      }
      if (_minAge != null) {
        params['minAge'] = _minAge.toString();
      }
      if (_maxAge != null) {
        params['maxAge'] = _maxAge.toString();
      }
      if (_searchController.text.isNotEmpty) {
        params['search'] = _searchController.text;
      }

      // Build URL with query parameters
      final baseUrl = ApiService.baseUrl;
      final uri = Uri.parse('$baseUrl/profiles');
      final urlWithParams = uri.replace(queryParameters: params);

      final response = await http.get(
        urlWithParams,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await StorageService.getToken()}',
        },
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        final profilesData = data['profiles'] as List;
        setState(() {
          _profiles = profilesData.map((json) => Profile.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = data['message'] ?? 'Failed to load profiles';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading profiles: $e';
        _isLoading = false;
      });
    }
  }

  List<Profile> get _filteredProfiles => _profiles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Browse Profiles',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, profession, education...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadProfiles();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onSubmitted: (_) => _loadProfiles(),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primary.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: _isLoading
            ? _buildLoadingState()
            : _errorMessage != null
                ? _buildErrorState()
                : _filteredProfiles.isEmpty
                    ? _buildEmptyState()
                    : _buildProfileGrid(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading profiles...',
            style: GoogleFonts.lato(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: GoogleFonts.lato(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadProfiles,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ॐ',
              style: GoogleFonts.notoSans(
                fontSize: 64,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Profiles Found',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to create a profile and start your journey',
              style: GoogleFonts.lato(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/role-selection',
                  (route) => false,
                );
              },
              child: const Text('Create Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileGrid() {
    return RefreshIndicator(
      onRefresh: _loadProfiles,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _filteredProfiles.length,
        itemBuilder: (context, index) {
          return _buildProfileCard(_filteredProfiles[index]);
        },
      ),
    );
  }

  Widget _buildProfileCard(Profile profile) {
    final basicDetails = profile.basicDetails;
    final advancedDetails = profile.advancedDetails;
    final age = basicDetails?.dateOfBirth != null
        ? _calculateAge(basicDetails!.dateOfBirth!)
        : null;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showProfileDetails(profile),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primary, AppTheme.secondary],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        basicDetails?.childFullName?.substring(0, 1).toUpperCase() ?? '?',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          basicDetails?.childFullName ?? 'Unknown',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (age != null)
                          Text(
                            '$age years',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Profile Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      Icons.location_city,
                      advancedDetails?.currentCity ?? basicDetails?.city ?? 'Not specified',
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      Icons.school,
                      advancedDetails?.education ?? basicDetails?.basicEducation ?? 'Not specified',
                    ),
                    const SizedBox(height: 8),
                    if (advancedDetails?.profession != null)
                      _buildDetailRow(
                        Icons.work,
                        advancedDetails!.profession!,
                      ),
                  ],
                ),
              ),

              // View Button
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showProfileDetails(profile),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primary),
                  ),
                  child: Text(
                    'View Details',
                    style: GoogleFonts.lato(
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.lato(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _showProfileDetails(Profile profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return _buildProfileDetailsSheet(profile, scrollController);
        },
      ),
    );
  }

  Widget _buildProfileDetailsSheet(Profile profile, ScrollController scrollController) {
    final basicDetails = profile.basicDetails;
    final advancedDetails = profile.advancedDetails;
    final age = basicDetails?.dateOfBirth != null
        ? _calculateAge(basicDetails!.dateOfBirth!)
        : null;

    return Container(
      padding: const EdgeInsets.all(24),
      child: ListView(
        controller: scrollController,
        children: [
          // Header
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Profile Avatar
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, AppTheme.secondary],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  basicDetails?.childFullName?.substring(0, 1).toUpperCase() ?? '?',
                  style: GoogleFonts.poppins(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name and Age
          Text(
            basicDetails?.childFullName ?? 'Unknown',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          if (age != null)
            Text(
              '$age years old',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 24),

          // Basic Details Section
          _buildSectionTitle('Basic Information'),
          _buildInfoCard([
            _buildInfoRow('Gender', basicDetails?.childGender ?? 'Not specified'),
            _buildInfoRow('City', advancedDetails?.currentCity ?? basicDetails?.city ?? 'Not specified'),
            _buildInfoRow('Education', advancedDetails?.education ?? basicDetails?.basicEducation ?? 'Not specified'),
            if (advancedDetails?.profession != null)
              _buildInfoRow('Profession', advancedDetails!.profession!),
          ]),

          // Advanced Details Section
          if (advancedDetails != null) ...[
            const SizedBox(height: 24),
            _buildSectionTitle('Personal Details'),
            _buildInfoCard([
              if (advancedDetails.religiousPractice != null)
                _buildInfoRow('Religious Practice', advancedDetails.religiousPractice!),
              if (advancedDetails.foodHabits != null)
                _buildInfoRow('Food Habits', advancedDetails.foodHabits!),
            ]),
          ],

          // Life Goals
          if (advancedDetails?.lifeGoals != null) ...[
            const SizedBox(height: 24),
            _buildSectionTitle('Life Goals'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  advancedDetails.lifeGoals!,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
          ],

          // Family Details
          if (advancedDetails?.familyDetails != null) ...[
            const SizedBox(height: 24),
            _buildSectionTitle('Family Details'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  advancedDetails.familyDetails!,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
          ],

          // Travelled Places
          if (advancedDetails?.travelledPlaces != null &&
              advancedDetails!.travelledPlaces!.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionTitle('Travelled Places'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: advancedDetails.travelledPlaces!.map((place) {
                return Chip(
                  label: Text(place),
                  backgroundColor: AppTheme.primary.withOpacity(0.1),
                );
              }).toList(),
            ),
          ],

          const SizedBox(height: 24),

          // Contact Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement contact functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contact feature coming soon!'),
                  ),
                );
              },
              icon: const Icon(Icons.message),
              label: const Text('Contact'),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    // Create temporary variables for the dialog
    String tempGender = _selectedGender;
    String tempCity = _selectedCity;
    int? tempMinAge = _minAge;
    int? tempMaxAge = _maxAge;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            'Filter Profiles',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gender Filter
                Text(
                  'Gender',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Wrap(
                  spacing: 8,
                  children: ['All', 'Male', 'Female'].map((gender) {
                    return ChoiceChip(
                      label: Text(gender),
                      selected: tempGender == gender,
                      onSelected: (selected) {
                        setDialogState(() {
                          tempGender = gender;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // City Filter
                TextField(
                  decoration: InputDecoration(
                    labelText: 'City',
                    hintText: 'e.g., Mumbai, Delhi',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  controller: TextEditingController(text: tempCity),
                  onChanged: (value) {
                    tempCity = value;
                  },
                ),
                const SizedBox(height: 16),

                // Age Range
                Text(
                  'Age Range',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Min',
                          hintText: '25',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(
                          text: tempMinAge?.toString() ?? '',
                        ),
                        onChanged: (value) {
                          tempMinAge = int.tryParse(value);
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('to'),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Max',
                          hintText: '35',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(
                          text: tempMaxAge?.toString() ?? '',
                        ),
                        onChanged: (value) {
                          tempMaxAge = int.tryParse(value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Reset filters
                setState(() {
                  _selectedGender = 'All';
                  _selectedCity = '';
                  _minAge = null;
                  _maxAge = null;
                });
                Navigator.pop(context);
                _loadProfiles();
              },
              child: const Text('Reset'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedGender = tempGender;
                  _selectedCity = tempCity;
                  _minAge = tempMinAge;
                  _maxAge = tempMaxAge;
                });
                Navigator.pop(context);
                _loadProfiles();
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/welcome',
          (route) => false,
        );
      }
    }
  }
}
