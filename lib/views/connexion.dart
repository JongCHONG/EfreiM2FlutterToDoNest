import 'package:todonest/controller/my_firebase_helper.dart';
import 'package:flutter/material.dart';
import '../constante.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
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
                      'Connexion',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Form(
                    child: Column(
                      children: [
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
                                  .connexion(email.text, password.text)
                                  .then((value) {
                                setState(() {
                                  me = value;
                                  print('user connecté');
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
