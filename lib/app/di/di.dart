import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

final GetIt getIt = GetIt.instance;

void setupDi({required AppFlavor appFlavor}) {
  getIt.registerSingleton(appFlavor);
}
