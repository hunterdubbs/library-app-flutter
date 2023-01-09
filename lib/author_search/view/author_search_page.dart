import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:library_app/author_add/view/author_add_page.dart';
import 'package:library_app/author_search/bloc/author_search_bloc.dart';
import 'package:library_app/author_search/models/models.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/widgets/widgets.dart';

class AuthorSearchPage extends StatelessWidget{
  const AuthorSearchPage({Key? key}) : super(key: key);

  static Route<Author?> route(){
    return MaterialPageRoute<Author?>(
      builder: (context) => BlocProvider(
        create: (context) => AuthorSearchBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context)
        ),
        child: const AuthorSearchPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Author Search')
      ),
      floatingActionButton: BlocBuilder<AuthorSearchBloc, AuthorSearchState>(
        builder: (context, state) {
          return FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push<Author?>(AuthorAddPage.route()).then((author) {
                  if(author != null){
                    Navigator.of(context).pop(author);
                  }
                });
              },
            child: const Icon(Icons.add),
          );
        }
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthorSearchBloc, AuthorSearchState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if(state.status == FormzStatus.submissionFailure){
                ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Error searching authors'))
                    );
              }
            },
          )
        ],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children:[
                  Expanded(
                    child: _QueryInput(),
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      icon: const Icon(
                        CupertinoIcons.search,
                        size: 28,
                        semanticLabel: 'search',
                      ),
                      onPressed: () {
                        context.read<AuthorSearchBloc>().add(const QuerySubmitted());
                      },
                    ),
                  )
                ]
              )
            ),
            BlocBuilder<AuthorSearchBloc, AuthorSearchState>(
              buildWhen: (previous, current) => previous.status != current.status || previous.results != current.results,
              builder: (context, state) {
                if(state.status == FormzStatus.pure){
                  return const Expanded(child: Center(child: Text('Search for an author to add to this book.')));
                }
                if(state.status == FormzStatus.submissionInProgress){
                  return const FullPageLoading();
                }
                if(state.status == FormzStatus.submissionFailure){
                  return const FullPageError(text: 'Error Loading Authors');
                }
                if(state.results.isEmpty){
                  return const Expanded(child: Center(child: Text("No results found")));
                }
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CupertinoScrollbar(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for(final author in state.results)
                            AuthorTile(
                              author: author,
                              onTap: () {
                                Navigator.of(context).pop(author);
                              }
                            )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      )
    );
  }
}

class _QueryInput extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorSearchBloc, AuthorSearchState>(
      buildWhen: (previous, current) => previous.query != current.query,
      builder: (context, state) {
        return TextField(
          onChanged: (query) => EasyDebounce.debounce('author_search_query', const Duration(milliseconds: 300), () => context.read<AuthorSearchBloc>().add(QueryChanged(query))),
          decoration: InputDecoration(
            hintText: 'Search by Author Name',
            errorText: _getError(state.query.error)
          ),
          maxLength: 100,
        );
      }
    );
  }

  String? _getError(QueryValidationError? error){
    if(error != null){
      switch(error){
        case QueryValidationError.empty:
          return 'query cannot be blank';
        case QueryValidationError.length:
          return 'query too long';
      }
    }
    return null;
  }

}