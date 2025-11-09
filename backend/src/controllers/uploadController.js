const prisma = require('../config/prisma');
const path = require('path');
const fs = require('fs');

// Upload photos for a profile
exports.uploadProfilePhotos = async (req, res) => {
  try {
    const { profileId } = req.params;

    if (!req.files || req.files.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'No files uploaded'
      });
    }

    // Get profile
    const profile = await prisma.profile.findUnique({
      where: { id: profileId }
    });

    if (!profile) {
      // Delete uploaded files if profile doesn't exist
      req.files.forEach(file => {
        fs.unlinkSync(file.path);
      });
      return res.status(404).json({
        success: false,
        message: 'Profile not found'
      });
    }

    // Check authorization - user must be the profile owner
    if (profile.childUserId !== req.user.id && profile.parentUserId !== req.user.id) {
      // Delete uploaded files if not authorized
      req.files.forEach(file => {
        fs.unlinkSync(file.path);
      });
      return res.status(403).json({
        success: false,
        message: 'Not authorized to upload photos for this profile'
      });
    }

    // Generate photo URLs
    const photoUrls = req.files.map(file => `/uploads/profiles/${file.filename}`);

    // Add new photos to existing photos
    const updatedProfile = await prisma.profile.update({
      where: { id: profileId },
      data: {
        photos: {
          push: photoUrls
        }
      }
    });

    res.json({
      success: true,
      message: 'Photos uploaded successfully',
      photos: updatedProfile.photos
    });

  } catch (error) {
    console.error('Upload error:', error);
    // Clean up uploaded files on error
    if (req.files) {
      req.files.forEach(file => {
        try {
          fs.unlinkSync(file.path);
        } catch (err) {
          console.error('Error deleting file:', err);
        }
      });
    }
    res.status(500).json({
      success: false,
      message: 'Error uploading photos',
      error: error.message
    });
  }
};

// Delete a photo from profile
exports.deleteProfilePhoto = async (req, res) => {
  try {
    const { profileId, photoIndex } = req.params;

    const profile = await prisma.profile.findUnique({
      where: { id: profileId }
    });

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Profile not found'
      });
    }

    // Check authorization
    if (profile.childUserId !== req.user.id && profile.parentUserId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to delete photos from this profile'
      });
    }

    const index = parseInt(photoIndex);
    if (index < 0 || index >= profile.photos.length) {
      return res.status(400).json({
        success: false,
        message: 'Invalid photo index'
      });
    }

    // Get photo URL to delete
    const photoUrl = profile.photos[index];
    const filename = path.basename(photoUrl);
    const filePath = path.join(__dirname, '../../uploads/profiles', filename);

    // Remove from array
    const updatedPhotos = profile.photos.filter((_, i) => i !== index);

    // Update database
    const updatedProfile = await prisma.profile.update({
      where: { id: profileId },
      data: {
        photos: updatedPhotos
      }
    });

    // Delete file from disk
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
    }

    res.json({
      success: true,
      message: 'Photo deleted successfully',
      photos: updatedProfile.photos
    });

  } catch (error) {
    console.error('Delete error:', error);
    res.status(500).json({
      success: false,
      message: 'Error deleting photo',
      error: error.message
    });
  }
};

// Get profile photos
exports.getProfilePhotos = async (req, res) => {
  try {
    const { profileId } = req.params;

    const profile = await prisma.profile.findUnique({
      where: { id: profileId },
      select: {
        id: true,
        photos: true
      }
    });

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Profile not found'
      });
    }

    res.json({
      success: true,
      photos: profile.photos
    });

  } catch (error) {
    console.error('Get photos error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching photos',
      error: error.message
    });
  }
};
