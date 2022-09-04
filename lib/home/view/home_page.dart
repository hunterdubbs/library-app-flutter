import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/authentication/bloc/authentication_bloc.dart';
import 'package:library_app/library/view/library_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Builder(
              builder: (context) {
                final userId = context.select(
                    (AuthenticationBloc bloc) => bloc.state.status
                );
                return Text('UserID: $userId');
              }
            ),
            ElevatedButton(
              child: const Text('Libraries'),
              onPressed: () {
                Navigator.of(context).push(LibraryPage.route());
              },
            ),
            ElevatedButton(
              child: const Text('Logout'),
              onPressed: (){
                context
                  .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested());
              },
            )
          ],
        )
      )
    );
  }
}