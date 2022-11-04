import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/book_collections/bloc/book_collections_bloc.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/widgets/widgets.dart';

class BookCollectionsPage extends StatelessWidget{
  const BookCollectionsPage({Key? key}) : super(key: key);

  static Route<bool?> route({required Book book}) {
    return MaterialPageRoute<bool?>(
      builder: (context) => BlocProvider(
        create: (context) => BookCollectionsBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context),
          book: book
        ),
        child: const BookCollectionsPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection Memberships'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<BookCollectionsBloc, BookCollectionsState>(
            listenWhen: (previous, current) => previous.errorMsg != current.errorMsg && current.errorMsg.isNotEmpty,
            listener: (context, state) {
              ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(state.errorMsg))
                  );
            },
          ),
          BlocListener<BookCollectionsBloc, BookCollectionsState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if(state.status == BookCollectionsStatus.submitted){
                Navigator.of(context).pop(true);
              }
            }
          )
        ],
        child: BlocBuilder<BookCollectionsBloc, BookCollectionsState>(
          builder: (context, state) {
            if(state.status == BookCollectionsStatus.initial){
              context.read<BookCollectionsBloc>().add(const LoadCollectionMemberships());
            }
            if(state.status == BookCollectionsStatus.loading || state.status == BookCollectionsStatus.submitting){
              return const FullPageLoading();
            }
            if(state.status == BookCollectionsStatus.error){
              return const FullPageError(text: 'Error Loading Collections');
            }
            if(state.collections.isEmpty) {
              return const Center(child: Text('You currently don\'t have any collections to add this book to'));
            }
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: CupertinoScrollbar(
                      child: ListView(
                        children: [
                          for(final membership in state.collections)
                            CollectionMembershipTile(
                              membership: membership,
                              onTap: membership.isUserModifiable ? () {
                                context.read<BookCollectionsBloc>().add(CheckboxToggled(membership.id));
                              } : null
                            )
                        ],
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
                        SubmitButton(
                          text: 'Modify',
                          onTap: () => context.read<BookCollectionsBloc>().add(const SubmitCollectionMemberships()),
                        )
                      ],
                    )
                  ),
                )
              ],
            );
          },
        )
      ),
    );
  }

}