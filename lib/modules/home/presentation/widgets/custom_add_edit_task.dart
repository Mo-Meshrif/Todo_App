import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as format;
import '../../../../app/helper/enums.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../../domain/entities/task_to_do.dart';

class AddEditTaskWidget extends StatelessWidget {
  final TaskTodo? editTask;
  final void Function(TaskTodo task)? addFun;
  final void Function(TaskTodo task)? editFun;
  const AddEditTaskWidget({
    Key? key,
    this.addFun,
    this.editTask,
    this.editFun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController taskNameController =
        TextEditingController(text: editTask?.name);
    TextEditingController categoryController =
        TextEditingController(text: editTask?.category);
    TextEditingController dateController = TextEditingController(
      text: editTask == null
          ? null
          : format.DateFormat('d-M-yyyy | h:mm a').format(
              DateTime.parse(editTask!.date),
            ),
    );
    TextEditingController descriptionController =
        TextEditingController(text: editTask?.description);
    TaskPriority taskPriority = editTask?.priority ?? TaskPriority.high;
    DateTime? dateTime;
    DateTime? tempTime;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p15, vertical: AppPadding.p20),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          StatefulBuilder(
            builder: (context, innerState) => Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autofocus: true,
                    controller: taskNameController,
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppStrings.enterTaskName.tr();
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: AppStrings.taskName.tr(),
                      labelStyle: const TextStyle(color: Colors.black),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  TextFormField(
                    controller: categoryController,
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppStrings.enterTaskCategory.tr();
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: AppStrings.category.tr(),
                      labelStyle: const TextStyle(color: Colors.black),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s15,
                  ),
                  const Text(AppStrings.taskPriority).tr(),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          horizontalTitleGap: AppConstants.oneVal,
                          title: const Text(AppStrings.high).tr(),
                          leading: Radio<TaskPriority>(
                            value: TaskPriority.high,
                            activeColor: ColorManager.kRed,
                            groupValue: taskPriority,
                            onChanged: (value) =>
                                innerState(() => taskPriority = value!),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          horizontalTitleGap: AppConstants.oneVal,
                          title: const Text(AppStrings.medium).tr(),
                          leading: Radio<TaskPriority>(
                            value: TaskPriority.medium,
                            groupValue: taskPriority,
                            activeColor: ColorManager.kOrange,
                            onChanged: (value) =>
                                innerState(() => taskPriority = value!),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSize.s10),
                      Expanded(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          horizontalTitleGap: AppConstants.oneVal,
                          title: const Text(AppStrings.low).tr(),
                          leading: Radio<TaskPriority>(
                            value: TaskPriority.low,
                            activeColor: ColorManager.kYellow,
                            groupValue: taskPriority,
                            onChanged: (value) => innerState(
                              () => taskPriority = value!,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  TextFormField(
                    onTap: () => showCupertinoModalPopup(
                      context: context,
                      builder: (context) => Material(
                        color: ColorManager.kWhite,
                        child: SizedBox(
                          height: ScreenUtil().screenHeight * AppSize.s035,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppPadding.p20,
                                    ),
                                    onPressed: () {
                                      innerState(
                                        () {
                                          if (tempTime == null) {
                                            if (editTask == null) {
                                              dateTime = DateTime.now();
                                            } else {
                                              dateTime = DateTime.parse(
                                                editTask!.date,
                                              );
                                            }
                                          } else {
                                            dateTime = tempTime;
                                          }
                                        },
                                      );
                                      dateController.text =
                                          format.DateFormat('d-M-yyyy | h:mm a')
                                              .format(dateTime!);
                                      Navigator.pop(context);
                                    },
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
                                  onDateTimeChanged: (value) => innerState(
                                    () => tempTime = value,
                                  ),
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
                    ),
                    controller: dateController,
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppStrings.enterTaskDate.tr();
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: AppStrings.taskDate.tr(),
                      labelStyle: const TextStyle(color: Colors.black),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s10,
                  ),
                  Card(
                    margin: EdgeInsets.zero,
                    child: TextFormField(
                      maxLines: 8,
                      controller: descriptionController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: AppStrings.taskDescription.tr(),
                        contentPadding: const EdgeInsets.all(AppPadding.p10),
                        hintStyle: const TextStyle(color: Colors.black),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s70,
                  ),
                ],
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.of(context).pop();
                if (editTask == null) {
                  addFun!(
                    TaskTodo(
                      name: taskNameController.text,
                      description: descriptionController.text,
                      category: categoryController.text,
                      date: dateTime.toString(),
                      priority: taskPriority,
                      important: false,
                    ),
                  );
                } else {
                  editFun!(editTask!.copyWith(
                    name: taskNameController.text,
                    description: descriptionController.text,
                    category: categoryController.text,
                    date: dateTime?.toString(),
                    priority: taskPriority,
                  ));
                }
              }
            },
            backgroundColor: ColorManager.primary,
            child: Icon(editTask == null ? Icons.add : Icons.edit),
          )
        ],
      ),
    );
  }
}
