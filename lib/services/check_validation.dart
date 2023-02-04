bool isValidEmail({required String email}) {
  RegExp regExp = RegExp(r"^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");
  return regExp.hasMatch(email);
}

bool isValidPassword({required String password}) {
  // if (password.length < 8) return false;

  return true;
}
