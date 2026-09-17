import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/event_model.dart';
import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription? _eventsSubscription;

  EventCubit() : super(EventInitial()) {
    getEvents();
  }

  void getEvents() {
    emit(EventLoading());
    final user = _auth.currentUser;
    if (user == null) {
      emit(EventError("User not logged in"));
      return;
    }

    _eventsSubscription?.cancel();
    _eventsSubscription = _firestore
        .collection('events')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .listen((snapshot) {
      final events = snapshot.docs
          .map((doc) => EventModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      emit(EventLoaded(events));
    }, onError: (error) {
      emit(EventError(error.toString()));
    });
  }

  Future<void> addEvent(EventModel event) async {
    try {
      final docRef = _firestore.collection('events').doc();
      final newEvent = event.copyWith(id: docRef.id);
      await docRef.set(newEvent.toMap());
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> updateEvent(EventModel event) async {
    try {
      await _firestore.collection('events').doc(event.id).update(event.toMap());
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> toggleFavorite(EventModel event) async {
    try {
      await _firestore
          .collection('events')
          .doc(event.id)
          .update({'isFavorite': !event.isFavorite});
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _eventsSubscription?.cancel();
    return super.close();
  }
}
