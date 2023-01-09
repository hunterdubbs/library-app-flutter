import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:library_app/author_add/bloc/author_add_bloc.dart';
import 'package:library_app/author_add/models/models.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/widgets/widgets.dart';

class AuthorAddPage extends StatelessWidget{
  const AuthorAddPage({Key? key}) : super(key: key);

  static Route<Author?> route(){
    return MaterialPageRoute<Author?>(
      builder: (context) => BlocProvider(
        create: (context) => AuthorAddBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context)
        ),
        child: const AuthorAddPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Author'),
      ),
      body: BlocListener<AuthorAddBloc, AuthorAddState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if(state.status == FormzStatus.submissionFailure){
            ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Error Adding Author'))
                );
          }
          if(state.status == FormzStatus.submissionSuccess){
            Navigator.of(context).pop(state.author);
          }
        },
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
                        _FirstNameInput(),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 12),),
                        _LastNameInput()
                      ],
                    ),
                  ),
                )
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    children: [
                      CancelButton(
                        onTap: () => Navigator.of(context).pop()
                      ),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                      BlocBuilder<AuthorAddBloc, AuthorAddState>(
                        buildWhen: (previous, current) => previous.status != current.status,
                        builder: (context, state) {
                          return SubmitButton(
                            text: 'Create',
                            onTap: state.status.isValidated && !state.status.isSubmissionInProgress ? () => context.read<AuthorAddBloc>().add(const Submitted()) : null,
                          );
                        },
                      )
                    ],
                  ),
                ),
            )
          ],
        ),
      )
    );
  }

}

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorAddBloc, AuthorAddState>(
        buildWhen: (previous, current) => previous.firstName != current.firstName,
        builder: (context, state) {
          return TextField(
            onChanged: (firstName) => EasyDebounce.debounce('author_add_first', const Duration(milliseconds: 300), ()=> context.read<AuthorAddBloc>().add(FirstNameChanged(firstName))),
            decoration: InputDecoration(
                labelText: 'First Name',
                errorText: _getError(state.firstName.error)
            ),
            maxLength: 80,
          );
        }
    );
  }

  String? _getError(FirstNameValidationError? error){
    if(error != null) {
      switch (error) {
        case FirstNameValidationError.empty:
          return 'name required';
        case FirstNameValidationError.length:
          return '40 chars max';
      }
    }
    return null;
  }
}

class _LastNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorAddBloc, AuthorAddState>(
        buildWhen: (previous, current) => previous.lastName != current.lastName,
        builder: (context, state) {
          return TextField(
            onChanged: (lastName) => EasyDebounce.debounce('author_add_last', const Duration(milliseconds: 300), ()=> context.read<AuthorAddBloc>().add(LastNameChanged(lastName))),
            decoration: InputDecoration(
                labelText: 'Last Name',
                errorText: _getError(state.lastName.error)
            ),
            maxLength: 80,
          );
        }
    );
  }

  String? _getError(LastNameValidationError? error){
    if(error != null) {
      switch (error) {
        case LastNameValidationError.empty:
          return 'name required';
        case LastNameValidationError.length:
          return '40 chars max';
      }
    }
    return null;
  }
}