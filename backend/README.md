# Jain Matrimony Backend

Node.js/Express backend API for the Jain Matrimony application.

## Quick Start

```bash
# Install dependencies
npm install

# Copy environment variables
cp .env.example .env

# Update .env with your configuration

# Start development server
npm run dev

# Start production server
npm start
```

## API Documentation

### Base URL
```
http://localhost:5000/api
```

### Authentication Endpoints

#### Send OTP
```http
POST /api/auth/send-otp
Content-Type: application/json

{
  "phoneNumber": "+911234567890",
  "role": "parent"
}
```

Response:
```json
{
  "success": true,
  "message": "OTP sent successfully"
}
```

#### Verify OTP
```http
POST /api/auth/verify-otp
Content-Type: application/json

{
  "phoneNumber": "+911234567890",
  "otp": "123456"
}
```

Response:
```json
{
  "success": true,
  "token": "jwt_token_here",
  "user": {
    "id": "user_id",
    "phoneNumber": "+911234567890",
    "role": "parent",
    "isVerified": true
  }
}
```

### Profile Endpoints

#### Create Basic Profile
```http
POST /api/profiles/create-basic
Authorization: Bearer {token}
Content-Type: application/json

{
  "parentName": "John Doe",
  "relation": "father",
  "parentContact": "+911234567890",
  "childFullName": "Jane Doe",
  "childGender": "female",
  "dateOfBirth": "1995-05-15",
  "city": "Mumbai",
  "basicEducation": "MBA"
}
```

Response:
```json
{
  "success": true,
  "message": "Basic profile created successfully",
  "profile": {
    "profileCode": "ABC123",
    "shareableLink": "https://jainmatch.app/child/ABC123",
    "childName": "Jane Doe"
  }
}
```

#### Get Profile by Code
```http
GET /api/profiles/code/{code}
```

#### Complete Profile
```http
PUT /api/profiles/complete/{code}
Authorization: Bearer {token}
Content-Type: application/json

{
  "lifeGoals": "Start my own business",
  "travelledPlaces": ["Mumbai", "Delhi", "Dubai"],
  "education": "MBA from IIM",
  "profession": "Software Engineer",
  "currentCity": "Bangalore",
  "religiousPractice": "moderate",
  "foodHabits": "strict_jain",
  "familyDetails": "Nuclear family"
}
```

## Database Schema

### User Model
```javascript
{
  phoneNumber: String (unique),
  isVerified: Boolean,
  otp: {
    code: String (hashed),
    expiresAt: Date
  },
  role: String (parent/self/admin),
  createdAt: Date
}
```

### Profile Model
```javascript
{
  profileCode: String (unique, 6 chars),
  parentUserId: ObjectId,
  childUserId: ObjectId,
  basicDetails: {
    parentName: String,
    relation: String,
    parentContact: String,
    childFullName: String,
    childGender: String,
    dateOfBirth: Date,
    city: String,
    basicEducation: String
  },
  advancedDetails: {
    lifeGoals: String,
    travelledPlaces: [String],
    education: String,
    profession: String,
    currentCity: String,
    religiousPractice: String,
    foodHabits: String,
    familyDetails: String
  },
  status: String (draft/pending_completion/active/inactive),
  shareableLink: String,
  createdAt: Date,
  completedAt: Date
}
```

## Environment Variables

```env
# Server
PORT=5000
NODE_ENV=development

# Database
MONGODB_URI=mongodb://localhost:27017/jain_matrimonial

# JWT
JWT_SECRET=your_secret_key
JWT_EXPIRE=7d

# Twilio (OTP)
TWILIO_ACCOUNT_SID=your_sid
TWILIO_AUTH_TOKEN=your_token
TWILIO_PHONE_NUMBER=your_number

# App
APP_URL=https://jainmatch.app
```

## Error Handling

All endpoints return errors in this format:
```json
{
  "success": false,
  "message": "Error description"
}
```

## Security

- JWT-based authentication
- OTP verification for phone numbers
- Password hashing with bcrypt
- CORS enabled
- Input validation
- Rate limiting (to be implemented)

## Testing

```bash
# Run tests
npm test
```

## Deployment

1. Set up MongoDB Atlas or production database
2. Configure environment variables
3. Deploy to your preferred platform (Heroku, AWS, etc.)
4. Update APP_URL in environment

## License

Proprietary
