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
    String type = "";
    CollectionReference firestore =
        FirebaseFirestore.instance.collection('users');

    // final reference = FirebaseFirestore.instance;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Card(
                    margin: const EdgeInsets.all(64),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Añadir Cuent@/s'),
                        ),
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
                        Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              onChanged: (type1) {
                                type = type1;
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
                                        "password": password,
                                        "type": type
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
            return buildCardContent(snapshot);
          },
        ));
  }

  ListView buildCardContent(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data?.docs.length,
        itemBuilder: (BuildContext context, int index) {
          DocumentSnapshot ds = snapshot.data!.docs[index];
          // return buildGestureDetector(context, ds);
          return Card(
            child: ExpansionTile(
              title: Text('${ds['website']}'),
              subtitle: Text('${ds['type']}'),
              children: <Widget>[
                const Divider(),
                ListTile(
                  leading: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.person_outline_outlined)),
                  title: Text('Usuario: ${ds['username']}'),
                ),
                const Divider(),
                ListTile(
                  leading: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.lock_outline_rounded)),
                  title: Text('Contraseña: ${ds['password']}'),
                ),
              ],
            ),
          );
        });
  }

  GestureDetector buildGestureDetector(
      BuildContext context, DocumentSnapshot<Object?> ds) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                insetPadding: const EdgeInsets.only(top: 232, bottom: 232),
                content: Column(
                  children: [
                    Container(
                      height: 100,
                      padding: const EdgeInsets.all(16),
                      child: Center(child: Text('Usuario: ${ds['username']}')),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                          child: Tooltip(
                        showDuration: const Duration(seconds: 30),
                        message: 'Contraseña:  ${ds['password']}',
                        child: const Center(child: Icon(Icons.lock_open)),
                      )),
                    )
                  ],
                ),
              );
            });
      },
      child: ShowCard(ds),
    );
  }

  SizedBox ShowCard(DocumentSnapshot<Object?> ds) {
    return SizedBox(
      height: 72,
      child: Card(
        color: Colors.grey,
        elevation: 8,
        child: Center(child: Text(ds['website'])),
      ),
    );
  }
}
