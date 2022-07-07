import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptor/encryptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreatePassword extends StatelessWidget {
  const CreatePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool visible = false;
    var key = 'Key to encrypt and decrpyt the plain text';
    //Firebase
    final uid = FirebaseAuth.instance.currentUser?.uid;
    User? user;
    String website = "";
    String usuario = "";
    String password = "";
    String type = "";
    CollectionReference firestore =
        FirebaseFirestore.instance.collection('$uid');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: const Icon(Icons.account_box),
        title: const Text('Añadir Cuenta'),
      ),
      body: ListView(children: [
        Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (website1) {
                website = website1;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.web),
                label: Text('Website'),
              ),
            )),
        Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (type1) {
                type = type1;
              },
              decoration: const InputDecoration(
                label: Text('Tipo'),
                icon: Icon(Icons.merge_type),
                border: OutlineInputBorder(),
              ),
            )),
        Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (usuario1) {
                usuario = usuario1;
              },
              decoration: const InputDecoration(
                label: Text('Usuario'),
                icon: Icon(Icons.person_outline_outlined),
                border: OutlineInputBorder(),
              ),
            )),
        Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (password1) {
                var encrypted = Encryptor.encrypt(key, password1);
                password = encrypted;
              },
              decoration: const InputDecoration(
                label: Text('Contraseña'),
                icon: Icon(Icons.password),
                border: OutlineInputBorder(),
              ),
            )),
        const Spacer(),
        const Padding(padding: EdgeInsets.symmetric(vertical: 88)),
        Container(
            padding: const EdgeInsets.all(8),
            child: Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () async {
                      await firestore.add({
                        "website": website,
                        "username": usuario,
                        "password": password,
                        "type": type
                      }).then((value) => print("Cuenta añadida"));

                      Navigator.pop(context);
                    },
                    child: const Text('Aceptar'))))
      ]),
    );
  }
}
