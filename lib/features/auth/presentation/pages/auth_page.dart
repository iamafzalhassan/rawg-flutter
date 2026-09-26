import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rawg/core/constants/route_constants.dart';
import 'package:rawg/core/theme/app_font.dart';
import 'package:rawg/core/theme/app_palette.dart';
import 'package:rawg/core/theme/app_spacing.dart';
import 'package:rawg/core/utils/show_snack_bar.dart';
import 'package:rawg/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:rawg/features/common/presentation/widgets/rawg_button.dart';
import 'package:rawg/features/common/presentation/widgets/rawg_form_field.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _signInEmailController = TextEditingController();
  final TextEditingController _signInPasswordController = TextEditingController();

  int _tab = 0;

  bool get _isSignUp => _tab == 0;

  Widget _buildSignUpForm(AuthState state) => _buildForm(
    state,
    'auth.register'.tr(),
    [_nameController, _emailController, _passwordController],
    () => context.read<AuthCubit>().signUp(email: _emailController.text, name: _nameController.text, password: _passwordController.text),
    [
      RawgFormField(controller: _nameController, enabled: !state.isLoading, hintText: 'auth.fullNameHint'.tr(), label: 'auth.fullName'.tr()),
      const SizedBox(height: AppSpacing.lg),
      _buildEmailField(state, _emailController),
      const SizedBox(height: AppSpacing.lg),
      _buildPasswordField(state, _passwordController),
    ],
  );

  Widget _buildSignInForm(AuthState state) => _buildForm(
    state,
    'auth.signIn'.tr(),
    [_signInEmailController, _signInPasswordController],
    () => context.read<AuthCubit>().signIn(email: _signInEmailController.text, password: _signInPasswordController.text),
    [_buildEmailField(state, _signInEmailController), const SizedBox(height: AppSpacing.lg), _buildPasswordField(state, _signInPasswordController)],
  );

  Widget _buildForm(AuthState state, String label, List<TextEditingController> requiredFields, VoidCallback submit, List<Widget> fields) => Padding(
    padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl + MediaQuery.paddingOf(context).bottom),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...fields,
        const SizedBox(height: AppSpacing.xxxl),
        ListenableBuilder(
          listenable: Listenable.merge(requiredFields),
          builder: (context, _) {
            final enabled = !state.isLoading && requiredFields.every((field) => field.text.trim().isNotEmpty);
            return RawgButton(backgroundColor: enabled ? AppPalette.black2 : AppPalette.gray6, isLoading: state.isLoading, label: label, onPressed: enabled ? submit : null);
          },
        ),
      ],
    ),
  );

  Widget _buildEmailField(AuthState state, TextEditingController controller) =>
      RawgFormField(controller: controller, enabled: !state.isLoading, hintText: 'auth.emailHint'.tr(), keyboardType: TextInputType.emailAddress, label: 'auth.email'.tr());

  Widget _buildPasswordField(AuthState state, TextEditingController controller) => RawgFormField(controller: controller, enabled: !state.isLoading, hintText: 'auth.passwordHint'.tr(), isPassword: true, label: 'auth.password'.tr());

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<AuthCubit, AuthState>(
    listener: (context, state) {
      if (state.errorMessage != null) showSnackBar(context, state.errorMessage!);
      if (state.isAuthenticated) context.pushReplacementNamed(RouteConstants.dashboard);
    },
    listenWhen: (previous, current) => previous.errorMessage != current.errorMessage || previous.isAuthenticated != current.isAuthenticated,
    builder: (context, state) => Scaffold(
      backgroundColor: AppPalette.black2,
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: MediaQuery.paddingOf(context).top + 32),
                        Semantics(
                          header: true,
                          child: Text((_isSignUp ? 'auth.signUpTitle' : 'auth.signInTitle').tr(), style: AppFont.style(fontSize: 28, fontWeight: FontWeight.bold)),
                        ),
                        Text((_isSignUp ? 'auth.signUpSubtitle' : 'auth.signInSubtitle').tr(), style: AppFont.style(color: AppPalette.gray1)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                      color: AppPalette.gray6,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.xl), color: AppPalette.gray4),
                          child: DefaultTabController(
                            initialIndex: _tab,
                            length: 2,
                            child: TabBar(
                              dividerColor: Colors.transparent,
                              indicator: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.xl), color: AppPalette.white),
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: AppPalette.black,
                              labelStyle: AppFont.style(fontSize: 16, fontWeight: FontWeight.w600),
                              onTap: (index) => setState(() => _tab = index),
                              tabs: [
                                Tab(text: 'auth.signUp'.tr()),
                                Tab(text: 'auth.signIn'.tr()),
                              ],
                              unselectedLabelColor: AppPalette.gray1,
                              unselectedLabelStyle: AppFont.style(fontSize: 16),
                            ),
                          ),
                        ),
                        if (_isSignUp) _buildSignUpForm(state) else _buildSignInForm(state),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
