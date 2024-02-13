import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app/data/authentication_api.dart';
import 'package:library_app/data/library_api.dart';
import 'package:library_app/home/view/home_page.dart';
import 'package:library_app/login/view/login_page.dart';
import 'package:library_app/repositories/auth_repository.dart';
import 'package:library_app/repositories/prefs_repository.dart';
import 'package:library_app/splash/view/splash_page.dart';

import 'authentication/bloc/authentication_bloc.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authRepository,
    required this.authenticationApi,
    required this.libraryApi,
    required this.prefsRepository
}) : super(key: key);

  final AuthRepository authRepository;
  final AuthenticationApi authenticationApi;
  final LibraryApi libraryApi;
  final PrefsRepository prefsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: authenticationApi),
        RepositoryProvider.value(value: libraryApi),
        RepositoryProvider.value(value: prefsRepository)
      ],
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
            authenticationApi: authenticationApi
        ),
        child: const AppView(),
      )
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: _navigatorKey,
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 45, 26, 81),
            background: const Color.fromARGB(255, 240, 240, 240)
          )
        ),
        builder: (context, child) {
          return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    _navigator.pushAndRemoveUntil<void>(
                        HomePage.route(),
                            (route) => false
                    );
                    break;
                  case AuthenticationStatus.unauthenticated:
                    _navigator.pushAndRemoveUntil<void>(
                        LoginPage.route(),
                            (route) => false
                    );
                    break;
                  default:
                    break;
                }
              },
              child: child
          );
        },
        onGenerateRoute: (_) => SplashPage.route()
    );
  }
}