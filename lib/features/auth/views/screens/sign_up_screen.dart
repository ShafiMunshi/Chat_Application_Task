import 'package:chat_application_task/core/constants/app_strings.dart';
import 'package:chat_application_task/core/constants/dimens.dart';
import 'package:chat_application_task/core/style/text_styles.dart';
import 'package:chat_application_task/features/auth/views/provider/sign_up_provider.dart';
import 'package:chat_application_task/features/auth/views/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    ref.listenManual(signUpProvider, (previous, next) {
      switch (next) {
        case AsyncData(:final value) when value != null:
          context.go('/chat_users');
        case AsyncError(:final error):
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));

        default:
        // Do nothing
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.mediumPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FlutterLogo(size: 100),
                    const Gap(40),
                    const Text(
                      AppStrings.createAccount,
                      style: AppTextStyles.heading2,
                    ),
                    const Gap(30),
                    nameField(),
                    const Gap(10),
                    emailAddressField(),
                    const Gap(10),
                    passwordField(),
                    const Gap(24),
                    signUpButton(context),
                    const Gap(20),
                    signUpSections(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column emailAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(AppStrings.emailAddress, style: AppTextStyles.labelLarge),
        AppTextField(
          controller: _emailController,
          hintText: AppStrings.enterYourEmail,
          validator: ValidationBuilder().email().build(),
        ),
      ],
    );
  }

  Column nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(AppStrings.fullName, style: AppTextStyles.labelLarge),
        AppTextField(
          controller: _nameController,
          hintText: AppStrings.enterYourFullName,
          validator: ValidationBuilder().minLength(2).build(),
        ),
      ],
    );
  }

  Column passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(AppStrings.password, style: AppTextStyles.labelLarge),
        AppTextField(
          controller: _passwordController,
          hintText: AppStrings.enterYourPassword,
          isPassword: true,
          validator: ValidationBuilder().minLength(6).build(),
        ),
      ],
    );
  }

  Row signUpSections() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(AppStrings.alreadyHaveAccountPrompt),
        TextButton(
          onPressed: () {
            // Navigate to sign in screen
            context.go('/sign_in');
          },
          child: const Text(AppStrings.signIn),
        ),
      ],
    );
  }

  SizedBox signUpButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ref
                .read(signUpProvider.notifier)
                .signUp(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text(AppStrings.signUp, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
