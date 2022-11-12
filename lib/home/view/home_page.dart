import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/account/view/account_page.dart';
import 'package:library_app/authentication/bloc/authentication_bloc.dart';
import 'package:library_app/invite/view/invite_page.dart';
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
            const Padding(padding: EdgeInsets.symmetric(vertical: 12)),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(LibraryPage.route());
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)
              ),
              child: const Text('Libraries', style: TextStyle(
                fontSize: 18,
              ),),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12)),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(InvitePage.route());
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)
              ),
              child: const Text('Invites', style: TextStyle(
                fontSize: 18,
              ),),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12)),ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(AccountPage.route());
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)
              ),
              child: const Text('Account', style: TextStyle(
                fontSize: 18,
              ),),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 12)),
            ElevatedButton(
              onPressed: (){
                context
                  .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested());
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)
              ),
              child: const Text('Logout', style: TextStyle(
                fontSize: 18,
              ),),
            )
          ],
        )
      )
    );
  }
}