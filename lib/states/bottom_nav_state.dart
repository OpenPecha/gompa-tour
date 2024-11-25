import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final AutoDisposeStateNotifierProvider<BottomNavBarState, int>
    bottomNavProvider = StateNotifierProvider.autoDispose((ref) {
  return BottomNavBarState(0);
});

class BottomNavBarState extends StateNotifier<int> {
  static const String _navIndexPreferenceKey = 'nav_index';

  BottomNavBarState(super.state) {
    _loadNavIndex();
  }

  int get value => state;

  set value(int index) {
    state = index;
    _saveNavIndex();
  }

  Future<void> _loadNavIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final navIndex = prefs.getInt(_navIndexPreferenceKey);
    if (navIndex != null) {
      state = navIndex;
    }
  }

  Future<void> _saveNavIndex() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_navIndexPreferenceKey, state);
  }

  void setAndPersistValue(int index) {
    value = index;
  }
}
