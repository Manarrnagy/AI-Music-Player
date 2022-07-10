import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/ui/core/components.dart';
import 'package:music_app/ui/core/layout/main_layout.dart';

import '../../../domain/core/resources/app_colors.dart';
import 'artist_grid_item.dart';

class ChooseArtistsPage extends StatelessWidget {
  ChooseArtistsPage({Key? key}) : super(key: key);
  // Creates a controller for a scrollable widget
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // takes the current page (builds the choose artist page) we are in and the
    // change in state and displays that change on that page on screen
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return state is AppChooseFavouriteArtistOnLoadingState
            ? Container(
                color: AppColors.backgroundColor,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                // displays app bar with title choose your favourite artists
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: AppColors.backgroundColor,
                  elevation: 0.0,
                  title: const Text(
                    'Choose your favourite artists',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        // if no artist is chosen, a grey pop up appears asking user to choose atleast one artist
                        if (cubit.favouriteArtists.isEmpty) {
                          AppComponents.showToast(
                              text: 'Please choose one artist at least',
                              states: ToastStates.grey);
                        } else {
                          // navigates to home page from this page (we can't press back from this page)
                          AppComponents.navigateTo(
                              context: context,
                              newRoute: const MainLayout(),
                              backRoute: false);
                        }

                        // choose favourite artists
                        for (var element in cubit.favouriteArtists) {
                          cubit.chooseArtist(element);
                        }
                      },
                      icon: const Icon(Icons.check),
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 5.0),
                  child: GridView.builder(
                    physics:
                        const BouncingScrollPhysics(), // adds a bouncing effect when user reaches the end
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 1,
                    ),
                    controller: controller, // the scrollable controller
                    itemCount: cubit.artists.length,
                    itemBuilder: (context, index) {
                      return ArtistGridItem(
                        // builds the grid of artists
                        artistModel: cubit
                            .artists[index], //shows artists on each grid item
                        // adds each artist that got chosen to a list
                        onArtistSelected: (artistModel) {
                          if (kDebugMode) {
                            print(artistModel.artistID);
                          }
                          cubit.favouriteArtists.add(artistModel);
                        },
                      );
                    },
                  ),
                ),
              );
      },
    );
  }
}
