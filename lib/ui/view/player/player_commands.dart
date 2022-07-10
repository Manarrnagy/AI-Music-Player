import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/music_app.dart';
import 'package:music_app/ui/core/play_button.dart';

class PlayerCommands extends StatefulWidget {
  const PlayerCommands({Key? key, required this.cubit, required this.songModel})
      : super(key: key);

  final AppCubit cubit;
  final SongModel songModel;

  @override
  State<PlayerCommands> createState() => _PlayerCommandsState();
}

class _PlayerCommandsState extends State<PlayerCommands> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              widget.cubit.changeLikeButton(widget.songModel);
            },
            child: StreamBuilder<Object>(
                stream: AppCubit.get(context).assetsAudioPlayer.isBuffering,
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    if (AppCubit.get(context)
                        .assetsAudioPlayer
                        .current
                        .hasValue) {
                      AppCubit.get(context).getSongLikes(SongModel(
                          songID: AppCubit.get(context)
                              .assetsAudioPlayer
                              .getCurrentAudioextra['songID']));
                    }
                    return const CircularProgressIndicator();
                  } else {
                    return Icon(
                      widget.cubit.likeBtn,
                      size: MusicApp.mediaQuery!.size.width / 13,
                      color: widget.cubit.songLike
                          ? AppColors.mainColor
                          : AppColors.whiteColor,
                    );
                  }
                }),
          ),
          IconButton(
            icon: Icon(
              Icons.skip_previous,
              size: MusicApp.mediaQuery!.size.width / 13,
              color: Colors.white,
            ),
            onPressed: () {
              widget.cubit.assetsAudioPlayer.previous();
            },
          ),
          StreamBuilder<Playing?>(
              stream: widget.cubit.assetsAudioPlayer.current,
              builder: (context, snapshot) {
                return PlayButton(
                  cubit: widget.cubit,
                );
              }),
          IconButton(
            icon: Icon(
              Icons.skip_next,
              size: MusicApp.mediaQuery!.size.width / 13,
              color: Colors.white,
            ),
            onPressed: () {
              widget.cubit.assetsAudioPlayer.next();
            },
          ),
          GestureDetector(
            onTap: () {
              widget.cubit.changeRepeatButton();
            },
            child: Icon(
              Icons.repeat,
              size: MusicApp.mediaQuery!.size.width / 13,
              color: widget.cubit.isRepeat
                  ? AppColors.mainColor
                  : AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
