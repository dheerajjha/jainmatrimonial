exports.sendOTP = async (phoneNumber, otp) => {
  try {
    // In development, just log the OTP
    if (process.env.NODE_ENV === 'development') {
      console.log(`📱 OTP for ${phoneNumber}: ${otp}`);
      return;
    }

    // In production, send actual SMS
    const twilio = require('twilio');
    const client = twilio(
      process.env.TWILIO_ACCOUNT_SID,
      process.env.TWILIO_AUTH_TOKEN
    );

    await client.messages.create({
      body: `Your Jain Matrimony verification code is: ${otp}. Valid for 10 minutes.`,
      from: process.env.TWILIO_PHONE_NUMBER,
      to: phoneNumber
    });

    console.log(`✅ OTP sent to ${phoneNumber}`);
  } catch (error) {
    console.error('SMS Error:', error);
    throw new Error('Failed to send OTP');
  }
};
