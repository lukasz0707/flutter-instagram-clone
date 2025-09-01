import 'package:envied/envied.dart';

part 'env.stg.g.dart';

/// {@template env}
/// Dev Environment variables. Used to access environment variables in the app.
/// {@endtemplate}
@Envied(path: '.env.stg', obfuscate: true)
abstract class EnvStg {
  /// Supabase url secret.
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static String supabaseUrl = _EnvStg.supabaseUrl;

  /// Supabase anon key secret.
  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static String supabaseAnonKey = _EnvStg.supabaseAnonKey;

  /// PowerSync ulr secret.
  @EnviedField(varName: 'POWERSYNC_URL', obfuscate: true)
  static String powersyncUrl = _EnvStg.powersyncUrl;

  /// Firebase cloud messaging server key secret.
  @EnviedField(varName: 'FCM_SERVER_KEY', obfuscate: true)
  static String fcmServerKey = _EnvStg.fcmServerKey;

  /// iOS client id key secret.
  @EnviedField(varName: 'IOS_CLIENT_ID', obfuscate: true)
  static String iOSClientId = _EnvStg.iOSClientId;

  /// Web client id key secret.
  @EnviedField(varName: 'WEB_CLIENT_ID', obfuscate: true)
  static String webClientId = _EnvStg.webClientId;
}
