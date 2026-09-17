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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _onLogin(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
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
          Navigator.pushReplacementNamed(context, AppRoutes.homeRouteName);
        } else if (state is AuthError) {
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: AppColors.redColor,
            textColor: AppColors.whiteColor,
            gravity: ToastGravity.BOTTOM,
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
                    'Login to your account',
                    style: isDark
                        ? AppStyles.semi24White
                        : AppStyles.semi24MainLightColor,
                  ),
                  SizedBox(height: context.height * 0.03),

                  // ── Email ─────────────────────────────────────────────
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Enter your email',
                    svgIconPath: AppAssets.emailIcon,
                    keyboardType: TextInputType.emailAddress,
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
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: () => _onLogin(context),
                    validator: _validatePassword,
                  ),
                  SizedBox(height: context.height * 0.008),

                  // ── Forget Password ───────────────────────────────────
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(
                          context, AppRoutes.forgetPasswordRouteName),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forget Password?',
                        style: AppStyles.medium16MainColor.copyWith(
                          color: activeColor,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: activeColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.height * 0.025),

                  // ── Login Button ──────────────────────────────────────
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) => CustomButton(
                      label: 'Login',
                      isLoading: state is AuthLoading,
                      backgroundColor: activeColor,
                      onPressed: () => _onLogin(context),
                    ),
                  ),
                  SizedBox(height: context.height * 0.025),

                  // ── Signup Link ───────────────────────────────────────
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: isDark
                            ? AppStyles.regular16WhiteDarkColor
                            : AppStyles.regular16Gray,
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, AppRoutes.registerRouteName),
                              child: Text(
                                'Signup',
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

                  // ── Google Sign In ────────────────────────────────────
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) => GoogleSignInButton(
                      label: 'Login with Google',
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

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}