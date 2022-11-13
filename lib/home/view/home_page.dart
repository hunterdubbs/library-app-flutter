import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/account/view/account_page.dart';
import 'package:library_app/authentication/bloc/authentication_bloc.dart';
import 'package:library_app/invite/view/invite_page.dart';
import 'package:library_app/library/view/library_page.dart';
import 'package:library_app/widgets/menu_tile.dart';

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
        child: GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          shrinkWrap: true,
          children: <Widget>[
            MenuTile(
              title: 'Libraries',
              icon: CupertinoIcons.book,
              onTap: () => Navigator.of(context).push(LibraryPage.route()),
            ),
            MenuTile(
              title: 'Invites',
              icon: CupertinoIcons.person_2,
              onTap: () => Navigator.of(context).push(InvitePage.route()),
            ),
            MenuTile(
              title: 'Account',
              icon: CupertinoIcons.person,
              onTap: () => Navigator.of(context).push(AccountPage.route()),
            ),
            MenuTile(
              title: 'Logout',
              icon: CupertinoIcons.arrow_left_square,
              onTap: () => context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested()),
            )
          ],
        )
      )
    );
  }
}