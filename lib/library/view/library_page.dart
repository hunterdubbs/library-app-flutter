import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/collections/view/collections_page.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/library/bloc/library_bloc.dart';
import 'package:library_app/library_add/view/library_add_page.dart';
import 'package:library_app/permissions/view/permissions_page.dart';
import 'package:library_app/widgets/widgets.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LibraryPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context){
          return LibraryBloc(libraryApi: RepositoryProvider.of<LibraryApi>(context));
      },
      child: MultiBlocListener(
  listeners: [
    BlocListener<LibraryBloc, LibraryState>(
        listener: (context, state) {
          if(state.status == LibraryStatus.errorLoading) {
            ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Error Loading Libraries'))
                );
          }
        },
      ),
    BlocListener<LibraryBloc, LibraryState>(
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
  child: Scaffold(
          appBar: AppBar(
            title: const Text('Libraries'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push<bool?>(LibraryAddPage.route())
                  .then((refresh) {
                    if(refresh != null && refresh == true) {
                      Navigator.of(context).pushReplacement(LibraryPage.route());
                    }
                  });
            },
            child: const Icon(Icons.add)
          ),
          body: BlocBuilder<LibraryBloc, LibraryState>(
            builder: (context, state) {
              if(state.status == LibraryStatus.initial || state.status == LibraryStatus.modified){
                context.read<LibraryBloc>().add(const LoadLibrariesEvent());
              }
              if(state.status == LibraryStatus.loading || state.status == LibraryStatus.modifying){
                return const FullPageLoading();
              }
              if(state.status == LibraryStatus.errorLoading){
                return const FullPageError(text: 'Error Loading Libraries');
              }
              if(state.libraries.isEmpty){
                return const Center(child: Text('You currently don\'t have any libraries. Try creating one below.'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<LibraryBloc>().add(const LoadLibrariesEvent());
                },
                child: CupertinoScrollbar(
                  child: ListView(
                    children: [
                      for(final library in state.libraries)
                        LibraryTile(
                          library: library,
                          onTap: (){
                            Navigator.of(context).push(CollectionsPage.route(library: library));
                          },
                          onDeleteLibrary: () {
                            final deleteController = TextEditingController();
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                  AlertDialog(
                                      title: const Text('Delete Library?'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                              'Enter library name to confirm deletion'),
                                          TextField(
                                            controller: deleteController,
                                            decoration: const InputDecoration(
                                              labelText: 'Library name'
                                            ),
                                          ),
                                        ],
                                      ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Cancel')
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(deleteController.text),
                                        child: const Text('Delete')
                                      )
                                    ],
                                )
                            ).then((confirmation) {
                              if(confirmation != null && confirmation.isNotEmpty){
                                if(confirmation == library.name){
                                  context.read<LibraryBloc>().add(LibraryDeletedEvent(library.id));
                                }else{
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                        const SnackBar(content: Text('Could not delete. Library name did not match.'))
                                    );
                                }
                              }
                            });
                          },
                          onEditLibrary: () {
                            final controller = TextEditingController(text: library.name);
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                    title: const Text('Modify Library'),
                                    content: TextField(
                                      controller: controller,
                                      decoration: const InputDecoration(
                                        labelText: 'Name'
                                      ),
                                      maxLength: 80,
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text('Cancel')
                                      ),
                                      TextButton(
                                          onPressed: () => Navigator.of(context).pop(controller.text),
                                          child: const Text('Submit')
                                      )
                                    ],
                                  )
                            ).then((name) {
                              if(name != null && name.isNotEmpty && name != library.name){
                                context.read<LibraryBloc>().add(LibraryModifiedEvent(library.id, name));
                              }
                            });
                          },
                          onEditShare: () {
                            Navigator.of(context).push(PermissionsPage.route(library: library));
                          },
                        )
                    ],
                  ),
                ),
              );
            }
          )
        ),
),
    );
  }
}