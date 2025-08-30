import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'habit_event.dart';
part 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  HabitBloc() : super(HabitInitial()) {
    on<HabitEvent>((event, emit) async {
      if (event is createHabit) {
        emit(HabitLoading());
        try {
          final prefs = await SharedPreferences.getInstance();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(prefs.getString('token'))
              .collection('habit')
              .add({
                "title": event.title,
                'category': event.category,
                'frequency': event.frequency,
                'startDate': event.startDate,
                'notes': event.notes,
                'completed': false,
              });
          emit(HabitLoaded(statusCode: 200, response: ""));
        } on FirebaseException catch (e) {
          emit(HabitLoaded(statusCode: 0, response: ""));
        }
      }

      if (event is getHabit) {
        emit(HabitLoading());
        try {
          final prefs = await SharedPreferences.getInstance();
          QuerySnapshot col = await FirebaseFirestore.instance
              .collection('users')
              .doc(prefs.getString('token'))
              .collection('habit')
              .get();
          emit(HabitLoaded(statusCode: 200, response: col.docs));
        } on FirebaseException catch (e) {
          emit(HabitLoaded(statusCode: 0, response: null));
        }
      }

      if (event is changeCompleted) {
        emit(HabitLoading());
        try {
          final prefs = await SharedPreferences.getInstance();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(prefs.getString('token'))
              .collection('habit').doc(event.doc).update({'completed':event.flag});
              QuerySnapshot col = await FirebaseFirestore.instance
              .collection('users')
              .doc(prefs.getString('token'))
              .collection('habit')
              .get();
          emit(HabitLoaded(statusCode: 200, response: col.docs));
        } on FirebaseException catch (e) {
          emit(HabitLoaded(statusCode: 0, response: null));
        }
      }
    });
  }
}
