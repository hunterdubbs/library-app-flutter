import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:library_app/login/bloc/login_bloc.dart';
import 'package:library_app/register/view/register_page.dart';
import 'package:library_app/request_password_reset/view/request_password_reset_page.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  SnackBar(content: Text(state.errorMsg)));
          }
        },
        child: Align(
            alignment: const Alignment(0, -1 / 3),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _UsernameInput(),
                  const Padding(padding: EdgeInsets.all(12)),
                  _PasswordInput(),
                  const Padding(padding: EdgeInsets.all(12)),
                  _LoginButton(),
                  const Padding(padding: EdgeInsets.all(12)),
                  _ForgotPasswordButton(),
                  const Padding(padding: EdgeInsets.all(12)),
                  _RegisterButton(),
                ],
              ),
            )
        )
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (username) => EasyDebounce.debounce('login_username', const Duration(milliseconds: 500), () => context.read<LoginBloc>().add(LoginUsernameChanged(username))),
          decoration: InputDecoration(
            labelText: 'username',
            errorText: state.username.invalid ? 'invalid username' : null
          )
        );
      }
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) => EasyDebounce.debounce('login_password', const Duration(milliseconds: 500), () => context.read<LoginBloc>().add(LoginPasswordChanged(password))),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            errorText: state.password.invalid ? 'invalid password' : null
          ),
        );
      }
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return state.status.isSubmissionInProgress
              ? const CircularProgressIndicator()
              : ElevatedButton(
              onPressed: state.status.isValidated
                  ? () {
                      context.read<LoginBloc>().add(const LoginSubmitted());
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                minimumSize: const Size.fromHeight(50)
              ),
              child: const Text('Login')
          );
        }
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).push(RegisterPage.route()),
      child: const Text('Register'),
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).push(RequestPasswordResetPage.route()),
      child: const Text('Forgot Password'),
    );
  }
}