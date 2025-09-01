import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      if (event is getProfileInfo) {
        emit(ProfileLoading());
        try {
          final prefs = await SharedPreferences.getInstance();
          DocumentSnapshot res = await FirebaseFirestore.instance
              .collection('users')
              .doc(prefs.getString('token'))
              .get();
          emit(ProfileLoaded(statusCode: 200, response: res));
        } on FirebaseAuthException catch (e) {
          emit(ProfileLoaded(statusCode: 0, response: e.message!));
        }
      }

      if (event is updateProfile) {
        emit(ProfileLoading());
        try {
          final prefs = await SharedPreferences.getInstance();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(prefs.getString('token'))
              .update({'name': event.name, 'gender': event.gender});
          DocumentSnapshot col = await FirebaseFirestore.instance
              .collection('users')
              .doc(prefs.getString('token'))
              .get();
          emit(ProfileLoaded(statusCode: 200, response: col));
        } on FirebaseException catch (e) {
          emit(ProfileLoaded(statusCode: 0, response: null));
        }
      }
    });
  }
}
