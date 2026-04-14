// ============================================================
// controllers/user_controller.dart
// ============================================================

import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/repository/user_repository.dart';
import '../utils/logger.dart';

enum UserState { initial, loading, success, error }

class UserController extends ChangeNotifier {
  final UserRepository _repository;

  UserController({UserRepository? repository})
      : _repository = repository ?? UserRepository();

  // ── State ────────────────────────────────────────────────
  UserState _state = UserState.initial;
  List<UserModel> _users = [];
  List<UserModel> _filtered = [];
  String _errorMessage = '';
  String _searchQuery = '';

  // ── Getters ──────────────────────────────────────────────
  UserState get state => _state;
  List<UserModel> get users => _filtered;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == UserState.loading;

  // ── Actions ──────────────────────────────────────────────

  /// Gọi API lấy danh sách user
  Future<void> loadUsers() async {
    _state = UserState.loading;
    notifyListeners();

    try {
      _users = await _repository.fetchUsers();
      _applyFilter();
      _state = UserState.success;
      AppLogger.info('UserController: loaded ${_users.length} users');
    } catch (e) {
      _errorMessage = e.toString();
      _state = UserState.error;
      AppLogger.error('UserController: load failed', e);
    }

    notifyListeners();
  }

  /// Tìm kiếm theo tên hoặc email
  void search(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filtered = List.from(_users);
    } else {
      _filtered = _users.where((u) {
        return u.name.toLowerCase().contains(_searchQuery) ||
            u.email.toLowerCase().contains(_searchQuery);
      }).toList();
    }
  }
}