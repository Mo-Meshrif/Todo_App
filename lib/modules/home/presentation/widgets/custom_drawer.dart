import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/utils/assets_manager.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/routes_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> pageList = [
      {
        'title': AppStrings.newTask,
        'icon': IconAssets.add,
        'size': AppSize.s25,
        'rotate': false,
        'onTap': () => Navigator.of(context).pushNamed(Routes.addTaskRoute),
      },
      {
        'title': AppStrings.important,
        'icon': IconAssets.important,
        'size': AppSize.s25,
        'rotate': false,
        'onTap': () => Navigator.of(context).pushNamed(Routes.importantRoute),
      },
      {
        'title': AppStrings.done,
        'icon': IconAssets.done,
        'size': AppSize.s25,
        'rotate': false,
        'onTap': () => Navigator.of(context).pushNamed(Routes.doneRoute),
      },
      {
        'title': AppStrings.later,
        'icon': IconAssets.later,
        'size': AppSize.s25,
        'rotate': false,
        'onTap': () => Navigator.of(context).pushNamed(Routes.laterRoute),
      },
      {
        'title': AppStrings.category,
        'icon': IconAssets.category,
        'size': AppSize.s25,
        'rotate': true,
        'onTap': () => Navigator.of(context).pushNamed(Routes.categoryRoute),
      },
      {
        'title': AppStrings.settings,
        'icon': IconAssets.settings,
        'size': AppSize.s25,
        'rotate': false,
        'onTap': () => Navigator.of(context).pushNamed(Routes.settingsRoute),
      },
      {
        'title': AppStrings.logout,
        'icon': IconAssets.logout,
        'size': AppSize.s20,
        'rotate': true,
        'onTap': () => debugPrint('Logout'),
      },
    ];
    return Container(
      color: Colors.white,
      width: ScreenUtil().screenWidth * 0.7,
      height: ScreenUtil().screenHeight,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: AppSize.s390.h,
            color: ColorManager.primary,
            padding: const EdgeInsets.fromLTRB(
              0,
              AppPadding.p5,
              0,
              AppPadding.p5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: ColorManager.primaryLight,
                  radius: AppSize.s110.r,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: AppSize.s100.r,
                  ),
                ),
                SizedBox(
                  height: AppSize.s10.h,
                ),
                const Text(
                  'Someone',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p5),
              itemCount: pageList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = pageList[index];
                return ListTile(
                  onTap: item['onTap'],
                  leading: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(
                      HelperFunctions.rotateVal(
                        context,
                        rotate: item['rotate'],
                      ),
                    ),
                    child: SvgPicture.asset(
                      item['icon'],
                      color: Colors.black,
                      width: item['size'] as double,
                    ),
                  ),
                  title: Text(
                    item['title'],
                  ).tr(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}