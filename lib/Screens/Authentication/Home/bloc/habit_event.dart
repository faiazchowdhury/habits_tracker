part of 'habit_bloc.dart';

@immutable
abstract class HabitEvent {}

class createHabit extends HabitEvent {
  final String title, category, frequency, startDate, notes;

  createHabit({
    required this.title,
    required this.category,
    required this.frequency,
    required this.startDate,
    required this.notes,
  });
}

class getHabit extends HabitEvent {}

class changeCompleted extends HabitEvent{
  final bool flag;
  final String doc;

  changeCompleted({required this.flag, required this.doc});
}
