# OTP Verification Flow Implementation

## Overview

This implementation provides a complete OTP verification flow for user registration in the PowerGodha Flutter application. The flow integrates with the PowerGodha API and provides a seamless user experience.

## API Integration

### Registration API Response:
```json
{
  "data": {
    "otp": "669263",
    "user_id": 33145,
    "sms_response": "",
    "phone_number": "9876541326"
  },
  "message": "Success.Please verify the otp sent to your registered phone number",
  "status": 200
}
```

### OTP Verification API:
- **Endpoint**: `POST https://orb.powergotha.com/api/verify_otp`
- **Content-Type**: `application/x-www-form-urlencoded`
- **Parameters**:
  - `user_id` (String): User ID from registration (e.g., "33143")
  - `otp` (String): 6-digit OTP (e.g., "686427")

### OTP Verification Response:
```json
{
  "data": [],
  "message": "OTP matched successfully",
  "status": 200
}
```

## Flow Implementation

### 1. Signup Success → OTP Verification
- **Trigger**: Successful user registration API call
- **Action**: Show success snackbar with the API message
- **Navigation**: Navigate to OTP verification screen with user data

### 2. OTP Verification Screen
- **Features**:
  - 6-digit OTP input with validation
  - Phone number format (Indian: starts with 6-9, 10 digits)
  - Input formatters (digits only, length limiting)
  - Comprehensive error handling
  - Resend OTP functionality

### 3. Successful OTP Verification → Login Required
- **Process**: OTP verification confirms the OTP is correct
- **User Flow**: User is redirected to login screen to authenticate
- **Message**: "Registration completed successfully! Please log in with your credentials."

## Updated Flow (Post-OTP API Integration)

1. User enters phone number in signup
2. API returns registration success with OTP data
3. Show snackbar: "Success. Please verify the OTP sent to your registered phone number"
4. Navigate to OTP verification screen
5. User enters 6-digit OTP
6. OTP gets verified with API using form URL-encoded parameters
7. Show success message: "OTP matched successfully"
8. Navigate to login screen for user authentication
9. User logs in with their credentials to access the app

## Key Changes for API Integration

### API Client Updates:
- Changed from JSON body to form URL-encoded parameters
- Updated endpoint to use `@FormUrlEncoded()` and `@Field()` annotations
- Modified response type to `OtpVerificationResponse`

### Authentication Flow:
- OTP verification no longer provides authentication tokens
- Separated OTP verification from user authentication
- User must log in after successful OTP verification

### User Experience:
- Clear messaging about the two-step process (verify OTP → login)
- Success feedback at each step
- Smooth transition from registration to login

## Files Created/Modified

### New Files:
- `lib/otp_verification/view/otp_verification_page.dart` - Main OTP verification page
- `lib/otp_verification/view/otp_verification_form.dart` - OTP input form widget
- `lib/otp_verification/bloc/otp_verification_bloc.dart` - BLoC for state management
- `lib/otp_verification/bloc/otp_verification_event.dart` - Events for OTP verification
- `lib/otp_verification/bloc/otp_verification_state.dart` - State for OTP verification
- `lib/otp_verification/models/otp.dart` - OTP validation model
- `lib/otp_verification/otp_verification.dart` - Module exports

### Modified Files:
- `lib/signup/view/signup_form.dart` - Added success handling and navigation to login
- `lib/app/app_routes.dart` - Added OTP verification route
- `packages/authentication_repository/lib/src/auth_api_client.dart` - Updated API method
- `packages/authentication_repository/lib/src/models/auth_models.dart` - Added OTP response model
- `packages/authentication_repository/lib/src/authentication_repository.dart` - Updated verification method

## Technical Implementation

### API Integration:
- **Form URL-encoded**: Uses `application/x-www-form-urlencoded` content type
- **Field Parameters**: `user_id` and `otp` as separate form fields
- **Response Handling**: Processes the simple success response structure

### Error Handling:
The implementation handles various error scenarios:
- Empty OTP input
- Invalid OTP format (not 6 digits)
- API validation errors
- Network connectivity issues
- Server errors

All errors are displayed to the user with appropriate feedback messages.

## Usage Example

```dart
// API call (handled internally by AuthApiClient)
@POST('/verify_otp')
@FormUrlEncoded()
Future<OtpVerificationResponse> verifyOtp(
  @Field('user_id') String userId,
  @Field('otp') String otp,
);

// Navigation after successful verification
Navigator.of(context).pushReplacementNamed('/login');
```

This implementation provides a complete and robust OTP verification flow that integrates seamlessly with the PowerGodha API specifications.
