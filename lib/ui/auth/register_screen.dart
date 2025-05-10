import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyqito_app/core/data/model/user.dart';
import 'package:storyqito_app/core/data/network/util/validators.dart';
import 'package:storyqito_app/core/localization/l10n/app_localizations.dart';
import 'package:storyqito_app/core/provider/auth_provider.dart';
import 'package:storyqito_app/core/provider/setting_provider.dart';
import 'package:storyqito_app/core/routes/my_route_delegate.dart';
import 'package:storyqito_app/core/style/theme.dart';
import 'package:storyqito_app/ui/widget/language_picker.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegister;
  final VoidCallback onLogin;

  const RegisterScreen({
    super.key,
    required this.onRegister,
    required this.onLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitFormRegister() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final User user = User(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      final result = await authProvider.register(user);
      if (result.data != null && !result.data!.error) {
        widget.onRegister();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.message ??
                    AppLocalizations.of(context)!.register_success,
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.message ?? AppLocalizations.of(context)!.register_failed,
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
                    selectedLanguageCode: settingProvider.locale.languageCode,
                    isCompactMode: true,
                    onTapDialog: () {
                      final delegate =
                          Router.of(context).routerDelegate as MyRouteDelegate;
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
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset("assets/icon/storyqito-logo.png", height: 80),
                    const SizedBox(height: 16.0),
                    Text(
                      localizations.create_account,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      localizations.please_create_account,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _nameController,
                      decoration: customInputDecoration(
                        label: localizations.full_name,
                        prefixIcon: Icons.person_outlined,
                      ),
                      validator:
                          (value) => Validators.validateRequired(
                            value,
                            localizations.enter_full_name,
                          ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
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
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return ElevatedButton(
                          onPressed:
                              authProvider.isLoadingRegister
                                  ? null
                                  : _submitFormRegister,
                          child:
                              authProvider.isLoadingRegister
                                  ? SizedBox(
                                    width: 20.0,
                                    height: 20.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(localizations.register_upper),
                        );
                      },
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localizations.already_have_account,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        TextButton(
                          onPressed: widget.onLogin,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(8.0),
                            minimumSize: Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(localizations.login_lower),
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
  }
}
