import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: BlocListener<CollectionsBloc, CollectionsState>(
        listener: (context, state) {
          if (state.status == CollectionsStatus.errorLoading) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  const SnackBar(content: Text('Error Loading Collections'))
              );
          }
        },
        child: BlocBuilder<CollectionsBloc, CollectionsState>(
          builder: (context, state) {
            if (state.status == CollectionsStatus.initial) {
              context.read<CollectionsBloc>().add(const LoadCollectionsEvent());
            }
            if (state.status == CollectionsStatus.loading) {
              return const FullPageLoading();
            }
            if (state.status == CollectionsStatus.errorLoading) {
              return const FullPageError(text: 'Error Loading Collections');
            }
            if (state.collections.isEmpty) {
              return const Center(child: Text(
                  'You currently don\'t have any collection in this library.'));
            }
            return ListView(
              children: [
                for(final collection in state.collections)
                  CollectionTile(collection: collection)
              ],
            );
          },
        ),
      ),
    );
  }
  
}