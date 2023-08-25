import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_sharer/models/song.dart';

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference songCollection =
      FirebaseFirestore.instance.collection("songs");

  final CollectionReference artistCollection =
      FirebaseFirestore.instance.collection("artists");

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future addSong(String songTitle, String artist, String file) async {
    return await songCollection
        .add({"songTitle": songTitle, "artist": artist, "file": file});
  }

  Future getArtistInfo(String artistId) async {
    late Object result;
    await artistCollection.doc(artistId).get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        print("data is loaded");

        result = documentSnapshot;
      } else {
        print('Document does not exist on the database');
      }
    });
    return result;
  }

  Future<List<Song>> getPopularTracks(String artistId) async {
    late List<Song> result;
    await artistCollection.doc(artistId).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          List<dynamic> popularTracks = documentSnapshot.get("popularTracks");

          result = popularTracks.map<Song>((song) {
            return Song(
                songTitle: song["songTitle"] ?? "hello",
                artist: song["artist"] ?? "hello",
                artistId: song["artistId"],
                songImageUrl: song["songImageUrl"],
                songUrl: song["songUrl"] ?? "hello");
          }).toList();
        } else {
          print("Document does not exist on the database");
        }
      },
      onError: (e) {
        print("Error getting document: $e");
      },
    );

    return result;
  }

  Future<Map> getLibraryInfo() async {
    String userId = _auth.currentUser?.uid ?? "";
    Map result = {};
    await userCollection
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map likedSongs = documentSnapshot.get("likedSongs");

      likedSongs["songs"] = likedSongs["songs"].map<Song>((song) {
        return Song(
            songTitle: song["songTitle"] ?? "hello",
            artist: song["artist"] ?? "hello",
            artistId: song["artistId"],
            songImageUrl: song["songImageUrl"],
            songUrl: song["songUrl"] ?? "hello");
      }).toList();

      List playlists = documentSnapshot.get("playlists");

      for (Map playlist in playlists) {
        playlist["songs"] = playlist["songs"].map<Song>((song) {
          return Song(
              songTitle: song["songTitle"] ?? "hello",
              artist: song["artist"] ?? "hello",
              artistId: song["artistId"],
              songImageUrl: song["songImageUrl"],
              songUrl: song["songUrl"] ?? "hello");
        }).toList();
      }

      result["likedSongs"] = likedSongs;
      result["playlists"] = playlists;
    });

    return result;
  }

  Future createPlaylist(Map playlist) async {
    String userId = _auth.currentUser?.uid ?? "";

    await userCollection.doc(userId).update({
      "playlists": FieldValue.arrayUnion([playlist])
    });
  }

  Future getUserInfo() async {
    String userId = _auth.currentUser?.uid ?? "";

    if (userId == "") {
      return null;
    }

    print("this is userId ${userId}");

    Map result = {};
    await userCollection
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      result = documentSnapshot.data() as Map;
      result["userId"] = userId;
    });

    return result;
  }

  Future likeSong(Song song, bool alreadyLiked) async {
    String userId = _auth.currentUser?.uid ?? "";

    if (alreadyLiked == false) {
      await userCollection.doc(userId).update({
        "likedSongs.songs": FieldValue.arrayUnion([song.toMap()])
      });
    } else {
      await userCollection.doc(userId).update({
        "likedSongs.songs": FieldValue.arrayRemove([song.toMap()])
      });
    }

    return await getUserInfo();
  }

  Future addSongToPlaylist(Song song, int index) async {
    String userId = _auth.currentUser?.uid ?? "";

    List playlists = [];
    await userCollection.doc(userId).get().then(
        (DocumentSnapshot snapshot) => playlists = snapshot.get("playlists"));
    playlists[index]["songs"].add(song.toMap());
    await userCollection.doc(userId).update({"playlists": playlists});

    print("Song added to playlist");
  }

  Future removeSongToPlaylist(Song toBeDeletedSong, int index) async {
    List playlists = [];

    String userId = _auth.currentUser?.uid ?? "";
    await userCollection.doc(userId).get().then(
        (DocumentSnapshot snapshot) => playlists = snapshot.get("playlists"));

    playlists[index]["songs"].removeWhere((song) =>
        song["songTitle"] == toBeDeletedSong.songTitle &&
        song["artist"] == toBeDeletedSong.artist);

    await userCollection.doc(userId).update({"playlists": playlists});

    print("Song deleted from playlist");
  }

  Future getPlaylist(int index) async {
    List playlists = [];

    String userId = _auth.currentUser?.uid ?? "";
    await userCollection.doc(userId).get().then(
        (DocumentSnapshot snapshot) => playlists = snapshot.get("playlists"));

    return playlists[index];
  }

  Future getLikedSongs() async {
    Map playlist = {};

    String userId = _auth.currentUser?.uid ?? "";
    await userCollection.doc(userId).get().then(
        (DocumentSnapshot snapshot) => playlist = snapshot.get("likedSongs"));

    return playlist;
  }

  Future editPlaylistTitle(String playlistTitle, int playlistIndex) async {
    List playlists = [];

    String userId = _auth.currentUser?.uid ?? "";
    await userCollection.doc(userId).get().then(
        (DocumentSnapshot snapshot) => playlists = snapshot.get("playlists"));

    playlists[playlistIndex]["playlistTitle"] = playlistTitle;
    await userCollection.doc(userId).update({"playlists": playlists});

    print("Edited playlist title");
  }

  Future deletePlaylist(int playlistIndex) async {
    List playlists = [];

    String userId = _auth.currentUser?.uid ?? "";
    await userCollection.doc(userId).get().then(
        (DocumentSnapshot snapshot) => playlists = snapshot.get("playlists"));

    playlists.removeAt(playlistIndex);
    await userCollection.doc(userId).update({"playlists": playlists});

    print("Deleted playlist");
  }
  // Future<String> getDownloadURL(String fileName) async {
  //   try {
  //     return await FirebaseStorage.instance
  //         .ref()
  //         .child(fileName)
  //         .getDownloadURL();
  //   } catch (e) {
  //     return "";
  //   }
  // }

  // song list from snapshot
  List<Song> _songListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map<Song>((doc) {
      return Song(
          songTitle: doc.get("songTitle") ?? "hello",
          artist: doc.get("artist") ?? "hello",
          songImageUrl: doc.get("songImageUrl"),
          songUrl: doc.get("songUrl") ?? "hello");
    }).toList();
  }

  Stream<List<Song>> get songs {
    return songCollection.snapshots().map(_songListFromSnapshot);
  }

  Future<List<Song>> getAllSongs() async {
    List<Song> songs = [];
    await songCollection.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        songs.add(Song(
            artist: doc.get("artist"),
            artistId: doc.get("artistId"),
            songTitle: doc.get("songTitle"),
            songImageUrl: doc.get("songImageUrl"),
            songUrl: doc.get("songUrl")));
      }
    });
    return songs;
  }
}
