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

// @desc    Get all active profiles with search/filter
// @route   GET /api/profiles?gender=Male&city=Mumbai&education=Graduate&minAge=25&maxAge=35&search=doctor
// @access  Private
exports.getAllProfiles = async (req, res) => {
  try {
    const { gender, city, education, minAge, maxAge, search, religiousPractice, foodHabits } = req.query;

    // Build where clause
    const where = { status: 'active' };

    // Gender filter
    if (gender) {
      where.childGender = { equals: gender, mode: 'insensitive' };
    }

    // City filter (matches both city and currentCity)
    if (city) {
      where.OR = [
        { city: { contains: city, mode: 'insensitive' } },
        { currentCity: { contains: city, mode: 'insensitive' } }
      ];
    }

    // Education filter
    if (education) {
      where.education = { contains: education, mode: 'insensitive' };
    }

    // Religious practice filter
    if (religiousPractice) {
      where.religiousPractice = { contains: religiousPractice, mode: 'insensitive' };
    }

    // Food habits filter
    if (foodHabits) {
      where.foodHabits = { contains: foodHabits, mode: 'insensitive' };
    }

    // Age range filter
    if (minAge || maxAge) {
      const today = new Date();
      if (minAge) {
        const maxDate = new Date(today.getFullYear() - parseInt(minAge), today.getMonth(), today.getDate());
        where.dateOfBirth = { ...where.dateOfBirth, lte: maxDate };
      }
      if (maxAge) {
        const minDate = new Date(today.getFullYear() - parseInt(maxAge) - 1, today.getMonth(), today.getDate());
        where.dateOfBirth = { ...where.dateOfBirth, gte: minDate };
      }
    }

    // Text search (searches in name, profession, education)
    if (search) {
      const searchConditions = [
        { childFullName: { contains: search, mode: 'insensitive' } },
        { profession: { contains: search, mode: 'insensitive' } },
        { education: { contains: search, mode: 'insensitive' } },
        { lifeGoals: { contains: search, mode: 'insensitive' } }
      ];

      if (where.OR) {
        where.AND = [
          { OR: where.OR },
          { OR: searchConditions }
        ];
        delete where.OR;
      } else {
        where.OR = searchConditions;
      }
    }

    const profiles = await prisma.profile.findMany({
      where,
      orderBy: { createdAt: 'desc' },
      select: {
        id: true,
        profileCode: true,
        childFullName: true,
        childGender: true,
        dateOfBirth: true,
        city: true,
        basicEducation: true,
        education: true,
        profession: true,
        currentCity: true,
        religiousPractice: true,
        foodHabits: true,
        lifeGoals: true,
        travelledPlaces: true,
        photos: true,
        createdAt: true,
        completedAt: true
      }
    });

    // Return as full profile objects with basicDetails and advancedDetails structure
    const formattedProfiles = profiles.map(p => ({
      id: p.id,
      profileCode: p.profileCode,
      status: 'active',
      photos: p.photos || [],
      basicDetails: {
        childFullName: p.childFullName,
        childGender: p.childGender,
        dateOfBirth: p.dateOfBirth,
        city: p.city,
        basicEducation: p.basicEducation
      },
      advancedDetails: {
        education: p.education,
        profession: p.profession,
        currentCity: p.currentCity,
        religiousPractice: p.religiousPractice,
        foodHabits: p.foodHabits,
        lifeGoals: p.lifeGoals,
        travelledPlaces: p.travelledPlaces
      },
      createdAt: p.createdAt,
      completedAt: p.completedAt
    }));

    res.status(200).json({
      success: true,
      count: formattedProfiles.length,
      profiles: formattedProfiles
    });

  } catch (error) {
    console.error('Get All Profiles Error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to get profiles',
      error: error.message
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
