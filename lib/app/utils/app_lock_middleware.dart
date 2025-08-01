import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../data/services/local_storage_service.dart';

class AppLockMiddleware extends GetMiddleware {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final LocalStorageService _localStorage = Get.put(LocalStorageService());

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    final isLocked = _localStorage.getBool('isBiometricEnabled', false);
    if (isLocked) {
      try {
        final authenticated = await _localAuth.authenticate(
          localizedReason: 'Authenticate to access the app',
        );
        return authenticated ? null : route;
      } catch (e) {
        print('Authentication error: $e');
        return route;
      }
    }
    return null;
  }
}
