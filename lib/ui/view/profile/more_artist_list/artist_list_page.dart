import 'package:flutter/material.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/models/artist_model.dart';
import 'package:music_app/ui/core/my_list_tile.dart';

class ArtistListPage extends StatelessWidget {
  const ArtistListPage({Key? key, required this.list, required this.listName})
      : super(key: key);
  final List<ArtistModel> list;
  final String listName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blackColor2,
        centerTitle: true,
        title: Text(
          listName,
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => MyListTile(
            hasTrailingIcon: false,
            onTap: () {
              // AppComponents.navigateTo(
              //     context: context,
              //     newRoute: Player(songModel: cubit.songs[ndx[index]]),
              //     backRoute: true);
            },
            title: list[index].artistName ?? '',
            image: list[index].artistImage ?? ''),
        itemCount: list.length,
        padding: const EdgeInsets.all(10.0),
      ),
    );
  }
}
