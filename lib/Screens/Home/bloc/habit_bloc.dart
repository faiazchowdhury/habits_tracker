import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
              .collection('habit')
              .doc(event.doc)
              .update({'completed': event.flag});
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

      if (event is getQuote) {
        emit(HabitLoading());
        final res = await http.get(
          Uri.parse("https://zenquotes.io/api/quotes"),
        );
        final quote = jsonDecode(res.body);
        emit(HabitLoaded(statusCode: 200, response: quote));
      }

      if (event is favQuote) {
        emit(HabitLoading());
        try {
          final prefs = await SharedPreferences.getInstance();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(prefs.getString('token'))
              .collection('favorites')
              .add({"quote": event.quote, "author": event.author});
          ScaffoldMessenger.of(
            event.context,
          ).showSnackBar(SnackBar(content: Text("Quote saved to Favorites")));
          emit(HabitLoaded(statusCode: 200, response: ""));
        } on FirebaseException catch (e) {
          emit(HabitLoaded(statusCode: 0, response: ""));
        }
      }

      if (event is getFavoriteList) {
        emit(HabitLoading());
        try {
          final prefs = await SharedPreferences.getInstance();
          QuerySnapshot col = await FirebaseFirestore.instance
              .collection('users')
              .doc(prefs.getString('token'))
              .collection('favorites')
              .get();
          emit(HabitLoaded(statusCode: 200, response: col));
        } on FirebaseException catch (e) {
          emit(HabitLoaded(statusCode: 0, response: null));
        }
      }

      if (event is deleteFavorite) {
        emit(HabitLoading());
        try {
          final prefs = await SharedPreferences.getInstance();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(prefs.getString('token'))
              .collection('favorites').doc(event.uid).delete();
          QuerySnapshot col = await FirebaseFirestore.instance
              .collection('users')
              .doc(prefs.getString('token'))
              .collection('favorites')
              .get();
          emit(HabitLoaded(statusCode: 200, response: col));
        } on FirebaseException catch (e) {
          emit(HabitLoaded(statusCode: 0, response: null));
        }
      }
    });
  }
}
