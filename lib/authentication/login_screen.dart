import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:remisse_arequipa/authentication/signup_screen.dart';
import 'package:remisse_arequipa/global.dart';
import 'package:remisse_arequipa/methods/common_methods.dart';
import 'package:remisse_arequipa/pages/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);
    signInFormValidation();
  }

  signInFormValidation() {
    if (_emailController.text.trim().isEmpty) {
      cMethods.displaysnackbar(
          "Por favor ingrese su correo electrónico", context);
      return;
    } else if (!_emailController.text.contains("@")) {
      cMethods.displaysnackbar(
          "Por favor ingrese su correo electrónico valido", context);
      return;
    } else if (_passwordController.text.isEmpty) {
      cMethods.displaysnackbar("Por favor ingrese su contraseña", context);
      return;
    } else {
      logInUserNow();
    }
  }

  logInUserNow() async {
    try {
      final User? firebaseUser =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ))
              .user;

      if (firebaseUser != null) {
        DatabaseReference ref = FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(firebaseUser.uid);
        await ref.once().then((dataSnapshot) {
          if (dataSnapshot.snapshot.value != null) {
            if ((dataSnapshot.snapshot.value as Map)["blockStatus"] == "no") {
              userName = (dataSnapshot.snapshot.value as Map)["name"];
              userPhone = (dataSnapshot.snapshot.value as Map)["phone"];

              if (mounted) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (c) => const HomePage()));
              }
            } else {
              FirebaseAuth.instance.signOut();
              cMethods.displaysnackbar(
                  "Tu cuenta esta bloqueada. Contacta con administración",
                  context);
            }
          }
        });
      }
    } on FirebaseException catch (e) {
      FirebaseAuth.instance.signOut();
      final errorMessage = e.message.toString();

      if (!mounted) return;

      cMethods.displaysnackbar(errorMessage, context);
    }
  }

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Inicializa ScreenUtil
    ScreenUtil.init(
      context,
      designSize: const Size(360, 690), // Tamaño de diseño base
      minTextAdapt: true,
      splitScreenMode: true,
    );
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange[900] ?? Colors.orange,
              Colors.orange[400] ?? Colors.orange,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 70, // Tamaño del logo redondeado
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.local_taxi,
                        size: 50,
                        color: Colors.orange[900], // Icono de taxi en el logo
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50), // tamaño del contenedor blanco y logo
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        '¡Hola de nuevo!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 400,
                        child: TextField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: _emailFocusNode.hasFocus
                                ? Colors.orange[900]
                                : Colors.black,
                          ), // Texto cambia según el foco
                          decoration: InputDecoration(
                            labelText: 'Correo Electrónico',
                            labelStyle: TextStyle(
                              color: _emailFocusNode.hasFocus
                                  ? Colors.orange[900]
                                  : Colors.black,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: Colors.orange[
                                    900]!, // Color del borde cuando está enfocado
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: Colors
                                    .black, // Color del borde cuando no está enfocado
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 400,
                        child: TextField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          obscureText: _obscureText,
                          style: TextStyle(
                            color: _passwordFocusNode.hasFocus
                                ? Colors.orange[900]
                                : Colors.black,
                          ), // Texto cambia según el foco
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(
                              color: _passwordFocusNode.hasFocus
                                  ? Colors.orange[900]
                                  : Colors.black,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: Colors.orange[
                                    900]!, // Color del borde cuando está enfocado
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: Colors
                                    .black, // Color del borde cuando no está enfocado
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: _passwordFocusNode.hasFocus
                                    ? Colors.orange[900]
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Acción para "Olvide mi contraseña"
                          },
                          child: Text(
                            "Olvide mi contraseña",
                            style: TextStyle(color: Colors.orange[900]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 0),
                      SizedBox(
                        width: 400,
                        child: ElevatedButton(
                          onPressed: () {
                            // Acción al presionar el botón de Ingresar
                            checkIfNetworkIsAvailable();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            backgroundColor: const Color.fromARGB(255, 204, 75, 5),
                          ),
                          child: const Text(
                            'Ingresar',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Añadir un separador con "OR"
                      Row(
                        children: <Widget>[
                          const Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey,
                              indent: 30,
                              endIndent: 10,
                            ),
                          ),
                          Text(
                            "OR",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey,
                              indent: 10,
                              endIndent: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Botones de Google y Apple

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton.icon(
                            onPressed: () {
                              // Acción al presionar el botón de Google
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10
                                    .w, // Cambia el padding horizontal y vertical a porcentajes
                                vertical: 10.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 16, 103, 255),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 15, 153, 233)),
                              minimumSize: Size(0.4.sw,
                                  0.06.sh), // 40% del ancho y 6% de la altura de la pantalla
                            ),
                            icon: Image.asset(
                              'lib/assets/google.png',
                              width: 20
                                  .w, // Ajusta el tamaño del icono a proporciones relativas
                              height: 20.h,
                            ),
                            label: const Text(
                              'Google',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 252, 251, 250)),
                            ),
                          ),
                          SizedBox(
                              width: 10
                                  .w), // Cambia el ancho del SizedBox a un valor relativo
                          ElevatedButton.icon(
                            onPressed: () {
                              // Acción al presionar el botón de Apple
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30
                                    .w, // Cambia el padding horizontal y vertical a porcentajes
                                vertical: 10.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 15, 14, 14),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 7, 7, 7)),
                              minimumSize: Size(0.4.sw,
                                  0.06.sh), // 40% del ancho y 6% de la altura de la pantalla
                            ),
                            icon: Icon(
                              Icons.apple,
                              size: 24
                                  .w, // Ajusta el tamaño del icono a proporciones relativas
                              color: const Color.fromARGB(255, 252, 252, 252),
                            ),
                            label: const Text(
                              'Apple',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 247, 245, 243)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Texto "Don't have an account?" seguido de un botón "Sign Up"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "¿No tienes una cuenta?",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => const SignupScreen()));
                            },
                            child: Text(
                              'Registrarse',
                              style: TextStyle(
                                color: Colors.orange[900],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
