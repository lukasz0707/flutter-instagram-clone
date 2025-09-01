import 'package:database_client/database_client.dart';
import 'package:env/env.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:flutter_instagram_clone/bootstrap.dart';
import 'package:flutter_instagram_clone/firebase_options_dev.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:shared/shared.dart';
import 'package:supabase_authentication_client/supabase_authentication_client.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  bootstrap(
    (powerSyncRepository) async {
      final iOSClientId = getIt<AppFlavor>().getEnv(Env.iOSClientId);
      final webClientId = getIt<AppFlavor>().getEnv(Env.webClientId);

      final googleSignIn = GoogleSignIn(
        clientId: iOSClientId,
        serverClientId: webClientId,
      );
      final tokenStorage = InMemoryTokenStorage();
      final supabaseAuthenticationClient = SupabaseAuthenticationClient(
        powerSyncRepository: powerSyncRepository,
        tokenStorage: tokenStorage,
        googleSignIn: googleSignIn,
      );

      final powerSyncDatabaseClient = PowerSyncDatabaseClient(
        powerSyncRepository: powerSyncRepository,
      );

      final userRepository = UserRepository(
        databaseClient: powerSyncDatabaseClient,
        authenticationClient: supabaseAuthenticationClient,
      );

      final postsRepository = PostsRepository(
        databaseClient: powerSyncDatabaseClient,
      );

      return App(
        user: await userRepository.user.first,
        userRepository: userRepository,
        postsRepository: postsRepository,
      );
    },
    appFlavor: AppFlavor.development(),
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
