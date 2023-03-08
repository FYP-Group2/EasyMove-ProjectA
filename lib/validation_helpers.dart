String? validatePassword(String? value) {
  if (value != null && value.isEmpty) return 'Please enter your password';
  return null;
}

String? validateConfirmPassword(String? value, String password) {
  if (value != null && value.isEmpty) {
    return 'Please enter confirmation password';
  }
  if (password != value!) return 'Passwords do not match';
  return null;
}

String? validatePhoneNumber(String? value, String label) {
  RegExp regExp = RegExp(r'^\+?[0-9]{10}$');

  if (value != null && value.isEmpty) return 'Please enter your $label';
  if (!regExp.hasMatch(value!)) return 'Please enter a valid $label';
  return null;
}

String? validateStringNotEmpty(String? value, String label) {
  if (value != null && value.isEmpty) return 'Please enter $label';
  return null;
}

// Cannot be empty and contains numbers and special characters
String? validateName(String? value, String label) {
  RegExp regExp = RegExp(r'\d');
  RegExp regExpSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>=\-]');

  if (value != null && value.isEmpty) {
    return 'Please enter $label';
  }
  if (regExp.hasMatch(value!) || regExpSpecial.hasMatch(value)) {
    return 'Name cannot contains number or special characters';
  }
  return null;
}

// Cannot be empty and must have 12 digits
String? validateIcNumber(String? value) {
  RegExp regExp = RegExp(r'^[0-9]{12}$');
  if (value != null && value.isEmpty) return 'Please enter your I.C. number';
  if (!regExp.hasMatch(value!)) return 'Please enter a valid I.C. number';
  return null;
}
