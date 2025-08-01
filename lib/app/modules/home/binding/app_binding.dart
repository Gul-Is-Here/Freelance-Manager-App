import 'package:get/get.dart';
import '../../../../data/services/database_service.dart';
import '../../../../data/services/invoice_service.dart';
import '../../../../data/services/local_storage_service.dart';

class AppBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    // Initialize LocalStorageService first since others might depend on it
    final localStorage = await LocalStorageService().init();
    Get.put(localStorage, permanent: true);

    Get.lazyPut(() => DatabaseService());
    Get.lazyPut(() => InvoiceService());
    // Add other bindings here
  }
}
