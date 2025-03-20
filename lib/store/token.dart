import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  dynamic localStorage(String method, String key, {dynamic value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (method == 'get') {
      return prefs.getString(key);
    } else if (method == 'set') {
      await prefs.setString(key, value);
      return 'done';
    } else {
      await prefs.remove(key);
      return 'done';
    }
  }
}
