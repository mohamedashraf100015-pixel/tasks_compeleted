import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../bloc/theme_cubit.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/size_utils.dart';

import '../bloc/auth/auth_cubit.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/google_sign_in_button.dart';
import '../widgets/or_divider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _onRegister(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
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
            msg: state.message ?? 'Registered successfully!',
            backgroundColor: AppColors.greenColor,
            textColor: AppColors.whiteColor,
          );
          Navigator.pushReplacementNamed(context, AppRoutes.homeRouteName);
        } else if (state is AuthError) {
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: AppColors.redColor,
            textColor: AppColors.whiteColor,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.width * 0.06,
              vertical: context.height * 0.02,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Logo ──────────────────────────────────────────────
                  Center(
                    child: Image.asset(
                      isDark
                          ? AppAssets.logoEventlyDarkImage
                          : AppAssets.logoEventlyLightImage,
                      height: context.height * 0.1,
                    ),
                  ),
                  SizedBox(height: context.height * 0.025),

                  // ── Title ─────────────────────────────────────────────
                  Text(
                    'Create your account',
                    style: isDark
                        ? AppStyles.semi24White
                        : AppStyles.semi24MainLightColor,
                  ),
                  SizedBox(height: context.height * 0.03),

                  // ── Name ──────────────────────────────────────────────
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'Enter your name',
                    svgIconPath: AppAssets.userIcon,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: () =>
                        FocusScope.of(context).requestFocus(_emailFocus),
                    validator: _validateName,
                  ),
                  SizedBox(height: context.height * 0.02),

                  // ── Email ─────────────────────────────────────────────
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Enter your email',
                    svgIconPath: AppAssets.emailIcon,
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _emailFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: () =>
                        FocusScope.of(context).requestFocus(_passwordFocus),
                    validator: _validateEmail,
                  ),
                  SizedBox(height: context.height * 0.02),

                  // ── Password ──────────────────────────────────────────
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    svgIconPath: AppAssets.passwordIcon,
                    isPassword: true,
                    focusNode: _passwordFocus,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: () =>
                        FocusScope.of(context).requestFocus(_confirmFocus),
                    validator: _validatePassword,
                  ),
                  SizedBox(height: context.height * 0.02),

                  // ── Confirm Password ──────────────────────────────────
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm your password',
                    svgIconPath: AppAssets.passwordIcon,
                    isPassword: true,
                    focusNode: _confirmFocus,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: () => _onRegister(context),
                    validator: _validateConfirmPassword,
                  ),
                  SizedBox(height: context.height * 0.035),

                  // ── Sign Up Button ────────────────────────────────────
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) => CustomButton(
                      label: 'Sign up',
                      isLoading: state is AuthLoading,
                      backgroundColor: activeColor,
                      onPressed: () => _onRegister(context),
                    ),
                  ),
                  SizedBox(height: context.height * 0.025),

                  // ── Login Link ────────────────────────────────────────
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: isDark
                            ? AppStyles.regular16WhiteDarkColor
                            : AppStyles.regular16Gray,
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, AppRoutes.loginRouteName),
                              child: Text(
                                'Login',
                                style: AppStyles.medium16MainColor.copyWith(
                                  color: activeColor,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: activeColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: context.height * 0.022),

                  // ── Or Divider ────────────────────────────────────────
                  const OrDivider(),
                  SizedBox(height: context.height * 0.022),

                  // ── Google Sign Up ────────────────────────────────────
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) => GoogleSignInButton(
                      label: 'Sign up with Google',
                      isLoading: state is AuthLoading,
                      onPressed: () =>
                          context.read<AuthCubit>().signInWithGoogle(),
                    ),
                  ),
                  SizedBox(height: context.height * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    if (v.trim().length < 2) return 'Name must be at least 2 characters';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v.trim())) {
      return 'Name can only contain letters';
    }
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Minimum 6 characters';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Add at least one uppercase letter';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Add at least one number';
    return null;
  }

  String? _validateConfirmPassword(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != _passwordController.text) return 'Passwords do not match';
    return null;
  }
}