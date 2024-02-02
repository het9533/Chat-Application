abstract class PhoneAuthenticationEvent {}

class VerifyPhoneNumberEvent extends PhoneAuthenticationEvent {
  final String phoneNumber;


  VerifyPhoneNumberEvent(this.phoneNumber);
}

class VerifyOTPCodeEvent extends PhoneAuthenticationEvent {
  final String smsCode;
  final bool otpVerified;

  VerifyOTPCodeEvent(this.smsCode, this.otpVerified);
}
