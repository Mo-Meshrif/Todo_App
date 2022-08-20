import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/utils/values_manager.dart';

class CustomTextFormField extends StatelessWidget {
  final String iconName;
  final String hintText;
  const CustomTextFormField({
    Key? key,
    required this.iconName,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: AppSize.s10),
        SvgPicture.asset(
          iconName,
          width: AppSize.s20,
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}
