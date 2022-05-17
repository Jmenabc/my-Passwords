import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomesScreen extends StatefulWidget {
  const HomesScreen({Key? key}) : super(key: key);

  @override
  State<HomesScreen> createState() => _HomesScreenState();
}

class _HomesScreenState extends State<HomesScreen> {
  @override
  Widget build(BuildContext context) {
    String website = "";
    String usuario = "";
    String password = "";
    CollectionReference firestore =
        FirebaseFirestore.instance.collection('users');
    final data = firestore.get();

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
                              onChanged: (website1) {
                                website = website1;
                              },
                              decoration: const InputDecoration(
                                label: Text('Website'),
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              onChanged: (usuario1) {
                                usuario = usuario1;
                              },
                              decoration:
                                  const InputDecoration(label: Text('Usuario')),
                            )),
                        Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              onChanged: (password1) {
                                password = password1;
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
                                    onPressed: () async {
                                      await firestore.add({
                                        "website": website,
                                        "username": usuario,
                                        "password": password
                                      }).then(
                                          (value) => print("Cuenta añadida"));
                                      Navigator.pop(context);
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
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(ds['username']),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(ds['password']),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: SizedBox(
                      height: 200,
                      child: Card(
                        child: Text(ds['website']),
                      ),
                    ),
                  );
                });
          },
        ));
  }
}
