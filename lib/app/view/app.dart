import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:flutter_instagram_clone/selector/selector.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:user_repository/user_repository.dart';

/// Key to access the [AppSnackbarState] from the [BuildContext].
final snackbarKey = GlobalKey<AppSnackbarState>();

/// Key to access the [AppLoadingIndeterminateState] from the
/// [BuildContext].
final loadingIndeterminateKey = GlobalKey<AppLoadingIndeterminateState>();

class App extends StatelessWidget {
  const App({
    required this.userRepository,
    required this.user,
    required this.postsRepository,
    super.key,
  });

  final User user;
  final UserRepository userRepository;
  final PostsRepository postsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: userRepository,
        ),
        RepositoryProvider.value(value: postsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AppBloc(user: user, userRepository: userRepository),
          ),
          BlocProvider(
            create: (context) => LocaleBloc(),
          ),
          BlocProvider(
            create: (context) => ThemeModeBloc(),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

/// Snack bar to show messages to the user.
void openSnackbar(
  SnackbarMessage message, {
  bool clearIfQueue = false,
  bool undismissable = false,
}) {
  snackbarKey.currentState?.post(
    message,
    clearIfQueue: clearIfQueue,
    undismissable: undismissable,
  );
}

/// Closes all snack bars.
void closeSnackbars() => snackbarKey.currentState?.closeAll();
