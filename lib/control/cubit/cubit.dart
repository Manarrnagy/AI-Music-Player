import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:music_app/control/core/save_user_data.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_assets_paths.dart';
import 'package:music_app/domain/core/resources/app_shared_preferences.dart';
import 'package:music_app/models/artist_model.dart';
import 'package:music_app/models/mood_model.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/music_app.dart';
import 'package:music_app/ui/core/components.dart';
import 'package:music_app/ui/view/explore/explore_page.dart';
import 'package:music_app/ui/view/home/home_page.dart';
import 'package:tflite/tflite.dart';

import '../../models/user_model.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  IconData visibility = Icons.visibility_outlined;
  bool secured = true;

  void changePasswordVisibility() {
    secured = !secured;
    visibility =
        secured ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(OnChangePasswordVisibilityState());
  }

  /// Navigation bar
  int currentIndex = 0;

  List<Widget> pages = [
    const HomePage(),
    const ExplorePage(),
  ];

  void changeNavBar(int index) {
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  ///Capturing Image from Camera
  //Capturing Image from Camera and Running the CNN model on this Image using Tflite to get mood label
  String moodImagePath = ''; //stores path of picked image
  String output = '';

  Future<void> pickMoodImage() async {
    output = ''; //stores label of mood
    loadModel(); //loads tflite model
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery, //picks image using camera
    );
    moodImagePath = File(pickedFile!.path).path;
    var predictions = await Tflite.runModelOnImage(
        //running the model on captured image and storing predicted label
        path: moodImagePath,
        imageMean: 0.0, // defaults to 117.0
        imageStd: 800.0, // defaults to 1.0
        numResults: 1, // defaults to 5
        threshold: 0.3, // defaults to 0.1
        asynch: true // defaults to true
        );
    for (var element in predictions!) {
      output =
          element['label']; //storing the label from predictions into output
      emit(ImagePickedOnSuccessState()); //viewing captured image
    }
    AppComponents.showToast(
        text: output, states: ToastStates.grey); //output the mood label
    if (kDebugMode) {
      print(output);
    }
  }

  ///loading the CNN model
  //using tflite to run teh cnn model
  loadModel() async {
    await Tflite.loadModel(
      model: AppAssets.moodModel,
      labels: AppAssets.moodLabels,
    );
  }

  ///Birthdate Calender DatePicker
  // displays Interactive Calender to pick the user's birthdate form
  DateTime selectedBirthDate = DateTime.now();
  var birthDateController = TextEditingController();
  Future<void> selectDate(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: selectedBirthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((value) {
      selectedBirthDate = value!;
      birthDateController.text = DateFormat.yMMMd().format(value);
      emit(SelectBirthDateOnSuccessState());
    });
  }

  /// Login using Firebase Authentication
  //Authenticating the user data  and Comparing it with the ones stored in firebase
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginOnLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      //sending Email and password to Authenticate
      email: email,
      password: password,
    )
        .then((value) {
      getUserData(uId: value.user!.uid); //Getting user data using the user Id
      MusicApp.isLoggedIn = true;
      // AppSharedPreferences.setData(
      //     key: AppSharedPreferences.isLoggedInKey, value: true);
      AppSharedPreferences()
          .saveIsLoggedIn(true); //Saving Logged In state to user preferences
      // AppSharedPreferences.setData(
      //     key: AppSharedPreferences.uId, value: value.user!.uid);
      AppSharedPreferences()
          .saveUID(value.user!.uid); // saving User ID to App preferences
      emit(LoginOnSuccessState());
    }).catchError((error) {
      emit(
        LoginOnFailedState(error.toString()),
      );
    });
  }

  /// Register
  //Creating new user and sending user's info to firebase
  void userRegister({
    required String name,
    required String email,
    required String password,
    required Timestamp birthDate,
  }) {
    emit(RegisterOnLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      //creating user using Firebase Authentication
      email: email,
      password: password,
    )
        .then((value) {
      createUserData(
        //Creating user Id and Initializing User Data
        uId: value.user!.uid,
        name: name,
        email: email,
        birthDate: birthDate,
      );
      MusicApp.isLoggedIn = true; //updating login status
      AppSharedPreferences()
          .saveIsLoggedIn(true); //saving logged in state in app preferences
      AppSharedPreferences()
          .saveUID(value.user!.uid); //saving user ID in app preferences
      emit(RegisterOnSuccessState());
    }).catchError((error) {
      emit(RegisterOnFailedState(error.toString()));
    });
  }

  /// Creating User Data
  //Stores User data in user data model and into firebase
  void createUserData({
    required String uId,
    required String name,
    required String email,
    required Timestamp birthDate,
  }) {
    UserModel model = UserModel(
      //initializing User Information
      uId: uId,
      name: name,
      email: email,
      birthDate: birthDate,
      profileImage: '',
    );
    FirebaseFirestore.instance
        .collection(
            'users') //picking user collection in firebase to store new user data in it
        .doc(uId)
        .set(model.toJson()) //converting data to json
        .then((value) {
      birthDateController.clear(); //In case error happens when signing up
      getUserData(uId: uId);
    }).catchError((error) {
      emit(RegisterOnFailedState(error.toString()));
    });
  }

  /// Get user Data

  void getUserData({required String uId}) {
    emit(AppGetUserOnLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      SaveUserData.saveUserMainData(value.data()); //saving data to user model
      emit(AppGetUserOnSuccessState());
    }).catchError((error) {
      emit(AppGetUserOnFailedState(error.toString()));
    });
  }

  /// Logout
  Future<void> logout() async {
    SaveUserData.clearUserData();
    MusicApp.isLoggedIn = false; //setting logged in status to false
    // await AppSharedPreferences.setData(
    //     key: AppSharedPreferences.isLoggedInKey, value: false);
    await AppSharedPreferences().saveIsLoggedIn(
        false); //Changing the logged In state in user preferences into false
  }

  /// Get all artists
  //retrieves all artists from firebase
  List<ArtistModel> artists = [];
  void getAllArtists() {
    emit(AppGetAllArtistsOnLoadingState());
    if (artists.isEmpty) {
      //if the artists list is empty
      FirebaseFirestore.instance.collection('artists').get().then((value) {
        //get artists from artists collection in firebase
        for (var element in value.docs) {
          artists.add(
            ArtistModel.fromJson(
              //receiving artists as Json file from firebase and extracting it
              element.data(),
            ),
          );

          emit(AppGetAllArtistsOnSuccessState());
        }
      }).catchError((error) {
        emit(
          AppGetAllArtistsOnFailedState(
            error.toString(),
          ),
        );
      });
    }
  }

  /// Get all moods
  //retrieves all moods from firebase
  List<MoodModel> moods = [];
  void getAllMoods() {
    emit(AppGetAllMoodsOnLoadingState());
    if (moods.isEmpty) {
      FirebaseFirestore.instance.collection('mood').get().then((value) {
        //gets moods from moods collection in firebase
        for (var element in value.docs) {
          moods.add(
            MoodModel.fromJson(
              element
                  .data(), //extracts the data from the firebase received JSON file
            ),
          );
          emit(AppGetAllMoodsOnSuccessState());
        }
      }).catchError((error) {
        emit(
          AppGetAllMoodsOnFailedState(
            error.toString(),
          ),
        );
      });
    }
  }

  /// Get song by mood
  //Gets songs by mood from firebase and Sorts it into mood playlists

  List<SongModel> moodsSongs = [];

  ///This List is of type [SongModel]
  List<Audio> audioMoodsSongs = [];

  /// This List is of type [Audio] to be added to the player be play a playlist
  /// Metas is a set of data that describes and
  /// gives information about other data which in our case is the Songs model
  void getSongByMood({required String mood}) {
    emit(AppGetSongByMoodOnLoadingState());

    moodsSongs = [];
    audioMoodsSongs = [];
    FirebaseFirestore.instance.collection('songs').get().then((value) {
      //getting songs from songs collection in firebase
      for (var element in value.docs) {
        if (element.data().containsValue(mood)) {
          //selecting songs with demanded mood
          moodsSongs.add(
            SongModel.fromJson(
              //receiving songs information as Json file from firebase and extracting it
              element.data(),
            ),
          );
          audioMoodsSongs.add(
            Audio.network(
              SongModel.fromJson(
                    element.data(), //adding the audio of the song
                  ).song ??
                  '',
              metas: Metas(
                extra: {
                  'songID': SongModel.fromJson(
                    element.data(),
                  ).songID //getting value of song ID
                },

                title: SongModel.fromJson(
                  element.data(),
                ).songName, //getting value of song name
                artist: SongModel.fromJson(
                  element.data(),
                ).artist, //getting value of artist
                album: 'Single',
                // image: MetasImage.network('https://www.google.com')
                image: MetasImage.network(SongModel.fromJson(
                      element.data(),
                    ).songImage ??
                    ''),
              ),
            ),
          );
        }
      }
      emit(AppGetSongByMoodOnSuccessState());
    }).catchError((error) {
      emit(AppGetSongByMoodOnFailedState(error));
    });
  }

  /// Choose favourite artist
  //Stores the Favourite artists that the user chose from list of artists into firebase

  List<ArtistModel> favouriteArtists = [];
  void chooseArtist(ArtistModel artistModel) {
    emit(AppChooseFavouriteArtistOnLoadingState());
    favouriteArtists = [];
    FirebaseFirestore
        .instance //Add the Artists Chosen by user to the user's favourite Artist
        .collection('users')
        .doc(AppSharedPreferences().getUID())
        .collection('artists')
        .doc(artistModel.artistID)
        .set(artistModel.toJson())
        .then((value) {
      FirebaseFirestore
          .instance //Add the user as a fan to the artist that user chose
          .collection('artists')
          .doc(artistModel.artistID)
          .collection('fans')
          .doc(AppSharedPreferences().getUID())
          .set({'favourite': true}).then((value) {
        emit(AppChooseFavouriteArtistOnSuccessState());
      }).catchError((error) {
        emit(AppChooseFavouriteArtistOnFailedState(error));
      });
    }).catchError((error) {
      emit(AppChooseFavouriteArtistOnFailedState(error));
    });
  }

  /// Get followed artist
  //displays the list of artists that the user likes
  List<ArtistModel> followedArtists = [];
  void getFollowedArtists() {
    emit(AppGetFavouriteArtistOnLoadingState());
    followedArtists = [];
    FirebaseFirestore.instance
        .collection('users')
        .doc(AppSharedPreferences()
            .getUID()) //using user ID to specify which user in firebase
        .collection('artists')
        .get() //then gets the favourite artists
        .then((value) {
      for (var element in value.docs) {
        if (kDebugMode) {
          print(element.data());
        }
        followedArtists.add(
          ArtistModel.fromJson(
            element
                .data(), //receiving followed artists as json file and extracting its contents using .fromJson function
          ),
        );
      }
      emit(AppGetFavouriteArtistOnSuccessState());
    }).catchError((error) {
      emit(AppGetFavouriteArtistOnFailedState(error.toString()));
    });
  }

  /// Rate songs
  //Stores rating of songs into firebase

  void rateSong(SongModel songModel, double rating) {
    emit(AppRateSongsOnLoadingState());

    FirebaseFirestore.instance
        .collection('songs')
        .doc(songModel.songID) //identifies which song in firebase using song ID
        .collection('Rate')
        .doc(AppSharedPreferences()
            .getUID()) //using user ID to specify which user in firebase
        .set({'Rating': rating}).then((value) {
      //sets rating for this song
      emit(AppRateSongsOnSuccessState());
    }).catchError((error) {
      emit(AppRateSongsOnFailedState(error));
    });
  }

  /// Player

  final assetsAudioPlayer = AssetsAudioPlayer();

  Duration audioPosition = const Duration();
  Duration audioDuration = const Duration();

  /// Open only one song of type [Audio] and shows all of its data in the notification
  /// Metas is a set of data that describes and
  /// gives information about other data which in our case is the Songs model
  void openSong({required SongModel songModel}) {
    emit(AppOpenSongOnLoadingState());
    assetsAudioPlayer
        .open(
      Audio.network(
        songModel.song ?? '', //if song model equal null
        metas: Metas(
          extra: {'songID': songModel.songID},
          title: songModel.songName,
          artist: songModel.artist,
          album: 'Single',
          image: MetasImage.network(songModel.songImage ?? ''),
        ),
      ),
      showNotification: true,
      autoStart: true,
    )
        .then((value) {
      changePlayButton();
      emit(AppOpenSongOnSuccessState());
    }).catchError((error) {
      emit(AppOpenSongOnFailedState(error));
    });
  }

  ///Open a list of type [Audio] that creating in the step of
  /// getting data from the firebase
  void openPlaylist({
    required List<Audio> list,
    required int startIndex,
    bool? autoStart,
  }) {
    emit(AppOpenSongOnLoadingState());
    assetsAudioPlayer
        .open(
      Playlist(audios: list, startIndex: startIndex),
      showNotification: true,
      autoStart: autoStart ?? true,
    )
        .then((value) {
      changePlayButton();
      emit(AppOpenSongOnSuccessState());
    }).catchError((error) {
      emit(AppOpenSongOnFailedState(error));
    });
  }

  void stopPlayer() {
    assetsAudioPlayer.stop().then((value) {}).catchError((error) {});
  }

  void pausePlayer() {
    assetsAudioPlayer.pause().then((value) {
      changePlayButton();
    }).catchError((error) {
      emit(AppChangePlaySongOnFailedState(error));
    });
  }

  void playPlayer() {
    assetsAudioPlayer.play().then((value) {
      changePlayButton();
    }).catchError((error) {
      emit(AppChangePlaySongOnFailedState(error));
    });
  }

  //
  // bool hasPlayingSong() {
  //   List<bool> isPlay = [];
  //   assetsAudioPlayer.current.listen((event) {
  //     if (event == null) {
  //       isPlay.add(false);
  //     } else {
  //       for (var element in moodsSongs) {
  //         if (element.songName == assetsAudioPlayer.getCurrentAudioTitle) {
  //           isPlay.add(true);
  //         }
  //       }
  //     }
  //   });
  //
  //   return isPlay.contains(true);
  // }

  IconData playBtn = Icons.play_arrow;
  bool isPlay = false;

  void changePlayButton() {
    isPlay = !isPlay;
    assetsAudioPlayer.isPlaying.listen((event) {
      if (event) {
        playBtn = Icons.pause;
        updateSongsNumberOfPlays(
            assetsAudioPlayer.getCurrentAudioextra['songID']);
      } else {
        playBtn = Icons.play_arrow;
      }
    });
    emit(AppChangePlaySongOnSuccessState());
  }

  bool isRepeat = false;

  void changeRepeatButton() {
    isRepeat = !isRepeat;
    assetsAudioPlayer.toggleLoop();
    emit(AppChangeRepeatBtnOnSuccessState());
  }

  /// get song rating
  //gets song rating using song id and user id from firebase

  double songRating = 0.0;
  void getSongRating(SongModel songModel) {
    emit(AppRateSongsOnLoadingState());
    songRating = 0.0;
    FirebaseFirestore.instance
        .collection('songs')
        .doc(songModel.songID) //getting Song ID from firebase
        .collection('Rate')
        .doc(AppSharedPreferences()
            .getUID()) //getting User ID from Shared Preferences
        .get()
        .then((value) {
      songRating = value.get(
          'Rating'); //Saving rating retrieved from firebase into songRating

      emit(AppRateSongsOnSuccessState());
    }).catchError((error) {
      emit(AppRateSongsOnFailedState(error.toString()));
    });
  }

  /// Get all songs
  //retrieves songs from firebase

  List<SongModel> songs = [];
  List<String> songsID = [];
  void getAllSongs() {
    emit(AppGetAllSongsOnLoadingState());
    songs = [];
    songsID = [];
    FirebaseFirestore.instance.collection('songs').get().then((value) {
      for (var element in value.docs) {
        songs.add(
          SongModel.fromJson(
            element
                .data(), //extracts JSON file received from firebase and adds song to songs array
          ),
        );
        songsID.add(element.data()['songID']); //add song Id to songsID array
        emit(AppGetAllSongsOnSuccessState());
      }
    }).catchError((error) {
      emit(
        AppGetAllSongsOnFailedState(error.toString()),
      );
    });
  }

  /// like songs
  //likes the song if it is unliked and unlikes the song if it is liked
  void likeSong(SongModel songModel, bool isLike) {
    emit(AppLikeSongsOnLoadingState());
    //adding user to likes of songs
    FirebaseFirestore.instance
        .collection('songs')
        .doc(songModel.songID)
        .collection('likes')
        .doc(AppSharedPreferences()
            .getUID()) //getting User ID from Shared preferences to specify which user
        .set({'isLiked': isLike}).then((value) {
      ///This condition is to ask whether the user is want to like the song
      /// in case of the like the song data is added to
      /// the user data so we can get it in his/her profile
      /// If the user removed the like so the data removed from his/her profile
      if (isLike) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(AppSharedPreferences().getUID())
            .collection('songs')
            .doc(songModel.songID)
            .set(songModel.toJson())
            .then((value) {
          emit(AppLikeSongsOnSuccessState());
        }).catchError((error) {
          emit(AppLikeSongsOnFailedState(error));
        });
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(AppSharedPreferences().getUID())
            .collection('songs')
            .doc(songModel.songID)
            .delete()
            .then((value) {
          emit(AppLikeSongsOnSuccessState());
        }).catchError((error) {
          emit(AppLikeSongsOnFailedState(error));
        });
      }
    }).catchError((error) {
      emit(AppLikeSongsOnFailedState(error));
    });
  }

  /// get song likes

  bool songLike = false;
  void getSongLikes(SongModel songModel) {
    emit(AppLikeSongsOnLoadingState());
    songLike = false;
    FirebaseFirestore.instance
        .collection('songs')
        .doc(songModel.songID)
        .collection('likes')
        .doc(AppSharedPreferences().getUID())
        .get()
        .then((value) {
      songLike = value.get('isLiked');
      likeBtn = songLike ? Icons.favorite : Icons.favorite_border;
      emit(AppLikeSongsOnSuccessState());
    }).catchError((error) {
      emit(AppLikeSongsOnFailedState(error.toString()));
    });
  }

  /// Get liked songs

  List<SongModel> likedSongs = [];
  void getLikedSongs() {
    emit(AppGetFavouriteArtistOnLoadingState());
    likedSongs = [];
    FirebaseFirestore.instance
        .collection('users')
        .doc(AppSharedPreferences().getUID())
        .collection('songs')
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (kDebugMode) {
          print(element.data());
        }
        likedSongs.add(
          SongModel.fromJson(
            element.data(),
          ),
        );
      }
      emit(AppGetFavouriteArtistOnSuccessState());
    }).catchError((error) {
      emit(AppGetFavouriteArtistOnFailedState(error.toString()));
    });
  }

  IconData likeBtn = Icons.favorite_border;
  //displays liked button when user liked the song and unliked button when user unliked the song
  void changeLikeButton(SongModel songModel) {
    songLike = !songLike; //inverting the like to unlike and vice versa
    likeBtn = songLike
        ? Icons.favorite
        : Icons
            .favorite_border; //if true we will display filled heart button (like) if false we will display bordered heart (unliked) button
    if (songLike) {
      likeSong(songModel, true); //like song
    } else {
      likeSong(songModel, false); //unlike song
    }
    emit(OnChangeLikeState());
  }

  /// Pick profile image
  // Receives user's profile image from the phone's gallery

  File? profileImage;
  Future<void> pickProfilePhoto() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery); //gets image from gallery
    if (pickedFile != null) {
      profileImage = File(
          pickedFile.path); //assigning the picked image to the profile image
      emit(AppProfileImagePickedOnSuccessState());
    } else {
      AppComponents.showToast(
          text: 'No image selected.',
          states: ToastStates
              .grey); //Displaying a message in case there is no image selected
      emit(AppProfileImagePickedOnFailedState());
    }
  }

  void clearImageFile() {
    profileImage = null;
    // moodImagePath = '';
    emit(AppClearImageFilesState());
  }

  /// Update user data
  // Receives the data that the user will update and updates it in user profile and firebase
  void updateUser({
    required String name,
    required String profile,
  }) {
    UserModel model = UserModel(
        //updating data in user model to encode it json
        uId: MusicApp.userModel.uId,
        name: name,
        email: MusicApp.userModel.email,
        birthDate: MusicApp.userModel.birthDate,
        profileImage: profile);
    FirebaseFirestore
        .instance //sending the json file to firebase for the update
        .collection('users')
        .doc(MusicApp.userModel.uId)
        .update(model.toJson())
        .then((value) {
      getUserData(uId: MusicApp.userModel.uId!);
      AppComponents.showToast(
        //displaying feedback
        text: 'Saved successfully',
        states: ToastStates.success,
      );
      clearImageFile();
    }).catchError((error) {
      emit(AppUpdateUserDataOnFailedState());
    });
  }

  ///Upload Profile Image

  void uploadProfileImage({
    required String name,
  }) {
    emit(AppUploadProfileImageOnLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
          'users/${MusicApp.userModel.uId}/profiles/${Uri.file(profileImage!.path).pathSegments.last}',
        )
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(
          name: name,
          profile: value,
        );
      }).catchError((error) {
        emit(AppUploadProfileImageOnFailedState());
      });
    }).catchError((error) {
      emit(AppUploadProfileImageOnFailedState());
    });
  }

  /// Create custom playlist
  //Creates a new custom playlist for the user and assigning and ID for this list
  void createPlayList(String playlistName) {
    emit(AppCreateCustomPlaylistOnLoadingState());

    FirebaseFirestore.instance //adding playlist to user playlists
        .collection('users')
        .doc(AppSharedPreferences().getUID())
        .collection('playlists')
        .add({'playListName': playlistName}).then((pValue) {
      FirebaseFirestore.instance //updating playlist ID
          .collection('users')
          .doc(AppSharedPreferences().getUID())
          .collection('playlists')
          .doc(pValue.id)
          .update({'playListID': pValue.id}).then((value) {
        emit(AppCreateCustomPlaylistOnSuccessState(pValue.id));
      }).catchError((error) {
        emit(AppCreateCustomPlaylistOnFailedState(error.toString()));
      });
    }).catchError((error) {
      emit(AppCreateCustomPlaylistOnFailedState(error.toString()));
    });
  }

  /// Get created playList

  List<Map<String, dynamic>> usersPlaylists = [];
  void getUserPlaylists() {
    emit(AppGetUserPlaylistsOnLoadingState());
    usersPlaylists = [];
    FirebaseFirestore.instance
        .collection('users')
        .doc(AppSharedPreferences().getUID())
        .collection('playlists')
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (kDebugMode) {
          print(element.data());
        }
        usersPlaylists.add({
          'playListID': element.data()['playListID'],
          'playListName': element.data()['playListName']
        });
      }
      emit(AppGetUserPlaylistsOnSuccessState());
    }).catchError((error) {
      emit(AppGetUserPlaylistsOnFailedState(error.toString()));
    });
  }

  /// Add songs to user playlist

  void addSongsToPlayList(SongModel songModel, String playlistID) {
    emit(AppAddSongsToPlaylistOnLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(AppSharedPreferences().getUID())
        .collection('playlists')
        .doc(playlistID)
        .collection('playlistSongs')
        .add(songModel.toJson())
        .then((value) {
      emit(AppAddSongsToPlaylistOnSuccessState());
    }).catchError((error) {
      emit(AppAddSongsToPlaylistOnFailedState(error));
    });
  }

  /// Get playList Songs

  List<SongModel> playlistSong = [];
  List<String> playlistSongsID = [];
  void getPlaylistSongs(String playlistID) {
    emit(AppGetSongsFromPlaylistOnLoadingState());
    playlistSong = [];
    playlistSongsID = [];
    audioMoodsSongs = [];
    FirebaseFirestore.instance
        .collection('users')
        .doc(AppSharedPreferences().getUID())
        .collection('playlists')
        .doc(playlistID)
        .collection('playlistSongs')
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (kDebugMode) {
          print(element.data());
        }
        playlistSong.add(
          SongModel.fromJson(
            element.data(),
          ),
        );
        audioMoodsSongs.add(
          Audio.network(
            SongModel.fromJson(
                  element.data(),
                ).song ??
                '',
            metas: Metas(
              extra: {
                'songID': SongModel.fromJson(
                  element.data(),
                ).songID
              },
              title: SongModel.fromJson(
                element.data(),
              ).songName,
              artist: SongModel.fromJson(
                element.data(),
              ).artist,
              album: 'Single',
              image: MetasImage.network(SongModel.fromJson(
                    element.data(),
                  ).songImage ??
                  ''),
            ),
          ),
        );
        playlistSongsID.add(element.data()['songID']);
      }
      emit(AppGetSongsFromPlaylistOnSuccessState());
    }).catchError((error) {
      emit(AppGetSongsFromPlaylistOnFailedState(error.toString()));
    });
  }

  /// Update songs number of plays
  //increments the value of number of plays in firebase
  void updateSongsNumberOfPlays(String songID) {
    emit(AppUpdateSongsNumberOfPlaysOnLoadingState());

    FirebaseFirestore.instance
        .collection('songs')
        .doc(songID)
        .get()
        .then((value) {
      FirebaseFirestore.instance.collection('songs').doc(songID).update({
        //accessing songs collection in firebase
        'numberOfPlays': (int.parse(value['numberOfPlays']) + 1)
            .toString() //incrementing the number of plays value by one
      });
      emit(AppUpdateSongsNumberOfPlaysOnSuccessState());
    }).catchError((error) {
      emit(AppUpdateSongsNumberOfPlaysOnFailedState(error.toString()));
    });
  }
}
