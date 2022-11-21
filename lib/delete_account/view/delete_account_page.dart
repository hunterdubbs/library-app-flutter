import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:library_app/authentication/bloc/authentication_bloc.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/delete_account/bloc/delete_account_bloc.dart';
import 'package:library_app/delete_account/models/models.dart';
import 'package:library_app/login/view/login_page.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => DeleteAccountBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context)
        ),
        child: const DeleteAccountPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Delete Account'),
        ),
        body: MultiBlocListener(
            listeners: [
              BlocListener<DeleteAccountBloc, DeleteAccountState>(
                listenWhen: (previous, current) => previous.status != current.status,
                listener: (context, state) {
                  if(state.status.isSubmissionFailure){
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                          const SnackBar(content: Text('Invalid password'))
                      );
                  }
                  if(state.status.isSubmissionSuccess){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            AlertDialog(
                                title: const Text('Account Deleted'),
                                content: const Text('You will be returned to the login page.'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('OK')
                                  )
                                ]
                            )
                    ).then((_) {
                      context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
                      Navigator.of(context).pushAndRemoveUntil(LoginPage.route(), (route) => false);
                    });
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
                                  const Text('This action cannot be undone!',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 16
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
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
                        child: BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
                          buildWhen: (previous, current) => previous.status != current.status,
                          builder: (context, state) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.red.shade900,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  minimumSize: const Size.fromHeight(50)
                              ),
                              onPressed: state.status.isValidated && !state.status.isSubmissionInProgress ? () {
                                showDialog<bool?>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text('Delete Account?'),
                                        content: const Text('Are you sure you want to delete your account? This action cannot be undone'),
                                        actions: [
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () => Navigator.of(context).pop(false),
                                          ),
                                          TextButton(
                                            child: const Text('Delete'),
                                            onPressed: () => Navigator.of(context).pop(true),
                                          )
                                        ],
                                      )
                                ).then((confirmed) {
                                  if(confirmed != null && confirmed == true) {
                                    context.read<DeleteAccountBloc>().add(const Submitted());
                                  }
                                });
                              } : null,
                              child: const Text('Delete Account'),
                            );
                          },
                        )
                    )
                )
              ],
            )
        )
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeleteAccountBloc, DeleteAccountState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (password) => EasyDebounce.debounce('delete_account_password', const Duration(milliseconds: 500), () => context.read<DeleteAccountBloc>().add(PasswordChanged(password))),
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
      }
    }
    return null;
  }
}