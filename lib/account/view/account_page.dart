import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/account/bloc/account_bloc.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/register/view/register_page.dart';
import 'package:library_app/widgets/widgets.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  static Route<void> route(){
    return MaterialPageRoute<void>(
      builder: (context) => BlocProvider(
        create: (context) => AccountBloc(
          libraryApi: RepositoryProvider.of<LibraryApi>(context)
        ),
        child: const AccountPage(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account')
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AccountBloc, AccountState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              if(state.status == AccountStatus.errorLoading){
                ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(state.errorMsg))
                    );
              }
            },
          )
        ],
        child: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if(state.status == AccountStatus.initial) {
              context.read<AccountBloc>().add(const LoadAccount());
            }
            if(state.status == AccountStatus.loading){
              return const FullPageLoading();
            }
            if(state.status == AccountStatus.errorLoading){
              return const FullPageError(text: 'Error Loading Account');
            }
            return Column(
              children: [
                Expanded(
                  child: CupertinoScrollbar(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        InfoRow(category: 'Username', contents: state.accountInfo.username),
                        InfoRow(category: 'Email', contents: state.accountInfo.email)
                      ],
                    )
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: SubmitButton(
                      text: 'Delete Account',
                      onTap: () => Navigator.of(context).push(RegisterPage.route()),
                    )
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