import 'package:flutter/material.dart';
import 'dart:convert';

InputDecoration textInputDecoration(
    {required String hintText, required ColorScheme colorScheme}) {
  return InputDecoration(
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2.0, color: colorScheme.secondary),
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: colorScheme.primary)));
}

double calculatePostion(key1, key2) {
  // key1: buttonContainer
  // key2: button

  RenderBox renderbox1 = key1.currentContext?.findRenderObject() as RenderBox;
  Offset position1 = renderbox1.localToGlobal(Offset.zero);

  double x1 = position1.dx;

  RenderBox renderbox2 = key2.currentContext?.findRenderObject() as RenderBox;
  Offset position2 = renderbox2.localToGlobal(Offset.zero);
  double x2 = position2.dx;

  return x2 - x1;
}

double currentPosition(key1, key2) {
  RenderBox renderbox1 = key1.currentContext?.findRenderObject() as RenderBox;
  Offset position1 = renderbox1.localToGlobal(Offset.zero);

  double x1 = position1.dx;

  RenderBox renderbox2 = key2.currentContext?.findRenderObject() as RenderBox;
  Offset position2 = renderbox2.localToGlobal(Offset.zero);
  double x2 = position2.dx;

  return x2 - x1;
}

String emptyPlaylistImage = "https://firebasestorage.googleapis.com/v0/b/music-sharer-6bc5b.appspot.com/o/playlist_images%2FEmptyPlaylistImage.png?alt=media&token=a7758813-2dca-4ec4-bd78-2174a58be647";
String likedSongPlaylistImage = "https://firebasestorage.googleapis.com/v0/b/music-sharer-6bc5b.appspot.com/o/playlist_images%2FLikedSongPlaylistImage.png?alt=media&token=20aba524-3c9f-4786-8e6e-6cfa831b9085";