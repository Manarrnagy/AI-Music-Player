import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/ui/core/components.dart';
import 'package:music_app/ui/core/loading_overlay.dart';
import 'package:music_app/ui/view/add_songs/add_custom_playlist_songs.dart';

class NewPlaylistBody extends StatefulWidget {
  const NewPlaylistBody({Key? key}) : super(key: key);

  @override
  State<NewPlaylistBody> createState() => _NewPlaylistBodyState();
}

class _NewPlaylistBodyState extends State<NewPlaylistBody> {
  final playlistNameController = TextEditingController();
  bool isEmptyField = true;
  @override
  void dispose() {
    playlistNameController.clear();
    playlistNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppCreateCustomPlaylistOnSuccessState) {
          AppComponents.navigateTo(
              context: context,
              newRoute: AddCustomPlayListSongs(
                list: cubit.songs,
                playlistID: state.playlistID,
              ),
              backRoute: true);
        }
      },
      builder: (context, state) {
        return Container(
          clipBehavior: Clip.hardEdge,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: const BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadiusDirectional.all(
              Radius.circular(10.0),
            ),
          ),
          child: Stack(
            children: [
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          'Give your playlist a name',
                          style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Center(
                            child: AppComponents.defaultFormField(
                                controller: playlistNameController,
                                type: TextInputType.text,
                                onChangeTextField: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      isEmptyField = false;
                                    });
                                  } else {
                                    setState(() {
                                      isEmptyField = true;
                                    });
                                  }
                                }),
                          ),
                        ),
                        AppComponents.defaultButton(
                            text: 'Done',
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              AppCubit.get(context)
                                  .createPlayList(playlistNameController.text);
                            },
                            isDimmed: isEmptyField,
                            context: context)
                      ],
                    ),
                  ),
                  const CloseButton(
                    color: AppColors.whiteColor,
                  ),
                ],
              ),
              if (state is AppCreateCustomPlaylistOnLoadingState)
                const LoadingOverlay(),
            ],
          ),
        );
      },
    );
  }
}

Future showNewPlaylistDialog({
  required BuildContext context,
}) {
  return showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white24,
      context: context,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: NewPlaylistBody(),
        );
      });
}
