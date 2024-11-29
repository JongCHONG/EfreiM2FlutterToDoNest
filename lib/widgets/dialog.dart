import 'package:flutter/material.dart';
import 'package:todonest/controllers/auth.controller.dart';
import 'package:todonest/models/my_task.dart';
import 'package:todonest/services/task.service.dart';
import 'package:todonest/views/dashboard.dart';

void showEditTaskDialog(BuildContext context, MyTask task,
    TaskService taskService, Function onUpdate) {
  TextEditingController edit = TextEditingController(text: task.title);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Modifier la tâche"),
        content: TextField(
          controller: edit,
          decoration: const InputDecoration(hintText: "Nouveau titre"),
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
              String newTitle = edit.text.trim();
              if (newTitle.isNotEmpty) {
                await taskService.updateTask(task.id, {'title': newTitle});
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

void showLoginDialog(BuildContext context) {
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
              TextField(
                controller: email,
                decoration: InputDecoration(
                    hintText: 'Entrer votre email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Entrer votre password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  AuthController()
                      .connexion(email.text, password.text)
                      .then((value) {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListTask(userId: value.uid),
                      ),
                    );
                  });
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
  TextEditingController surname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Inscription"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: surname,
                decoration: InputDecoration(
                    hintText: 'Entrer votre surnom',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: email,
                decoration: InputDecoration(
                    hintText: 'Entrer votre email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Entrer votre password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  AuthController()
                      .inscription(surname.text, email.text, password.text)
                      .then((value) {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListTask(userId: value.uid),
                      ),
                    );
                  });
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
