import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/music_app.dart';
import 'package:music_app/ui/core/components.dart';

class RatingContainer extends StatelessWidget {
  const RatingContainer(
      {Key? key, required this.cubit, required this.songModel})
      : super(key: key);

  final AppCubit cubit;
  final SongModel songModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) {
              return Center(
                child: Card(
                  color: AppColors.backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Rate the song',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        RatingBar.builder(
                          initialRating: cubit.songRating,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: AppColors.mainColor,
                          ),
                          onRatingUpdate: (rating) {
                            cubit.songRating = rating;
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        AppComponents.defaultButton(
                            width: MusicApp.mediaQuery!.size.width / 2,
                            text: 'Submit',
                            onPressed: () {
                              Navigator.pop(context);
                              cubit.rateSong(songModel, cubit.songRating);
                            },
                            context: context),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: AppColors.mainColor, width: 3.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your rating :',
              style: TextStyle(fontSize: 20.0, color: AppColors.whiteColor),
            ),
            const SizedBox(
              width: 15.0,
            ),
            RatingBarIndicator(
              rating: cubit.songRating,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: AppColors.mainColor,
              ),
              itemCount: 5,
              itemSize: 25.0,
              direction: Axis.horizontal,
            ),
          ],
        ),
      ),
    );
  }
}
