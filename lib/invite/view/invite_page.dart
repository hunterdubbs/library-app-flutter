import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/invite/bloc/invite_bloc.dart';
import 'package:library_app/widgets/widgets.dart';

class InvitePage extends StatelessWidget {
  const InvitePage({Key? key}) : super(key: key);

  static Route<void> route(){
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => InviteBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context)
        ),
        child: const InvitePage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invites'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<InviteBloc, InviteState>(
            listenWhen: (previous, current) => previous.status != current.status && (current.status == InviteStatus.errorModifying || current.status == InviteStatus.error),
            listener: (context, state) {
              ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(state.errorMsg))
                  );
            },
          ),
          BlocListener<InviteBloc, InviteState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if(state.status == InviteStatus.modified){
                context.read<InviteBloc>().add(const LoadInvites());
              }
            },
          )
        ],
        child: BlocBuilder<InviteBloc, InviteState>(
          builder: (context, state) {
            if(state.status == InviteStatus.initial){
              context.read<InviteBloc>().add(const LoadInvites());
            }
            if(state.status == InviteStatus.loading || state.status == InviteStatus.modifying){
              return const FullPageLoading();
            }
            if(state.status == InviteStatus.error){
              return const FullPageError(text: 'Error Loading Invites');
            }
            if(state.invites.isEmpty){
              return const Center(child: Text('No pending invites'));
            }
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: CupertinoScrollbar(
                      child: ListView(
                        children: [
                          for(final invite in state.invites)
                            InviteRecipientTile(
                              invite: invite,
                              onAccept: () {
                                showDialog<bool?>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text('Accept Invite'),
                                        content: Text('Accept invite for the library \'${invite.libraryName}\'?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Cancel')
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text('Accept')
                                          )
                                        ]
                                      )
                                ).then((confirmed) {
                                  if(confirmed != null && confirmed == true){
                                    context.read<InviteBloc>().add(AcceptInvite(invite));
                                  }
                                });
                              },
                              onReject: () {
                                showDialog<bool?>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: const Text('Reject Invite'),
                                            content: Text('Reject invite for the library \'${invite.libraryName}\'?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: const Text('Cancel')
                                              ),
                                              TextButton(
                                                  onPressed: () => Navigator.of(context).pop(true),
                                                  child: const Text('Reject')
                                              )
                                            ]
                                        )
                                ).then((confirmed) {
                                  if(confirmed != null && confirmed == true){
                                    context.read<InviteBloc>().add(RejectInvite(invite));
                                  }
                                });
                              },
                            )
                        ],
                      )
                    ),
                  )
                )
              ],
            );
          },
        )
      )
    );
  }

}