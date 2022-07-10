import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/music_app.dart';
import 'package:music_app/ui/core/my_list_tile.dart';
import 'package:music_app/ui/view/playlist/playlist_page.dart';

import '../../../../control/cubit/cubit.dart';
import '../../../core/components.dart';

class MyPlaylists extends StatelessWidget {
  const MyPlaylists({Key? key, required this.list, required this.listName})
      : super(key: key);
  final List list;
  final String listName;
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (BuildContext context, Object? state) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.blackColor2,
          centerTitle: true,
          title: Text(listName),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) => MyListTile(
            hasTrailingIcon: false,
            onTap: () {
              cubit.getPlaylistSongs(cubit.usersPlaylists[index]['playListID']);
              AppComponents.navigateTo(
                  context: context,
                  newRoute: CustomPlaylist(
                    playListCardColor: Colors.purpleAccent,
                    playListName: cubit.usersPlaylists[index]['playListName'],
                    playListID: cubit.usersPlaylists[index]['playListID'],
                  ),
                  backRoute: true);
            },
            title: cubit.usersPlaylists[index]['playListName'],
            subTitle: 'Playlist • ${MusicApp.userModel.name}',
            image:
                'https://firebasestorage.googleapis.com/v0/b/musimood-dba21.appspot.com/o/music-tape-cassette-tape.png?alt=media&token=551f7a1f-75de-4769-8d2d-65721231fe3a',
          ),
          itemCount: list.length,
          padding: const EdgeInsets.all(10.0),
        ),
      ),
    );
  }
}
