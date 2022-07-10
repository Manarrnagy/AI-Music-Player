import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/ui/core/my_list_tile.dart';

import '../../../../control/cubit/cubit.dart';
import '../../../core/components.dart';
import '../../player/player_page.dart';

class LikesListPage extends StatelessWidget {
  const LikesListPage({Key? key, required this.list, required this.listName})
      : super(key: key);
  final List<SongModel> list;
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
                cubit.openSong(songModel: list[index]);
                cubit.getSongRating(list[index]);
                cubit.getSongLikes(list[index]);
                Navigator.pop(context);
                AppComponents.navigateTo(
                    context: context,
                    newRoute: Player(songModel: list[index]),
                    backRoute: true);
              },
              title: list[index].songName ?? '',
              subTitle: list[index].artist ?? '',
              image: list[index].songImage ?? ''),
          itemCount: list.length,
          padding: const EdgeInsets.all(10.0),
        ),
      ),
    );
  }
}
