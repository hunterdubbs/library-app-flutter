import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:library_app/author_search/view/author_search_page.dart';
import 'package:library_app/book_add/bloc/book_add_bloc.dart';
import 'package:library_app/book_add/models/models.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/isbn_lookup/view/isbn_lookup_page.dart';
import 'package:library_app/tags/view/tags_page.dart';
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
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: BlocBuilder<BookAddBloc, BookAddState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.isEdit ? null : () {
                          Navigator.of(context).push<BookLookupDetails?>(
                              IsbnLookupPage.route()).then((details) {
                            if (details != null) {
                              context.read<BookAddBloc>().add(DetailsReturned(details));
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            minimumSize: const Size(150, 50)
                        ),
                        child: const Text('Quick Add'),
                      );
                    }
                )
              )
            ),
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
                        _AuthorsInput(),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 12)),
                        _TagsInput(),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 12)),
                        _SeriesInput(),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 12)),
                        _VolumeInput()
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
          onChanged: (title) => EasyDebounce.debounce('book_add_title', const Duration(milliseconds: 300), () => context.read<BookAddBloc>().add(TitleChanged(title))),
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
          //onChanged: (synopsis) => context.read<BookAddBloc>().add(SynopsisChanged(synopsis)),
          onChanged: (synopsis) => EasyDebounce.debounce('book_add_synopsis', const Duration(milliseconds: 300), () => context.read<BookAddBloc>().add(SynopsisChanged(synopsis))),
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
        case SynopsisValidationError.length:
          return 'synopsis too long';
      }
    }
    return null;
  }
}


class _SeriesInput extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAddBloc, BookAddState>(
      buildWhen: (previous, current) => previous.series != current.series,
      builder: (context, state) {
        final controller = TextEditingController(text: state.series.value);
        controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
        return TextField(
          controller: controller,
          //onChanged: (synopsis) => context.read<BookAddBloc>().add(SynopsisChanged(synopsis)),
          onChanged: (series) => EasyDebounce.debounce('book_add_series', const Duration(milliseconds: 300), () => context.read<BookAddBloc>().add(SeriesChanged(series))),
          minLines: 1,
          maxLines: 10,
          decoration: InputDecoration(
              labelText: 'Series',
              hintText: 'Enter Series',
              errorText: _getError(state.series.error)
          ),
          maxLength: 80,
        );
      },
    );
  }

  String? _getError(SeriesValidationError? error){
    if(error != null){
      switch(error){
        case SeriesValidationError.length:
          return 'series too long';
      }
    }
    return null;
  }
}

class _VolumeInput extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAddBloc, BookAddState>(
      buildWhen: (previous, current) => previous.volume != current.volume,
      builder: (context, state) {
        final controller = TextEditingController(text: state.volume.value);
        controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
        return TextField(
          controller: controller,
          //onChanged: (synopsis) => context.read<BookAddBloc>().add(SynopsisChanged(synopsis)),
          onChanged: (volume) => EasyDebounce.debounce('book_add_series', const Duration(milliseconds: 300), () => context.read<BookAddBloc>().add(VolumeChanged(volume))),
          minLines: 1,
          maxLines: 10,
          decoration: InputDecoration(
              labelText: 'Volume',
              hintText: 'Enter Volume',
              errorText: _getError(state.volume.error)
          ),
          maxLength: 3,
        );
      },
    );
  }

  String? _getError(VolumeValidationError? error){
    if(error != null){
      switch(error){
        case VolumeValidationError.length:
          return 'volume too long';
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
      buildWhen: (previous, current) => previous.authors != current.authors || previous.rev != current.rev,
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
                    context.read<BookAddBloc>().add(AuthorRemoved(author.id));
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
                          Navigator.of(context).push<Author?>(AuthorSearchPage.route()).then((author) {
                            if(author != null) context.read<BookAddBloc>().add(AuthorAdded(author));
                          });
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

class _TagsInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAddBloc, BookAddState>(
      buildWhen: (previous, current) => previous.tags != current.tags || previous.rev != current.rev,
      builder: (context, state) {
        return InputDecorator(
            decoration: const InputDecoration(
                labelText: 'Tags'
            ),
            child: Column(
              children: [
                for(final tag in state.tags)
                  TagListTile(
                      tag: tag,
                      onDelete: (){
                        context.read<BookAddBloc>().add(TagRemoved(tag.id));
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
                              child: const Text('Add Tag'),
                              onPressed: () {
                                Navigator.of(context).push<Tag?>(TagsPage.route(libraryId: state.libraryId)).then((tag) {
                                  if(tag != null) context.read<BookAddBloc>().add(TagAdded(tag));
                                });
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