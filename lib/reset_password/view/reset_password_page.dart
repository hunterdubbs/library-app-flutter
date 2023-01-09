import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/authentication_api.dart';
import 'package:library_app/login/view/login_page.dart';
import 'package:library_app/reset_password/models/models.dart';
import 'package:library_app/reset_password/bloc/reset_password_bloc.dart';
import 'package:library_app/widgets/widgets.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  static Route<void> route({String email = ''}){
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => ResetPasswordBloc(
          authenticationApi: RepositoryProvider.of<AuthenticationApi>(context),
          email: email
        ),
        child: const ResetPasswordPage(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ResetPasswordBloc, ResetPasswordState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if(state.status.isSubmissionFailure){
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                      const SnackBar(content: Text('Invalid Email or Reset Code'))
                  );
              }
              if(state.status.isSubmissionSuccess){
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        AlertDialog(
                            title: const Text('Password Reset'),
                            content: const Text('Your password has been changed.'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Login')
                              )
                            ]
                        )
                ).then((_) => Navigator.of(context).pushAndRemoveUntil(LoginPage.route(), (route) => false));
              }
            },
          )
        ],
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _EmailInput(),
                          const Padding(padding: EdgeInsets.all(12)),
                          _CodeInput(),
                          const Padding(padding: EdgeInsets.all(12)),
                          _PasswordInput()
                        ],
                      ),
                    )
                  )
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  children: [
                    BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                      buildWhen: (previous, current) => previous.status != current.status,
                      builder: (context, state) {
                        return SubmitButton(
                          text: 'Reset Password',
                          onTap: state.status.isValidated && !state.status.isSubmissionInProgress ? () => context.read<ResetPasswordBloc>().add(const Submitted()) : null,
                        );
                      },
                    ),
                  ],
                )
              )
            )
          ],
        )
      )
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        final controller = TextEditingController(text: state.email.value);
        controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
        return TextField(
        controller: controller,
          onChanged: (email) => EasyDebounce.debounce('reset_password_email', const Duration(milliseconds: 300), () => context.read<ResetPasswordBloc>().add(EmailChanged(email))),
          decoration: InputDecoration(
              labelText: 'email',
              errorText: _getError(state.email.error)
          ),
          maxLength: 255,
        );
      },
    );
  }

  String? _getError(EmailValidationError? error){
    if(error != null){
      switch(error) {
        case EmailValidationError.empty:
          return 'email required';
        case EmailValidationError.length:
          return '255 chars max';
        case EmailValidationError.format:
          return 'invalid email address';
      }
    }
    return null;
  }
}

class _CodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      buildWhen: (previous, current) => previous.code != current.code,
      builder: (context, state) {
        return TextField(
          onChanged: (code) => EasyDebounce.debounce('reset_password_code', const Duration(milliseconds: 300), () => context.read<ResetPasswordBloc>().add(CodeChanged(code))),
          decoration: InputDecoration(
            labelText: 'reset code',
            errorText: _getError(state.code.error)
          ),
          maxLength: 10,
        );
      },
    );
  }

  String? _getError(CodeValidationError? error) {
    if(error != null){
      switch(error) {
        case CodeValidationError.empty:
          return 'reset code required';
        case CodeValidationError.length:
          return '10 chars max';
      }
    }
    return null;
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (password) => EasyDebounce.debounce('reset_password_password', const Duration(milliseconds: 300), () => context.read<ResetPasswordBloc>().add(PasswordChanged(password))),
          decoration: InputDecoration(
              labelText: 'password',
              errorText: _getError(state.password.error)
          ),
          maxLength: 40,
          obscureText: true,
        );
      },
    );
  }

  String? _getError(PasswordValidationError? error){
    if(error != null){
      switch(error) {
        case PasswordValidationError.empty:
          return 'password required';
        case PasswordValidationError.length:
          return 'requires 6 - 40 chars';
      }
    }
    return null;
  }
}