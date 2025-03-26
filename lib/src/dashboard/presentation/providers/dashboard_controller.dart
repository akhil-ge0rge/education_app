import 'package:education_app/core/common/app/providers/tab_navigator.dart';
import 'package:education_app/core/common/view/persistent_view.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/profile/presentation/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DashboardController extends ChangeNotifier {
  List<int> _indexHistory = [0];
  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => TabNavigator(TabItem(child: const Placeholder())),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(TabItem(child: const Placeholder())),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(TabItem(child: const Placeholder())),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: const ProfileScreen(),
        ),
      ),
      child: const PersistentView(),
    ),
  ];

  List<Widget> get screens => _screens;
  List<int> get indexHistory => _indexHistory;
  int _currentIndex = 3;
  int get currentIndex => _currentIndex;

  void changeCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      _indexHistory.add(index);
      notifyListeners();
    }
  }

  void goBack() {
    if (_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex() {
    _indexHistory = [0];
    _currentIndex = 0;
    notifyListeners();
  }
}
