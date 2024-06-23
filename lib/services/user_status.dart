import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class UserStatusService extends WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserStatusService() {
    WidgetsBinding.instance.addObserver(this);
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        setUserStatus(true);
      } else {
        setUserStatus(false);
      }
    });

    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (_auth.currentUser != null) {
        setUserStatus(!result.contains(ConnectivityResult.none));
      }
    });
  }

  Future<void> setUserStatus(bool isOnline) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference docRef = _firestore.collection('status').doc(user.uid);
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update({
          'isOnline': isOnline,
          'lastSeen': FieldValue.serverTimestamp(),
        });
      } else {
        await docRef.set({
          'isOnline': isOnline,
          'lastSeen': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_auth.currentUser != null) {
      if (state == AppLifecycleState.resumed) {
        setUserStatus(true);
      } else if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.inactive ||
          state == AppLifecycleState.detached) {
        setUserStatus(false);
      }
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
