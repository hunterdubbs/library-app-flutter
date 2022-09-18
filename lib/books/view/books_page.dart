import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/books/bloc/books_bloc.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/widgets/widgets.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({Key? key}) : super(key: key);

  static Route<void> route({required Library library, required Collection collection}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => BooksBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context),
          library: library,
          collection: collection
        ),
        child: const BooksPage(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
      ),
      floatingActionButton: BlocBuilder<BooksBloc, BooksState>(
        buildWhen: (previous, current) => previous.collection != current.collection,
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              /*Navigator.of(context).push<bool?>(BookAddPage.route(libraryId: state.library.id, collectionId: state.collection.id)).then((refresh) {
                if(refresh != null && refresh == true){
                  Navigator.of(context).pushReplacement(BooksPage.route(library: state.library, collection: state.collection));
                }
              });*/
            },
            child: const Icon(Icons.add),
          );
        }
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<BooksBloc, BooksState>(
            listener:  (context, state) {
              if(state.status == BooksStatus.errorLoading){
                ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Error Loading Books'))
                    );
              }
            },
          ),
          BlocListener<BooksBloc, BooksState>(
            listenWhen: (previous, current) => previous.errorMsg != current.errorMsg && current.errorMsg.isNotEmpty,
            listener: (context, state) {
              ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(state.errorMsg))
                  );
            },
          )
        ],
        child: BlocBuilder<BooksBloc, BooksState>(
          builder: (context, state) {
            if(state.status == BooksStatus.initial || state.status == BooksStatus.modified){
              context.read<BooksBloc>().add(const LoadBooksEvent());
            }
            if(state.status == BooksStatus.loading || state.status == BooksStatus.modifying) {
              return const FullPageLoading();
            }
            if(state.status == BooksStatus.errorLoading){
              return const FullPageError(text: 'Error Loading Books');
            }
            if(state.books.isEmpty) {
              return const Center(child: Text('You currently don\'t have any books in this collection'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<BooksBloc>().add(const LoadBooksEvent());
              },
              child: CupertinoScrollbar(
                child: ListView(
                  children: [
                    for(final book in state.books)
                      BookTile(
                        library: state.library,
                        book: book,
                      )
                  ],
                )
              )
            );
          },
        )
      ),
    );
  }
}