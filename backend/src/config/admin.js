const AdminJS = require('adminjs');
const AdminJSExpress = require('@adminjs/express');
const { Database, Resource } = require('@adminjs/prisma');
const prisma = require('./prisma');

// Register Prisma adapter
AdminJS.registerAdapter({ Database, Resource });

// AdminJS configuration
const adminOptions = {
  resources: [
    {
      resource: { model: prisma.user, client: prisma },
      options: {
        navigation: {
          name: 'User Management',
          icon: 'User',
        },
        properties: {
          id: { isVisible: { list: true, filter: true, show: true, edit: false } },
          phoneNumber: { isTitle: true },
          otpCode: { isVisible: false },
          otpExpiresAt: { isVisible: false },
          createdAt: { isVisible: { list: true, filter: true, show: true, edit: false } },
          updatedAt: { isVisible: { list: false, filter: false, show: true, edit: false } },
        },
        actions: {
          delete: {
            isVisible: true,
            isAccessible: ({ currentAdmin }) => currentAdmin && currentAdmin.role === 'admin',
          },
        },
      },
    },
    {
      resource: { model: prisma.profile, client: prisma },
      options: {
        navigation: {
          name: 'Profile Management',
          icon: 'Document',
        },
        properties: {
          id: { isVisible: { list: true, filter: true, show: true, edit: false } },
          profileCode: { isTitle: true },
          childFullName: { isVisible: { list: true, filter: true, show: true, edit: true } },
          childGender: { isVisible: { list: true, filter: true, show: true, edit: true } },
          status: {
            isVisible: { list: true, filter: true, show: true, edit: true },
            availableValues: [
              { value: 'draft', label: 'Draft' },
              { value: 'pending_completion', label: 'Pending Completion' },
              { value: 'active', label: 'Active' },
              { value: 'inactive', label: 'Inactive' },
            ],
          },
          photos: {
            isVisible: { list: false, filter: false, show: true, edit: true },
          },
          lifeGoals: {
            type: 'textarea',
            isVisible: { list: false, filter: false, show: true, edit: true },
          },
          familyDetails: {
            type: 'textarea',
            isVisible: { list: false, filter: false, show: true, edit: true },
          },
          createdAt: { isVisible: { list: true, filter: true, show: true, edit: false } },
          updatedAt: { isVisible: { list: false, filter: false, show: true, edit: false } },
          completedAt: { isVisible: { list: true, filter: true, show: true, edit: false } },
        },
        listProperties: ['profileCode', 'childFullName', 'childGender', 'status', 'createdAt'],
      },
    },
  ],
  rootPath: '/admin',
  branding: {
    companyName: 'Jain Matrimony Admin',
    logo: false,
    softwareBrothers: false,
  },
  dashboard: {
    component: AdminJS.bundle('../components/dashboard.jsx'),
  },
};

const admin = new AdminJS(adminOptions);

// Authentication function
const authenticate = async (email, password) => {
  // In production, this should check against a real admin table
  // For now, using environment variables
  const ADMIN_EMAIL = process.env.ADMIN_EMAIL || 'admin@jainmatrimony.com';
  const ADMIN_PASSWORD = process.env.ADMIN_PASSWORD || 'admin123';

  if (email === ADMIN_EMAIL && password === ADMIN_PASSWORD) {
    return { email, role: 'admin' };
  }
  return null;
};

// Create AdminJS router with authentication
const adminRouter = AdminJSExpress.buildAuthenticatedRouter(
  admin,
  {
    authenticate,
    cookiePassword: process.env.ADMIN_COOKIE_SECRET || 'admin_cookie_secret_change_in_production',
  },
  null,
  {
    resave: false,
    saveUninitialized: true,
    secret: process.env.ADMIN_SESSION_SECRET || 'admin_session_secret_change_in_production',
    cookie: {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production', // Use secure cookies in production
    },
  }
);

module.exports = { admin, adminRouter };
