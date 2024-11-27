import 'package:todonest/controller/my_firebase_helper.dart';
import 'package:flutter/material.dart';
import '../constante.dart';
import 'package:todonest/validator/validators.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<StatefulWidget> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final _formKey = GlobalKey<FormState>();

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
                        const SizedBox(
                          height: 10,
                        ),
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
                        const SizedBox(
                          height: 10,
                        ),
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
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                MyFirebaseHelper()
                                    .inscription(
                                        surname.text, email.text, password.text)
                                    .then((value) {
                                  setState(() {
                                    me = value;
                                  });
                                });
                              }
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
