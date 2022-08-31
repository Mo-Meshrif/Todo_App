import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/utils/assets_manager.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../widgets/custom_text_form_field.dart';

class ForgetPassword extends StatelessWidget {
  final TextEditingController forgetPassController;
  final void Function() restFun;
  const ForgetPassword({
    Key? key,
    required this.forgetPassController,
    required this.restFun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final GlobalKey<FormState> _forgetKey = GlobalKey<FormState>();
        HelperFunctions.showAlert(
          context: context,
          title: AppStrings.forgetPassword.tr(),
          content: Form(
            key: _forgetKey,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppPadding.p10,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: ColorManager.border),
              ),
              child: CustomTextFormField(
                controller: forgetPassController,
                iconName: IconAssets.email,
                hintText: AppStrings.email.tr(),
                textInputAction: TextInputAction.done,
                validator: (val) {
                  if (val!.isEmpty) {
                    return AppStrings.enterEmail.tr();
                  } else if (!HelperFunctions.isEmailValid(val.toString())) {
                    return AppStrings.notVaildEmail.tr();
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(AppStrings.cancel.tr()),
              style: TextButton.styleFrom(primary: ColorManager.primary),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(AppStrings.rest.tr()),
              style: TextButton.styleFrom(primary: ColorManager.primary),
              onPressed: () {
                if (_forgetKey.currentState!.validate()) {
                  _forgetKey.currentState!.save();
                  Navigator.of(context).pop();
                  restFun();
                }
              },
            ),
          ],
        );
      },
      style: TextButton.styleFrom(primary: ColorManager.border),
      child: Text(AppStrings.forgetPassword.tr()),
    );
  }
}