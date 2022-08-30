import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';

class CustomElevatedLoading extends StatelessWidget {
  const CustomElevatedLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppPadding.p10),
            child: CircularProgressIndicator(
              color: ColorManager.primary,
            ),
          ),
          const SizedBox(
            width: AppSize.s20,
          ),
           Text(
            AppStrings.loading.tr(),
            style: const TextStyle(fontSize: AppSize.s20),
          )
        ],
      ),
    );
  }
}
