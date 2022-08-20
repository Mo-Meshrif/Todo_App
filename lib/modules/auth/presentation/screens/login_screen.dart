import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/app/utils/color_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../widgets/custom_social_button.dart';
import '../widgets/custom_text_form_field.dart';
import '/app/utils/assets_manager.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 144.w),
        child: Column(
          children: [
            SizedBox(height: AppSize.s250.h),
            Center(
              child: SvgPicture.asset(
                ImageAssets.logo,
                height: AppSize.s189.h,
                width: AppSize.s295.w,
              ),
            ),
            SizedBox(height: AppSize.s120.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManager.border),
                  ),
                  child: Column(
                    children: [
                      const CustomTextFormField(
                        iconName: IconAssets.user,
                        hintText: AppStrings.userName,
                      ),
                      Divider(color: ColorManager.border),
                      const CustomTextFormField(
                        iconName: IconAssets.password,
                        hintText: AppStrings.password,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(primary: ColorManager.border),
                  child: const Text(AppStrings.forgetPassword),
                ),
              ],
            ),
            SizedBox(height: AppSize.s36.h),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: AppSize.s144.h,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(AppStrings.login),
              ),
            ),
            SizedBox(height: AppSize.s48.h),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: ColorManager.border,
                    height: AppSize.s36,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p10),
                  child: Text(AppStrings.or),
                ),
                Expanded(
                  child: Divider(
                    color: ColorManager.border,
                    height: AppSize.s36,
                  ),
                ),
              ],
            ),
            const Text(AppStrings.loginUsingSm),
            SizedBox(height: AppSize.s48.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomSocialButton(
                  iconName: IconAssets.facebook,
                  onPress: () {},
                ),
                CustomSocialButton(
                  iconName: IconAssets.twitter,
                  onPress: () {},
                ),
                CustomSocialButton(
                  iconName: IconAssets.google,
                  onPress: () {},
                ),
              ],
            ),
            SizedBox(height: AppSize.s80.h),
            TextButton(
              onPressed: () {},
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(text: AppStrings.noAccount),
                    TextSpan(
                      text: AppStrings.signUp,
                      style: TextStyle(color: ColorManager.primary),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}