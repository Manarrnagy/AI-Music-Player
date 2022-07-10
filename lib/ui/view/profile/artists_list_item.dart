import 'package:flutter/material.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';

class ArtistsListItem extends StatelessWidget {
  const ArtistsListItem({
    Key? key,
    required this.artistImage,
    required this.artistName,
  }) : super(key: key);
  final String artistImage;
  final String artistName;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CircleAvatar(
            radius: 40.0,
            backgroundImage: NetworkImage(artistImage),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          artistName,
          style: const TextStyle(
            color: AppColors.whiteColor,
          ),
        ),
      ],
    );
  }
}
