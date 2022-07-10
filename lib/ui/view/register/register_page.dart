// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_assets_paths.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/ui/core/components.dart';

import '../../core/loading_overlay.dart';
import '../choose_artists/choose_artists_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final formGlobalKey = GlobalKey<FormState>();

  bool isPasswordValid(String password) => password.length >= 8;

  bool isEmailValid(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email);
  }

  bool isNameValid(String name) {
    Pattern pattern =
        r"^([a-zA-Z]{2,}\s[a-zA-Z]{1,}'?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)";
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(name);
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is RegisterOnFailedState) {
          AppComponents.showToast(
            text: state.error,
            states: ToastStates.error,
          );
        }
        if (state is RegisterOnSuccessState) {
          AppComponents.navigateTo(
              context: context,
              newRoute: ChooseArtistsPage(),
              backRoute: false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 9,
                    ),
                    Hero(
                      tag: "AppLogo",
                      child: Image.asset(
                        AppAssets.appLogo,
                        height: 100.0,
                        width: 100.0,
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    AppComponents.reusableFormCard(
                        key: formGlobalKey,
                        color: AppColors.formCardColor,
                        children: [
                          AppComponents.defaultFormField(
                            controller: nameController,
                            type: TextInputType.name,
                            label: 'Name',
                            validate: (name) {
                              if (!isNameValid(name.toString())) {
                                return 'Enter a valid name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          AppComponents.defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            label: 'Email',
                            validate: (email) {
                              if (!isEmailValid(email.toString())) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          AppComponents.defaultFormField(
                            controller: passwordController,
                            type: TextInputType.text,
                            label: 'Password',
                            isPassword: true,
                            validate: (password) {
                              if (!isPasswordValid(password.toString())) {
                                return 'Enter a valid password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          AppComponents.defaultFormField(
                            controller: cubit.birthDateController,
                            type: TextInputType.datetime,
                            readOnly: true,
                            label: 'Birthdate',
                            onTapTextField: () {
                              cubit.selectDate(context);
                            },
                            validate: (birthDate) {
                              if (birthDate!.isEmpty) {
                                return 'Enter your birthdate';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: AppComponents.defaultButton(
                                text: 'SignUp',
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (formGlobalKey.currentState!.validate()) {
                                    cubit.userRegister(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        birthDate: Timestamp.fromDate(
                                            cubit.selectedBirthDate));
                                  }
                                },
                                context: context),
                          ),
                        ]),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
              if (state is RegisterOnLoadingState) const LoadingOverlay()
            ],
          ),
        );
      },
    );
  }
}
