abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileUpdated extends UserProfileState {}

class UserProfileError extends UserProfileState {
  final String errorMessage;

  UserProfileError(this.errorMessage);
}

class UserProfilePhotoUpdated extends UserProfileState {
  final String photoUrl;

  UserProfilePhotoUpdated(this.photoUrl);
}
