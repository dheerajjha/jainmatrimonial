// In-memory storage for testing without MongoDB
const profiles = new Map();
const users = new Map();

// Generate unique code
function generateCode() {
  return Math.random().toString(36).substring(2, 8).toUpperCase();
}

// Mock Profile Storage
const profileStorage = {
  create: (data) => {
    const profileCode = generateCode();
    const profile = {
      _id: Date.now().toString(),
      profileCode,
      shareableLink: `${process.env.APP_URL}/child/${profileCode}`,
      ...data,
      createdAt: new Date(),
    };
    profiles.set(profileCode, profile);
    return profile;
  },

  findByCode: (code) => {
    return profiles.get(code) || null;
  },

  update: (code, data) => {
    const profile = profiles.get(code);
    if (!profile) return null;

    const updated = { ...profile, ...data, updatedAt: new Date() };
    profiles.set(code, updated);
    return updated;
  },

  getAll: () => {
    return Array.from(profiles.values()).filter(p => p.status === 'active');
  }
};

// Mock User Storage
const userStorage = {
  create: (data) => {
    const user = {
      _id: Date.now().toString(),
      ...data,
      createdAt: new Date(),
    };
    users.set(user.phoneNumber, user);
    return user;
  },

  findByPhone: (phoneNumber) => {
    return users.get(phoneNumber) || null;
  },

  findById: (id) => {
    return Array.from(users.values()).find(u => u._id === id) || null;
  },

  update: (phoneNumber, data) => {
    const user = users.get(phoneNumber);
    if (!user) return null;

    const updated = { ...user, ...data };
    users.set(phoneNumber, updated);
    return updated;
  }
};

module.exports = {
  profileStorage,
  userStorage
};
