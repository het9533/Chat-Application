import 'dart:io';

import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_events.dart';
import 'package:chat_app/features/Presentation/Bloc/profile_page_bloc/profile_page_states.dart';
import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/data/entity/user_session.dart';
import 'package:chat_app/features/dependencyInjector/injector.dart';
import 'package:chat_app/features/domain/usecase/firebase_firestore_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePageBloc extends Bloc<ProfilePageEvents, ProfilePageState> {
      final _userSession = sl<UserSession>();
  final FirebaseFirestoreUseCase firebaseFirestoreUseCase;
  ProfilePageBloc(this.firebaseFirestoreUseCase) : super(ProfilePageInitial()) {
    on<FetchUserDetailsEvent>(_fetchUserDetails);
    on<UpdateUserDetailsEvent>(_updateUserDetails);
    on<ToggleEditModeEvent>(_toggleEditMode);
    on<ContinueButtonEvent>(_continueButton);
    on<SaveChangesEvent>(_saveChanges);
  }

  Future<void> _fetchUserDetails(
      FetchUserDetailsEvent event, Emitter<ProfilePageState> emit) async {
    try {
      final _userSession = sl<UserSession>();
      final user = FirebaseAuth.instance.currentUser;
      _userSession.userDetails =
          await firebaseFirestoreUseCase.getCurrentUserDetails(user!.uid);
      emit(ProfileLoadedState(
          userDetails: UserDetails(
            signUpType: event.userDetails.signUpType,
        userName: _userSession.userDetails!.userName ?? "",
        userId: _userSession.userDetails!.userId ?? "",
        email: _userSession.userDetails!.email ?? "",
        firstName: _userSession.userDetails!.firstName ?? "",
        lastName: _userSession.userDetails!.lastName ?? "",
        imagepath: _userSession.userDetails!.imagepath ?? "",
        number: _userSession.userDetails!.number ?? "",
        password: _userSession.userDetails!.password ?? "",
      )));
    } catch (error) {
      emit(ProfileErrorState(error: error.toString()));
    }
  }

  Future<void> _updateUserDetails(
      UpdateUserDetailsEvent event, Emitter<ProfilePageState> emit) async {
    try {
      await firebaseFirestoreUseCase.updateUser(UserDetails(
        signUpType: event.userDetails.signUpType,
          userName: event.userDetails.userName,
          userId: event.userDetails.userId,
          email: event.userDetails.email,
          firstName: event.userDetails.firstName,
          lastName: event.userDetails.lastName,
          imagepath: event.userDetails.imagepath,
          number: event.userDetails.number,
          password: event.userDetails.password));

      emit(ProfileLoadedState(
          userDetails: UserDetails(
            signUpType: event.userDetails.signUpType,
            userName: event.userDetails.userName,
            userId: event.userDetails.userId,
              email: event.userDetails.email,
              firstName: event.userDetails.firstName,
              lastName: event.userDetails.lastName,
              imagepath: event.userDetails.imagepath,
              number: event.userDetails.number,
              password: event.userDetails.password)));
    } catch (error) {
      emit(ProfileErrorState(error: error.toString()));
    }
  }

  Future<void> _toggleEditMode(
      ToggleEditModeEvent event, Emitter<ProfilePageState> emit) async {
    try {
      if (event.editMode) {
        emit(EditingModeEnabledState(editMode: true));
      } else {
        emit(EditingModeDisabledState(editMode: false));
      }
    } catch (error) {
      emit(ProfileErrorState(error: error.toString()));
    }
  }

  Future<void> _continueButton(
      ContinueButtonEvent event, Emitter<ProfilePageState> emit) async {
    try {
      emit(ContinueButtonState());
    } catch (error) {
      emit(ProfileErrorState(error: error.toString()));
    }
  }

  Future<void> _saveChanges(
      SaveChangesEvent event, Emitter<ProfilePageState> emit) async {
    try {

        if (event.image != null) {
        File file = File(event.image!.path);
        final storageRef = FirebaseStorage.instance.ref();
        final imageref = await storageRef
            .child("UserProfile/user_${_userSession.userDetails?.email}")
            .putFile(file);
        final imageUrl = await imageref.ref.getDownloadURL();
        event.userDetails.imagepath = imageUrl;
      }
      final user = FirebaseAuth.instance.currentUser!;
  
      final bool docExist =
          await firebaseFirestoreUseCase.checkIfDocExists(user.uid);
      
      final bool doesUserNameUserExist = _userSession.userDetails!.userName == null ? await firebaseFirestoreUseCase.doesUserNameUserExist(event.userDetails.userName!,event.userDetails.userId!) : false;
      if (docExist && !doesUserNameUserExist) {
        firebaseFirestoreUseCase.updateUser(UserDetails(
          signUpType: event.userDetails.signUpType,
          userName: event.userDetails.userName,
          userId: event.userDetails.userId,
            email: event.userDetails.email,
            firstName: event.userDetails.firstName,
            lastName: event.userDetails.lastName,
            imagepath: event.userDetails.imagepath,
            number: event.userDetails.number,
            password: event.userDetails.password));
      }

      if (!docExist && !doesUserNameUserExist) {
        firebaseFirestoreUseCase.addUser(UserDetails(
          signUpType: event.userDetails.signUpType,
          userName: event.userDetails.userName,
            userId: event.userDetails.userId,
            email: event.userDetails.email,
            firstName: event.userDetails.firstName,
            lastName: event.userDetails.lastName,
            imagepath: event.userDetails.imagepath,
            number: event.userDetails.number,
            password: event.userDetails.password));
      }
      _userSession.userDetails = UserDetails(
        signUpType: event.userDetails.signUpType,
            userName: event.userDetails.userName,
            userId: event.userDetails.userId,
              email: event.userDetails.email,
              firstName: event.userDetails.firstName,
              lastName: event.userDetails.lastName,
              imagepath: event.userDetails.imagepath,
              number: event.userDetails.number,
              password: event.userDetails.password);
      emit(ChangesSavedState(
          userDetails: _userSession.userDetails!, doesUserNameUserExist));
    } catch (error) {
      emit(ProfileErrorState(error: error.toString()));
    }
  }






  
}
