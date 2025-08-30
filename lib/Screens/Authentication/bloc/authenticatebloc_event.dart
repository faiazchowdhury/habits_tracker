part of 'authenticatebloc_bloc.dart';

@immutable
abstract class AuthenticateblocEvent {}

class resgisterUser extends AuthenticateblocEvent{
  final String name,password,email,gender;

  resgisterUser({required this.name, required this.password, required this.email, required this.gender});
}

class loginUser extends AuthenticateblocEvent{
  final String email, password;

  loginUser({required this.email, required this.password});
}