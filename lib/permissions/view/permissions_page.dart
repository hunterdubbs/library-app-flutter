import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/data/models/models.dart';
import 'package:library_app/permissions/bloc/permissions_bloc.dart';
import 'package:library_app/user_search/view/user_search_page.dart';
import 'package:library_app/widgets/widgets.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({Key? key}) : super(key: key);

  static Route<void> route({required Library library}){
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => PermissionsBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context),
          library: library
        ),
        child: const PermissionsPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Permissions'),
      ),
      floatingActionButton: BlocBuilder<PermissionsBloc, PermissionsState>(
        buildWhen: (previous, current) => previous.permissions != current.permissions,
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push<bool?>(UserSearchPage.route(library: state.library)).then((refresh) {
                if(refresh != null && refresh == true){
                  Navigator.of(context).pushReplacement(PermissionsPage.route(library: state.library));
                }
              });
            },
            child: const Icon(Icons.add),
          );
        },
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PermissionsBloc, PermissionsState>(
            listenWhen: (previous, current) => previous.status != current.status && current.status == PermissionsStatus.error,
            listener: (context, state) {
              ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(state.errorMsg))
                  );
            },
          )
        ],
        child: BlocBuilder<PermissionsBloc, PermissionsState>(
          builder: (context, state) {
            if(state.status == PermissionsStatus.initial){
              context.read<PermissionsBloc>().add(const LoadPermissions());
            }
            if(state.status == PermissionsStatus.loading || state.status == PermissionsStatus.modifying){
              return const FullPageLoading();
            }
            if(state.status == PermissionsStatus.error){
              return const FullPageError(text: 'Error Loading Library Permissions');
            }
            if(state.permissions.isEmpty){
              return const Center(child: Text('No permissions for this library'));
            }
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: CupertinoScrollbar(
                      child: ListView(
                        children: [
                          for(final permission in state.permissions)
                            LibraryPermissionTile(
                              permission: permission,
                              library: state.library
                            )
                        ],
                      )
                    )
                  ),
                ),
              ],
            );
          },
        )
      )
    );
  }

}