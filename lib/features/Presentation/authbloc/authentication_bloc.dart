import 'package:chat_app/features/Presentation/authbloc/authentication_events.dart';
import 'package:chat_app/features/Presentation/authbloc/authentication_states.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/domain/repository/authentication_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;

  AuthenticationBloc({required  this.authenticationRepository})
      : super(AuthenticationInitial()) {
    on<AuthenticationStarted>(_onAuthenticationStarted);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<EmailSignInRequested>(_onEmailSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthenticationStarted(
      AuthenticationStarted event, Emitter<AuthenticationState> emit) async {
    try {
      Either<User, String> userOption =
          await authenticationRepository.getCurrentUser();
      userOption.fold(
        (user) => emit(AuthenticationSuccess(user)),
        (r) => emit(AuthenticationFailure(r.toString())),
      );
    } catch (error) {
      emit(AuthenticationFailure(error.toString()));
    }
  }

  Future<void> _onGoogleSignInRequested(
      GoogleSignInRequested event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      final Either<User, String>  userOption = await authenticationRepository.signInWithGoogle();
      userOption.fold((l) => emit(AuthenticationSuccess(l)), (r) => emit(AuthenticationFailure("Error signing in with Google")));
      // userOption.fold(
      //   (user) => emit(AuthenticationSuccess(user)),
      //    (error) => emit(AuthenticationFailure("Error signing in with Google")),
      // );
      
    }on Exception catch (error) {
      emit(AuthenticationFailure(error.toString()));
    }
  }

  void _onEmailSignInRequested(
      EmailSignInRequested event, Emitter<AuthenticationState> emit) async {
        emit(AuthenticationLoading());
    try {
      final userOption = await authenticationRepository.createAccountWithEmail(UserDetails(
        displayName: event.user.displayName, email: event.user.email, number: event.user.number, password: event.user.password));
      userOption.fold(
        (user) => emit(AuthenticationSuccess(user)),
         (error) => emit(AuthenticationFailure("Error signing in with Google")),
      );
    } catch (error) {
      emit(AuthenticationFailure(error.toString()));
    }
  
  }

  // void _onOTPSignInRequested(
  //     OTPSignInRequested event, Emitter<AuthenticationState> emit) async {
  //   emit(AuthenticationLoading());
  //   try {
  //     final userOption = await loginWithOTP.execute(event.otp).fold(
  //           (user) => Some(user),
  //           (error) => None(),
  //         );

  //     userOption.fold(
  //       () => emit(AuthenticationFailure("Error signing in with OTP")),
  //       (user) => emit(AuthenticationSuccess(user)),
  //     );
  //   } catch (error) {
  //     emit(AuthenticationFailure(error.toString()));
  //   }
  // }

  void _onSignUpRequested(
      SignUpRequested event, Emitter<AuthenticationState> emit) async {
   emit(AuthenticationLoading());
    try {
      final userOption = await authenticationRepository.createAccountWithEmail(UserDetails(
        displayName: event.user.displayName, email: event.user.email, number: event.user.number, password: event.user.password));
      userOption.fold(
        (user) => emit(AuthenticationSuccess(user)),
         (error) => emit(AuthenticationFailure("Error signing in with Google")),
      );
    } catch (error) {
      emit(AuthenticationFailure(error.toString()));
    }
  
  }

  void _onLogoutRequested(
      LogoutRequested event, Emitter<AuthenticationState> emit) async {
    try {
      final success = await authenticationRepository.signout();
    
          if (success) {
            emit(AuthenticationInitial());
          }
        } on Exception catch(e) {
          emit(AuthenticationFailure(e.toString()));
        }
    
  }
}
