import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_events.dart';
import 'package:chat_app/features/Presentation/Bloc/authbloc/authentication_states.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/domain/repository/authentication_repository.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final FirebaseFirestoreUseCase firebaseFirestoreUseCase;
  AuthenticationBloc({ required this.firebaseFirestoreUseCase,required  this.authenticationRepository})
      : super(AuthenticationInitial()) {
    on<AuthenticationStartedEvent>(_onAuthenticationStarted);
    on<GoogleSignInRequestedEvent>(_onGoogleSignInRequested);
    on<EmailSignInRequestedEvent>(_onEmailSignInRequested);
    on<EmailSignUpRequestedEvent>(_onSignUpRequested);
    on<LogoutRequestedEvent>(_onLogoutRequested);
     on<AuthentticatedUserEvent>(_onAuthentticatedUser);
  }

  Future<void> _onAuthenticationStarted(
      AuthenticationStartedEvent event, Emitter<AuthenticationState> emit) async {
        emit(AuthenticationLoading());
    try {
      Either<User, String> userOption =
          await authenticationRepository.getCurrentUser();
          final user = FirebaseAuth.instance.currentUser;
        final bool isUserExist = await firebaseFirestoreUseCase.checkIfDocExists(user!.uid);
   
      userOption.fold(
        (user) => emit(AuthenticationSuccess(user,isUserExist,)),
        (r) => emit(AuthenticationFailure(r.toString())),
      );
    }  on FirebaseAuthException catch(e) {
          emit(AuthenticationFailure(e.message ?? ""));
        }
  }
void _onAuthentticatedUser(AuthentticatedUserEvent event, Emitter<AuthenticationState> emit) async{
    emit(AuthenticationLoading());
    try {
      final userOption = await authenticationRepository.getCurrentUser();
      final user = FirebaseAuth.instance.currentUser;
        final bool isUserExist = await firebaseFirestoreUseCase.checkIfDocExists(user!.uid);
    
      userOption.fold(
        (user) => emit(AuthenticationSuccess(user,isUserExist,)),
         (error) => emit(AuthenticationFailure("Error signing in with Google")),
      );
    }  on FirebaseAuthException catch(e) {
          emit(AuthenticationFailure(e.message ?? ""));
        }
}

  void  _onGoogleSignInRequested(
      GoogleSignInRequestedEvent event, Emitter<AuthenticationState> emit,) async {
    emit(AuthenticationLoading());
    try {
 
      final Either<User, String> userOption = await authenticationRepository.signInWithGoogle();
      final user = FirebaseAuth.instance.currentUser;
      print(user?.displayName);
      bool isUserExist = await firebaseFirestoreUseCase.checkIfDocExists(user!.uid);
      print(">>>>>>>>>>>>>>>>$isUserExist<<<<<<<<<<<<");

      
      userOption.fold((l,) => emit(AuthenticationSuccess(l,isUserExist)), (r) => emit(AuthenticationFailure("Error signing in with Google")));
      // userOption.fold(
      //   (user) => emit(AuthenticationSuccess(user)),
      //    (error) => emit(AuthenticationFailure("Error signing in with Google")),
      // );
      
    }on FirebaseAuthException  catch(e) {
          emit(AuthenticationFailure(e.message ?? ""));
        }
  }
  

  void _onEmailSignInRequested(
      EmailSignInRequestedEvent event, Emitter<AuthenticationState> emit) async {
        emit(AuthenticationLoading());
    try {
      final userOption = await authenticationRepository.signInWithEmail(UserDetails(
        signUpType: SignUpType.email,
        userName: event.user.userName,
        userId: event.user.userId,
        firstName: event.user.firstName, 
        lastName: event.user.lastName,
        email: event.user.email, number: event.user.number, password: event.user.password));
      final user = FirebaseAuth.instance.currentUser;
        final bool isUserExist =  user!=null ? await firebaseFirestoreUseCase.checkIfDocExists(user.uid) : false;
     
      userOption.fold(
        (user) => emit(AuthenticationSuccess(user,isUserExist,)),
         (error) => emit(AuthenticationFailure("Error signing in with Google")),
      );
    }  on FirebaseAuthException catch(e) {
      print(e.message);
          emit(AuthenticationFailure(e.message ?? ""));
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
      EmailSignUpRequestedEvent event, Emitter<AuthenticationState> emit) async {
   emit(AuthenticationLoading());
    try {
      final userOption = await authenticationRepository.createAccountWithEmail(UserDetails(
        signUpType: SignUpType.email,
        userName: event.user.userName,
        userId: event.user.userId,
        firstName: event.user.firstName,
        lastName: event.user.lastName,
         email: event.user.email, number: event.user.number, password: event.user.password));
         final user = FirebaseAuth.instance.currentUser;
        final bool isUserExist = await firebaseFirestoreUseCase.checkIfDocExists(user!.uid);
      
      userOption.fold(
        (user) => emit(AuthenticationSuccess(user,isUserExist )),
         (error) => emit(AuthenticationFailure("Error signing in with Google")),
      );
    }  on FirebaseAuthException catch(e) {
          emit(AuthenticationFailure(e.message ?? "error"));
        }
  
  }

  void _onLogoutRequested(
      LogoutRequestedEvent event, Emitter<AuthenticationState> emit) async {
emit(AuthenticationLoading());
    try {
       
      final success = await authenticationRepository.signout();
    
          if (success) {
            emit(LogoutSucessState());
          }
        } on FirebaseAuthException catch(e) {
          emit(AuthenticationFailure(e.message ?? ""));
        }
    
  }
}