// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/music_app.dart';
import 'package:music_app/ui/core/loading_overlay.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();

  bool isNameValid(String name) {
    Pattern pattern =
        r"^([a-zA-Z]{2,}\s[a-zA-Z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)";
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(name);
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = MusicApp.userModel.name ?? '';
    AppCubit cubit = AppCubit.get(context);
    cubit.clearImageFile();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text('Edit profile'),
              elevation: 0.0,
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: () {
                    if (cubit.profileImage != null) {
                      cubit.uploadProfileImage(name: nameController.text);
                    } else {
                      cubit.updateUser(
                          name: nameController.text,
                          profile: MusicApp.userModel.profileImage ?? '');
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      cubit.pickProfilePhoto();
                    },
                    child: Column(
                      children: [
                        Center(
                          child: Hero(
                              tag: 'profilePic',
                              child: cubit.profileImage == null
                                  ? MusicApp.userModel.profileImage == ''
                                      ? const Icon(
                                          Icons.account_circle,
                                          size: 200.0,
                                          color: AppColors.whiteColor,
                                        )
                                      : Container(
                                          width: 200.0,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.network(
                                            MusicApp.userModel.profileImage!,
                                          ),
                                        )
                                  : Container(
                                      width: 200.0,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.file(cubit.profileImage!),
                                    )),
                        ),
                        const Text(
                          'Change photo',
                          style: TextStyle(
                              color: AppColors.whiteColor, fontSize: 12.0),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          textAlign: TextAlign.center,
                          controller: nameController,
                          validator: (name) {
                            if (!isNameValid(name.toString())) {
                              return 'Enter a valid name';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          style: const TextStyle(
                              color: AppColors.whiteColor, fontSize: 25.0),
                          decoration: InputDecoration(
                            hintText: 'Your Name',
                            hintStyle: TextStyle(
                                color: AppColors.whiteColor.withOpacity(0.2),
                                fontSize: 25.0),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.whiteColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (state is AppGetUserOnLoadingState ||
              state is AppUploadProfileImageOnLoadingState)
            const LoadingOverlay()
        ],
      ),
    );
  }
}
