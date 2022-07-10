import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/music_app.dart';
import 'package:music_app/ui/view/player/player_commands.dart';
import 'package:music_app/ui/view/player/player_slider.dart';
import 'package:music_app/ui/view/player/rating_container.dart';

import '../../core/loading_overlay.dart';

class Player extends StatelessWidget {
  const Player({Key? key, required this.songModel}) : super(key: key);

  final SongModel songModel;

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    size: MusicApp.mediaQuery!.size.height / 25,
                  ),
                ),
                backgroundColor: AppColors.backgroundColor,
                elevation: 0.0,
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: MusicApp.mediaQuery!.size.width / 1.4,
                          // child: Image.network(songModel.songImage ?? ''),
                          child: StreamBuilder<Playing?>(
                              stream: cubit.assetsAudioPlayer.current,
                              builder: (context, snapshot) {
                                return Image.network(
                                    cubit.assetsAudioPlayer.current.hasValue
                                        ? cubit.assetsAudioPlayer
                                            .getCurrentAudioImage!.path
                                        : songModel.songImage!);
                              }),
                        ),
                      ),
                      const SizedBox(
                        height: 35.0,
                      ),
                      StreamBuilder<Playing?>(
                          stream: cubit.assetsAudioPlayer.current,
                          builder: (context, snapshot) {
                            return Text(
                              // songModel.songName ?? '',
                              cubit.assetsAudioPlayer.current.hasValue
                                  ? cubit.assetsAudioPlayer.getCurrentAudioTitle
                                  : songModel.songName!,
                              style: const TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold),
                            );
                          }),
                      const SizedBox(
                        height: 5.0,
                      ),
                      StreamBuilder<Playing?>(
                          stream: cubit.assetsAudioPlayer.current,
                          builder: (context, snapshot) {
                            return Text(
                              // songModel.artist ?? '',
                              cubit.assetsAudioPlayer.current.hasValue
                                  ? cubit
                                      .assetsAudioPlayer.getCurrentAudioArtist
                                  : songModel.artist!,
                              style: const TextStyle(
                                color: AppColors.greyColor,
                              ),
                            );
                          }),
                      const SizedBox(
                        height: 5.0,
                      ),
                      PLayerSlider(cubit: cubit),
                      PlayerCommands(cubit: cubit, songModel: songModel),
                      const SizedBox(
                        height: 15.0,
                      ),
                      StreamBuilder<Object>(
                          stream: cubit.assetsAudioPlayer.isBuffering,
                          builder: (context, snapshot) {
                            if (snapshot.data == true) {
                              if (cubit.assetsAudioPlayer.current.hasValue) {
                                cubit.getSongRating(SongModel(
                                    songID: cubit.assetsAudioPlayer
                                        .getCurrentAudioextra['songID']));
                              }

                              return const CircularProgressIndicator();
                            } else {
                              return RatingContainer(
                                  cubit: cubit, songModel: songModel);
                            }
                          }),
                    ],
                  ),
                ),
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
        );
      },
    );
  }
}
