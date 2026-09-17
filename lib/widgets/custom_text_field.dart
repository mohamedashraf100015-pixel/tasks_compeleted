import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/theme_cubit.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/custom_svg_wrapper.dart';
import '../../../utils/size_utils.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String svgIconPath;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onFieldSubmitted;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.svgIconPath,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final activeColor =
    isDark ? AppColors.mainDarkColor : AppColors.mainLightColor;

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      focusNode: widget.focusNode,
      onFieldSubmitted: (_) => widget.onFieldSubmitted?.call(),
      style: isDark ? AppStyles.medium16White : AppStyles.medium16Black,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppStyles.regular16Gray,
        filled: true,
        fillColor:
        isDark ? AppColors.darkInputColor : AppColors.whiteColor,
        prefixIconConstraints:
        BoxConstraints(minWidth: context.width * 0.12, minHeight: 0),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.width * 0.035),
          child: CustomSvgWrapper(
            imagePath: widget.svgIconPath,
            height: context.height * 0.024,
            width: context.height * 0.024,
            color: AppColors.lightGreyColor,
          ),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
          onPressed: () =>
              setState(() => _obscureText = !_obscureText),
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: _obscureText
                ? AppColors.lightGreyColor
                : activeColor,
            size: context.width * 0.055,
          ),
        )
            : null,
        border: _buildBorder(Colors.transparent),
        enabledBorder: _buildBorder(
          isDark ? AppColors.strokeDarkColor : Colors.transparent,
        ),
        focusedBorder: _buildBorder(activeColor, width: 1.5),
        errorBorder: _buildBorder(AppColors.redColor),
        focusedErrorBorder: _buildBorder(AppColors.redColor, width: 1.5),
        contentPadding: EdgeInsets.symmetric(
          vertical: context.height * 0.018,
        ),
        errorStyle: AppStyles.regular14Black
            .copyWith(color: AppColors.redColor, fontSize: 12),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: color == Colors.transparent
          ? BorderSide.none
          : BorderSide(color: color, width: width),
    );
  }
}