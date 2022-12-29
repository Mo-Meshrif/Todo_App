import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../domain/entities/task_to_do.dart';
import 'custom_task_list.dart';

class CustomTaskListTile extends StatelessWidget {
  const CustomTaskListTile({
    Key? key,
    required this.taskList,
    required this.title,
  }) : super(key: key);

  final List<TaskTodo> taskList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 40.sp,
            color: ColorManager.primary,
          ),
        ),
        const SizedBox(height: 5),
        CustomTaskList(
          taskList: taskList,
        ),
      ],
    );
  }
}
