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

class changeCompleted extends HabitEvent {
  final bool flag;
  final String doc;

  changeCompleted({required this.flag, required this.doc});
}

class getQuote extends HabitEvent {}

class favQuote extends HabitEvent {
  final String quote, author;
  final BuildContext context;
  favQuote({required this.quote, required this.author, required this.context});
}

class getFavoriteList extends HabitEvent{}

class deleteFavorite extends HabitEvent{
  final String uid;

  deleteFavorite({required this.uid});
}