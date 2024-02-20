abstract class PhoneAuthenticationState {}

class PhoneAuthenticationInitial extends PhoneAuthenticationState {}

class PhoneAuthenticationLoading extends PhoneAuthenticationState {}

class PhoneNumberVerifiedState extends PhoneAuthenticationState {}

class PhoneAuthenticationSuccess extends PhoneAuthenticationState {}

class PhoneAuthenticationFailure extends PhoneAuthenticationState {
  final String error;
  PhoneAuthenticationFailure(this.error);
}
