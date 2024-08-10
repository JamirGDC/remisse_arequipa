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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              gradienteEndColor, // Reemplazado con la variable global gradienteEndColor
              brandColor, // Reemplazado con la variable global brandColor
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 70, // Tamaño del logo redondeado
                      backgroundColor: neutralColor, // Reemplazado con la variable global neutralColor
                      child: Icon(
                        Icons.local_taxi,
                        size: 50,
                        color: gradienteEndColor, // Reemplazado con la variable global gradienteEndColor
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50), // tamaño del contenedor blanco y logo
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: neutralColor, // Reemplazado con la variable global neutralColor
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
                          color: contrastColor, // Reemplazado con la variable global contrastColor
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
                                ? gradienteEndColor // Reemplazado con la variable global gradienteEndColor
                                : contrastColor, // Reemplazado con la variable global contrastColor
                          ), // Texto cambia según el foco
                          decoration: InputDecoration(
                            labelText: 'Correo Electrónico',
                            labelStyle: TextStyle(
                              color: _emailFocusNode.hasFocus
                                  ? gradienteEndColor // Reemplazado con la variable global gradienteEndColor
                                  : contrastColor, // Reemplazado con la variable global contrastColor
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: gradienteEndColor, // Reemplazado con la variable global gradienteEndColor
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: contrastColor, // Reemplazado con la variable global contrastColor
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
                                ? gradienteEndColor // Reemplazado con la variable global gradienteEndColor
                                : contrastColor, // Reemplazado con la variable global contrastColor
                          ), // Texto cambia según el foco
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(
                              color: _passwordFocusNode.hasFocus
                                  ? gradienteEndColor // Reemplazado con la variable global gradienteEndColor
                                  : contrastColor, // Reemplazado con la variable global contrastColor
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: gradienteEndColor, // Reemplazado con la variable global gradienteEndColor
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: contrastColor, // Reemplazado con la variable global contrastColor
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: _passwordFocusNode.hasFocus
                                    ? gradienteEndColor // Reemplazado con la variable global gradienteEndColor
                                    : contrastColor, // Reemplazado con la variable global contrastColor
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
                          child:const Text(
                            "Olvide mi contraseña",
                            style: TextStyle(color: brandColor), // Reemplazado con la variable global gradienteEndColor
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
                            backgroundColor: brandColor, // Reemplazado con la variable global gradienteEndColor
                          ),
                          child: const Text(
                            'Ingresar',
                            style: TextStyle(color: neutralColor, fontSize: 18), // Reemplazado con la variable global neutralColor
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Añadir un separador con "OR"
                      const Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: mutedColor, // Reemplazado con la variable global mutedColor
                              indent: 30,
                              endIndent: 10,
                            ),
                          ),
                          Text(
                            "OR",
                            style: TextStyle(
                              color: mutedColor, // Reemplazado con la variable global mutedColor
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: mutedColor, // Reemplazado con la variable global mutedColor
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
                              backgroundColor: acentColor, // Reemplazado con la variable global acentColor
                              side: const BorderSide(
                                  color:acentColor),
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
                                  color: neutralColor),
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
                              backgroundColor: contrastColor, // Reemplazado con la variable global contrastColor
                              side: const BorderSide(
                                  color: contrastColor), // Reemplazado con la variable global contrastColor
                              minimumSize: Size(0.4.sw,
                                  0.06.sh), // 40% del ancho y 6% de la altura de la pantalla
                            ),
                            icon: Icon(
                              Icons.apple,
                              size: 24
                                  .w, // Ajusta el tamaño del icono a proporciones relativas
                              color: neutralColor, // Reemplazado con la variable global neutralColor
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
                              color: mutedColor, // Reemplazado con la variable global mutedColor
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
                            child: const Text(
                              'Registrarse',
                              style:TextStyle(
                                color: brandColor, // Reemplazado con la variable global gradienteEndColor
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
