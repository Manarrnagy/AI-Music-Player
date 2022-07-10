import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/models/mood_model.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/music_app.dart';
import 'package:music_app/ui/core/components.dart';
import 'package:music_app/ui/core/my_list_tile.dart';
import 'package:music_app/ui/view/add_songs/add_custom_playlist_songs.dart';
import 'package:music_app/ui/view/player/player_page.dart';

import 'data_cut_rectangle.dart';

/// Mood playlist
class PlayList extends StatefulWidget {
  const PlayList({
    Key? key,
    required this.moodModel,
    required this.playListCardColor,
  }) : super(key: key);

  final MoodModel moodModel;
  final Color playListCardColor;
  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    final size = MediaQuery.of(context).size;
    cubit.getSongByMood(mood: widget.moodModel.moodName!);

    return WillPopScope(
      onWillPop: () async {
        cubit.changeNavBar(0);

        return false;
      },
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return state is! AppGetSongByMoodOnLoadingState
                ? Scaffold(
                    body: SafeArea(
                      child: CustomScrollView(
                        slivers: [
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _PlayListAppBar(
                              minExtended: kToolbarHeight,
                              maxExtended: size.height * 0.35,
                              size: size,
                              playListCount: cubit.moodsSongs.length,
                              playListName: widget.moodModel.moodName ?? '',
                              playListColor: widget.playListCardColor,
                              isCustomPlaylist: false,
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (ctx, index) => Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: MyListTile(
                                            hasTrailingIcon: false,
                                            onTap: () {
                                              cubit.openPlaylist(
                                                  list: cubit.audioMoodsSongs,
                                                  startIndex: index);

                                              AppComponents.navigateTo(
                                                  context: context,
                                                  newRoute: Player(
                                                    songModel:
                                                        cubit.moodsSongs[index],
                                                  ),
                                                  backRoute: true);
                                              cubit.getSongRating(
                                                  cubit.moodsSongs[index]);
                                              cubit.getSongLikes(
                                                  cubit.moodsSongs[index]);
                                            },
                                            title: cubit.moodsSongs[index]
                                                    .songName ??
                                                '',
                                            subTitle: cubit
                                                    .moodsSongs[index].artist ??
                                                '',
                                            image: cubit.moodsSongs[index]
                                                    .songImage ??
                                                '',
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Container(
                                            height: 1.0,
                                            color: AppColors.greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                childCount: cubit.moodsSongs.length),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    color: AppColors.backgroundColor,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
          }),
    );
  }
}

/// Custom playlist
class CustomPlaylist extends StatefulWidget {
  const CustomPlaylist({
    Key? key,
    required this.playListCardColor,
    required this.playListName,
    required this.playListID,
  }) : super(key: key);

  final Color playListCardColor;
  final String playListName;
  final String playListID;
  @override
  State<CustomPlaylist> createState() => _CustomPlaylistState();
}

class _CustomPlaylistState extends State<CustomPlaylist> {
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    final size = MediaQuery.of(context).size;

    List<SongModel> getAddMoreSongsPlaylist() {
      List<SongModel> _songs = [];
      List<String> _songsID = [];
      int counter = 0;
      for (var element in cubit.songsID) {
        if (!cubit.playlistSongsID.contains(element)) {
          _songsID.add(element);
          _songs.add(cubit.songs[counter]);
        }
        counter += 1;
      }

      return _songs;
    }

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return state is! AppGetSongsFromPlaylistOnLoadingState
              ? Scaffold(
                  body: SafeArea(
                    child: CustomScrollView(
                      slivers: [
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _PlayListAppBar(
                            minExtended: kToolbarHeight,
                            maxExtended: size.height * 0.35,
                            size: size,
                            playListCount: cubit.playlistSong.length,

                            /// Todo Add playlist name
                            playListName: widget.playListName,
                            playListColor: widget.playListCardColor,
                            isCustomPlaylist: true,
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (ctx, index) => Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: MyListTile(
                                          hasTrailingIcon: false,
                                          onTap: () {
                                            cubit.openPlaylist(
                                              list: cubit.audioMoodsSongs,
                                              startIndex: index,
                                            );
                                            AppComponents.navigateTo(
                                                context: context,
                                                newRoute: Player(
                                                  songModel:
                                                      cubit.playlistSong[index],
                                                ),
                                                backRoute: true);
                                            cubit.getSongRating(
                                                cubit.playlistSong[index]);
                                            cubit.getSongLikes(
                                                cubit.playlistSong[index]);
                                          },
                                          title: cubit.playlistSong[index]
                                                  .songName ??
                                              '',
                                          subTitle: cubit
                                                  .playlistSong[index].artist ??
                                              '',
                                          image: cubit.playlistSong[index]
                                                  .songImage ??
                                              '',
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Container(
                                          height: 1.0,
                                          color: AppColors.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                              childCount: cubit.playlistSong.length),
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      AppComponents.navigateTo(
                          context: context,
                          newRoute: AddCustomPlayListSongs(
                              list: getAddMoreSongsPlaylist(),
                              playlistID: widget.playListID),
                          backRoute: true);
                    },
                    tooltip: 'Add songs',
                  ),
                )
              : Container(
                  color: AppColors.backgroundColor,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
        });
  }
}

/// Common playlists Appbar
class _PlayListAppBar extends SliverPersistentHeaderDelegate {
  const _PlayListAppBar({
    required this.maxExtended,
    required this.minExtended,
    required this.size,
    required this.playListName,
    required this.playListCount,
    required this.playListColor,
    required this.isCustomPlaylist,
  });
  final double maxExtended;
  final double minExtended;
  final Size size;
  final String playListName;
  final int playListCount;
  final Color playListColor;
  final bool isCustomPlaylist;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / maxExtended;
    //validate the angle at which the card returns
    const uploadLimit = 13 / 100;
    //return value of the card
    final valueBack = (1 - percent - 0.77).clamp(0, uploadLimit);
    final fixRotation = pow(percent, 1.5);

    final card = _CoverCard(
      size: size,
      percent: percent,
      uploadLimit: uploadLimit,
      valueBack: valueBack,
      playListName: playListName,
      playListColor: playListColor,
      isCustomPlaylist: isCustomPlaylist,
    );

    final bottomSliverBar = Positioned(
      bottom: 0,
      left: -size.width * fixRotation.clamp(0, 0.35),
      right: 0,
      child: SizedBox(
        height: size.height * 0.12,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: CutRectangle(),
            ),
            DataCutRectangle(
              playListName: playListName,
              playListCount: playListCount,
              size: size,
              percent: percent,
            )
          ],
        ),
      ),
    );

    return Stack(
      children: [
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: 0,
          // child: Container(
          //   // color: AppColors.backgroundColor,
          // ),
          child: Image(
            image: AssetImage(
              'assets/images/party.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        if (percent > uploadLimit) ...[
          card,
          bottomSliverBar,
        ] else ...[
          bottomSliverBar,
          card,
        ],
        Positioned(
            top: size.height * 0.015,
            left: size.width / 40,
            child: InkWell(
              onTap: () => isCustomPlaylist
                  ? Navigator.pop(context)
                  : AppCubit.get(context).changeNavBar(0),
              child: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
            )),
        // Positioned(
        //   bottom: size.height * 0.10,
        //   right: 10,
        //   child: percent < 0.2
        //       ? TweenAnimationBuilder<double>(
        //           tween: percent < 0.17
        //               ? Tween(begin: 1, end: 0)
        //               : Tween(begin: 0, end: 1),
        //           duration: const Duration(milliseconds: 300),
        //           builder: (context, value, widget) {
        //             return Transform.scale(
        //               scale: 1.0 - value,
        //               child: StreamBuilder<Playing?>(
        //                   stream: cubit.assetsAudioPlayer.current,
        //                   builder: (context, snapshot) {
        //                     return PlayButton(
        //                       cubit: cubit,
        //                       buttonColor: AppColors.whiteColor,
        //                       playIconColor: AppColors.mainColor,
        //                       size: MusicApp.mediaQuery!.size.width * 0.08,
        //                       playIconPadding:
        //                           MusicApp.mediaQuery!.size.width * 0.02,
        //                       onButtonTap: () {
        //                         cubit.openPlaylist(
        //                             list: cubit.audioMoodsSongs,
        //                             startIndex: 0,
        //                             autoStart: false);
        //                       },
        //                     );
        //                   }),
        //             );
        //           })
        //       : const SizedBox(),
        // ),
      ],
    );
  }

  @override
  double get maxExtent => maxExtended;

  @override
  double get minExtent => minExtended;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

/// Common playlists cover card
class _CoverCard extends StatelessWidget {
  const _CoverCard({
    Key? key,
    required this.size,
    required this.percent,
    required this.uploadLimit,
    required this.valueBack,
    required this.playListColor,
    required this.playListName,
    required this.isCustomPlaylist,
  }) : super(key: key);
  final Size size;
  final double percent;
  final double uploadLimit;
  final num valueBack;
  final Color playListColor;
  final String playListName;
  final bool isCustomPlaylist;

  final double angleForCard = 6.5;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: size.height * 0.15,
      left: size.width / 24,
      child: Transform(
        alignment: Alignment.topRight,
        transform: Matrix4.identity()
          ..rotateZ(percent > uploadLimit
              ? (valueBack * angleForCard)
              : percent * angleForCard),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: size.width * 0.27,
          height: size.height * 0.18,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: playListColor,
                    border: Border.all(color: AppColors.whiteColor, width: 4.0),
                  ),
                  child: Center(
                    child: isCustomPlaylist
                        ? Icon(
                            Icons.queue_music,
                            size: MusicApp.mediaQuery!.size.width * 0.14,
                            color: AppColors.whiteColor,
                          )
                        : Text(
                            playListName,
                            style: const TextStyle(
                                fontSize: 20.0, color: AppColors.whiteColor),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom appbar cut
class CutRectangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = AppColors.mainColor;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 10;
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.27, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
