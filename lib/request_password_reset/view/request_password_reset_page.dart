import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/authentication_api.dart';
import 'package:library_app/request_password_reset/bloc/request_password_reset_bloc.dart';
import 'package:library_app/request_password_reset/models/models.dart';
import 'package:library_app/reset_password/view/reset_password_page.dart';
import 'package:library_app/widgets/submit_button.dart';

class RequestPasswordResetPage extends StatelessWidget {
  const RequestPasswordResetPage({Key? key}) : super(key: key);

  static Route<void> route(){
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => RequestPasswordResetBloc(
          authenticationApi: RepositoryProvider.of<AuthenticationApi>(context)
        ),
        child: const RequestPasswordResetPage(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<RequestPasswordResetBloc, RequestPasswordResetState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if(state.status.isSubmissionFailure){
                ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Error Requesting Reset Code'))
                    );
              }
              if(state.status.isSubmissionSuccess){
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      AlertDialog(
                        title: const Text('Reset Code Sent'),
                        content: const Text('A password reset code will be sent to your email. It expires in 15 minutes.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK')
                          )
                        ]
                      )
                ).then((_) => Navigator.of(context).push(ResetPasswordPage.route(email: state.email.value)));
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
                        const Text('Enter your email and a reset code will be sent for your account if it exists.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(12)),
                        _EmailInput(),
                      ],
                    ),
                  )
                )
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  children: [
                    SubmitButton(
                      text: 'I Have a Code',
                      onTap: () => Navigator.of(context).push(ResetPasswordPage.route()),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    BlocBuilder<RequestPasswordResetBloc, RequestPasswordResetState>(
                      buildWhen: (previous, current) => previous.status != current.status,
                      builder: (context, state) {
                        return SubmitButton(
                          text: 'Request Code',
                          onTap: state.status.isValidated && !state.status.isSubmissionInProgress ? () => context.read<RequestPasswordResetBloc>().add(const Submitted()) : null,
                        );
                      },
                    ),
                  ],
                )
              ),
            )
          ],
        ),
      )
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestPasswordResetBloc, RequestPasswordResetState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) => EasyDebounce.debounce('request_password_reset_email', const Duration(milliseconds: 300), () => context.read<RequestPasswordResetBloc>().add(EmailChanged(email))),
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