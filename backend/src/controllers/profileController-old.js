const Profile = require('../models/Profile');
const User = require('../models/User');

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
    const profile = await Profile.create({
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

    const profile = await Profile.findOne({ profileCode: code })
      .populate('parentUserId', 'phoneNumber')
      .select('-__v');

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

    const profile = await Profile.findOne({ profileCode: code });

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Profile not found'
      });
    }

    // Update advanced details
    profile.advancedDetails = {
      lifeGoals,
      travelledPlaces,
      education,
      profession,
      currentCity,
      religiousPractice,
      foodHabits,
      familyDetails
    };

    profile.childUserId = req.user.id;
    profile.status = 'active';
    profile.completedAt = new Date();

    await profile.save();

    res.status(200).json({
      success: true,
      message: 'Profile completed successfully',
      profile
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
    const profiles = await Profile.find({ status: 'active' })
      .select('-__v')
      .sort('-createdAt');

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
    const profiles = await Profile.find({
      $or: [
        { parentUserId: req.user.id },
        { childUserId: req.user.id }
      ]
    }).sort('-createdAt');

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
