part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class getProfileInfo extends ProfileEvent{}

class updateProfile extends ProfileEvent{
    final String name,gender;

  updateProfile({required this.name, required this.gender});
}
