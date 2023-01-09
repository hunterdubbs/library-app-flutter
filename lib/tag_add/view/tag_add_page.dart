import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/tag_add/bloc/tag_add_bloc.dart';
import 'package:library_app/tag_add/models/models.dart';
import 'package:library_app/widgets/widgets.dart';

class TagAddPage extends StatelessWidget {
  const TagAddPage({Key? key}) : super(key: key);

  static Route<Tag?> route({required int libraryId}){
    return MaterialPageRoute<Tag?>(
      builder: (context) => BlocProvider(
        create: (context) => TagAddBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context),
          libraryId: libraryId
        ),
        child: const TagAddPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tag'),
      ),
      body: BlocListener<TagAddBloc, TagAddState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if(state.status == FormzStatus.submissionFailure) {
            ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Error Adding Tag'))
                );
          }
          if(state.status == FormzStatus.submissionSuccess) {
            Navigator.of(context).pop(state.tag);
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
                    )
                  )
                )
              )
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
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    BlocBuilder<TagAddBloc, TagAddState>(
                      buildWhen: (previous, current) => previous.status != current.status,
                      builder: (context, state) {
                        return SubmitButton(
                          text: 'Create',
                          onTap: state.status.isValidated && !state.status.isSubmissionInProgress ? () => context.read<TagAddBloc>().add(const Submitted()) : null,
                        );
                      }
                    )
                  ],
                )
              )
            )
          ],
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagAddBloc, TagAddState>(
        buildWhen: (previous, current) => previous.name != current.name,
        builder: (context, state) {
          return TextField(
            onChanged: (name) => EasyDebounce.debounce('tag_add_name', const Duration(milliseconds: 300), () => context.read<TagAddBloc>().add(NameChanged(name))),
            decoration: InputDecoration(
                labelText: 'Tag Name',
                errorText: _getError(state.name.error)
            ),
            maxLength: 30,
          );
        }
    );
  }

  String? _getError(NameValidationError? error){
    if(error != null) {
      switch (error) {
        case NameValidationError.empty:
          return 'name required';
        case NameValidationError.length:
          return '30 chars max';
      }
    }
    return null;
  }
}