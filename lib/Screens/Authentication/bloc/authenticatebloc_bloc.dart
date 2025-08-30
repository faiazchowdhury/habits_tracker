// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authenticatebloc_event.dart';
part 'authenticatebloc_state.dart';

class AuthenticateblocBloc
    extends Bloc<AuthenticateblocEvent, AuthenticateblocState> {
  AuthenticateblocBloc() : super(AuthenticateblocInitial()) {
    on<AuthenticateblocEvent>((event, emit) async {
      if (event is resgisterUser) {
        try {
          emit(AuthenticateblocLoading());
          final pref = await SharedPreferences.getInstance();
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: event.email,
                password: event.password,
              );
          if (userCredential.user != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user!.uid)
                .set({
                  'name': event.name,
                  'email': event.email,
                  'gender': event.gender,
                });
          }
          pref.setString("token", userCredential.user!.uid);
          pref.setString("name", event.name);
          emit(
            AuthenticateblocLoaded(
              statusCode: 200,
              response: userCredential.user!.uid,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(AuthenticateblocLoaded(statusCode: 0, response: e.message!));
        }
      }

      if (event is loginUser) {
        emit(AuthenticateblocLoading());
        try {
          final prefs = await SharedPreferences.getInstance();
          UserCredential user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                email: event.email,
                password: event.password,
              );
          DocumentSnapshot res = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.user!.uid)
              .get();
          prefs.setString('token', user.user!.uid);
          prefs.setString('name', res['name']);
          emit(AuthenticateblocLoaded(statusCode: 200, response: ""));
        } on FirebaseAuthException catch (e) {
          emit(AuthenticateblocLoaded(statusCode: 0, response: e.message!));
        }
      }
    });
  }
}
