import 'package:chat_app/features/data/entity/user.dart';
import 'package:chat_app/features/data/entity/user_session.dart';

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

  ChangesSavedState({required this.userDetails});
}


class AccountDeletedState extends ProfilePageState {}

class ContinueButtonState extends ProfilePageState{}
