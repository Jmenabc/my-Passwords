import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_passwords/screens/home_screen.dart';
import 'package:my_passwords/screens/login_screen.dart';

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
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
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
                child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        label: Text('Correo',
                            style: TextStyle(color: Colors.red))))),
            Container(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                        label: Text('Contraseña',
                            style: TextStyle(color: Colors.red))))),
            Container(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                    child: const Text('Register'),
                    onPressed: () {
                      try {
                        final user = FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text)
                            .then((value) => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomesScreen()),
                                ));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    })),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Text('Pulsa aqui para Loguearse'),
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
}