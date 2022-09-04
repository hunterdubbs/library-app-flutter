import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/collections/view/collections_page.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/library/bloc/library_bloc.dart';
import 'package:library_app/library_add/view/library_add_page.dart';
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
      child: BlocListener<LibraryBloc, LibraryState>(
        listener: (context, state) {
          if(state.status == LibraryStatus.errorLoading) {
            ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Error Loading Libraries'))
                );
          }
        },
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
              if(state.status == LibraryStatus.initial){
                context.read<LibraryBloc>().add(const LoadLibrariesEvent());
              }
              if(state.status == LibraryStatus.loading){
                return const FullPageLoading();
              }
              if(state.status == LibraryStatus.errorLoading){
                return const FullPageError(text: 'Error Loading Libraries');
              }
              if(state.libraries.isEmpty){
                return const Center(child: Text('You currently don\'t have any libraries. Try creating one below.'));
              }
              return ListView(
                children: [
                  for(final library in state.libraries)
                    LibraryTile(
                      library: library,
                      onTap: (){
                        Navigator.of(context).push(CollectionsPage.route(library: library));
                      },
                    )
                ],
              );
            }
          )
        )
      ),
    );
  }
}