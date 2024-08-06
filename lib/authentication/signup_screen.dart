import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:remisse_arequipa/authentication/login_screen.dart';
import 'package:remisse_arequipa/global.dart';
import 'package:remisse_arequipa/methods/common_methods.dart';
import 'package:remisse_arequipa/pages/home_page.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:remisse_arequipa/widgets/loading_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscureText = true;
  bool _termsAccepted = false;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);
    signUpFormValidation();
  }

  signUpFormValidation() {
    if (_nameController.text.isEmpty) {
      cMethods.displaysnackbar("Por favor ingrese un Nombre", context);
      return;
    } else if (_lastNameController.text.isEmpty) {
      cMethods.displaysnackbar(
          "Por favor ingrese al menos un Apellido", context);
      return;
    } else if (_emailController.text.trim().isEmpty ||
        !_emailController.text.trim().contains("@")) {
      cMethods.displaysnackbar(
          "Por favor ingrese un correo electronico valido", context);
      return;
    } else if (_phoneController.text.trim().isEmpty) {
      cMethods.displaysnackbar(
          "Por favor ingrese un número de teléfono", context);
      return;
    } else if (_passwordController.text.trim().isEmpty ||
        _passwordController.text.trim().length < 6) {
      cMethods.displaysnackbar(
          "Por favor ingrese una contraseña de al menos 6 caracteres", context);
      return;
    } else if (_confirmPasswordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().length < 6) {
      cMethods.displaysnackbar("Por favor repita la contraseña", context);
      return;
    } else if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      cMethods.displaysnackbar("Las contraseñas no coinciden", context);
      return;
    } else if (!_termsAccepted) {
      cMethods.displaysnackbar(
          "Por favor acepte los términos y condiciones", context);
      return;
    } else {
      signUpUserNow();
    }
  }

  signUpUserNow() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => const LoadingDialog(
              messageText: "espere, porfavor...",
            ));
    try {
      final User? firebaseUser = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ).catchError((onError) {
        associateMethods.displaysnackbar(onError.toString(), context);
        throw onError;
      }))
          .user;

      Map userDataMap = {
        "name": _nameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _phoneController.text.trim(),
        "id": firebaseUser!.uid,
        "blockStatus": "no",
      };

      FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(firebaseUser.uid)
          .set(userDataMap);


        if (mounted) {
        associateMethods.displaysnackbar("cuenta creada con exito", context);
        }    
      } on FirebaseException catch (e) {
      FirebaseAuth.instance.signOut();
      final errorMessage = e.message.toString();

      if (!mounted) return;
      Navigator.pop(context);
      cMethods.displaysnackbar(errorMessage, context);
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => const HomePage()));
      

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
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 80, // Tamaño del logo redondeado
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
              const SizedBox(height: 170),
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
                        'Registro',
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
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: _nameFocusNode.hasFocus
                                ? Colors.orange[900]
                                : Colors.black,
                          ), // Texto cambia según el foco
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            labelStyle: TextStyle(
                              color: _nameFocusNode.hasFocus
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
                          controller: _lastNameController,
                          focusNode: _lastNameFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: _lastNameFocusNode.hasFocus
                                ? Colors.orange[900]
                                : Colors.black,
                          ), // Texto cambia según el foco
                          decoration: InputDecoration(
                            labelText: 'Apellidos',
                            labelStyle: TextStyle(
                              color: _lastNameFocusNode.hasFocus
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
                        width: 400, // Establece el ancho máximo a 400 píxeles
                        child: IntlPhoneField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Número de Teléfono',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: Colors.orange[900]!,
                              ),
                            ),
                          ),
                          initialCountryCode: 'PE',
                          onChanged: (phone) {
                            //print(phone.completeNumber);
                          },
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

                      const SizedBox(height: 20),
                      SizedBox(
                        width: 400,
                        child: TextField(
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          obscureText: _obscureText,
                          style: TextStyle(
                            color: _confirmPasswordFocusNode.hasFocus
                                ? Colors.orange[900]
                                : Colors.black,
                          ), // Texto cambia según el foco
                          decoration: InputDecoration(
                            labelText: 'Repetir Contraseña',
                            labelStyle: TextStyle(
                              color: _confirmPasswordFocusNode.hasFocus
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
                                color: _confirmPasswordFocusNode.hasFocus
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value:
                                _termsAccepted, // Esto debe ser una variable booleana en tu clase State
                            onChanged: (bool? value) {
                              setState(() {
                                _termsAccepted = value ?? false;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navega a una pantalla o muestra un diálogo con los términos y condiciones
                            },
                            child: Text(
                              "Aceptar términos y condiciones",
                              style: TextStyle(
                                color: Colors.orange[900],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                            backgroundColor: Colors.orange[900],
                          ),
                          child: const Text(
                            'Registrarse',
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 16, 103, 255),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 15, 153, 233)),
                              minimumSize: const Size(190, 50),
                            ),
                            icon: Image.asset(
                              'lib/assets/google.png',
                              width: 20,
                              height: 20,
                            ),
                            label: const Text(
                              'Google',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 252, 251, 250)),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Acción al presionar el botón de Apple
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 15, 14, 14),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 7, 7, 7)),
                              minimumSize: const Size(190, 50),
                            ),
                            icon: const Icon(
                              Icons.apple,
                              color: Color.fromARGB(255, 252, 252, 252),
                            ),
                            label: const Text(
                              'Apple',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 247, 245, 243)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Texto "Don't have an account?" seguido de un botón "Sign Up"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "¿Ya tienes una cuenta?",
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
                                      builder: (c) => const LoginScreen()));
                            },
                            child: Text(
                              'Ingresa aquí',
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
