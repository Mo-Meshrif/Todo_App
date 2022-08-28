import 'package:flutter/material.dart';
import '/app/utils/values_manager.dart';
import '../utils/color_manager.dart';
import '../utils/constants_manager.dart';

class HelperFunctions {
  // isEmailValid
  static bool isEmailValid(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
// showSnackBar
  static showSnackBar(BuildContext context, String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: AppConstants.durationInSec),
          content: Text(msg),
        ),
      );
// showAlert
  static showAlert(
      {required BuildContext context,
      String? title,
      required Widget content,
      List<Widget>? actions}) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s10)),
      contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 5),
      title: title == null ? null : Text(title),
      content: content,
      actions: actions ?? [],
    );
    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => alert,
    );
  }

  //show popUp loading
  static showPopUpLoading(BuildContext context) => showAlert(
        context: context,
        content: SizedBox(
          height: AppSize.s80,
          child: Center(
            child: CircularProgressIndicator(
              color: ColorManager.primary,
            ),
          ),
        ),
      );
}
