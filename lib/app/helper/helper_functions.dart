import 'dart:io';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import '../../modules/auth/domain/entities/user.dart';
import '../../modules/home/presentation/controller/home_bloc.dart';
import '../common/models/alert_action_model.dart';
import '../common/models/notifiy_model.dart';
import '../services/notification_services.dart';
import '../utils/routes_manager.dart';
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
                              foregroundColor:
                                  action.color ?? ColorManager.primary,
                            ),
                            onPressed: action.onPressed,
                            child: Text(action.title),
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
                            child: Text(action.title),
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
            deviceToken: savedData['deviceToken'],
          )
        : savedData;
  }

  //loadUserPic
  static Future<File?> loadUserPic(AuthUser user) async {
    AppShared _appShared = sl<AppShared>();
    if (user.pic != null) {
      if (user.pic!.isNotEmpty) {
        String img = user.pic!.split('/').last;
        String savedPic = _appShared.getVal(AppConstants.userPicKey) ?? '';
        bool isExists = File(savedPic).existsSync();
        if (savedPic.isEmpty
            ? true
            : isExists
                ? savedPic.split('/').last != img
                : true) {
          http.Response response = await http.get(Uri.parse(user.pic!));
          if (response.statusCode != 404) {
            final bytes = response.bodyBytes;
            var temp = await getTemporaryDirectory();
            final path = '${temp.path}/$img';
            File(path).writeAsBytesSync(bytes);
            _appShared.setVal(
              AppConstants.userPicKey,
              path,
            );
            return File(path);
          } else {
            return null;
          }
        } else {
          return File(savedPic);
        }
      } else {
        return null;
      }
    } else {
      return null;
    }
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
      return number.toString();
    }
  }

  //isExpired
  static bool isExpired(String date) {
    DateTime dateTime = DateTime.parse(date).zeroTime();
    DateTime now = DateTime.now().zeroTime();
    return dateTime.isBefore(now);
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

  //change language
  static toggleLanguage(BuildContext context) {
    if (context.locale == AppConstants.arabic) {
      context.setLocale(AppConstants.english);
    } else {
      context.setLocale(AppConstants.arabic);
    }
  }

  //convert ringTone to Uint8List
  static Future<Uint8List> getAssetRingToneData(String path) async {
    var asset = await rootBundle.load(path);
    return asset.buffer.asUint8List();
  }

  //getNumberOfDayByIndex
  static DateTime getDateByIndex(int index) {
    DateTime now = DateTime.now();
    return now.add(Duration(days: index + 1 - now.weekday));
  }

  //get month
  static String getMonth(int monthAsInt) {
    late String month;
    switch (monthAsInt) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }
    return month;
  }

  //refactor taskList
  static List<Map<String, dynamic>> refactorTaskList(List<TaskTodo> taskList) {
    List<Map<String, dynamic>> tempList = [];
    for (var item in taskList) {
      DateTime date = DateTime.parse(item.date);
      int indexTemp =
          tempList.indexWhere((element) => element['day'] == date.day);
      if (indexTemp > -1) {
        (tempList[indexTemp]['tasks'] as List).add(item);
      } else {
        tempList.add(
          {
            'day': date.day,
            'month': date.month,
            'tasks': [item],
          },
        );
      }
    }
    tempList.sort((a, b) => a['day'].compareTo(b['day']));
    return tempList;
  }

  //Check notifications permission
  static checkNotificationsPermission(BuildContext context) {
    sl<AwesomeNotifications>().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        if (Platform.isIOS) {
          sl<AwesomeNotifications>().requestPermissionToSendNotifications();
        } else {
          showAlert(
            context: context,
            title: 'Allow Notifications',
            content: const Text('Our app would like to send you notifications'),
            actions: [
              AlertActionModel(
                title: 'Allow',
                onPressed: () => sl<AwesomeNotifications>()
                    .requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context)),
              ),
              AlertActionModel(
                title: 'Don\'t Allow',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        }
      }
    });
  }

  //notification action
  static handleNotificationAction(
    BuildContext context,
    ReceivedNotifyModel event, {
    bool hideNotifyIcon = false,
    bool fromNotScreen = false,
  }) {
    if (event.type == 'Task') {
      //Local Notifications
      debugPrint('Local Notifications action');
      if (event.buttonKeyPressed.isNotEmpty && !event.isOpened) {
        debugPrint('Notification key pressed: ${event.buttonKeyPressed}');
        BlocProvider.of<HomeBloc>(context).add(
          GetTaskByIdEvent(taskId: event.id, withNav: false),
        );
      } else {
        BlocProvider.of<HomeBloc>(context).add(
          GetTaskByIdEvent(
            taskId: event.id,
            withNav: true,
            hideNotifyIcon: hideNotifyIcon,
          ),
        );
      }
    } else {
      //Remote notification
      debugPrint('Remote Notifications action');
      Navigator.of(context).pushNamed(
        Routes.tempNotifyScreenRoute,
        arguments: event,
      );
    }
    if (!event.isOpened) {
      sl<NotificationServices>().saveNotificationData(
        event.toJson(),
        true,
        fromNotScreen: fromNotScreen,
      );
      sl<AwesomeNotifications>().getGlobalBadgeCounter().then(
        (value) {
          if (value > 0) {
            sl<AwesomeNotifications>().setGlobalBadgeCounter(value - 1);
          }
        },
      );
    }
  }
}
