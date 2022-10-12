import 'dart:io';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import '../../modules/auth/domain/entities/user.dart';
import '../../modules/home/presentation/controller/home_bloc.dart';
import '../common/models/alert_action_model.dart';
import '../utils/strings_manager.dart';
import '/app/helper/extentions.dart';
import '/app/helper/shared_helper.dart';
import '../../modules/home/domain/entities/task_to_do.dart';
import '../services/services_locator.dart';
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
          content: Text(
            msg,
            textAlign: TextAlign.center,
          ),
        ),
      );

// showAlert
  static showAlert(
      {required BuildContext context,
      String? title,
      required Widget content,
      List<AlertActionModel>? actions,
      bool forceAndroidStyle = false}) {
    Platform.isAndroid || forceAndroidStyle
        ? showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s10)),
              contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 5),
              title: title == null ? null : Text(title),
              content: content,
              actions: actions == null
                  ? []
                  : actions
                      .map((action) => TextButton(
                            style: TextButton.styleFrom(
                              primary: action.color ?? ColorManager.primary,
                            ),
                            onPressed: action.onPressed,
                            child: Text(action.title).tr(),
                          ))
                      .toList(),
            ),
          )
        : showCupertinoDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: title == null ? null : Text(title),
              content: content,
              actions: actions == null
                  ? []
                  : actions
                      .map((action) => CupertinoDialogAction(
                            textStyle: TextStyle(
                              color: action.color ?? ColorManager.primary,
                            ),
                            child: Text(
                              action.title,
                            ).tr(),
                            onPressed: action.onPressed,
                          ))
                      .toList(),
            ),
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

  //Rotate value
  static double rotateVal(BuildContext context, {bool rotate = true}) {
    if (rotate && context.locale == AppConstants.arabic) {
      return math.pi;
    } else {
      return math.pi * 2;
    }
  }

  //getSavedUser
  static AuthUser getSavedUser() {
    var savedData = sl<AppShared>().getVal(AppConstants.userKey);
    return savedData is Map
        ? AuthUser(
            id: savedData['id'],
            name: savedData['name'],
            email: savedData['email'],
            pic: savedData['pic'],
          )
        : savedData;
  }

  //getLastUserName
  static String lastUserName() {
    AuthUser user = getSavedUser();
    return user.name.split(' ').last;
  }

  //get welcome string
  static String welcome() {
    String mark = DateTime.now().toHourMark();
    return mark == AppStrings.am
        ? AppStrings.goodMorning
        : AppStrings.goodNight;
  }

  //getTasksOnTab
  static getTasksOnTab(BuildContext ctx, int index) {
    switch (index) {
      case 0:
        BlocProvider.of<HomeBloc>(ctx).add(
          GetDailyTasksEvent(),
        );
        break;
      case 1:
        BlocProvider.of<HomeBloc>(ctx).add(
          GetWeeklyTasksEvent(),
        );
        break;
      case 2:
        BlocProvider.of<HomeBloc>(ctx).add(
          GetMonthlyTasksEvent(
            date: DateTime.now(),
          ),
        );
        break;
      default:
    }
  }

  // getDoneTaskLength
  static String doneTasksLength(BuildContext context, List<TaskTodo> tasks) {
    var temp = tasks.where((task) => task.done).toList();
    return getlocaleNumber(context, temp.length);
  }

  // toClock
  static String getlocaleNumber(BuildContext context, number) {
    if (context.locale == AppConstants.arabic) {
      return ArabicNumbers().convert(number);
    } else {
      return number;
    }
  }

  //isExpired
  static bool isExpired(String date) {
    //hint: we use custom fun because other funs compare all but we need only year,month,week and day
    DateTime dateTime = DateTime.parse(date);
    DateTime now = DateTime.now();
    if (dateTime.year >= now.year) {
      if (dateTime.month >= now.month) {
        if (dateTime.weekday >= now.weekday) {
          if (dateTime.day >= now.day) {
            return false;
          } else {
            return true;
          }
        } else {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  //datePicker
  static showDataPicker(
      {required BuildContext context,
      required void Function() onSave,
      required void Function(DateTime) onTimeChanged,
      void Function()? onclose}) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Material(
        color: ColorManager.kWhite,
        child: SizedBox(
          height: ScreenUtil().screenHeight * AppSize.s035,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p20,
                    ),
                    onPressed: onSave,
                    icon: const Icon(Icons.save),
                  ),
                  IconButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p20,
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(
                height: AppConstants.zeroVal,
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  onDateTimeChanged: onTimeChanged,
                  initialDateTime: DateTime.now(),
                  minimumDate: DateTime.now().subtract(
                    const Duration(seconds: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then(
      (_) => onclose == null ? () {} : onclose(),
    );
  }
}
