import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';

class CustomOrDivider extends StatelessWidget {
  const CustomOrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: ColorManager.border,
            height: AppSize.s36,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
          child: Text(AppStrings.or.tr()),
        ),
        Expanded(
          child: Divider(
            color: ColorManager.border,
            height: AppSize.s36,
          ),
        ),
      ],
    );
  }
}
