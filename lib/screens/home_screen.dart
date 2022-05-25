import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:my_passwords/screens/user_screen.dart';

class HomesScreen extends StatefulWidget {
  const HomesScreen({Key? key}) : super(key: key);

  @override
  State<HomesScreen> createState() => _HomesScreenState();
}

class _HomesScreenState extends State<HomesScreen> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
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
        bottomNavigationBar: GNav(
          tabMargin: const EdgeInsets.all(8),
            rippleColor: Colors.grey,
            // tab button ripple color when pressed
            hoverColor: Colors.grey,
            // tab button hover color
            haptic: true,
            // haptic feedback
            tabBorderRadius: 15,
            tabActiveBorder: Border.all(color: Colors.black, width: 1),
            // tab button border
            tabBorder: Border.all(color: Colors.grey, width: 1),
            // tab button border
            tabShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)
            ],
            // tab button shadow
            curve: Curves.easeOutExpo,
            // tab animation curves
            duration: const Duration(milliseconds: 900),
            // tab animation duration
            gap: 8,
            // the tab button gap between icon and text
            color: Colors.grey[800],
            // unselected icon color
            activeColor: Colors.purple,
            // selected icon and text color
            iconSize: 24,
            // tab button icon size
            tabBackgroundColor: Colors.purple.withOpacity(0.1),
            // selected tab background color
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            // navigation bar padding
            tabs: [
              GButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const HomesScreen()),
                  );
                },
                icon: Icons.home,
                text: 'Passwords',
              ),
              GButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const UserScreen()),
                  );
                },
                icon: Icons.person,
                text: 'User',
              ),
            ]),
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
          leading:  Tooltip(
              message: 'Bienvenido ${user?.displayName ?? "usuario"}', child: const Icon(Icons.person)),
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
