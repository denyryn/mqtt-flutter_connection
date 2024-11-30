import 'package:shared_preferences/shared_preferences.dart';
import '../models/debug_model.dart';

class DebugRefRepository {
  final SharedPreferences _prefs;

  DebugRefRepository(this._prefs);

  Future<void> saveDebug(DebugModel debug) async {
    await _prefs.setString('topic', debug.topic);
    await _prefs.setString('name', debug.name ?? '');
    await _prefs.setBool('state', debug.state);
  }

  DebugModel loadDebug() {
    final topic = _prefs.getString('topic') ?? '';
    final name = _prefs.getString('name') ?? '';
    final state = _prefs.getBool('state') ?? false;
    print("debug: $topic, name: $name, state: $state");
    return DebugModel(topic: topic, name: name, state: state);
  }

  Future<void> updateDebug(DebugModel debug) async {
    final currentDebug = loadDebug();

    final updatedDebug = DebugModel(
        topic: debug.topic, // ?? currentDebug.topic,
        name: debug.name ?? currentDebug.name,
        state: debug.state //?? currentDebug.state,
        );

    await saveDebug(updatedDebug);
  }

  Future<void> clearDebug() async {
    await _prefs.remove('topic');
    await _prefs.remove('name');
  }
}
