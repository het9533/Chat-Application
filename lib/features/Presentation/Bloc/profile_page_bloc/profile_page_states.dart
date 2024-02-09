import 'package:chat_app/features/data/entity/user.dart';

abstract class ProfilePageState {}
class ProfilePageInitial extends ProfilePageState {}


class ProfileLoadingState extends ProfilePageState {}

class ProfileLoadedState extends ProfilePageState {
  final UserDetails userDetails;

  ProfileLoadedState({required this.userDetails});
}

class ProfileErrorState extends ProfilePageState{
  final String error;

  ProfileErrorState({required this.error});
}

class EditingModeEnabledState extends ProfilePageState {
 final bool editMode;

  EditingModeEnabledState({required this.editMode});
}

class EditingModeDisabledState extends ProfilePageState {
  final bool editMode;

  EditingModeDisabledState({required this.editMode});
}


class ChangesSavedState extends ProfilePageState {
  final UserDetails userDetails;
  final bool doesUserNameUserExist;

  ChangesSavedState(this.doesUserNameUserExist, {required this.userDetails});
}


class AccountDeletedState extends ProfilePageState {}

class ContinueButtonState extends ProfilePageState{}
