import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:user_app/features/users/data/model/user_model.dart';

class UserSearchProvider extends ChangeNotifier {
  // ───── User List & Filtering ─────
  String _query = '';
  String get query => _query;

  List<UserModel> _allUsers = [];
  List<UserModel> get allUsers => _allUsers;

  List<UserModel> get filteredUsers {
    if (_query.isEmpty) return _allUsers;
    return _allUsers
        .where((u) => u.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  void setUsers(List<UserModel> users) {
    _allUsers = users;
    notifyListeners();
  }

  void updateQuery(String newQuery) {
    _query = newQuery;
    notifyListeners();
  }

  // ───── Voice Search ─────
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool get isListening => _isListening;

  Future<void> toggleVoiceListening() async {
    try {
      // Start Listening
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
              _query = val.recognizedWords;
              notifyListeners(); // update textField + filtered list live
            },
          );
        } else {
          log('Speech not available');
        }
      } else {
        // Stop Listening
        _isListening = false;
        await _speech.stop();
        notifyListeners();
      }
    } catch (e, s) {
      log('Voice search error: $e\n$s');
    }
  }
}
