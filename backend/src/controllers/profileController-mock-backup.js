const { profileStorage } = require('../mock-storage');

// @desc    Create basic profile (by parent)
// @route   POST /api/profiles/create-basic
// @access  Private (Parent)
exports.createBasicProfile = async (req, res) => {
  try {
    const {
      parentName,
      relation,
      parentContact,
      childFullName,
      childGender,
      dateOfBirth,
      city,
      basicEducation
    } = req.body;

    // Validate required fields
    if (!parentName || !relation || !parentContact || !childFullName || !childGender || !dateOfBirth || !city) {
      return res.status(400).json({
        success: false,
        message: 'Please provide all required fields'
      });
    }

    // Create profile
    const profile = profileStorage.create({
      parentUserId: req.user.id,
      basicDetails: {
        parentName,
        relation,
        parentContact,
        childFullName,
        childGender,
        dateOfBirth,
        city,
        basicEducation
      },
      status: 'pending_completion'
    });

    res.status(201).json({
      success: true,
      message: 'Basic profile created successfully',
      profile: {
        profileCode: profile.profileCode,
        shareableLink: profile.shareableLink,
        childName: profile.basicDetails.childFullName
      }
    });

  } catch (error) {
    console.error('Create Basic Profile Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to create profile'
    });
  }
};

// @desc    Get profile by code
// @route   GET /api/profiles/code/:code
// @access  Public
exports.getProfileByCode = async (req, res) => {
  try {
    const { code } = req.params;

    const profile = profileStorage.findByCode(code);

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Profile not found'
      });
    }

    res.status(200).json({
      success: true,
      profile
    });

  } catch (error) {
    console.error('Get Profile By Code Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to get profile'
    });
  }
};

// @desc    Complete profile (by child)
// @route   PUT /api/profiles/complete/:code
// @access  Private (Child)
exports.completeProfile = async (req, res) => {
  try {
    const { code } = req.params;
    const {
      lifeGoals,
      travelledPlaces,
      education,
      profession,
      currentCity,
      religiousPractice,
      foodHabits,
      familyDetails
    } = req.body;

    const profile = profileStorage.findByCode(code);

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Profile not found'
      });
    }

    // Update advanced details
    const updatedProfile = profileStorage.update(code, {
      advancedDetails: {
        lifeGoals,
        travelledPlaces,
        education,
        profession,
        currentCity,
        religiousPractice,
        foodHabits,
        familyDetails
      },
      childUserId: req.user.id,
      status: 'active',
      completedAt: new Date()
    });

    res.status(200).json({
      success: true,
      message: 'Profile completed successfully',
      profile: updatedProfile
    });

  } catch (error) {
    console.error('Complete Profile Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to complete profile'
    });
  }
};

// @desc    Get all active profiles
// @route   GET /api/profiles
// @access  Private
exports.getAllProfiles = async (req, res) => {
  try {
    const profiles = profileStorage.getAll();

    res.status(200).json({
      success: true,
      count: profiles.length,
      profiles
    });

  } catch (error) {
    console.error('Get All Profiles Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to get profiles'
    });
  }
};

// @desc    Get user's profiles
// @route   GET /api/profiles/my-profiles
// @access  Private
exports.getMyProfiles = async (req, res) => {
  try {
    const allProfiles = Array.from(profileStorage.getAll());
    const profiles = allProfiles.filter(p =>
      p.parentUserId === req.user.id || p.childUserId === req.user.id
    );

    res.status(200).json({
      success: true,
      count: profiles.length,
      profiles
    });

  } catch (error) {
    console.error('Get My Profiles Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to get profiles'
    });
  }
};
