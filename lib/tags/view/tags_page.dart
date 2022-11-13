import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/tag_add/view/tag_add_page.dart';
import 'package:library_app/tags/bloc/tags_bloc.dart';
import 'package:library_app/widgets/widgets.dart';

class TagsPage extends StatelessWidget {
  const TagsPage({Key? key}) : super(key: key);

  static Route<Tag?> route({required int libraryId}){
    return MaterialPageRoute<Tag?>(
      builder: (context) => BlocProvider(
        create: (context) => TagsBloc(
          libraryId: libraryId,
          libraryApi: RepositoryProvider.of<LibraryApi>(context)
        ),
        child: const TagsPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
      ),
      floatingActionButton: BlocBuilder<TagsBloc, TagsState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push<Tag?>(TagAddPage.route(libraryId: state.libraryId)).then((tag) {
                if(tag != null) {
                  Navigator.of(context).pop(tag);
                }
              });
            },
            child: const Icon(Icons.add)
          );
        },
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TagsBloc, TagsState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if(state.status == TagsStatus.errorLoading) {
                ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Error loading tags'))
                    );
              }
            },
          )
        ],
        child: BlocBuilder<TagsBloc, TagsState>(
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            if(state.status == TagsStatus.initial){
              context.read<TagsBloc>().add(const LoadTags());
              return const FullPageLoading();
            }
            if(state.status == TagsStatus.loading){
              return const FullPageLoading();
            }
            if(state.status == TagsStatus.errorLoading){
              return const FullPageError(text: 'Error Loading Tags');
            }
            if(state.tags.isEmpty){
              return const Center(child: Text('This library doesn\'t have any tags yet.'));
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CupertinoScrollbar(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for(final tag in state.tags)
                      TagTile(
                        tag: tag,
                        onTap: () {
                          Navigator.of(context).pop(tag);
                        },
                      )
                  ],
                ),
              )
            );
          },
        ),
      )
    );
  }
}