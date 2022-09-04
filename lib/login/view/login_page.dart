import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/data/authentication_api.dart';
import 'package:library_app/login/bloc/login_bloc.dart';
import 'package:library_app/login/view/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context){
            return LoginBloc(
              authenticationApi:
                RepositoryProvider.of<AuthenticationApi>(context)
            );
          },
          child: const LoginForm()
        )
      )
    );
  }
}