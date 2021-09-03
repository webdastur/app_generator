import 'package:mustache_template/mustache.dart';

class GetXTemplate {
  static const String _CONTROLLER = '''
import 'package:get/get.dart';

class {{name}} extends GetxController {
  static {{name}} get to => Get.find<{{name}}>();

  @override
  void onInit() {
    // TODO: init
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: close
    super.onClose();
  }
}
  ''';

  static String renderString(Map<String, String> data) {
    var template = Template(_CONTROLLER);
    return template.renderString(data);
  }
}
