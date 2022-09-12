import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:library_app/collection_add/bloc/collection_add_bloc.dart';
import 'package:library_app/collection_add/models/models.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/widgets/widgets.dart';

class CollectionAddPage extends StatelessWidget{
  const CollectionAddPage({Key? key}) : super(key: key);

  static Route<bool?> route({required int libraryId, Collection? collection}){
    return MaterialPageRoute<bool?>(
      builder: (context) => BlocProvider(
        create: (context) => CollectionAddBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context),
          libraryId: libraryId,
          collection: collection
        ),
        child: const CollectionAddPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Collection Details')
        ),
        body: BlocListener<CollectionAddBloc, CollectionAddState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if(state.status == FormzStatus.submissionFailure){
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text('Error Creating/Modifying Collection'))
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
                            _NameInput(),
                            const Padding(padding: EdgeInsets.symmetric(horizontal: 12)),
                            _DescriptionInput()
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
                        BlocBuilder<CollectionAddBloc, CollectionAddState>(
                            buildWhen: (previous, current) => previous.status != current.status,
                            builder: (context, state) {
                              return SubmitButton(
                                  text: state.isEdit ? 'Modify' : 'Create',
                                  onTap: state.status.isValidated && !state.status.isSubmissionInProgress ? () => context.read<CollectionAddBloc>().add(const Submitted()) : null
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
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionAddBloc, CollectionAddState>(
        buildWhen: (previous, current) => previous.name != current.name,
        builder: (context, state) {
          final controller = TextEditingController(text: state.name.value);
          controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
          return TextField(
            controller: controller,
            onChanged: (name) => context.read<CollectionAddBloc>().add(NameChanged(name)),
            decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Your collection name',
                errorText: _getError(state.name.error)
            ),
            maxLength: 80,
          );
        }
    );
  }

  String? _getError(CollectionNameValidationError? error){
    if(error != null) {
      switch (error) {
        case CollectionNameValidationError.empty:
          return 'name required';
        case CollectionNameValidationError.length:
          return '80 chars max';
        case CollectionNameValidationError.specialChars:
          return 'only alphanumeric characters allowed';
      }
    }
    return null;
  }
}

class _DescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionAddBloc, CollectionAddState>(
        buildWhen: (previous, current) => previous.description != current.description,
        builder: (context, state) {
          final controller = TextEditingController(text: state.description.value);
          controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
          return TextField(
            controller: controller,
            onChanged: (description) => context.read<CollectionAddBloc>().add(DescriptionChanged(description)),
            decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'A brief description',
                errorText: _getError(state.description.error)
            ),
            maxLength: 255,
          );
        }
    );
  }

  String? _getError(CollectionDescriptionValidationError? error){
    if(error != null) {
      switch (error) {
        case CollectionDescriptionValidationError.empty:
          return 'description required';
        case CollectionDescriptionValidationError.length:
          return '80 chars max';
        case CollectionDescriptionValidationError.specialChars:
          return 'only alphanumeric characters allowed';
      }
    }
    return null;
  }
}