import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/data/model/user.dart';
import 'package:storyqito_app/core/data/network/util/validators.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/auth/auth_provider.dart';
import 'package:storyqito_app/core/provider/setting/setting_provider.dart';
import 'package:storyqito_app/core/routes/my_route_delegate.dart';
import 'package:storyqito_app/core/style/theme.dart';
import 'package:storyqito_app/features/widget/language_picker.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitFormLogin() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final authProvider = context.read<AuthProvider>();
      final User user = User(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final result = await authProvider.login(user.email!, user.password!);
      if (result.data != null) {
        widget.onLogin();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
              content: Text(
                result.message ?? AppLocalizations.of(context)!.login_success,
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.green.shade300,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.message ?? AppLocalizations.of(context)!.login_failed,
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              Consumer<SettingProvider>(
                builder:
                    (context, settingProvider, _) => Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: LanguagePicker(
                        onLanguageChanged:
                            (code) => settingProvider.setLocale(code),
                        selectedLanguageCode:
                            settingProvider.locale.languageCode,
                        isCompactMode: true,
                        onTapDialog: () {
                          final delegate =
                              Router.of(context).routerDelegate
                                  as MyRouteDelegate;
                          delegate.showLanguageDialog();
                        },
                      ),
                    ),
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          "assets/icon/storyqito-logo.png",
                          height: 80,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          localizations.login_account,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          localizations.please_login_using_your_account,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28.0),
                        TextFormField(
                          enabled: !authProvider.isLoadingLogin,
                          controller: _emailController,
                          decoration: customInputDecoration(
                            label: localizations.email,
                            prefixIcon: Icons.email_outlined,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator:
                              (value) => Validators.validateEmail(
                                value,
                                localizations.enter_email,
                                localizations.enter_valid_email,
                              ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          enabled: !authProvider.isLoadingLogin,
                          controller: _passwordController,
                          decoration: customInputDecoration(
                            label: localizations.password,
                            prefixIcon: Icons.lock_outlined,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator:
                              (value) => Validators.validatePassword(
                                value,
                                localizations.enter_password,
                                localizations.password_minimum,
                              ),
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed:
                              authProvider.isLoadingLogin
                                  ? null
                                  : _submitFormLogin,
                          child:
                              authProvider.isLoadingLogin
                                  ? SizedBox(
                                    width: 18.0,
                                    height: 18.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(localizations.login_upper),
                        ),
                        const SizedBox(height: 24.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localizations.dont_have_account,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            TextButton(
                              onPressed:
                                  authProvider.isLoadingLogin
                                      ? null
                                      : widget.onRegister,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(8.0),
                                minimumSize: Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(localizations.register_lower),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
