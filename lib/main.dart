import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/domain/core/resources/app_shared_preferences.dart';

import 'control/cubit/cubit.dart';
import 'control/cubit/states.dart';
import 'music_app.dart';

void main() async { // used to wait for firebase initialization before running the application

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // initializes a connection to firebase
  await AppSharedPreferences.init();
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {// shows the music player in the notification bar
    return true;
  });
  SystemChrome.setPreferredOrientations(// sets device orientation to portrait mode only
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(   // links the User interface to the application
    BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getAllMoods()
        ..getAllArtists()
        ..getAllSongs()
        ..getUserPlaylists(),
      // takes the current page we are in and the change in state and displays that change on that page on screen
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => const MusicApp(),
      ),
    ),
  );
}
