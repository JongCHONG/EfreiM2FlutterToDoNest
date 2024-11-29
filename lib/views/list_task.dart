import 'package:flutter/material.dart';
import 'package:todonest/controllers/auth.controller.dart';
import 'package:todonest/models/my_task.dart';
import 'package:todonest/services/task.service.dart';
import 'package:todonest/widgets/dialog.dart';
import 'package:todonest/validator/validators.dart';

class ListTask extends StatefulWidget {
  const ListTask({super.key});

  @override
  State<StatefulWidget> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  final taskService = TaskService();

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
                Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(children: [
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
                      ]),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (title.text.isNotEmpty) {
                          await taskService.addTask(title.text);
                          setState(() {});
                          title.clear();
                        }
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
                                      showEditTaskDialog(
                                          context, task, taskService, () {
                                        setState(() {});
                                      });
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      showDeleteConfirmationDialog(
                                          context, task.id, taskService, () {
                                        setState(() {});
                                      });
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
