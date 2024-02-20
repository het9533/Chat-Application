import 'package:bloc/bloc.dart';
import 'package:chat_app/features/domain/repository/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'phone_authentication_events.dart';
import 'phone_authentication_states.dart';

class PhoneAuthenticationBloc
    extends Bloc<PhoneAuthenticationEvent, PhoneAuthenticationState> {
  final AuthenticationRepository authenticationRepository;

  PhoneAuthenticationBloc({required this.authenticationRepository})
      : super(PhoneAuthenticationInitial()) {
    on<VerifyPhoneNumberEvent>(_verifyPhoneNumberEvent);
    on<VerifyOTPCodeEvent>(_verifyOtpCodeEvent);
  }

  Future<void> _verifyPhoneNumberEvent(VerifyPhoneNumberEvent event,
      Emitter<PhoneAuthenticationState> emit) async {
    try {
      emit(PhoneAuthenticationLoading());

      await authenticationRepository.verifyPhoneNumber(event.phoneNumber);

      emit(PhoneNumberVerifiedState());
    } on FirebaseException catch (e) {
      emit(PhoneAuthenticationFailure(e.message??''));
    }
  }

  Future<void> _verifyOtpCodeEvent(
      VerifyOTPCodeEvent event, Emitter<PhoneAuthenticationState> emit) async {
    try {
      emit(PhoneAuthenticationLoading());

      await authenticationRepository.verifyOTPCode(
        event.smsCode,
      );

      emit(PhoneAuthenticationSuccess());
    } on FirebaseException catch (e) {
      emit(PhoneAuthenticationFailure(e.message??''));
    }
  }
}
