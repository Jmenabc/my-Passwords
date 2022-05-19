import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomesScreen extends StatefulWidget {
  const HomesScreen({Key? key}) : super(key: key);

  @override
  State<HomesScreen> createState() => _HomesScreenState();
}

class _HomesScreenState extends State<HomesScreen> {
  bool visible = false;
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
                    margin: const EdgeInsets.all(40),
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
                                  label: Text('Tipo')),
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
          return buildCardInfo(ds);
        });
  }

  Card buildCardInfo(DocumentSnapshot<Object?> ds) {
    return Card(
      child: ExpansionTile(
        title: Text('${ds['website']}'),
        subtitle: Text('${ds['type']}'),
        children: <Widget>[
          const Divider(),
          ListTile(
            leading: Container(
                padding: const EdgeInsets.all(8),
                child: const Tooltip(message:'Usuario',child: Icon(Icons.person_outline_outlined))),
            title: Text('${ds['username']}'),
          ),
          const Divider(),
          ListTile(
            leading: Container(
                padding: const EdgeInsets.all(8),
                child:  const Tooltip(message:'Contraseña',child: Icon(Icons.lock_outline_rounded))),
            title: Text(visible?'${ds['password']}':'*********'),
            trailing: IconButton(onPressed: () {
              setState(() {
                visible = !visible;
              });
            },icon: Icon(!visible ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined)),
          ),
        ],
      ),
    );
  }


}
