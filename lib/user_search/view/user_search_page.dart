import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/user_search/bloc/user_search_bloc.dart';
import 'package:library_app/user_search/models/models.dart';
import 'package:library_app/widgets/widgets.dart';

class UserSearchPage extends StatelessWidget {
  const UserSearchPage({Key? key}) : super(key: key);

  static Route<bool?> route({required Library library}){
    return MaterialPageRoute<bool?>(
      builder: (context) => BlocProvider(
        create: (context) => UserSearchBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context),
          library: library
        ),
        child: const UserSearchPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Search'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<UserSearchBloc, UserSearchState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if(state.status == FormzStatus.submissionFailure){
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                      const SnackBar(content: Text('Error searching users'))
                  );
              }
            },
          ),
          BlocListener<UserSearchBloc, UserSearchState>(
            listenWhen: (previous, current) => previous.selectionStatus != current.selectionStatus,
            listener: (context, state) {
              if(state.selectionStatus == UserSearchStatus.error){
                ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(state.errorMsg))
                    );
              }
              if(state.selectionStatus == UserSearchStatus.success){
                Navigator.of(context).pop(true);
              }
            },
          )
        ],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: _QueryInput()
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
                        context.read<UserSearchBloc>().add(const QuerySubmitted());
                      },
                    ),
                  )
                ],
              ),
            ),
            BlocBuilder<UserSearchBloc, UserSearchState>(
              buildWhen: (previous, current) => previous.status != current.status || previous.results != current.results || previous.selectionStatus != current.selectionStatus,
              builder: (context, state) {
                if(state.status == FormzStatus.pure){
                  return const Expanded(child: Center(child: Text('Search for a user to invite to your library.')));
                }
                if(state.status == FormzStatus.submissionInProgress || state.selectionStatus == UserSearchStatus.working){
                  return const FullPageLoading();
                }
                if(state.status == FormzStatus.submissionFailure){
                  return const FullPageError(text: 'Error loading users');
                }
                if(state.results.isEmpty){
                  return const Expanded(child: Center(child: Text('No results found')));
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CupertinoScrollbar(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for(final user in state.results)
                          UserTile(
                            user: user,
                            onTap: () {
                              showDialog<int?>(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    title: const Text('Invite User as'),
                                    children: [
                                      SimpleDialogOption(
                                        onPressed: () => Navigator.of(context).pop(1),
                                        child: const Text('View Only')
                                      ),
                                      SimpleDialogOption(
                                        onPressed: () => Navigator.of(context).pop(2),
                                        child: const Text('Editor')
                                      )
                                    ],
                                  );
                                }
                              ).then((permissionLevel) {
                                if(permissionLevel != null){
                                  context.read<UserSearchBloc>().add(InviteUser(user, permissionLevel));
                                }
                              });
                            }
                          )
                      ],
                    ),
                  ),
                );
              }
            )
          ],
        )
      )
    );
  }
}

class _QueryInput extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSearchBloc, UserSearchState>(
        buildWhen: (previous, current) => previous.query != current.query,
        builder: (context, state) {
          return TextField(
            onChanged: (query) => EasyDebounce.debounce('user_search_query', const Duration(milliseconds: 500), () => context.read<UserSearchBloc>().add(QueryChanged(query))),
            decoration: InputDecoration(
                hintText: 'Search by username',
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