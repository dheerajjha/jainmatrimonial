const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const path = require('path');
const prisma = require('./config/prisma');
const { admin, adminRouter } = require('./config/admin');

// Load environment variables
dotenv.config();

// Test Prisma connection
prisma.$connect()
  .then(() => console.log('✅ PostgreSQL connected via Prisma'))
  .catch((err) => console.error('❌ Prisma connection error:', err.message));

// Initialize express app
const app = express();

// AdminJS middleware (must be before other middleware)
app.use(admin.options.rootPath, adminRouter);

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files (uploaded photos)
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/profiles', require('./routes/profiles'));
app.use('/api/users', require('./routes/users'));
app.use('/api/upload', require('./routes/upload'));

// Health check
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK', message: 'Server is running' });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Internal Server Error'
  });
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`👨‍💼 Admin panel available at http://localhost:${PORT}${admin.options.rootPath}`);
  console.log(`📧 Admin email: ${process.env.ADMIN_EMAIL || 'admin@jainmatrimony.com'}`);
  console.log(`🔑 Admin password: ${process.env.ADMIN_PASSWORD || 'admin123'}`);
});
