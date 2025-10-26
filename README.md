# Jain Matrimony App

A family-first matrimonial platform for the Jain community, designed to honor traditional values while embracing modern technology.

## Overview

Jain Matrimony is a unique matrimonial app that follows a family-centric approach:

1. **Parent Flow**: Parents create basic profiles for their children
2. **Child Flow**: Children receive a unique code to complete their own profiles
3. **Profile Sharing**: Seamless code-based profile completion system

This approach respects cultural traditions where families are involved in the matchmaking process while giving individuals autonomy to share their personal details.

## Project Structure

```
jainmatrimonial/
├── backend/              # Node.js/Express backend
│   ├── src/
│   │   ├── controllers/  # Request handlers
│   │   ├── models/       # MongoDB schemas
│   │   ├── routes/       # API routes
│   │   ├── middleware/   # Auth and other middleware
│   │   ├── config/       # Configuration files
│   │   ├── utils/        # Utility functions
│   │   └── server.js     # Entry point
│   ├── package.json
│   └── .env.example
│
└── flutter_app/          # Flutter frontend
    ├── lib/
    │   ├── screens/      # UI screens
    │   ├── widgets/      # Reusable widgets
    │   ├── models/       # Data models
    │   ├── services/     # API services
    │   ├── theme/        # App theme
    │   └── main.dart     # Entry point
    └── pubspec.yaml
```

## Features

### Current Features
- **Role Selection**: Choose between Parent or Self profile creation
- **Parent Flow**:
  - Create basic profile for child
  - Generate unique 6-character code
  - Share code via multiple channels
- **Child Flow**:
  - Enter code received from parent
  - Complete advanced profile details
  - Add personal information and preferences
- **Jain Aesthetics**:
  - Saffron, gold, and white color scheme
  - Cultural symbols (Om, Namokar Mantra)
  - Family-focused messaging

### Planned Features
- OTP-based authentication
- Profile browsing and search
- Advanced filtering (education, location, religious practice)
- Photo and horoscope uploads
- Messaging between matched users
- Admin panel for profile management

## Tech Stack

### Backend
- **Node.js** with Express.js
- **MongoDB** with Mongoose ODM
- **JWT** for authentication
- **Twilio** for OTP (SMS)
- **bcrypt** for password hashing

### Frontend
- **Flutter** (Dart)
- **Provider** for state management
- **HTTP** for API calls
- **Google Fonts** (Poppins, Lato)
- **Share Plus** for sharing functionality

## Setup Instructions

### Prerequisites
- Node.js (v18+)
- MongoDB (local or Atlas)
- Flutter SDK (v3.0+)
- Twilio account (for OTP)

### Backend Setup

1. Navigate to backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create environment file:
   ```bash
   cp .env.example .env
   ```

4. Configure environment variables in `.env`:
   ```
   PORT=5000
   MONGODB_URI=mongodb://localhost:27017/jain_matrimonial
   JWT_SECRET=your_secure_secret_key
   TWILIO_ACCOUNT_SID=your_twilio_sid
   TWILIO_AUTH_TOKEN=your_twilio_token
   TWILIO_PHONE_NUMBER=your_twilio_number
   ```

5. Start MongoDB:
   ```bash
   mongod
   ```

6. Run the server:
   ```bash
   npm run dev
   ```

   The backend will be available at `http://localhost:5000`

### Flutter App Setup

1. Navigate to Flutter app directory:
   ```bash
   cd flutter_app
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Update API URL in `lib/services/api_service.dart`:
   ```dart
   static const String baseUrl = 'http://your-backend-url:5000/api';
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## API Endpoints

### Authentication
- `POST /api/auth/send-otp` - Send OTP to phone number
- `POST /api/auth/verify-otp` - Verify OTP and login
- `GET /api/auth/me` - Get current user (requires auth)

### Profiles
- `POST /api/profiles/create-basic` - Create basic profile (Parent)
- `GET /api/profiles/code/:code` - Get profile by code
- `PUT /api/profiles/complete/:code` - Complete profile (Child)
- `GET /api/profiles` - Get all active profiles
- `GET /api/profiles/my-profiles` - Get user's profiles

## User Flows

### Parent Flow
1. Open app → Welcome screen
2. Select "Parent" role
3. Fill basic details form:
   - Parent name and contact
   - Child's name, gender, DOB
   - City and basic education
4. Submit and receive unique 6-character code
5. Share code with child via SMS/WhatsApp/etc.

### Child Flow
1. Open app → Welcome screen
2. Select "Self" role
3. Enter 6-character code from parent
4. View basic details filled by parent
5. Complete advanced details:
   - Life goals and ambitions
   - Places travelled
   - Detailed education and profession
   - Religious practice and food habits
   - Family details
6. Submit and profile becomes active

## Design Philosophy

### Cultural Sensitivity
- Respects Jain values and traditions
- Family-centric approach
- Religious symbols and blessings
- Appropriate color scheme

### User Experience
- Simple, intuitive flows
- Minimal steps to complete profile
- Clear progress indicators
- Affirmations and blessings throughout

### Technical Excellence
- Clean code architecture
- Secure authentication
- Scalable backend design
- Responsive Flutter UI

## Development Roadmap

### Phase 1 (Current)
- ✅ Project setup
- ✅ Basic UI screens
- ✅ Parent flow implementation
- ✅ Child flow implementation
- ✅ Code generation system

### Phase 2 (Next)
- [ ] OTP authentication integration
- [ ] Profile browsing screen
- [ ] Search and filter functionality
- [ ] Photo upload feature
- [ ] Profile details view

### Phase 3 (Future)
- [ ] Messaging system
- [ ] Match recommendations
- [ ] Admin dashboard
- [ ] Premium features
- [ ] Mobile app deployment

## Contributing

This is a private project. For any queries or suggestions, please contact the development team.

## License

Proprietary - All rights reserved

## Contact

For support or inquiries, please reach out through the appropriate channels.

---

**णमो अरिहंताणं** 🙏
