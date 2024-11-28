import 'package:todonest/controller/my_firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:todonest/models/my_task.dart';
import 'package:todonest/validator/validators.dart';

class ListTask extends StatefulWidget {
  const ListTask({super.key});

  @override
  State<StatefulWidget> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  final MyFirebaseHelper _firebaseHelper = MyFirebaseHelper();

  void _showEditTaskDialog(MyTask task) {
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
                        hintText: 'Nouveau titre',
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
                      await _firebaseHelper.updateTask(task.id, newTitle);
                      setState(() {});
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Modifier"),
                )
              ]);
        });
  }

  void _showDeleteConfirmationDialog(String taskId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Confirmer la suppression"),
              content: const Text(
                  "Êtes-vous sûr de vouloir supprimer cette tâche ?"),
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
                    _firebaseHelper.deleteTask(taskId).then((_) {
                      setState(() {});
                    });
                  },
                  child: const Text("Supprimer"),
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TodoNest", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: title,
                        decoration: InputDecoration(
                          hintText: 'Entrer le titre de la tâche',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: validateTask,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (title.text.isNotEmpty) {
                                _firebaseHelper.addTask(title.text);
                                title.clear();
                              }
                            }
                          },
                          child: const Text('Envoyer')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder<List<MyTask>>(
                  future: _firebaseHelper.getTasksForCurrentUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Aucune tâche disponible.'));
                    }

                    final tasks = snapshot.data!;

                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return ListTile(
                            title: Text(task.title),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _showEditTaskDialog(task);
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(task.id);
                                    },
                                    icon: const Icon(Icons.delete)),
                              ],
                            ));
                      },
                    );
                  }))
        ],
      ),
    );
  }
}
