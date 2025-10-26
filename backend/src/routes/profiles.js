const express = require('express');
const router = express.Router();
// Use Prisma controller with PostgreSQL
const {
  createBasicProfile,
  getProfileByCode,
  completeProfile,
  getAllProfiles,
  getMyProfiles
} = require('../controllers/profileController');
const { protect } = require('../middleware/auth');

router.post('/create-basic', protect, createBasicProfile);
router.get('/code/:code', getProfileByCode);
router.put('/complete/:code', protect, completeProfile);
router.get('/', protect, getAllProfiles);
router.get('/my-profiles', protect, getMyProfiles);

module.exports = router;
