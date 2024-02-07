import 'package:chat_app/features/data/entity/user.dart';

abstract class ProfilePageEvents {}

class FetchUserDetailsEvent extends ProfilePageEvents {
  final UserDetails userDetails;
  FetchUserDetailsEvent({required this.userDetails});
}

class UpdateUserDetailsEvent extends ProfilePageEvents {
  final UserDetails userDetails;

  UpdateUserDetailsEvent({required this.userDetails});
}



class ToggleEditModeEvent extends ProfilePageEvents {
  final bool editMode;

  ToggleEditModeEvent({required this.editMode});
}
class ContinueButtonEvent extends ProfilePageEvents{}

class SaveChangesEvent extends ProfilePageEvents {
   final UserDetails userDetails;

  SaveChangesEvent({required this.userDetails});
}


