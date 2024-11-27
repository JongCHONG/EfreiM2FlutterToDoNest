import 'package:flutter/material.dart';
import 'package:todonest/controllers/auth.controller.dart';
import 'package:todonest/models/my_task.dart';
import 'package:todonest/services/task.service.dart';

class ListTask extends StatefulWidget {
  const ListTask({super.key});

  @override
  State<StatefulWidget> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  TextEditingController title = TextEditingController();
  final taskService = TaskService();

  void _showEditTaskDialog(MyTask task) {
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
                      await taskService.updateTask(task.id, newTitle);
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
                    taskService.deleteTask(taskId).then((_) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthController().logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                      hintText: 'Entrer le titre de la tâche',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () async {
                      if (title.text.isNotEmpty) {
                        await taskService.addTask(title.text);
                        setState(() {});
                        title.clear();
                      }
                    },
                    child: const Text('Envoyer')),
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder<List<MyTask>>(
                  future: taskService.getTasksForCurrentUser(),
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
