import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/control/cubit/cubit.dart';
import 'package:music_app/control/cubit/states.dart';
import 'package:music_app/domain/core/resources/app_assets_paths.dart';
import 'package:music_app/domain/core/resources/app_colors.dart';
import 'package:music_app/ui/core/components.dart';
import 'package:music_app/ui/core/layout/main_layout.dart';
import 'package:music_app/ui/view/register/register_page.dart';

import '../../core/loading_overlay.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is LoginOnFailedState) {
          AppComponents.showToast(
            text: state.error,
            states: ToastStates.error,
          );
        }
        if (state is LoginOnSuccessState) {
          AppComponents.navigateTo(
              context: context, newRoute: const MainLayout(), backRoute: false);
        }
      },
      builder: (context, state) => Scaffold(
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
                          isPassword: cubit.secured,
                          suffixIcon: cubit.visibility,
                          onTapSuffixIcon: () {
                            cubit.changePasswordVisibility();
                          },
                          suffixIconColor: AppColors.whiteColor,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: AppComponents.defaultButton(
                              text: 'Login',
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (formGlobalKey.currentState!.validate()) {
                                  cubit.userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              context: context),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                              style: TextStyle(color: AppColors.whiteColor),
                            ),
                            AppComponents.defaultTextButton(
                                onPressed: () {
                                  AppComponents.navigateTo(
                                      context: context,
                                      newRoute: RegisterPage(),
                                      backRoute: true);
                                },
                                text: 'SignUp ')
                          ],
                        )
                      ]),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            if (state is LoginOnLoadingState) const LoadingOverlay()
          ],
        ),
      ),
    );
  }
}
