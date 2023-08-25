import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_sharer/models/myUser.dart';
import 'package:music_sharer/shared/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // create user obj based on FirebaseUser
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<MyUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  // sign in anon
  Future signInAnnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();

      await _db.collection("users").doc(result.user!.uid).set({
        "email": "",
        "likedSongs": {"playlistImage": likedSongPlaylistImage, "songs": []},
        "playlists": []
      });

      User user = result.user!;
      return MyUser(uid: user.uid);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in wiht email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _db.collection("users").doc(result.user!.uid).set({
        "email": email,
        "likedSongs": {"playlistImage": likedSongPlaylistImage, "songs": []},
        "playlists": []
      });

      User user = result.user!;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
