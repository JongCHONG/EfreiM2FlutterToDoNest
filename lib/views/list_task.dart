import 'package:todonest/controller/my_firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:todonest/models/my_task.dart';

class ListTask extends StatefulWidget {
  const ListTask({super.key});

  @override
  State<StatefulWidget> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  TextEditingController title = TextEditingController();
  final MyFirebaseHelper _firebaseHelper = MyFirebaseHelper();

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
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                      hintText: 'Entrer le titre de la tâche',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      if (title.text.isNotEmpty) {
                        _firebaseHelper.addTask(title.text);
                        title.clear();
                      }
                    },
                    child: const Text('Envoyer')),
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
                        return ListTile(title: Text(task.title));
                      },
                    );
                  }))
        ],
      ),
    );
  }
}
