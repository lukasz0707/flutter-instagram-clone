import 'dart:async';
import 'dart:developer';

import 'package:app_ui/app_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync_repository/powersync_repository.dart';
import 'package:shared/shared.dart';

typedef AppBuilder = Future<Widget> Function(PowerSyncRepository);

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    logD('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logD('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(
  AppBuilder builder, {
  required AppFlavor appFlavor,
  required FirebaseOptions options,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      setupDi(appFlavor: appFlavor);

      // Check if Firebase is already initialized before calling initializeApp()
      try {
        await Firebase.initializeApp(options: options);
      } on Exception catch (e) {
        // This will catch the 'duplicate-app' error and allow the app to run.
        // Log the error for debugging purposes if needed.
        log('Firebase already initialized: $e');
      }

      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory((await getTemporaryDirectory()).path),
      );

      final powerSyncRepository = PowerSyncRepository(env: appFlavor.getEnv);
      await powerSyncRepository.initialize();

      // lock in portrait orientation
      SystemUiOverlayTheme.setPortraitOrientation();

      runApp(await builder(powerSyncRepository));
    },
    (error, stack) {
      logE(error.toString(), stackTrace: stack);
    },
  );
}
