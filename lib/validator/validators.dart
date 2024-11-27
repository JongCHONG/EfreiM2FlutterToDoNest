String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer votre email';
  }

  String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regex = RegExp(emailPattern);
  if (!regex.hasMatch(value)) {
    return 'Veuillez entrer un email valide';
  }

  return null;
}

String? validateSurname(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer votre nom';
  }

  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer votre mot de passe';
  }

  if (value.length < 6) {
    return 'Le mot de passe doit contenir au moins 6 caractères';
  }
  return null;
}
