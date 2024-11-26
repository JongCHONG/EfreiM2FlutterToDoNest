import 'package:todonest/controller/my_firebase_helper.dart';
import 'package:flutter/material.dart';
import '../constante.dart';

class ListTask extends StatefulWidget {
  const ListTask({super.key});

  @override
  State<StatefulWidget> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TodoNest", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'TodoNest',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Form(
                    child: Column(
                      children: [
                        TextField(
                          controller: title,
                          decoration: InputDecoration(
                              hintText: 'Entrer le title de la tâche',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              MyFirebaseHelper()
                                  .addTask(title.text)
                                  .then((value) {
                                setState(() {
                                  task = value;
                                });
                              });
                            },
                            child: const Text('Envoyer'))
                      ],
                    ),
                  )
                ],
              ))),
    );
  }
}
