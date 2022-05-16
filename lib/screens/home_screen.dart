import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomesScreen extends StatelessWidget {
  const HomesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? website;
    String? usuario;
    String? password;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = <String, dynamic>{

      "website": website,
      "usuario": usuario,
      "password": password
    };
    // final reference = FirebaseFirestore.instance;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return Card(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            onChanged: (value) {
                              website = value;
                            },
                            decoration: const InputDecoration(
                              label: Text('Website'),
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            onChanged: (value) {
                              usuario = value;
                            },
                            decoration:
                                const InputDecoration(label: Text('Usuario')),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: const InputDecoration(
                                label: Text('Contraseña')),
                          )),
                      const Spacer(),
                      Container(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                  onPressed: () {
                                    firestore.collection("users").add(user).then(
                                        (DocumentReference doc) => print(
                                            'DocumentSnapshot added with ID: ${doc.id}'));
                                  },
                                  child: const Text('Aceptar'))))
                    ],
                  ),
                );
              });
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        leading: const Tooltip(
            message: 'Bienvenido Lord Mena', child: Icon(Icons.person)),
        actions: [
          Tooltip(
            message: 'Para añadir contraseñas pulse el mas',
            child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.info_outline_rounded)),
          )
        ],
        title: const Text('My passwords'),
        elevation: 0,
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
