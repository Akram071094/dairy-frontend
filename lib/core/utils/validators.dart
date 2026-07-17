class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? businessCode(String? value) {
    if (value == null || value.isEmpty) return 'Business code is required';
    if (value.length < 3) return 'Business code must be at least 3 characters';
    if (value.length > 50) return 'Business code must be at most 50 characters';
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value)) {
      return 'Business code must contain only uppercase letters and numbers';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null;
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{7,20}$');
    if (!phoneRegex.hasMatch(value)) return 'Please enter a valid phone number';
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.isEmpty) return null;
    final urlRegex = RegExp(r'^https?://.+');
    if (!urlRegex.hasMatch(value)) return 'Please enter a valid URL starting with http:// or https://';
    return null;
  }

  static String? gst(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length != 15) return 'GST number must be 15 characters';
    return null;
  }

  static String? yearEstablished(String? value) {
    if (value == null || value.isEmpty) return null;
    final year = int.tryParse(value);
    if (year == null) return 'Please enter a valid year';
    if (year < 1900 || year > 2100) return 'Year must be between 1900 and 2100';
    return null;
  }

  static String? numeric(String? value, [String fieldName = 'This field']) {
    if (value == null || value.isEmpty) return null;
    if (double.tryParse(value) == null) return '$fieldName must be a number';
    return null;
  }
}
