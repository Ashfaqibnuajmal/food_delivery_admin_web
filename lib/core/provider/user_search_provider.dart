import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:user_app/features/users/data/model/user_model.dart';
import 'package:user_app/features/users/data/services/user_services.dart';

class UserSearchProvider extends ChangeNotifier {
  final UserServices userServices;

  UserSearchProvider(this.userServices) {
    _listenUsers(); // ✅ start listening automatically
  }

  // ───── STREAM SUBSCRIPTION ─────
  StreamSubscription<List<UserModel>>? _userSub;

  void _listenUsers() {
    _userSub = userServices.fetchUsers().listen((users) {
      _allUsers = users;
      _applyFilter();
    });
  }

  @override
  void dispose() {
    _userSub?.cancel();
    super.dispose();
  }

  // ───── DATA ─────
  String _query = '';
  String get query => _query;

  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];

  List<UserModel> get filteredUsers => _filteredUsers;

  // ───── FILTER ─────
  void updateQuery(String newQuery) {
    _query = newQuery;
    _applyFilter();
  }

  void _applyFilter() {
    if (_query.isEmpty) {
      _filteredUsers = _allUsers;
    } else {
      final q = _query.toLowerCase();
      _filteredUsers = _allUsers.where((user) {
        return user.name.toLowerCase().contains(q) ||
            user.email.toLowerCase().contains(q) ||
            user.phone.contains(q);
      }).toList();
    }

    notifyListeners();
  }

  // ───── VOICE SEARCH ─────
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool get isListening => _isListening;

  Future<void> toggleVoiceListening() async {
    try {
      if (!_isListening) {
        bool available = await _speech.initialize(
          onStatus: (val) => log('Speech status: $val'),
          onError: (val) => log('Speech error: $val'),
        );

        if (available) {
          _isListening = true;
          notifyListeners();

          await _speech.listen(
            onResult: (val) {
              updateQuery(val.recognizedWords);
            },
          );
        }
      } else {
        _isListening = false;
        await _speech.stop();
        notifyListeners();
      }
    } catch (e, s) {
      log('Voice search error: $e\n$s');
    }
  }
}
