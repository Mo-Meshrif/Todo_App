import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/main.dart';
import '../../../../app/helper/helper_functions.dart';
import '../widgets/custom_elevated_loading.dart';
import '/app/services/services_locator.dart';
import '/app/utils/constants_manager.dart';
import '/modules/auth/domain/usecases/login_use_case.dart';
import '../../../../app/helper/shared_helper.dart';
import '../../../../app/utils/routes_manager.dart';
import '/modules/auth/presentation/controller/auth_bloc.dart';
import '/app/utils/color_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../widgets/custom_social_button.dart';
import '../widgets/custom_text_form_field.dart';
import '/app/utils/assets_manager.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _forgetPassController = TextEditingController();
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (ctx, state) {
            if (state is AuthSuccess) {
              sl<AppShared>().setVal(AppConstants.passLoginKey, true);
              sl<AppShared>().setVal(AppConstants.userKey, state.user);
              Navigator.of(ctx).pushReplacementNamed(Routes.homeRoute);
              _emailController.clear();
              _passwordController.clear();
            } else if (state is AuthRestSuccess) {
              Navigator.of(ctx).pop();
              _forgetPassController.clear();
              HelperFunctions.showSnackBar(
                context,
                AppStrings.checkEmail,
              );
            } else if (state is AuthFailure) {
              if (isDialogShowing) {
                isDialogShowing = false;
                Navigator.of(ctx).pop();
              }
              if (state.msg.isNotEmpty) {
                HelperFunctions.showSnackBar(context, state.msg);
              }
            } else if (state is AuthPopUpLoading) {
              Navigator.of(ctx).pop();
              isDialogShowing = true;
              HelperFunctions.showPopUpLoading(context);
            }
          },
          builder: (context, state) => Form(
            key: _formKey,
            child: SingleChildScrollView(
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
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorManager.border),
                        ),
                        child: Column(
                          children: [
                            CustomTextFormField(
                              controller: _emailController,
                              iconName: IconAssets.user,
                              hintText: AppStrings.email,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return AppStrings.enterEmail;
                                } else if (!HelperFunctions.isEmailValid(
                                    val.toString())) {
                                  return AppStrings.notVaildEmail;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Divider(color: ColorManager.border),
                            CustomTextFormField(
                              controller: _passwordController,
                              iconName: IconAssets.password,
                              hintText: AppStrings.password,
                              isPassword: true,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return AppStrings.enterPassword;
                                } else if (val.length < 8) {
                                  return AppStrings.notVaildPassword;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          HelperFunctions.showAlert(
                            context: context,
                            title: AppStrings.forgetPassword,
                            content: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppPadding.p5,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorManager.border),
                              ),
                              child: CustomTextFormField(
                                controller: _forgetPassController,
                                iconName: IconAssets.user,
                                hintText: AppStrings.email,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return AppStrings.enterEmail;
                                  } else if (!HelperFunctions.isEmailValid(
                                      val.toString())) {
                                    return AppStrings.notVaildEmail;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text(AppStrings.cancel),
                                style: TextButton.styleFrom(
                                    primary: ColorManager.primary),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: const Text(AppStrings.rest),
                                style: TextButton.styleFrom(
                                    primary: ColorManager.primary),
                                onPressed: () => context.read<AuthBloc>().add(
                                      ForgetPasswordEvent(
                                        email: _forgetPassController.text,
                                      ),
                                    ),
                              ),
                            ],
                          );
                        },
                        style:
                            TextButton.styleFrom(primary: ColorManager.border),
                        child: const Text(AppStrings.forgetPassword),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.s36.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: AppSize.s144.h,
                    child: state is AuthLoading
                        ? const CustomElevatedLoading()
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                context.read<AuthBloc>().add(
                                      LoginEvent(
                                        loginInputs: LoginInputs(
                                          name: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      ),
                                    );
                              }
                            },
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
                        padding:
                            EdgeInsets.symmetric(horizontal: AppPadding.p10),
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
                        onPress: () =>
                            context.read<AuthBloc>().add(FacebookLoginEvent()),
                      ),
                      CustomSocialButton(
                        iconName: IconAssets.twitter,
                        onPress: () =>
                            context.read<AuthBloc>().add(TwitterLoginEvent()),
                      ),
                      CustomSocialButton(
                        iconName: IconAssets.google,
                        onPress: () =>
                            context.read<AuthBloc>().add(GoogleLoginEvent()),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.s80.h),
                  TextButton(
                    onPressed: () {
                      //TODO toggle between login and signUp
                    },
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
          ),
        ),
      ),
    );
  }
}
