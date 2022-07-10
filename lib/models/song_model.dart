// defines a song using the song, id, name, image, mood id and mood name
class SongModel {
  String? song;
  String? songID;
  String? songName;
  String? songImage;
  String? moodID;
  String? moodName;

  String? artist;
  String? artistID;
  String? rating;
  String? numberOfPlays;

  SongModel(
      {this.song,
      this.songID,
      this.songName,
      this.songImage,
      this.moodID,
      this.moodName,
      this.artist,
      this.artistID,
      this.rating,
      this.numberOfPlays});

  // converts the song, id, name, image, mood id and mood name from firebase
  // json files (firebase files are .json extension) to store them in the app
  SongModel.fromJson(Map<String, dynamic> json) {
    song = json['song'];
    songID = json['songID'];
    songName = json['songName'];
    songImage = json['songImage'];
    moodID = json['moodID'];
    moodName = json['moodName'];
    artist = json['artist'];
    artistID = json['artistID'];
    rating = json['rating'];
    numberOfPlays = json['numberOfPlays'];
  }

  // converts the song, id, name, image, mood id and mood name to json files to send to firebase
  Map<String, dynamic> toJson() {
    return {
      'song': song,
      'songID': songID,
      'songName': songName,
      'songImage': songImage,
      'moodID': moodID,
      'moodName': moodName,
      'artist': artist,
      'artistID': artistID,
      'rating': rating,
      'numberOfPlays': numberOfPlays,
    };
  }
}
