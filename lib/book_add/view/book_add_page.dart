import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:library_app/book_add/bloc/book_add_bloc.dart';
import 'package:library_app/book_add/models/models.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/widgets/widgets.dart';

class BookAddPage extends StatelessWidget{
  const BookAddPage({Key? key}) : super(key: key);

  static Route<bool?> route({required int libraryId, required int collectionId, Book? book}){
    return MaterialPageRoute<bool?>(
      builder: (context) => BlocProvider(
        create: (context) => BookAddBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context),
          libraryId: libraryId,
          collectionId: collectionId,
          book: book
        ),
        child: const BookAddPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Edit Book'),
      ),
      body: BlocListener<BookAddBloc, BookAddState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if(state.status == FormzStatus.submissionFailure){
            ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Error Creating/Modifying Book'))
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
                        _TitleInput(),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 12),),
                        _SynopsisInput(),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 12),),
                        _DatePublishedInput(),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 12),),
                        _AuthorsInput()
                      ],
                    )
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
                      onTap: () => Navigator.of(context).pop(false),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                    BlocBuilder<BookAddBloc, BookAddState>(
                      buildWhen: (previous, current) => previous.status != current.status,
                      builder: (context, state) {
                        return SubmitButton(
                          text: state.isEdit ? 'Modify' : 'Create',
                          onTap: state.status.isValidated && !state.status.isSubmissionInProgress ? () => context.read<BookAddBloc>().add(const Submitted()) : null,
                        );
                      },
                    )
                  ],
                ),
              )
            )
          ],
        ),
      )
    );
  }
}

class _TitleInput extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAddBloc, BookAddState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        final controller = TextEditingController(text: state.title.value);
        controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
        return TextField(
          controller: controller,
          onChanged: (title) => context.read<BookAddBloc>().add(TitleChanged(title)),
          decoration: InputDecoration(
            labelText: 'Title',
            hintText: 'Enter Title',
            errorText: _getError(state.title.error)
          ),
          maxLength: 255,
        );
      },
    );
  }

  String? _getError(TitleValidationError? error){
    if(error != null){
      switch(error){
        case TitleValidationError.empty:
          return 'title required';
        case TitleValidationError.length:
          return 'title too long';
      }
    }
    return null;
  }
}

class _SynopsisInput extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAddBloc, BookAddState>(
      buildWhen: (previous, current) => previous.synopsis != current.synopsis,
      builder: (context, state) {
        final controller = TextEditingController(text: state.synopsis.value);
        controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
        return TextField(
          controller: controller,
          onChanged: (synopsis) => context.read<BookAddBloc>().add(SynopsisChanged(synopsis)),
          minLines: 1,
          maxLines: 10,
          decoration: InputDecoration(
              labelText: 'Synopsis',
              hintText: 'Enter Synopsis',
              errorText: _getError(state.synopsis.error)
          ),
          maxLength: 1023,
        );
      },
    );
  }

  String? _getError(SynopsisValidationError? error){
    if(error != null){
      switch(error){
        case SynopsisValidationError.empty:
          return 'synopsis required';
        case SynopsisValidationError.length:
          return 'synopsis too long';
      }
    }
    return null;
  }
}

class _DatePublishedInput extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAddBloc, BookAddState>(
      buildWhen: (previous, current) => previous.datePublished != current.datePublished,
      builder: (context, state) {
        return  InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Date Published'
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('MMM dd, yyyy').format(state.datePublished.value)),
              ElevatedButton(
                onPressed: () {
                  showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.utc(1000, 1, 1),
                      lastDate: DateTime.utc(3000, 1, 1),
                      initialDatePickerMode: DatePickerMode.year
                  ).then((datePublished) => {
                    if(datePublished != null){
                      context.read<BookAddBloc>().add(DatePublishedChanged(datePublished))
                    }
                  });
                },
                child: const Text('Change')
              ),
            ],
          )
        );
      },
    );
  }
}

class _AuthorsInput extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAddBloc, BookAddState>(
      buildWhen: (previous, current) => previous.authors != current.authors,
      builder: (context, state) {
        return InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Authors'
          ),
          child: Column(
            children: [
              for(final author in state.authors)
                AuthorListTile(
                  author: author,
                  onDelete: (){

                  }
                ),
              Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      width: 800,
                      height: 40,
                      child: TextButton(
                        child: const Text('Add Author'),
                        onPressed: () {

                        },
                      )
                    ),
                  )
                ),
              )
            ],
          )
        );
      },
    );
  }

}