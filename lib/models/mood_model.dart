// defines a mood using id and name
class MoodModel {
  String? moodID;
  String? moodName;

  MoodModel({
    this.moodID,
    this.moodName,
  });
  // converts mood id and mood name from firebase json files
  // (firebase files are .json extension) to store them in the app
  MoodModel.fromJson(Map<String, dynamic> json) {
    moodID = json['moodID'];
    moodName = json['moodName'];
  }
  // converts mood id and mood name to json files to send to firebase
  Map<String, dynamic> toJson() {
    return {
      'moodID': moodID,
      'artistName': moodName,
    };
  }
}
