# Jain Matrimony Flutter App

The mobile frontend for the Jain Matrimony platform built with Flutter.

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio

### Installation

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Configure the backend API URL in `lib/services/api_service.dart`:
   ```dart
   static const String baseUrl = 'http://your-backend-url:5000/api';
   ```

3. Run the app:
   ```bash
   # Run on connected device/emulator
   flutter run

   # Run in debug mode
   flutter run --debug

   # Run in release mode
   flutter run --release
   ```

## Project Structure

```
lib/
├── main.dart               # App entry point with routing
├── theme/
│   └── app_theme.dart      # Color scheme, text styles, theme
├── models/
│   ├── user.dart           # User model
│   └── profile.dart        # Profile models (Basic & Advanced)
├── services/
│   └── api_service.dart    # HTTP API client
├── screens/
│   ├── splash_screen.dart
│   ├── welcome_screen.dart
│   ├── role_selection_screen.dart
│   ├── parent_basic_details_screen.dart
│   ├── profile_created_screen.dart
│   ├── code_entry_screen.dart
│   ├── child_advanced_details_screen.dart
│   └── profile_complete_success_screen.dart
└── widgets/
    └── (reusable widgets to be added)
```

## App Flow

### Parent Journey
```
Splash → Welcome → Role Selection → Basic Details Form → Profile Created (with code)
```

### Child Journey
```
Splash → Welcome → Role Selection → Code Entry → Advanced Details Form → Success
```

## Features

### Current Implementation
- ✅ Splash screen with animation
- ✅ Welcome screen with Jain aesthetics
- ✅ Role selection (Parent/Self)
- ✅ Parent flow for basic profile creation
- ✅ Code generation and sharing
- ✅ Child flow with code entry
- ✅ Advanced profile completion
- ✅ Success screens with animations

### Coming Soon
- [ ] OTP authentication screens
- [ ] Profile browsing
- [ ] Search and filters
- [ ] Profile detail view
- [ ] Messaging interface
- [ ] Settings and preferences

## Theme

### Colors
- **Primary**: Saffron (#FF9933)
- **Secondary**: Gold (#D4AF37)
- **Background**: Warm white (#FFFBF5)
- **Surface**: Pure white (#FFFFFF)

### Fonts
- **Display/Headings**: Poppins
- **Body Text**: Lato
- **Hindi Text**: Noto Sans Devanagari

## State Management

Currently using basic setState. Will migrate to Provider for:
- User authentication state
- Profile data
- App-wide settings

## API Integration

All API calls are handled through `ApiService` class:

```dart
// Example usage
final response = await ApiService.createBasicProfile(data);
if (response['success']) {
  // Handle success
}
```

### Available Methods
- `sendOTP(phoneNumber, role)`
- `verifyOTP(phoneNumber, otp)`
- `createBasicProfile(data)`
- `getProfileByCode(code)`
- `completeProfile(code, data)`
- `getAllProfiles()`
- `isLoggedIn()`
- `logout()`

## Building for Production

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Dependencies

Key packages used:
- `provider` - State management
- `http` - API calls
- `shared_preferences` - Local storage
- `google_fonts` - Typography
- `share_plus` - Sharing functionality
- `intl` - Date formatting
- `image_picker` - Image selection (future)

## Known Issues

- Authentication with OTP not yet integrated
- Profile browsing screen pending
- Image upload functionality pending

## Contributing

Follow the Flutter style guide and ensure all code passes:
```bash
flutter analyze
flutter format .
```

## License

Proprietary
