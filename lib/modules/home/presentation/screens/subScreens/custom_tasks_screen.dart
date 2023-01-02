import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../../app/common/models/custom_task_args_model.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../controller/home_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/customTaskList/custom_task_list.dart';

class CustomTasksScreen extends StatelessWidget {
  final CustomTaskArgsModel args;
  const CustomTasksScreen({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: args.appTitle,
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is EditTaskLoaded || state is DeleteTaskLLoaded) {
            BlocProvider.of<HomeBloc>(context).add(
              GetCustomTasksEvent(args.type),
            );
          }
        },
        buildWhen: (previous, current) =>
            current is CustomTaskLoaded || current is CustomTaskLoading,
        builder: (context, state) => state is CustomTaskLoaded
            ? state.customList.isNotEmpty
                ? SingleChildScrollView(
                    child: CustomTaskList(
                      taskList: state.customList,
                    ),
                  )
                : Center(child: Lottie.asset(JsonAssets.empty))
            : Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primary,
                ),
              ),
      ),
    );
  }
}
