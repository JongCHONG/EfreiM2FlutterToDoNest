import 'package:todonest/controller/my_firebase_helper.dart';
import 'package:flutter/material.dart';
import '../constante.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<StatefulWidget> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  TextEditingController surname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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
                      'Inscription',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Form(
                    child: Column(
                      children: [
                        TextField(
                          controller: surname,
                          decoration: InputDecoration(
                              hintText: 'Entrer votre surnom',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: email,
                          decoration: InputDecoration(
                              hintText: 'Entrer votre email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: 'Entrer votre password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              MyFirebaseHelper()
                                  .inscription(
                                      surname.text, email.text, password.text)
                                  .then((value) {
                                setState(() {
                                  me = value;
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
