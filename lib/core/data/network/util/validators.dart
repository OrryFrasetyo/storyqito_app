class Validators {
  static String? validateEmail(
    String? value,
    String errorEmpty,
    String errorInvalid,
  ) {
    if (value == null || value.isEmpty) {
      return errorEmpty;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return errorInvalid;
    }
    return null;
  }

  static String? validatePassword(
    String? value,
    String errorEmpty,
    String errorMinLength,
  ) {
    if (value == null || value.isEmpty) {
      return errorEmpty;
    }
    if (value.length < 8) {
      return errorMinLength;
    }
    return null;
  }

  static String? validateRequired(String? value, String errorEmpty) {
    if (value == null || value.isEmpty) {
      return errorEmpty;
    }
    return null;
  }
}
