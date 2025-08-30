part of 'authenticatebloc_bloc.dart';

@immutable
abstract class AuthenticateblocState {}

class AuthenticateblocInitial extends AuthenticateblocState {}

class AuthenticateblocLoading extends AuthenticateblocState{}

class AuthenticateblocLoaded extends AuthenticateblocState{
  final int statusCode;
  final String response;

  AuthenticateblocLoaded({required this.statusCode, required this.response});
}




