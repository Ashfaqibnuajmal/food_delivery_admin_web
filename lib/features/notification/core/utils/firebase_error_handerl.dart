import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseErrorHandler {
  static String getMessage(dynamic error) {
    // FIREBASE EXCEPTION
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'Permission denied';

        case 'unavailable':
          return 'Server unavailable';

        case 'network-request-failed':
          return 'No internet connection';

        case 'not-found':
          return 'Data not found';

        default:
          return 'Something went wrong';
      }
    }

    // DEFAULT
    return 'Unexpected error occurred';
  }
}
