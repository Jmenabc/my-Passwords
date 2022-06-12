import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_passwords/screens/login_screen.dart';

class HomesScreen extends StatefulWidget {
  @override
  State<HomesScreen> createState() => _HomesScreenState();
}

class _HomesScreenState extends State<HomesScreen> {
  //Visible text
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    final key = encrypt.Key.fromUtf8('my 32 length key................');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.Salsa20(key));
    //Firebase
    final uid = FirebaseAuth.instance.currentUser?.uid;
    User? user;
    String website = "";
    String usuario = "";
    String password = "";
    String type = "";
    CollectionReference firestore =
        FirebaseFirestore.instance.collection('$uid');

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
                              decoration:
                                  const InputDecoration(label: Text('Tipo')),
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
          leading: Tooltip(
              message: 'Bienvenido ${user?.displayName ?? "usuario"}',
              child: const Icon(Icons.person)),
          actions: [
            Tooltip(
              message: 'Cerrar sesión',
              child: Container(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut().then((value) =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginScreen())));
                    },
                    icon: const Icon(Icons.logout)),
              ),
            )
          ],
          title: const Text('My passwords'),
          elevation: 0,
          backgroundColor: Colors.blueGrey,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('$uid').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return buildCardContent(snapshot, iv, encrypter);
          },
        ));
  }

  ListView buildCardContent(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
      IV iv,
      encrypt.Encrypter encrypter) {
    return ListView.builder(
        itemCount: snapshot.data?.docs.length,
        itemBuilder: (BuildContext context, int index) {
          DocumentSnapshot ds = snapshot.data!.docs[index];
          return buildCardInfo(ds, iv, encrypter);
        });
  }

  Card buildCardInfo(
      DocumentSnapshot<Object?> ds, IV iv, encrypt.Encrypter encrypt) {
    String pssword = ds['password'];
    return Card(
      child: ExpansionTile(
        title: Text('${ds['website']}'),
        subtitle: Text('${ds['type']}'),
        children: <Widget>[
          const Divider(),
          ListTile(
            leading: Container(
                padding: const EdgeInsets.all(8),
                child: const Tooltip(
                    message: 'Usuario',
                    child: Icon(Icons.person_outline_outlined))),
            title: Text('${ds['username']}'),
          ),
          const Divider(),
          ListTile(
            leading: Container(
                padding: const EdgeInsets.all(8),
                child: const Tooltip(
                    message: 'Contraseña',
                    child: Icon(Icons.lock_outline_rounded))),
            title: Text(visible ? '${ds['password']}' : '*********'),
            trailing: IconButton(
                onPressed: () {
                  setState(() {
                    visible = !visible;
                  });
                },
                icon: Icon(!visible
                    ? Icons.remove_red_eye_outlined
                    : Icons.visibility_off_outlined)),
          ),
        ],
      ),
    );
  }
}
