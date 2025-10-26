const prisma = require('../config/prisma');

// Helper function to generate unique 6-character code
const generateCode = async () => {
  let code;
  let isUnique = false;

  while (!isUnique) {
    code = Math.random().toString(36).substring(2, 8).toUpperCase();
    const existing = await prisma.profile.findUnique({
      where: { profileCode: code }
    });
    if (!existing) {
      isUnique = true;
    }
  }

  return code;
};

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

    // Generate unique profile code
    const profileCode = await generateCode();
    const shareableLink = `${process.env.APP_URL}/child/${profileCode}`;

    // Create profile
    const profile = await prisma.profile.create({
      data: {
        profileCode,
        shareableLink,
        parentUserId: req.user.id,
        parentName,
        relation,
        parentContact,
        childFullName,
        childGender,
        dateOfBirth: new Date(dateOfBirth),
        city,
        basicEducation,
        status: 'pending_completion'
      }
    });

    res.status(201).json({
      success: true,
      message: 'Basic profile created successfully',
      profile: {
        profileCode: profile.profileCode,
        shareableLink: profile.shareableLink,
        childName: profile.childFullName
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

    const profile = await prisma.profile.findUnique({
      where: { profileCode: code },
      include: {
        parent: {
          select: {
            phoneNumber: true
          }
        }
      }
    });

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

    const profile = await prisma.profile.findUnique({
      where: { profileCode: code }
    });

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Profile not found'
      });
    }

    // Update profile with advanced details
    const updatedProfile = await prisma.profile.update({
      where: { profileCode: code },
      data: {
        lifeGoals,
        travelledPlaces,
        education,
        profession,
        currentCity,
        religiousPractice,
        foodHabits,
        familyDetails,
        childUserId: req.user.id,
        status: 'active',
        completedAt: new Date()
      }
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
    const profiles = await prisma.profile.findMany({
      where: { status: 'active' },
      orderBy: { createdAt: 'desc' },
      select: {
        id: true,
        profileCode: true,
        childFullName: true,
        childGender: true,
        dateOfBirth: true,
        city: true,
        education: true,
        profession: true,
        currentCity: true,
        religiousPractice: true,
        foodHabits: true,
        createdAt: true,
        completedAt: true
      }
    });

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
    const profiles = await prisma.profile.findMany({
      where: {
        OR: [
          { parentUserId: req.user.id },
          { childUserId: req.user.id }
        ]
      },
      orderBy: { createdAt: 'desc' }
    });

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
