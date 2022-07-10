import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/ui/core/components.dart';
import 'package:music_app/ui/core/my_list_tile.dart';
import 'package:music_app/ui/view/player/player_page.dart';

class MusicSearch extends SearchDelegate<String> {
  final songs = [];
  final recentSongs = [];
  List suggestionList = [];

  List<int> ndx = [];
  @override
  List<Widget>? buildActions(BuildContext context) {
    // actions for appbar
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // leading icon on the left of the appbar
    return IconButton(
        onPressed: () {
          close(context, 'null');
        },
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation));
  }

  @override
  Widget buildResults(BuildContext context) {
    // shown result based on the selection

    AppCubit cubit = AppCubit.get(context);
    return ListView.builder(
      itemBuilder: (context, index) => MyListTile(
          hasTrailingIcon: false,
          onTap: () {
            AppComponents.navigateTo(
                context: context,
                newRoute: Player(songModel: cubit.songs[ndx[index]]),
                backRoute: true);
          },
          title: cubit.songs[ndx[index]].songName ?? '',
          subTitle: cubit.songs[ndx[index]].artist ?? '',
          image: cubit.songs[ndx[index]].songImage ?? ''),
      itemCount: suggestionList.length,
      padding: const EdgeInsets.all(10.0),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //the suggestions shown when someone starts searching
    AppCubit cubit = AppCubit.get(context);

    suggestionList = query.isEmpty
        ? recentSongs
        : songs.where((p) => p.startsWith(query)).toList();

    cubit.songs.asMap().forEach((key, value) {
      if (!songs.contains(value.songName)) {
        songs.add(value.songName);
      }
    });
    ndx.clear();
    cubit.songs.asMap().forEach((key, value) {
      if (suggestionList.isNotEmpty) {
        suggestionList.asMap().forEach((suggestionKey, suggestionValue) {
          if (suggestionList[suggestionKey] == value.songName) {
            ndx.add(key);
          }
        });
      }
    });

    return BlocConsumer<AppCubit, AppStates>(
      listener: (state, context) {},
      builder: (state, context) {
        return ListView.builder(
          itemBuilder: (context, index) => ListTile(
            onTap: () {
              // showResults(context);

              cubit.openSong(songModel: cubit.songs[ndx[index]]);
              cubit.getSongRating(cubit.songs[ndx[index]]);
              cubit.getSongLikes(cubit.songs[ndx[index]]);
              AppComponents.navigateTo(
                  context: context,
                  newRoute: Player(songModel: cubit.songs[ndx[index]]),
                  backRoute: true);
            },
            leading: const Icon(
              Icons.music_note_rounded,
              color: AppColors.greyColor,
            ),
            title: RichText(
              text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: const TextStyle(
                    color: AppColors.mainColor, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: const TextStyle(color: AppColors.greyColor),
                  ),
                ],
              ),
            ),
          ),
          itemCount: suggestionList.length,
        );
      },
    );
  }
}
