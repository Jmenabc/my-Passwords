import 'package:encrypt/encrypt.dart';
import 'package:encryptor/encryptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_passwords/screens/create_password.dart';
import 'package:my_passwords/screens/login_screen.dart';

class HomesScreen extends StatefulWidget {
  @override
  State<HomesScreen> createState() => _HomesScreenState();
}

class _HomesScreenState extends State<HomesScreen> {
  //Visible text
  bool visible = false;
  var key = 'Key to encrypt and decrpyt the plain text';
  @override
  Widget build(BuildContext context) {
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreatePassword()),
            );
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
            return buildCardContent(snapshot);
          },
        ));
  }

  ListView buildCardContent(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
      ) {
    return ListView.builder(
        itemCount: snapshot.data?.docs.length,
        itemBuilder: (BuildContext context, int index) {
          DocumentSnapshot ds = snapshot.data!.docs[index];
          return buildCardInfo(ds);
        });
  }

  Card buildCardInfo(
      DocumentSnapshot<Object?> ds) {
    String pssword = ds['password'];
    var decrypted = Encryptor.decrypt(key, pssword);
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
            title: Text(visible ? '${decrypted}' : '*********'),
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
