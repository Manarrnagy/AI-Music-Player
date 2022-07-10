import 'package:flutter/material.dart';
import 'package:music_app/domain/core/resources/app_assets_paths.dart';
import 'package:music_app/music_app.dart';

import '../../../domain/core/resources/app_colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
    this.onTapLeadingIcon,
    this.title,
    this.trailingIcon,
    this.leadingIcon,
    this.onTapTrailingIcon,
  }) : super(key: key);

  final String? title;
  final Widget? trailingIcon;
  final Widget? leadingIcon;

  final void Function()? onTapLeadingIcon;
  final void Function()? onTapTrailingIcon;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.blackColor2,
      leadingWidth: MusicApp.mediaQuery!.size.width * 0.12,
      titleSpacing: 0.0,
      centerTitle: true,
      // leading: Padding(
      //   padding: const EdgeInsetsDirectional.only(start: 10.0),
      //   child: IconButton(
      //     padding: EdgeInsets.zero,
      //     icon: leadingIcon ?? Container(),
      //     onPressed: onTapLeadingIcon,
      //   ),
      // ),
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 15.0),
        child: Hero(
          tag: "AppLogo",
          child: Image.asset(
            AppAssets.appLogo,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      title: Text(title ?? ''),
      actions: [
        if (trailingIcon != null)
          GestureDetector(
            onTap: onTapTrailingIcon,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 10.0),
              child: trailingIcon,
            ),
          ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: leadingIcon ?? Container(),
          onPressed: onTapLeadingIcon,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
