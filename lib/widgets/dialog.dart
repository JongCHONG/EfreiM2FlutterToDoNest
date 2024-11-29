import 'package:flutter/material.dart';
import 'package:todonest/controllers/auth.controller.dart';
import 'package:todonest/models/my_task.dart';
import 'package:todonest/services/task.service.dart';
import 'package:todonest/views/list_task.dart';
import 'package:todonest/validator/validators.dart';

void showEditTaskDialog(BuildContext context, MyTask task,
    TaskService taskService, Function onUpdate) {
  TextEditingController edit = TextEditingController(text: task.title);

  final _formKeyShowEdit = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Modifier la tâche"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKeyShowEdit,
              child: TextFormField(
                controller: edit,
                decoration: InputDecoration(
                  hintText: "Nouveau titre",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: validateTask,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKeyShowEdit.currentState?.validate() ?? false) {
                String newTitle = edit.text.trim();
                await taskService.updateTask(task.id, newTitle);
                onUpdate();
                Navigator.of(context).pop();
              }
            },
            child: const Text("Modifier"),
          )
        ],
      );
    },
  );
}

void showDeleteConfirmationDialog(BuildContext context, String taskId,
    TaskService taskService, Function onDelete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: const Text("Êtes-vous sûr de vouloir supprimer cette tâche ?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await taskService.deleteTask(taskId);
              onDelete();
            },
            child: const Text("Supprimer"),
          )
        ],
      );
    },
  );
}

void showConnexionDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController(text: 'jong@test.com');
  TextEditingController password = TextEditingController(text: 'azerty');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Connexion"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                          hintText: 'Entrer votre email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Entrer votre password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: validatePassword,
                      ),
                    ],
                  )),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    AuthController()
                        .connexion(email.text, password.text)
                        .then((value) {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListTask(),
                        ),
                      );
                    });
                  }
                },
                child: const Text('Envoyer'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Annuler"),
          ),
        ],
      );
    },
  );
}

void showInscriptionDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();

  TextEditingController surname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Inscription"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: surname,
                      decoration: InputDecoration(
                        hintText: 'Entrer votre surnom',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: validateSurname,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        hintText: 'Entrer votre email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Entrer votre mot de passe',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: confirmPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Entrer votre mot de passe de confirmation',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) =>
                          validateEqualsPassword(password.text, value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    AuthController()
                        .inscription(surname.text, email.text, password.text)
                        .then((value) {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListTask(),
                        ),
                      );
                    });
                  }
                },
                child: const Text('Envoyer'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Annuler"),
          ),
        ],
      );
    },
  );
}
