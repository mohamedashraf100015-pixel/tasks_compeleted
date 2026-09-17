import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../bloc/theme_cubit.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/size_utils.dart';
import '../bloc/auth/auth_cubit.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: const _ForgetPasswordView(),
    );
  }
}

class _ForgetPasswordView extends StatefulWidget {
  const _ForgetPasswordView();

  @override
  State<_ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<_ForgetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onReset(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context
          .read<AuthCubit>()
          .resetPassword(email: _emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final activeColor =
    isDark ? AppColors.mainDarkColor : AppColors.mainLightColor;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Fluttertoast.showToast(
            msg: state.message ?? 'Check your email!',
            backgroundColor: AppColors.greenColor,
            textColor: AppColors.whiteColor,
          );
          Navigator.pop(context);
        } else if (state is AuthError) {
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: AppColors.redColor,
            textColor: AppColors.whiteColor,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.all(context.width * 0.02),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark
                        ? AppColors.strokeDarkColor
                        : AppColors.strokeWhiteColor,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: context.width * 0.04,
                  color: isDark ? AppColors.whiteColor : AppColors.blackColor,
                ),
              ),
            ),
          ),
          title: Text(
            'Forget Password',
            style: isDark ? AppStyles.semi20White : AppStyles.semi20Black,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.06),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Spacer(),

                  // ── Illustration ───────────────────────────────────
                  Image.asset(
                    isDark
                        ? AppAssets.forgetPasswordDark
                        : AppAssets.forgetPasswordLight,
                    height: context.height * 0.35,
                  ),
                  const Spacer(),

                  // ── Email Field ────────────────────────────────────
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Enter your email',
                    svgIconPath: AppAssets.emailIcon,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: () => _onReset(context),
                    validator: _validateEmail,
                  ),
                  SizedBox(height: context.height * 0.025),

                  // ── Reset Button ───────────────────────────────────
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) => CustomButton(
                      label: 'Reset password',
                      isLoading: state is AuthLoading,
                      backgroundColor: activeColor,
                      onPressed: () => _onReset(context),
                    ),
                  ),
                  SizedBox(height: context.height * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }
}