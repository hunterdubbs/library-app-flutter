import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/book_add/view/book_add_page.dart';
import 'package:library_app/book_collections/view/book_collections_page.dart';
import 'package:library_app/book_details/view/book_details_page.dart';
import 'package:library_app/books/bloc/books_bloc.dart';
import 'package:library_app/books/models/models.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/repositories/prefs_repository.dart';
import 'package:library_app/widgets/widgets.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({Key? key}) : super(key: key);

  static Route<void> route({required Library library, required Collection collection}) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => BooksBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context),
          prefsRepository: RepositoryProvider.of<PrefsRepository>(context),
          library: library,
          collection: collection
        ),
        child: const BooksPage(),
      )
    );
  }

  static Route<void> routeSeries({
    required Library library,
    required Collection collection,
    required List<Book> books,
    required Query query
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => BooksBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context),
          prefsRepository: RepositoryProvider.of<PrefsRepository>(context),
          library: library,
          collection: collection,
          books: books,
          query: query,
          status: BooksStatus.loaded,
          isGroupable: false
        ),
        child: const BooksPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              size: 28,
              semanticLabel: 'search',
            ),
            onPressed: () => context.read<BooksBloc>().add(const ToggleQueryEditorVisible()),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                children: [
                  BlocBuilder<BooksBloc, BooksState>(
                      buildWhen: (previous, current) => previous.groupSeries != current.groupSeries || previous.isGroupable != current.isGroupable,
                      builder: (context, state) {
                        if(state.isGroupable) {
                          return ListTile(
                              title: const Text('Group Series'),
                              onTap: () =>
                                  context.read<BooksBloc>().add(
                                      const ToggleSeriesGroup()),
                              trailing: Switch(
                                value: state.groupSeries,
                                onChanged: (val) =>
                                    context.read<BooksBloc>().add(
                                        const ToggleSeriesGroup()),
                              )
                          );
                        }
                        return const Text('');
                      })
                ],
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: ListTile(
                  title: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.arrow_back
                        ),
                        Text('Back')
                      ],
                    )
                  ),
                  tileColor: Theme.of(context).primaryColorLight,
                  onTap: () {
                    //POP! POP!
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: ListTile(
                  title: const Center(child: Text('Close')),
                  tileColor: Theme.of(context).primaryColorLight,
                  onTap: () => Navigator.of(context).pop()
              ),
            )
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<BooksBloc, BooksState>(
        buildWhen: (previous, current) => previous.collection != current.collection,
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: state.library.permissions > 1 ? () {
              Navigator.of(context).push<bool?>(BookAddPage.route(libraryId: state.library.id, collectionId: state.collection.id)).then((refresh) {
                if(refresh != null && refresh == true){
                  Navigator.of(context).pushReplacement(BooksPage.route(library: state.library, collection: state.collection));
                }
              });
            } : null,
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
            final searchController = TextEditingController(text: state.query.searchTerm);
            searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
            return Column(
              children: [
                if(state.query.editorVisible) Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (query) => EasyDebounce.debounce('book_search_query', const Duration(milliseconds: 300), () => context.read<BooksBloc>().add(QueryTextChanged(query))),
                          decoration: const InputDecoration(
                            hintText: 'Search'
                          ),
                        )
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: IconButton(
                          icon: const Icon(
                            CupertinoIcons.xmark,
                            size: 28,
                            semanticLabel: 'clear search',
                          ),
                          onPressed: () => context.read<BooksBloc>().add(const QueryTextChanged('')),
                        )
                      )
                    ],
                  ),
                ),
                if(state.query.editorVisible) Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          icon: const Icon(CupertinoIcons.chevron_down),
                          elevation: 16,
                          onChanged: (i) => context.read<BooksBloc>().add(QueryTypeChanged(QueryMappings.queryTypeMappings[i] ?? QueryType.title)),
                          items: QueryMappings.queryTypeMappings.keys.map<DropdownMenuItem<String>>((i) {
                            return DropdownMenuItem<String>(
                              value: i,
                              child: Text(i, overflow: TextOverflow.fade,)
                            );
                          }).toList(),
                          value: QueryMappings.queryTypeMappings.keys.firstWhere((k) => QueryMappings.queryTypeMappings[k] == state.query.queryType),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        child: DropdownButton<String>(
                          isExpanded: true,
                          isDense: true,
                          icon: const Icon(CupertinoIcons.chevron_down),
                          elevation: 16,
                          onChanged: (i) => context.read<BooksBloc>().add(SortTypeChanged(QueryMappings.sortTypeMappings[i] ?? SortType.dateAddedNewest)),
                          items: QueryMappings.sortTypeMappings.keys.map<DropdownMenuItem<String>>((i) {
                            return DropdownMenuItem(
                              value: i,
                              child: Text(i, overflow: TextOverflow.fade,)
                            );
                          }).toList(),
                          value: QueryMappings.sortTypeMappings.keys.firstWhere((k) => QueryMappings.sortTypeMappings[k] == state.query.sortType)
                        ),
                      )
                    ],
                  )
                ),
                if(state.query.editorVisible) const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Divider(
                    height: 5,
                    color: Colors.black54,
                    thickness: 2,
                  ),
                ),
                Expanded(
                  child: Opacity(
                    opacity: state.query.editorVisible ? 0.5 : 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CupertinoScrollbar(
                        child: RefreshIndicator(
                            onRefresh: () async {
                              context.read<BooksBloc>().add(const LoadBooksEvent());
                            },
                          child: ListView(
                            shrinkWrap: false,
                            children: [
                              for(final book in state.filteredBooks)
                                BookTile(
                                  library: state.library,
                                  book: book,
                                  onTap: () {
                                    if(book.isGroup){
                                      Navigator.of(context).push(BooksPage.routeSeries(
                                          library: state.library,
                                          collection: state.collection,
                                          books: state.books.where((b) => b.series == book.title).toList(),
                                          query: state.query.copyWith(searchTerm: '')
                                      ));
                                    }else {
                                      Navigator.of(context).push(BookDetailsPage.route(book: book, library: state.library));
                                    }
                                  },
                                  onEditBook: () {
                                    Navigator.of(context).push<bool?>(BookAddPage.route(
                                        libraryId: state.library.id,
                                        collectionId: state.collection.id,
                                        book: book)).then((refresh) {
                                          if(refresh != null && refresh == true){
                                            Navigator.of(context).pushReplacement(BooksPage.route(library: state.library, collection: state.collection));
                                          }
                                    });
                                  },
                                  onDeleteBook: (){
                                    showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text('Delete Book?'),
                                              content: const Text('Are you sure you want to delete this book?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(true);
                                                    },
                                                    child: const Text('Delete')
                                                )
                                              ],
                                            )
                                    ).then((confirmed) {
                                      if(confirmed != null && confirmed == true){
                                        context.read<BooksBloc>().add(BookDeletedEvent(book.id));
                                      }
                                    });
                                  },
                                  onEditCollections: (){
                                    Navigator.of(context).push(BookCollectionsPage.route(book: book));
                                  },
                                )
                            ],
                          )
                        )
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        )
      ),
    );
  }
}