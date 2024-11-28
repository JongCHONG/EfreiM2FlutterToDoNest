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

  if (value.length < 3) {
    return 'Votre nom doit contenir au moins 3 caractères';
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

String? validateTask(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer une tâche';
  }

  if (value.length < 4) {
    return 'la tâche doit contenir au moins 4 caractères';
  }
  return null;
}
