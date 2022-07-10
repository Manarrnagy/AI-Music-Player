import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/domain/core/resources/app_shared_preferences.dart';
import 'package:music_app/music_app.dart';
import 'package:music_app/ui/view/home/home_app_bar.dart';
import 'package:music_app/ui/view/playlist/playlist_page.dart';
import 'package:music_app/ui/view/profile/profile_page.dart';
import 'package:music_app/ui/view/search/search_delegate.dart';

import '../../core/components.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // List<Color> moodColors = [
  //   AppColors.happyColor,
  //   AppColors.sadColor,
  //   AppColors.angryColor,
  //   AppColors.disgustColor,
  //   AppColors.anxiousColor,
  //   AppColors.surprisedColor,
  //   AppColors.neutralColor,
  // ];

  Color returnMoodColors(String moods) {
    switch (moods) {
      case "Anxious":
        {
          return AppColors.anxiousColor;
        }
      case "Angry":
        {
          return AppColors.angryColor;
        }
      case "Happy":
        {
          return AppColors.happyColor;
        }
      case "Sad":
        {
          return AppColors.sadColor;
        }
      case "Neutral":
        {
          return AppColors.neutralColor;
        }
      case "Surprised":
        {
          return AppColors.surprisedColor;
        }
      case "Disgust":
        {
          return AppColors.disgustColor;
        }

      default:
        {
          return AppColors.neutralColor;
        }
    }
  }

  int returnMoodIndex(String moods) {
    switch (moods) {
      case "Anxious":
        {
          return 2;
        }
      case "Angry":
        {
          return 4;
        }
      case "Happy":
        {
          return 5;
        }
      case "Sad":
        {
          return 6;
        }
      case "Neutral":
        {
          return 3;
        }
      // case "Surprised":
      //   {
      //     return 7;
      //   }
      // case "Disgust":
      //   {
      //     return 8;
      //   }

      default:
        {
          return 0;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    cubit.getUserData(
      uId: AppSharedPreferences().getUID() ?? '',
    );
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is ImagePickedOnSuccessState) {
          AppCubit.get(context).changeNavBar(returnMoodIndex(cubit.output));
        }
      },
      builder: (context, state) {
        return state is! AppGetUserOnLoadingState
            ? Scaffold(
                appBar: HomeAppBar(
                  leadingIcon: InkWell(
                    onTap: () {
                      cubit.getFollowedArtists();
                      cubit.getLikedSongs();
                      cubit.getUserPlaylists();
                      AppComponents.navigateTo(
                          context: context,
                          newRoute: const Profile(),
                          backRoute: true);
                    },
                    child: Hero(
                      tag: 'profilePic',
                      child: MusicApp.userModel.profileImage == ''
                          ? const Icon(
                              Icons.account_circle,
                              size: 30.0,
                              color: AppColors.whiteColor,
                            )
                          : Container(
                              width: 30.0,
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.network(
                                MusicApp.userModel.profileImage!,
                              ),
                            ),
                    ),
                  ),
                  trailingIcon: const Icon(
                    CupertinoIcons.search,
                    color: AppColors.whiteColor,
                  ),
                  onTapTrailingIcon: () {
                    showSearch(context: context, delegate: MusicSearch());
                  },
                ),
                backgroundColor: AppColors.backgroundColor,
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          cubit.pickMoodImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.camera_alt,
                              size: 80.0,
                              color: AppColors.greyColor,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'Capture your mood',
                              style: TextStyle(
                                  color: AppColors.mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: AppColors.greyColor,
                      height: 1.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100.0),
                      child: Text(
                        'or choose from the playlists that suits every mood',
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 16.0,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 35,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: cubit.moods.length,
                            itemBuilder: (BuildContext ctx, index) {
                              cubit.pages.add(
                                PlayList(
                                  playListCardColor: returnMoodColors(
                                      cubit.moods[index].moodName ?? ''),
                                  moodModel: cubit.moods[index],
                                ),
                              );
                              return GestureDetector(
                                onTap: () {
                                  cubit.changeNavBar(index + 2);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Text(
                                      cubit.moods[index].moodName ?? '',
                                      style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.whiteColor),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    // color: Color(math.Random().nextInt(0xFF50286D)),
                                    color: returnMoodColors(
                                        cubit.moods[index].moodName ?? ''),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                color: AppColors.backgroundColor,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}
