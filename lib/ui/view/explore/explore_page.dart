import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/music_app.dart';
import 'package:music_app/ui/core/components.dart';
import 'package:music_app/ui/core/my_list_tile.dart';
import 'package:music_app/ui/view/player/player_page.dart';
import 'package:music_app/ui/view/profile/artists_list_item.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    cubit.songs.sort((a, b) {
      return int.parse(b.numberOfPlays!).compareTo(int.parse(a.numberOfPlays!));
    });

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return cubit.songs.isNotEmpty
            ? Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.backgroundColor,
                  elevation: 0.0,
                ),
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: [
                        AppColors.mainColor,
                        AppColors.mainColor,
                        AppColors.backgroundColor,
                        AppColors.backgroundColor,
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(
                          MusicApp.mediaQuery!.size.width * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore',
                            style: TextStyle(
                                fontSize: MusicApp.mediaQuery!.size.width * 0.1,
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteColor),
                          ),
                          SizedBox(
                            height: MusicApp.mediaQuery!.size.width * 0.08,
                          ),
                          Text(
                            'Most Played Songs',
                            style: TextStyle(
                                fontSize:
                                    MusicApp.mediaQuery!.size.width * 0.055,
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteColor),
                          ),
                          SizedBox(
                            height: MusicApp.mediaQuery!.size.width * 0.04,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2.1,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 5,
                              itemBuilder: (context, index) => MyListTile(
                                padding: 0.0,
                                hasTrailingIcon: true,
                                trailingIcon: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      end: MusicApp.mediaQuery!.size.width *
                                          0.04),
                                  child: Text(
                                    index == 0
                                        ? '🔥' + (index + 1).toString()
                                        : (index + 1).toString(),
                                    style: TextStyle(
                                        color: index == 0
                                            ? Colors.orange
                                            : AppColors.whiteColor,
                                        fontSize: index == 0
                                            ? MusicApp.mediaQuery!.size.width *
                                                0.06
                                            : MusicApp.mediaQuery!.size.width *
                                                0.04),
                                  ),
                                ),
                                onTap: () {
                                  cubit.openSong(songModel: cubit.songs[index]);
                                  cubit.getSongRating(cubit.songs[index]);
                                  cubit.getSongLikes(cubit.songs[index]);
                                  AppComponents.navigateTo(
                                    context: context,
                                    newRoute:
                                        Player(songModel: cubit.songs[index]),
                                    backRoute: true,
                                  );
                                },
                                title: cubit.songs[index].songName ?? '',
                                subTitle: cubit.songs[index].artist ?? '',
                                image: cubit.songs[index].songImage ?? '',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MusicApp.mediaQuery!.size.width * 0.04,
                          ),
                          Text(
                            'Recommended playlists ',
                            style: TextStyle(
                                fontSize:
                                    MusicApp.mediaQuery!.size.width * 0.055,
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteColor),
                          ),
                          SizedBox(
                            height: MusicApp.mediaQuery!.size.width * 0.04,
                          ),
                          Center(
                              child: Text(
                            'Coming soon',
                            style: TextStyle(
                                fontSize:
                                    MusicApp.mediaQuery!.size.width * 0.04,
                                color: AppColors.whiteColor),
                          )),
                          SizedBox(
                            height: MusicApp.mediaQuery!.size.width * 0.04,
                          ),
                          Text(
                            'Artists',
                            style: TextStyle(
                                fontSize:
                                    MusicApp.mediaQuery!.size.width * 0.055,
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteColor),
                          ),
                          SizedBox(
                            height: MusicApp.mediaQuery!.size.width * 0.04,
                          ),
                          SizedBox(
                            height: MusicApp.mediaQuery!.size.height * 0.14,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => ArtistsListItem(
                                artistImage: cubit.artists[index].artistImage!,
                                artistName: cubit.artists[index].artistName!,
                              ),
                              itemCount: cubit.artists.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                color: AppColors.backgroundColor,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}
