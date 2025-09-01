part of 'habit_bloc.dart';

@immutable
abstract class HabitState {}

class HabitInitial extends HabitState {}

class HabitLoading extends HabitState{}

class HabitLoaded extends HabitState{
  final int statusCode;
  final response;

  HabitLoaded({required this.statusCode, required this.response});
}
