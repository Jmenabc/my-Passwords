import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_passwords/screens/home_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: FutureBuilder(
            future: _initializeFirebase(),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        buildUpPart(size),
                        buildLoginCube(context, size, snapshot)
                      ],
                    )
                  ],
                ),
              );
            }));
  }

  Padding buildLoginCube(context, Size size, snapshot) {
    String email = "";
    String password = "";
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 100, top: 156, left: 50, right: 50),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(16)),
        width: size.width * 0.9,
        height: size.height * 0.4,
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                    onChanged: (value1) {
                      email = value1;
                    },
                    decoration: const InputDecoration(
                        label: Text('Correo',
                            style: TextStyle(color: Colors.red))))),
            Container(
                padding: const EdgeInsets.all(16),
                child: TextField(
                    onChanged: (value2) {
                      password = value2;
                    },
                    decoration: const InputDecoration(
                        label: Text('Contraseña',
                            style: TextStyle(color: Colors.red))))),
            Container(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    /*user = Register.registerNewUser(
                        email: email, password: password);*/
                    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                    _initializeScreen(context);
                  },
                  child: const Text('Registrarse'),
                )),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Text('Pulsa aqui para iniciar sesión'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Center buildUpPart(Size size) {
    return Center(
      child: Container(
        width: size.width * 1,
        height: size.height * 0.35,
        color: Colors.blue[300],
        child: Container(
            padding: const EdgeInsets.only(top: 64),
            child: const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Registrate',
                  style: TextStyle(fontSize: 32),
                ))),
      ),
    );
  }

  Future<FirebaseApp> _initializeScreen(context,var userM) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomesScreen()),
      );
    }
    return firebaseApp;
  }
}
