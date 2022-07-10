import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/music_app.dart';
import 'package:music_app/ui/core/components.dart';
import 'package:music_app/ui/core/loading_overlay.dart';
import 'package:music_app/ui/core/my_list_tile.dart';
import 'package:music_app/ui/core/play_button.dart';
import 'package:music_app/ui/view/player/player_page.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) => Stack(
        children: [
          Scaffold(
            body: cubit.pages[cubit.currentIndex],
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (cubit.assetsAudioPlayer.current.hasValue)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MusicApp.mediaQuery!.size.height * 0.09,
                        child: Scaffold(
                          backgroundColor: AppColors.blackColor2,
                          body: StreamBuilder<Playing?>(
                              stream: cubit.assetsAudioPlayer.current,
                              builder: (context, snapshot) {
                                return MyListTile(
                                  fit: BoxFit.contain,
                                  onTap: () {
                                    if (kDebugMode) {
                                      print(cubit.assetsAudioPlayer
                                          .getCurrentAudioextra['songID']);
                                    }
                                    cubit.getSongLikes(SongModel(
                                        songID: cubit.assetsAudioPlayer
                                            .getCurrentAudioextra['songID']));
                                    cubit.getSongRating(SongModel(
                                        songID: cubit.assetsAudioPlayer
                                            .getCurrentAudioextra['songID']));
                                    AppComponents.navigateTo(
                                        context: context,
                                        newRoute: Player(
                                          songModel: SongModel(
                                            songID: cubit.assetsAudioPlayer
                                                .getCurrentAudioextra['songID'],
                                          ),
                                        ),
                                        backRoute: true);
                                  },
                                  image: cubit.assetsAudioPlayer
                                      .getCurrentAudioImage!.path,
                                  title: cubit
                                      .assetsAudioPlayer.getCurrentAudioTitle,
                                  subTitle: cubit
                                      .assetsAudioPlayer.getCurrentAudioArtist,
                                  hasTrailingIcon: true,
                                  trailingIcon: PlayButton(
                                    size: MusicApp.mediaQuery!.size.width / 15,
                                    buttonColor: Colors.transparent,
                                    playIconColor: AppColors.whiteColor,
                                    cubit: cubit,
                                    playIconPadding: 0.0,
                                  ),
                                );
                              }),
                        ),
                      ),
                      Container(
                        height: 0.4,
                        color: Colors.black,
                      ),
                    ],
                  ),
                Theme(
                  data: Theme.of(context).copyWith(
                    // sets the background color of the `BottomNavigationBar`
                    canvasColor: AppColors.blackColor2,
                  ), // sets the inactive color of the `BottomNavigationBar`
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex:
                        cubit.currentIndex > 1 ? 0 : cubit.currentIndex,
                    onTap: (index) {
                      cubit.changeNavBar(index);
                    },
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.music_house_fill),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.explore),
                        label: 'Explore',
                      ),
                    ],
                    selectedItemColor: cubit.currentIndex > 1
                        ? AppColors.greyColor
                        : Colors.white,
                    unselectedItemColor: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<Object>(
              stream: cubit.assetsAudioPlayer.isBuffering,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return const LoadingOverlay();
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }
}
