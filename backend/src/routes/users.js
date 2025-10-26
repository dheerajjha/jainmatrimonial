const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/auth');

// Placeholder for future user routes
router.get('/', protect, (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Users endpoint'
  });
});

module.exports = router;
