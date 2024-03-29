import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/books/view/books_page.dart';
import 'package:library_app/collection_add/view/collection_add_page.dart';
import 'package:library_app/collections/bloc/collections_bloc.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/widgets/widgets.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({Key? key}) : super(key: key);

  static Route<void> route({required Library library}) {
    return MaterialPageRoute<void>(
        builder: (context) => BlocProvider(
          create: (context) => CollectionsBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context),
          library: library
    ),
    child: const CollectionsPage(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
      ),
      floatingActionButton: BlocBuilder<CollectionsBloc, CollectionsState>(
        buildWhen: (previous, current) => previous.library != current.library,
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: state.library.permissions > 1 ? () {
              Navigator.of(context).push<bool?>(CollectionAddPage.route(libraryId: state.library.id))
                  .then((refresh) {
                if(refresh != null && refresh == true){
                  Navigator.of(context).pushReplacement(CollectionsPage.route(library: state.library));
                }
              });
            } : null,
            child: const Icon(Icons.add)
          );
        },
      ),
      body: MultiBlocListener(
  listeners: [
    BlocListener<CollectionsBloc, CollectionsState>(
        listener: (context, state) {
          if (state.status == CollectionsStatus.errorLoading) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  const SnackBar(content: Text('Error Loading Collections'))
              );
          }
        },
),
    BlocListener<CollectionsBloc, CollectionsState>(
      listenWhen: (previous, current) => previous.errorMsg != current.errorMsg && current.errorMsg.isNotEmpty,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text(state.errorMsg))
          );
      },
    ),
  ],
  child: BlocBuilder<CollectionsBloc, CollectionsState>(
          builder: (context, state) {
            if (state.status == CollectionsStatus.initial || state.status == CollectionsStatus.modified) {
              context.read<CollectionsBloc>().add(const LoadCollectionsEvent());
            }
            if (state.status == CollectionsStatus.loading || state.status == CollectionsStatus.modifying) {
              return const FullPageLoading();
            }
            if (state.status == CollectionsStatus.errorLoading) {
              return const FullPageError(text: 'Error Loading Collections');
            }
            if (state.collections.isEmpty) {
              return const Center(child: Text(
                  'You currently don\'t have any collection in this library.'));
            }
            final searchController = TextEditingController(text: state.query.searchTerm);
            searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                            controller: searchController,
                            onChanged: (query) => EasyDebounce.debounce('collections_query', const Duration(milliseconds: 300), () => context.read<CollectionsBloc>().add(QueryTextChanged(query))),
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
                            onPressed: () => context.read<CollectionsBloc>().add(const QueryTextChanged('')),
                          )
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CupertinoScrollbar(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<CollectionsBloc>().add(const LoadCollectionsEvent());
                        },
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            for(final collection in state.filteredCollections)
                              CollectionTile(
                                  collection: collection,
                                  library: state.library,
                                  onEditCollection: () {
                                    Navigator.of(context).push<bool?>(CollectionAddPage.route(libraryId: collection.libraryId, collection: collection))
                                        .then((refresh) {
                                       if(refresh != null && refresh == true){
                                         Navigator.of(context).pushReplacement(CollectionsPage.route(library: state.library));
                                       }
                                    });
                                  },
                                  onDeleteCollection: () {
                                    showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('Delete Collection?'),
                                            content: const Text('Are you sure you want to delete this collection?'),
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
                                        context.read<CollectionsBloc>().add(CollectionDeletedEvent(collection.id));
                                      }
                                    });
                                  },
                                onTap: (){
                                    Navigator.of(context).push(BooksPage.route(library: state.library, collection: collection));
                                },
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
),
    );
  }
  
}