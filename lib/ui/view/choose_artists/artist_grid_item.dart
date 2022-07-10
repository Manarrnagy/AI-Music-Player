import 'package:flutter/material.dart';
import 'package:music_app/models/artist_model.dart';

import '../../../domain/core/resources/app_colors.dart';

// ignore: must_be_immutable
class ArtistGridItem extends StatefulWidget {
  ArtistGridItem({
    Key? key,
    required this.artistModel,
    required this.onArtistSelected,
  }) : super(key: key);

  final ArtistModel artistModel;
  final Function(ArtistModel artistModel) onArtistSelected;
  bool isSelected = false;
  @override
  State<ArtistGridItem> createState() => _ArtistGridItemState();
}

class _ArtistGridItemState extends State<ArtistGridItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            GestureDetector(
              onTap: () {
                if (!widget.isSelected) {
                  widget.onArtistSelected(widget.artistModel);
                }
                setState(() {
                  widget.isSelected = true;
                });
              },
              child: Container(
                width: 100.0,
                height: 100.0,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  widget.artistModel.artistImage ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (widget.isSelected)
              const Icon(
                Icons.check_circle_sharp,
                color: Colors.pink,
                size: 30.0,
              )
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          widget.artistModel.artistName ?? '',
          style: const TextStyle(
            color: AppColors.whiteColor,
          ),
        ),
      ],
    );
  }
}
