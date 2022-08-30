import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/app/services/language_services.dart';
import '/modules/auth/domain/usecases/signup_use_case.dart';
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

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLogin = true;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _forgetPassController = TextEditingController();
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (ctx, state) {
            if (state is AuthPopUpLoading) {
              HelperFunctions.showPopUpLoading(context);
            } else if (state is AuthSuccess) {
              sl<AppShared>().setVal(AppConstants.authPassKey, true);
              sl<AppShared>().setVal(AppConstants.userKey, state.user);
              Navigator.of(ctx).pushReplacementNamed(Routes.homeRoute);
              _emailController.clear();
              _passwordController.clear();
            } else if (state is AuthRestSuccess) {
              Navigator.of(ctx).pop();
              _forgetPassController.clear();
              HelperFunctions.showSnackBar(
                context,
                AppStrings.checkEmail.tr(),
              );
            } else if (state is AuthFailure) {
              if (state.isPopup) {
                Navigator.of(ctx).pop();
              }
              if (state.msg.isNotEmpty) {
                HelperFunctions.showSnackBar(context, state.msg.tr());
              }
            } else if (state is AuthSocialPass) {
              ctx.read<AuthBloc>().add(SignInWithCredentialEvent(
                  authCredential: state.authCredential));
            } else if (state is AuthChanged) {
              isLogin = state.currentState;
            }
          },
          builder: (context, state) => SafeArea(
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 144.w),
                    child: Column(
                      children: [
                        SizedBox(height: AppSize.s170.h),
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
                                  Visibility(
                                    visible: !isLogin,
                                    child: Column(
                                      children: [
                                        CustomTextFormField(
                                          controller: _nameController,
                                          iconName: IconAssets.user,
                                          hintText: AppStrings.userName.tr(),
                                          textInputAction: TextInputAction.next,
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return AppStrings.enterName.tr();
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        Divider(color: ColorManager.border),
                                      ],
                                    ),
                                  ),
                                  CustomTextFormField(
                                    controller: _emailController,
                                    iconName: IconAssets.email,
                                    hintText: AppStrings.email.tr(),
                                    textInputAction: TextInputAction.next,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return AppStrings.enterEmail.tr();
                                      } else if (!HelperFunctions.isEmailValid(
                                          val.toString())) {
                                        return AppStrings.notVaildEmail.tr();
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  Divider(color: ColorManager.border),
                                  CustomTextFormField(
                                    controller: _passwordController,
                                    iconName: IconAssets.password,
                                    hintText: AppStrings.password.tr(),
                                    textInputAction: TextInputAction.done,
                                    isPassword: true,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return AppStrings.enterPassword.tr();
                                      } else if (val.length < 8) {
                                        return AppStrings.notVaildPassword.tr();
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: isLogin,
                              child: TextButton(
                                onPressed: () {
                                  final GlobalKey<FormState> _forgetKey =
                                      GlobalKey<FormState>();
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
                                          border: Border.all(
                                              color: ColorManager.border),
                                        ),
                                        child: CustomTextFormField(
                                          controller: _forgetPassController,
                                          iconName: IconAssets.email,
                                          hintText: AppStrings.email.tr(),
                                          textInputAction: TextInputAction.done,
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return AppStrings.enterEmail.tr();
                                            } else if (!HelperFunctions
                                                .isEmailValid(val.toString())) {
                                              return AppStrings.notVaildEmail
                                                  .tr();
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
                                        style: TextButton.styleFrom(
                                            primary: ColorManager.primary),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      TextButton(
                                        child: Text(AppStrings.rest.tr()),
                                        style: TextButton.styleFrom(
                                            primary: ColorManager.primary),
                                        onPressed: () {
                                          if (_forgetKey.currentState!
                                              .validate()) {
                                            _forgetKey.currentState!.save();
                                            Navigator.of(context).pop();
                                            context.read<AuthBloc>().add(
                                                  ForgetPasswordEvent(
                                                    email: _forgetPassController
                                                        .text,
                                                  ),
                                                );
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                                style: TextButton.styleFrom(
                                    primary: ColorManager.border),
                                child: Text(AppStrings.forgetPassword.tr()),
                              ),
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
                                      if (isLogin) {
                                        context.read<AuthBloc>().add(
                                              LoginEvent(
                                                loginInputs: LoginInputs(
                                                  email: _emailController.text,
                                                  password:
                                                      _passwordController.text,
                                                ),
                                              ),
                                            );
                                      } else {
                                        context.read<AuthBloc>().add(
                                              SignUpEvent(
                                                signUpInputs: SignUpInputs(
                                                  name: _nameController.text,
                                                  email: _emailController.text,
                                                  password:
                                                      _passwordController.text,
                                                ),
                                              ),
                                            );
                                      }
                                    }
                                  },
                                  child: Text(
                                    isLogin
                                        ? AppStrings.loginButton.tr()
                                        : AppStrings.signUpButton.tr(),
                                  ),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.p10),
                              child: Text(AppStrings.or.tr()),
                            ),
                            Expanded(
                              child: Divider(
                                color: ColorManager.border,
                                height: AppSize.s36,
                              ),
                            ),
                          ],
                        ),
                        Text(AppStrings.loginUsingSm.tr()),
                        SizedBox(height: AppSize.s48.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomSocialButton(
                              iconName: IconAssets.facebook,
                              onPress: () => context
                                  .read<AuthBloc>()
                                  .add(FacebookLoginEvent()),
                            ),
                            CustomSocialButton(
                              iconName: IconAssets.twitter,
                              onPress: () => context
                                  .read<AuthBloc>()
                                  .add(TwitterLoginEvent()),
                            ),
                            CustomSocialButton(
                              iconName: IconAssets.google,
                              onPress: () => context
                                  .read<AuthBloc>()
                                  .add(GoogleLoginEvent()),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.s48.h),
                        TextButton(
                          onPressed: () {
                            if (_formKey.currentState != null) {
                              FocusScope.of(context).unfocus();
                              _formKey.currentState!.reset();
                            }
                            context
                                .read<AuthBloc>()
                                .add(AuthToggleEvent(prevState: isLogin));
                          },
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: isLogin
                                      ? AppStrings.noAccount.tr()
                                      : AppStrings.haveAccount.tr(),
                                ),
                                const WidgetSpan(
                                    child: SizedBox(
                                  width: AppSize.s5,
                                )),
                                TextSpan(
                                  text: isLogin
                                      ? AppStrings.signUp.tr()
                                      : AppStrings.login.tr(),
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
                IconButton(
                  splashRadius: AppSize.s20,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.p8,
                    horizontal: AppPadding.p15,
                  ),
                  onPressed: () => LanguageServices.changeLang(context),
                  icon: const Icon(Icons.language),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
