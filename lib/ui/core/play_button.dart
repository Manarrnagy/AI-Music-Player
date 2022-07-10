import 'package:flutter/material.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/music_app.dart';

import '../../domain/core/resources/app_colors.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({
    Key? key,
    required this.cubit,
    this.size,
    this.buttonColor,
    this.playIconColor,
    this.playIconPadding,
  }) : super(key: key);
  final AppCubit cubit;
  final double? size;
  final Color? buttonColor;
  final Color? playIconColor;
  final double? playIconPadding;

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ///Todo: play music here
        setState(() {
          if (widget.cubit.isPlay) {
            widget.cubit.pausePlayer();
          } else {
            widget.cubit.playPlayer();
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(widget.playIconPadding ?? 12.0),
        decoration: BoxDecoration(
          color: widget.buttonColor ?? AppColors.mainColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          widget.cubit.playBtn,
          size: widget.size ?? MusicApp.mediaQuery!.size.width / 9,
          color: widget.playIconColor ?? Colors.white,
        ),
      ),
    );
  }
}
