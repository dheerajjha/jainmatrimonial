const mongoose = require('mongoose');

const profileSchema = new mongoose.Schema({
  // Unique 6-digit code for sharing
  profileCode: {
    type: String,
    required: true,
    unique: true,
    length: 6
  },

  // Link between parent and child
  parentUserId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  childUserId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },

  // Basic Details (filled by parent)
  basicDetails: {
    parentName: String,
    relation: {
      type: String,
      enum: ['father', 'mother', 'guardian']
    },
    parentContact: String,
    childFullName: String,
    childGender: {
      type: String,
      enum: ['male', 'female']
    },
    dateOfBirth: Date,
    city: String,
    basicEducation: String
  },

  // Advanced Details (filled by child)
  advancedDetails: {
    lifeGoals: String,
    travelledPlaces: [String],
    education: String,
    profession: String,
    currentCity: String,
    religiousPractice: {
      type: String,
      enum: ['strict', 'moderate', 'flexible']
    },
    foodHabits: {
      type: String,
      enum: ['strict_jain', 'vegan', 'vegetarian']
    },
    familyDetails: String
  },

  // Profile Status
  status: {
    type: String,
    enum: ['draft', 'pending_completion', 'active', 'inactive'],
    default: 'draft'
  },

  // Additional Info
  photos: [{
    url: String,
    isPrimary: Boolean
  }],
  horoscope: {
    url: String
  },
  partnerPreferences: {
    ageRange: {
      min: Number,
      max: Number
    },
    education: [String],
    profession: [String],
    cities: [String]
  },

  // Shareable link
  shareableLink: String,

  createdAt: {
    type: Date,
    default: Date.now
  },
  completedAt: Date
}, {
  timestamps: true
});

// Generate unique 6-digit code
profileSchema.pre('save', async function(next) {
  if (!this.profileCode) {
    let code;
    let isUnique = false;

    while (!isUnique) {
      code = Math.random().toString(36).substring(2, 8).toUpperCase();
      const existingProfile = await mongoose.model('Profile').findOne({ profileCode: code });
      if (!existingProfile) {
        isUnique = true;
      }
    }

    this.profileCode = code;
    this.shareableLink = `${process.env.APP_URL}/child/${code}`;
  }
  next();
});

module.exports = mongoose.model('Profile', profileSchema);
