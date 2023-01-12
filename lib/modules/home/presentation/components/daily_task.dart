import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart' as format;
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/utils/assets_manager.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../controller/home_bloc.dart';
import '../widgets/customTaskList/custom_task_list.dart';
import '../widgets/custom_scroll_to_top.dart';

class DailyTask extends StatelessWidget {
  const DailyTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (ctx, state) {
        if (state is AddTaskLoaded ||
            state is EditTaskLoaded ||
            state is DeleteTaskLLoaded) {
          BlocProvider.of<HomeBloc>(ctx).add(GetDailyTasksEvent());
        }
      },
      buildWhen: (previous, current) =>
          current is DailyTaskLoaded || current is DailyTaskLoading,
      builder: (context, state) => state is DailyTaskLoaded
          ? state.dailyList.isNotEmpty
              ? Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.fromLTRB(
                        AppPadding.p15,
                        AppPadding.p15,
                        AppPadding.p15,
                        AppConstants.zeroVal,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppPadding.p15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${HelperFunctions.welcome().tr()} ${HelperFunctions.lastUserName()}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.today,
                                  style: TextStyle(
                                    color: ColorManager.primary,
                                  ),
                                ).tr(),
                                Column(
                                  children: [
                                    Text(
                                      AppStrings.completed,
                                      style: TextStyle(
                                        color: ColorManager.kGreen,
                                      ),
                                    ).tr(),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                            color: ColorManager.kGreen),
                                        children: [
                                          TextSpan(
                                            text:
                                                HelperFunctions.doneTasksLength(
                                                      context,
                                                      state.dailyList,
                                                    ) +
                                                    '/',
                                          ),
                                          TextSpan(
                                            text:
                                                HelperFunctions.getlocaleNumber(
                                              context,
                                              state.dailyList.length,
                                            ),
                                            style: TextStyle(
                                              color: ColorManager.kRed,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Text(
                              format.DateFormat(
                                'd-M-yyyy',
                                context.locale.languageCode,
                              ).format(
                                DateTime.now(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppPadding.p15),
                    Expanded(
                      child: CustomScrollToTop(
                        builder: (context, properties) => SingleChildScrollView(
                          controller: properties.scrollController,
                          scrollDirection: properties.scrollDirection,
                          reverse: properties.reverse,
                          primary: properties.primary,
                          child: CustomTaskList(
                            taskList: state.dailyList,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Lottie.asset(JsonAssets.addTask)
          : Center(
              child: CircularProgressIndicator(
                color: ColorManager.primary,
              ),
            ),
    );
  }
}
