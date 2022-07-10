import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';

class PLayerSlider extends StatelessWidget {
  const PLayerSlider({Key? key, required this.cubit}) : super(key: key);

  final AppCubit cubit;
  String _durationToString(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final twoDigitMinutes =
        twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
    final twoDigitSeconds =
        twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: cubit.assetsAudioPlayer.currentPosition,
          initialData: const Duration(),
          builder: (BuildContext context, AsyncSnapshot<Duration?> snapshot) {
            if (snapshot.hasData) {
              cubit.audioPosition = snapshot.data!;
            }
            return Text(_durationToString(cubit.audioPosition),
                style: const TextStyle(color: AppColors.whiteColor));
          },
        ),

        /// Slider

        StreamBuilder(
          stream: cubit.assetsAudioPlayer.currentPosition,
          initialData: const Duration(),
          builder: (BuildContext context, AsyncSnapshot<Duration?> snapshot) {
            var duration = const Duration();
            if (snapshot.hasData) {
              duration = snapshot.data!;
            }
            return SizedBox(
              width: 300,
              child: Slider(
                value: duration.inSeconds.toDouble(),
                min: 0,
                max: cubit.audioDuration.inSeconds.toDouble(),
                onChanged: (double value) {
                  cubit.assetsAudioPlayer.seek(
                    Duration(seconds: value.toInt()),
                  );
                  value = value;
                },
              ),
            );
          },
        ),

        StreamBuilder(
          stream: cubit.assetsAudioPlayer.current,
          builder: (BuildContext context, AsyncSnapshot<Playing?> snapshot) {
            if (snapshot.hasData) {
              cubit.audioDuration = snapshot.data!.audio.duration;
            }
            return Text(
              _durationToString(cubit.audioDuration),
              style: const TextStyle(color: AppColors.whiteColor),
            );
          },
        ),
      ],
    );
  }
}
