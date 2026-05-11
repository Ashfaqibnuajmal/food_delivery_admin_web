class NotificationValidator {
  // TITLE VALIDATION
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a title';
    }

    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }

    return null;
  }

  // MESSAGE VALIDATION
  static String? validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a message';
    }

    if (value.trim().length < 3) {
      return 'Message must be at least 3 characters';
    }

    return null;
  }
}
