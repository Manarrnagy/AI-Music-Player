import 'package:flutter/material.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/music_app.dart';

class MyListTile extends StatefulWidget {
  const MyListTile({
    Key? key,
    required this.hasTrailingIcon,
    this.onTap,
    required this.title,
    this.subTitle,
    required this.image,
    this.trailingIcon,
    this.padding,
    this.fit,
  }) : super(key: key);

  final bool hasTrailingIcon;
  final VoidCallback? onTap;
  final String title;
  final String? subTitle;
  final String image;
  final Widget? trailingIcon;
  final double? padding;
  final BoxFit? fit;

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap ?? () {},
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: widget.padding ?? 15.0, vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: MusicApp.mediaQuery!.size.width * 0.14,
                width: MusicApp.mediaQuery!.size.width * 0.14,
                child: Image.network(
                  widget.image,
                  fit: widget.fit ?? BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            widget.subTitle != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                            color: AppColors.whiteColor, fontSize: 16.0),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        widget.subTitle ?? '',
                        style: const TextStyle(
                            color: AppColors.greyColor, fontSize: 12.0),
                      ),
                    ],
                  )
                : Text(
                    widget.title,
                    style: const TextStyle(
                        color: AppColors.whiteColor, fontSize: 16.0),
                  ),
            const Spacer(),
            if (widget.hasTrailingIcon) widget.trailingIcon!
          ],
        ),
      ),
    );
  }
}
