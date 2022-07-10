import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../domain/core/resources/app_colors.dart';

enum ToastStates { success, error, warning, grey }

class AppComponents {
  static void navigateTo(
          {required BuildContext context,
          required Widget newRoute,
          required bool backRoute}) =>
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => newRoute),
        (route) => backRoute,
      );

  static Widget defaultFormField({
    required TextEditingController controller,
    required TextInputType type,
    FormFieldValidator<String>? validate,
    bool isPassword = false,
    String? label,
    IconData? suffixIcon,
    Color? suffixIconColor,
    VoidCallback? onTapSuffixIcon,
    VoidCallback? onTapTextField,
    void Function(String)? onChangeTextField,
    bool readOnly = false,
  }) =>
      TextFormField(
        controller: controller,
        onChanged: onChangeTextField,
        onTap: onTapTextField,
        validator: validate,
        readOnly: readOnly,
        obscureText: isPassword,
        keyboardType: type,
        style: const TextStyle(color: AppColors.whiteColor),
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: onTapSuffixIcon,
            child: Icon(
              suffixIcon,
              color: suffixIconColor,
              size: 20,
            ),
          ),
          suffixIconColor: suffixIconColor,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.whiteColor),
          ),
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.whiteColor),
        ),
      );

  static Widget reusableFormCard({
    Key? key,
    required List<Widget> children,
    Color? color,
  }) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Form(
          key: key,
          child: Column(
            children: children,
          ),
        ),
      );

  static Widget defaultButton({
    required String text,
    required VoidCallback onPressed,
    required BuildContext context,
    double? radius = 10.0,
    double? height = 50.0,
    double? width = double.infinity,
    bool isDimmed = false,
  }) =>
      Container(
        width: width,
        decoration: BoxDecoration(
          color: isDimmed
              ? AppColors.greyColor2.withOpacity(0.2)
              : AppColors.mainColor,
          borderRadius: BorderRadius.circular(radius!),
        ),
        height: height,
        child: MaterialButton(
          splashColor:
              isDimmed ? Colors.transparent : Theme.of(context).splashColor,
          highlightColor:
              isDimmed ? Colors.transparent : Theme.of(context).highlightColor,
          onPressed: isDimmed ? () {} : onPressed,
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              color: isDimmed
                  ? AppColors.greyColor.withOpacity(0.3)
                  : Colors.white,
            ),
          ),
        ),
      );

  static Widget defaultTextButton({
    required VoidCallback onPressed,
    required String text,
    Color? textColor,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: InkWell(
          onTap: onPressed,
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
                color: textColor ?? Colors.blueAccent,
                fontWeight: FontWeight.bold),
          ),
        ),
      );

  // static Widget roundIconButton({
  //   required IconData icon,
  //   required VoidCallback onPressed,
  //   required Color color,
  //   Color? iconColor,
  // }) =>
  //     RawMaterialButton(
  //       elevation: 0.0,
  //       child: Icon(
  //         icon,
  //         color: iconColor,
  //       ),
  //       onPressed: onPressed,
  //       constraints: const BoxConstraints.tightFor(
  //         width: 60.0,
  //         height: 60.0,
  //       ),
  //       shape: const CircleBorder(),
  //       fillColor: color,
  //     );

  static Widget roundedOutlinedButton({
    required String text,
    required void Function() onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.whiteColor),
              borderRadius: BorderRadius.circular(20.0)),
          child: Text(
            text,
            style: const TextStyle(
                color: AppColors.whiteColor,
                fontSize: 12.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      );

  static void showToast({
    required String text,
    required ToastStates states,
  }) =>
      Fluttertoast.showToast(
          msg: text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: chooseToastColor(states),
          textColor: Colors.white,
          fontSize: 16.0);

  static Color chooseToastColor(ToastStates states) {
    Color color;
    switch (states) {
      case ToastStates.success:
        color = Colors.green;
        break;
      case ToastStates.error:
        color = Colors.red;
        break;
      case ToastStates.warning:
        color = Colors.amber;
        break;
      case ToastStates.grey:
        color = Colors.grey;
        break;
    }
    return color;
  }
}
