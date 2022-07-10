abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeNavBarState extends AppStates {}

/// Login
class LoginOnLoadingState extends AppStates {}

class LoginOnSuccessState extends AppStates {}

class LoginOnFailedState extends AppStates {
  final String error;

  LoginOnFailedState(this.error);
}

class OnChangePasswordVisibilityState extends AppStates {}

class ImagePickedOnSuccessState extends AppStates {}

class SelectBirthDateOnSuccessState extends AppStates {}

/// Register
class RegisterOnLoadingState extends AppStates {}

class RegisterOnSuccessState extends AppStates {}

class RegisterOnFailedState extends AppStates {
  final String error;

  RegisterOnFailedState(this.error);
}

/// Get user data

class AppGetUserOnLoadingState extends AppStates {}

class AppGetUserOnSuccessState extends AppStates {}

class AppGetUserOnFailedState extends AppStates {
  final String error;

  AppGetUserOnFailedState(this.error);
}

/// Get all artists

class AppGetAllArtistsOnLoadingState extends AppStates {}

class AppGetAllArtistsOnSuccessState extends AppStates {}

class AppGetAllArtistsOnFailedState extends AppStates {
  final String error;

  AppGetAllArtistsOnFailedState(this.error);
}

/// Get all moods

class AppGetAllMoodsOnLoadingState extends AppStates {}

class AppGetAllMoodsOnSuccessState extends AppStates {}

class AppGetAllMoodsOnFailedState extends AppStates {
  final String error;

  AppGetAllMoodsOnFailedState(this.error);
}

/// Get Song by mood

class AppGetSongByMoodOnLoadingState extends AppStates {}

class AppGetSongByMoodOnSuccessState extends AppStates {}

class AppGetSongByMoodOnFailedState extends AppStates {
  final String error;

  AppGetSongByMoodOnFailedState(this.error);
}

/// Choose your favourite artists

class AppChooseFavouriteArtistOnLoadingState extends AppStates {}

class AppChooseFavouriteArtistOnSuccessState extends AppStates {}

class AppChooseFavouriteArtistOnFailedState extends AppStates {
  final String error;

  AppChooseFavouriteArtistOnFailedState(this.error);
}

/// get your favourite artists

class AppGetFavouriteArtistOnLoadingState extends AppStates {}

class AppGetFavouriteArtistOnSuccessState extends AppStates {}

class AppGetFavouriteArtistOnFailedState extends AppStates {
  final String error;

  AppGetFavouriteArtistOnFailedState(this.error);
}

/// rate songs

class AppRateSongsOnLoadingState extends AppStates {}

class AppRateSongsOnSuccessState extends AppStates {}

class AppRateSongsOnFailedState extends AppStates {
  final String error;

  AppRateSongsOnFailedState(this.error);
}

/// open songs player

class AppOpenSongOnLoadingState extends AppStates {}

class AppOpenSongOnSuccessState extends AppStates {}

class AppOpenSongOnFailedState extends AppStates {
  final String error;

  AppOpenSongOnFailedState(this.error);
}

class AppChangePlaySongOnSuccessState extends AppStates {}

class AppChangePlaySongOnFailedState extends AppStates {
  final String error;

  AppChangePlaySongOnFailedState(this.error);
}

class AppChangeRepeatBtnOnSuccessState extends AppStates {}

/// Get all songs

class AppGetAllSongsOnLoadingState extends AppStates {}

class AppGetAllSongsOnSuccessState extends AppStates {}

class AppGetAllSongsOnFailedState extends AppStates {
  final String error;

  AppGetAllSongsOnFailedState(this.error);
}

/// like songs

class AppLikeSongsOnLoadingState extends AppStates {}

class AppLikeSongsOnSuccessState extends AppStates {}

class AppLikeSongsOnFailedState extends AppStates {
  final String error;

  AppLikeSongsOnFailedState(this.error);
}

class OnChangeLikeState extends AppStates {}

/// pick profile photo

class AppProfileImagePickedOnSuccessState extends AppStates {}

class AppProfileImagePickedOnFailedState extends AppStates {}

class AppClearImageFilesState extends AppStates {}

/// update user data

class AppUpdateUserDataOnFailedState extends AppStates {}

class AppUploadProfileImageOnLoadingState extends AppStates {}

class AppUploadProfileImageOnFailedState extends AppStates {}

/// Create custom playlist

class AppCreateCustomPlaylistOnLoadingState extends AppStates {}

class AppCreateCustomPlaylistOnSuccessState extends AppStates {
  final String playlistID;

  AppCreateCustomPlaylistOnSuccessState(this.playlistID);
}

class AppCreateCustomPlaylistOnFailedState extends AppStates {
  final String error;

  AppCreateCustomPlaylistOnFailedState(this.error);
}

/// get user playlists

class AppGetUserPlaylistsOnLoadingState extends AppStates {}

class AppGetUserPlaylistsOnSuccessState extends AppStates {}

class AppGetUserPlaylistsOnFailedState extends AppStates {
  final String error;

  AppGetUserPlaylistsOnFailedState(this.error);
}

/// Add songs to user playlist

class AppAddSongsToPlaylistOnLoadingState extends AppStates {}

class AppAddSongsToPlaylistOnSuccessState extends AppStates {}

class AppAddSongsToPlaylistOnFailedState extends AppStates {
  final String error;

  AppAddSongsToPlaylistOnFailedState(this.error);
}

/// Get playLists Songs

class AppGetSongsFromPlaylistOnLoadingState extends AppStates {}

class AppGetSongsFromPlaylistOnSuccessState extends AppStates {}

class AppGetSongsFromPlaylistOnFailedState extends AppStates {
  final String error;

  AppGetSongsFromPlaylistOnFailedState(this.error);
}

/// Get playLists Songs

class AppUpdateSongsNumberOfPlaysOnLoadingState extends AppStates {}

class AppUpdateSongsNumberOfPlaysOnSuccessState extends AppStates {}

class AppUpdateSongsNumberOfPlaysOnFailedState extends AppStates {
  final String error;

  AppUpdateSongsNumberOfPlaysOnFailedState(this.error);
}
