import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/library_add/bloc/library_add_bloc.dart';
import 'package:library_app/library_add/models/models.dart';
import 'package:library_app/widgets/widgets.dart';

class LibraryAddPage extends StatelessWidget{
  const LibraryAddPage({Key? key}) : super(key: key);

  static Route<bool> route(){
    return MaterialPageRoute<bool>(builder: (_) => const LibraryAddPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Library')
      ),
      body: BlocProvider(
        create: (context) => LibraryAddBloc(libraryApi: RepositoryProvider.of<LibraryApi>(context)),
        child: BlocListener<LibraryAddBloc, LibraryAddState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if(state.status == FormzStatus.submissionFailure){
              ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Error Creating Library'))
                  );
            }
            if(state.status == FormzStatus.submissionSuccess){
              Navigator.of(context).pop(true);
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
                          _NameInput()
                        ],
                      ),
                    )
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
                        onTap: () => Navigator.of(context).pop(false)
                      ),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                      BlocBuilder<LibraryAddBloc, LibraryAddState>(
                        buildWhen: (previous, current) => previous.status != current.status,
                        builder: (context, state) {
                          return SubmitButton(
                              text: 'Create',
                              onTap: state.status.isValidated && !state.status.isSubmissionInProgress ? () => context.read<LibraryAddBloc>().add(const Submitted()) : null
                          );
                        }
                      )
                    ],
                  ),
                )
              )
            ],
          )
        )
      )
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryAddBloc, LibraryAddState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          onChanged: (name) => EasyDebounce.debounce('library_add_name', const Duration(milliseconds: 500), () => context.read<LibraryAddBloc>().add(NameChanged(name))),
          decoration: InputDecoration(
            labelText: 'Name',
            hintText: 'Your library name',
            errorText: _getError(state.name.error)
          ),
          maxLength: 80,
        );
      }
    );
  }

  String? _getError(LibraryNameValidationError? error){
    if(error != null) {
      switch (error) {
        case LibraryNameValidationError.empty:
          return 'name required';
        case LibraryNameValidationError.length:
          return '80 chars max';
      }
    }
    return null;
  }
}