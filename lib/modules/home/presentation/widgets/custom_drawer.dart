import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/common/models/custom_task_args_model.dart';
import '../../../../app/common/models/drawer_item_model.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/helper/shared_helper.dart';
import '../../../../app/services/services_locator.dart';
import '../../../../app/utils/assets_manager.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../../../app/utils/routes_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/controller/auth_bloc.dart';
import '../controller/home_bloc.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthUser user = HelperFunctions.getSavedUser();
    List<DrawerItemModel> pageList = [
      DrawerItemModel(
        title: AppStrings.important,
        icon: IconAssets.importantWhite,
        size: AppSize.s25,
        rotate: false,
        onTap: () {
          BlocProvider.of<HomeBloc>(context).add(
            const GetCustomTasksEvent('important'),
          );
          Navigator.of(context).pushNamed(
            Routes.customRoute,
            arguments: CustomTaskArgsModel(
              appTitle: 'Important Tasks',
              type: 'important',
            ),
          );
        },
      ),
      DrawerItemModel(
        title: AppStrings.done,
        icon: IconAssets.done,
        size: AppSize.s25,
        rotate: false,
        onTap: () {
          BlocProvider.of<HomeBloc>(context).add(
            const GetCustomTasksEvent('done'),
          );
          Navigator.of(context).pushNamed(
            Routes.customRoute,
            arguments: CustomTaskArgsModel(
              appTitle: 'Done Tasks',
              type: 'done',
            ),
          );
        },
      ),
      DrawerItemModel(
        title: AppStrings.later,
        icon: IconAssets.later,
        size: AppSize.s25,
        rotate: false,
        onTap: () {
          BlocProvider.of<HomeBloc>(context).add(
            const GetCustomTasksEvent('later'),
          );
          Navigator.of(context).pushNamed(
            Routes.customRoute,
            arguments: CustomTaskArgsModel(
              appTitle: 'Later Tasks',
              type: 'later',
            ),
          );
        },
      ),
      DrawerItemModel(
        title: AppStrings.settings,
        icon: IconAssets.settings,
        size: AppSize.s25,
        rotate: false,
        onTap: () => Navigator.of(context).pushNamed(Routes.settingsRoute),
      ),
      DrawerItemModel(
        title: AppStrings.logout,
        icon: IconAssets.logout,
        size: AppSize.s20,
        rotate: true,
        onTap: () => BlocProvider.of<AuthBloc>(context).add(
          const LogoutEvent(),
        ),
      ),
    ];
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPopUpLoading) {
          HelperFunctions.showPopUpLoading(context);
        } else if (state is AuthLogoutSuccess) {
          sl<AppShared>().removeVal(AppConstants.authPassKey);
          sl<AppShared>().setVal(AppConstants.authPassKey, false);
          sl<FirebaseMessaging>().unsubscribeFromTopic(AppConstants.toUser);
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.authRoute,
            (route) => false,
          );
        }
      },
      child: Container(
        color: Colors.white,
        width: ScreenUtil().screenWidth * 0.7,
        height: ScreenUtil().screenHeight,
        child: Column(
          children: [
            FutureBuilder<File?>(
              future: HelperFunctions.loadUserPic(user),
              builder: (context, snapshot) {
                File? pic = snapshot.hasData ? snapshot.data : null;
                return Container(
                  width: double.infinity,
                  color: ColorManager.primary,
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SafeArea(
                        left: false,
                        right: false,
                        bottom: false,
                        child: CircleAvatar(
                          backgroundColor: ColorManager.primaryLight,
                          radius: AppSize.s110.r,
                          child: snapshot.connectionState ==
                                  ConnectionState.waiting
                              ? CircleAvatar(
                                  backgroundColor: ColorManager.primary,
                                  radius: AppSize.s100.r,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(AppPadding.p10),
                                    child: CircularProgressIndicator(
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: AppSize.s100.r,
                                  backgroundImage: pic != null
                                      ? FileImage(pic)
                                      : const AssetImage(
                                              ImageAssets.placeHolder)
                                          as ImageProvider,
                                ),
                        ),
                      ),
                      SizedBox(
                        height: AppSize.s10.h,
                      ),
                      Text(
                        user.name.isEmpty ? AppStrings.user.tr() : user.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: AppPadding.p5),
                itemCount: pageList.length,
                itemBuilder: (context, index) {
                  DrawerItemModel item = pageList[index];
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      item.onTap();
                    },
                    leading: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(
                        HelperFunctions.rotateVal(
                          context,
                          rotate: item.rotate,
                        ),
                      ),
                      child: SvgPicture.asset(
                        item.icon,
                        color: Colors.black,
                        width: item.size,
                      ),
                    ),
                    title: Text(
                      item.title,
                    ).tr(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
