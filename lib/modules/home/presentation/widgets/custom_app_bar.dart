import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../app/common/models/notifiy_model.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/utils/assets_manager.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../../../app/utils/routes_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../controller/home_bloc.dart';
import 'customTask/custom_add_edit_task.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
    String? title,
    bool hideNotifyIcon = false,
    Widget? clearNotify,
  }) : super(
          key: key,
          leading: title != null
              ? null
              : Builder(
                  builder: (context) => Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(
                            HelperFunctions.rotateVal(context)),
                        child: Padding(
                          padding: const EdgeInsets.all(AppPadding.p15),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: SvgPicture.asset(
                              IconAssets.menubar,
                            ),
                          ),
                        ),
                      )),
          centerTitle: hideNotifyIcon,
          title: title != null
              ? Text(title).tr()
              : SvgPicture.asset(
                  IconAssets.appTitle,
                  width: AppSize.s120,
                ),
          actions: [
            Builder(builder: (context) {
              var notificationList = Hive.box(AppConstants.notificaionKey);
              return ValueListenableBuilder(
                valueListenable: notificationList.listenable(),
                builder: (context, _, __) {
                  String uid = HelperFunctions.getSavedUser().id;
                  List<ReceivedNotifyModel> savedList = notificationList.values
                      .map((e) => ReceivedNotifyModel.fromJson(
                          Map<String, dynamic>.from(e)))
                      .toList();
                  List<ReceivedNotifyModel> items = savedList
                      .where((e) =>
                          (e.from == uid && e.type == 'Task') || e.to == uid)
                      .toList();
                  List<ReceivedNotifyModel> notOpenedList =
                      items.where((e) => !e.isOpened).toList();
                  return clearNotify != null && items.isNotEmpty
                      ? clearNotify
                      : hideNotifyIcon
                          ? const Padding(padding: EdgeInsets.zero)
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.p10),
                              child: Badge(
                                position:
                                    BadgePosition.topEnd(top: 12, end: 15),
                                showBadge: notOpenedList.isNotEmpty,
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context).pushNamed(
                                    Routes.notificationRoute,
                                    arguments: items,
                                  ),
                                  child: SvgPicture.asset(
                                    IconAssets.alarm,
                                    width: AppSize.s25,
                                  ),
                                ),
                              ),
                            );
                },
              );
            }),
            Visibility(
              visible: title == null,
              child: Builder(
                  builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p10),
                        child: GestureDetector(
                          onTap: () => showBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(AppSize.s30.r),
                                topRight: Radius.circular(AppSize.s30.r),
                              ),
                            ),
                            builder: (context) => AddEditTaskWidget(
                              addFun: (task) => context.read<HomeBloc>().add(
                                    AddTaskEvent(
                                      taskTodo: task,
                                    ),
                                  ),
                            ),
                          ),
                          child: SvgPicture.asset(
                            IconAssets.add,
                            width: AppSize.s25,
                          ),
                        ),
                      )),
            ),
          ],
        );
}
