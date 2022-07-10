// defines an artist using id, name and image
class ArtistModel {
  String? artistID;
  String? artistName;
  String? artistImage;

  ArtistModel({
    this.artistID,
    this.artistName,
    this.artistImage,
  });

  // converts artist id, artist name and artist image from firebase json files
  // (firebase files are .json extension) to store them in the app
  ArtistModel.fromJson(Map<String, dynamic> json) {
    artistID = json['artistID'];
    artistName = json['artistName'];
    artistImage = json['artistImage'];
  }
  // converts artist id, artist name and artist image to json files to send to firebase
  Map<String, dynamic> toJson() {
    return {
      'artistID': artistID,
      'artistName': artistName,
      'artistImage': artistImage,
    };
  }
}
