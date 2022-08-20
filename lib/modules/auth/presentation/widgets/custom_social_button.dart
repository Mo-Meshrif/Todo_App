
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/utils/values_manager.dart';

class CustomSocialButton extends StatelessWidget {
  final String iconName;
  final void Function()? onPress;
  const CustomSocialButton({
    Key? key,
    required this.iconName,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      shape: const CircleBorder(),
      child: SvgPicture.asset(
        iconName,
        width: AppSize.s144.w,
        height: AppSize.s144.w,
      ),
    );
  }
}
