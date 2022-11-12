import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/authentication_api.dart';
import 'package:library_app/register/bloc/register_bloc.dart';
import 'package:library_app/register/models/models.dart';
import 'package:library_app/widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static Route<void> route(){
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => RegisterBloc(
          authenticationApi: RepositoryProvider.of<AuthenticationApi>(context)
        ),
        child: const RegisterPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<RegisterBloc, RegisterState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if(state.status.isSubmissionFailure){
                ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(state.error))
                    );
              }
              if(state.status.isSubmissionSuccess){
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      AlertDialog(
                        title: const Text('Account Created'),
                        content: const Text('Look for an email confirmation link in your inbox to activate your account.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK')
                          )
                        ],
                      )
                ).then((_) => Navigator.of(context).pop());
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
                          _UsernameInput(),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 12)),
                          _EmailInput(),
                          const Padding(padding: EdgeInsets.symmetric(horizontal: 12)),
                          _PasswordInput()
                        ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    children: [
                      CancelButton(
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      BlocBuilder<RegisterBloc, RegisterState>(
                        buildWhen: (previous, current) => previous.status != current.status,
                        builder: (context, state) {
                          return SubmitButton(
                            text: 'Register',
                            onTap: state.status.isValidated && !state.status.isSubmissionInProgress ? () => context.read<RegisterBloc>().add(const Submitted()) : null,
                          );
                      },
                      ),
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          onChanged: (username) => context.read<RegisterBloc>().add(UsernameChanged(username)),
          decoration: InputDecoration(
            labelText: 'username',
            errorText: _getError(state.username.error)
          ),
          maxLength: 255,
        );
      },
    );
  }

  String? _getError(UsernameValidationError? error){
    if(error != null){
      switch(error) {
        case UsernameValidationError.length:
          return '255 chars max';
        case UsernameValidationError.empty:
          return 'username required';
        case UsernameValidationError.specialChars:
          return 'only alphanumeric characters allowed';
      }
    }
    return null;
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) => context.read<RegisterBloc>().add(EmailChanged(email)),
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

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (password) => context.read<RegisterBloc>().add(PasswordChanged(password)),
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
          return '40 chars max';
      }
    }
    return null;
  }
}