const express = require('express');
const router = express.Router();
const upload = require('../config/multer');
const { protect } = require('../middleware/auth');
const {
  uploadProfilePhotos,
  deleteProfilePhoto,
  getProfilePhotos
} = require('../controllers/uploadController');

// All routes require authentication
router.use(protect);

// Upload photos (max 5 photos at a time)
router.post('/profile/:profileId/photos', upload.array('photos', 5), uploadProfilePhotos);

// Delete a photo
router.delete('/profile/:profileId/photos/:photoIndex', deleteProfilePhoto);

// Get profile photos
router.get('/profile/:profileId/photos', getProfilePhotos);

module.exports = router;
