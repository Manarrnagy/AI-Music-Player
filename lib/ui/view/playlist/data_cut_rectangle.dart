import 'dart:math';

import 'package:flutter/material.dart';

import '../../../domain/core/resources/app_colors.dart';

class DataCutRectangle extends StatelessWidget {
  const DataCutRectangle({
    Key? key,
    required this.size,
    required this.percent,
    required this.playListName,
    required this.playListCount,
  }) : super(key: key);

  final Size size;
  final double percent;
  final String playListName;
  final int playListCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: size.width * 0.34, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: percent > 0.13
                    ? size.width * pow(percent, 5.5).clamp(0.0, 0.2)
                    : 0,
                top: size.height *
                    (percent > 0.48
                        ? pow(percent, 10.5).clamp(0.0, 0.06)
                        : 0.0)),
            child: Text(
              playListName,
              style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
          ),
          if (percent < 0.50) ...[
            const SizedBox(
              height: 2,
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: (1 - pow(percent, 0.001)).toDouble(),
              child: Text(
                '$playListCount Songs',
                style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            )
          ]
        ],
      ),
    );
  }
}
