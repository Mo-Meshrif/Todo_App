import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/utils/assets_manager.dart';
import '../../../../app/utils/routes_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../controller/home_bloc.dart';
import 'custom_add_edit_task.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isNotifiy;

  const CustomAppBar({Key? key, this.title, this.isNotifiy = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //hint:if title has null value ,refers to home-appBar
    return AppBar(
      leading: title != null
          ? null
          : Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(HelperFunctions.rotateVal(context)),
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
            ),
      centerTitle: isNotifiy,
      title: title != null
          ? Text(title!).tr()
          : SvgPicture.asset(
              IconAssets.appTitle,
              width: AppSize.s120,
            ),
      actions: [
        Visibility(
          visible: !isNotifiy,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
            child: GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushNamed(Routes.notificationRoute),
              child: SvgPicture.asset(
                IconAssets.alarm,
                width: AppSize.s25,
              ),
            ),
          ),
        ),
        Visibility(
          visible: title == null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
            child: GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
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
          ),
        ),
      ]
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(title == null ? AppSize.s70 : AppSize.s48);
}
