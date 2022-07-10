import 'package:flutter/material.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white24,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.mainColor,
        ),
      ),
    );
  }
}
