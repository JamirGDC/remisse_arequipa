import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:remisse_arequipa/authentication/login_screen.dart';
import 'package:remisse_arequipa/global.dart';
import 'package:remisse_arequipa/methods/common_methods.dart';
import 'package:remisse_arequipa/pages/home_page.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:remisse_arequipa/widgets/loading_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final TextEditingController _confirmPasswordController = TextEditingController();
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
      cMethods.displaysnackbar("Por favor ingrese al menos un Apellido", context);
      return;
    } else if (_emailController.text.trim().isEmpty || !_emailController.text.trim().contains("@")) {
      cMethods.displaysnackbar("Por favor ingrese un correo electronico valido", context);
      return;
    } else if (_phoneController.text.trim().isEmpty) {
      cMethods.displaysnackbar("Por favor ingrese un número de teléfono", context);
      return;
    } else if (_passwordController.text.trim().isEmpty || _passwordController.text.trim().length < 6) {
      cMethods.displaysnackbar("Por favor ingrese una contraseña de al menos 6 caracteres", context);
      return;
    } else if (_confirmPasswordController.text.trim().isEmpty || _confirmPasswordController.text.trim().length < 6) {
      cMethods.displaysnackbar("Por favor repita la contraseña", context);
      return;
    } else if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      cMethods.displaysnackbar("Las contraseñas no coinciden", context);
      return;
    } else if (!_termsAccepted) {
      cMethods.displaysnackbar("Por favor acepte los términos y condiciones", context);
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
      final User? firebaseUser = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ).catchError((onError) {
        cMethods.displaysnackbar(onError.toString(), context);
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
        cMethods.displaysnackbar("cuenta creada con exito", context);
      }
    } on FirebaseException catch (e) {
      FirebaseAuth.instance.signOut();
      final errorMessage = e.message.toString();

      if (!mounted) return;
      Navigator.pop(context);
      cMethods.displaysnackbar(errorMessage, context);
      Navigator.push(context, MaterialPageRoute(builder: (c) => const HomePage()));
    }
  }

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() {
      setState(() {});
    });
    _lastNameFocusNode.addListener(() {
      setState(() {});
    });
    _emailFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
    _confirmPasswordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
              brandColor, // Reemplazado con la variable global brandColor
              gradienteEndColor, // Reemplazado con la variable global gradienteEndColor
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 80),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 80, // Tamaño del logo redondeado
                      backgroundColor: neutralColor, // Reemplazado con la variable global neutralColor
                      child: Icon(
                        Icons.local_taxi,
                        size: 50,
                        color: brandColor, // Reemplazado con la variable global brandColor
                      ),
                    ),
                  ],
                ),
              ),
               SizedBox(height: 30.h),
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
                        'Registro',
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
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          style: TextStyle(
                            color: _nameFocusNode.hasFocus
                                ? brandColor // Reemplazado con la variable global brandColor
                                : contrastColor, // Reemplazado con la variable global contrastColor
                          ), // Texto cambia según el foco
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            labelStyle: TextStyle(
                              color: _nameFocusNode.hasFocus
                                  ? brandColor // Reemplazado con la variable global brandColor
                                  : contrastColor, // Reemplazado con la variable global contrastColor
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: brandColor, // Reemplazado con la variable global brandColor
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
                          controller: _lastNameController,
                          focusNode: _lastNameFocusNode,
                          style: TextStyle(
                            color: _lastNameFocusNode.hasFocus
                                ? brandColor // Reemplazado con la variable global brandColor
                                : contrastColor, // Reemplazado con la variable global contrastColor
                          ), // Texto cambia según el foco
                          decoration: InputDecoration(
                            labelText: 'Apellidos',
                            labelStyle: TextStyle(
                              color: _lastNameFocusNode.hasFocus
                                  ? brandColor // Reemplazado con la variable global brandColor
                                  : contrastColor, // Reemplazado con la variable global contrastColor
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: brandColor, // Reemplazado con la variable global brandColor
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
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: _emailFocusNode.hasFocus
                                ? brandColor // Reemplazado con la variable global brandColor
                                : contrastColor, // Reemplazado con la variable global contrastColor
                          ), // Texto cambia según el foco
                          decoration: InputDecoration(
                            labelText: 'Correo Electrónico',
                            labelStyle: TextStyle(
                              color: _emailFocusNode.hasFocus
                                  ? brandColor // Reemplazado con la variable global brandColor
                                  : contrastColor, // Reemplazado con la variable global contrastColor
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: brandColor, // Reemplazado con la variable global brandColor
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
                              borderSide: const BorderSide(
                                color: brandColor, // Reemplazado con la variable global brandColor
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
                                ? brandColor // Reemplazado con la variable global brandColor
                                : contrastColor, // Reemplazado con la variable global contrastColor
                          ), // Texto cambia según el foco
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(
                              color: _passwordFocusNode.hasFocus
                                  ? brandColor // Reemplazado con la variable global brandColor
                                  : contrastColor, // Reemplazado con la variable global contrastColor
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: brandColor, // Reemplazado con la variable global brandColor
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
                                    ? brandColor // Reemplazado con la variable global brandColor
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
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 400,
                        child: TextField(
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          obscureText: _obscureText,
                          style: TextStyle(
                            color: _confirmPasswordFocusNode.hasFocus
                                ? brandColor // Reemplazado con la variable global brandColor
                                : contrastColor, // Reemplazado con la variable global contrastColor
                          ), // Texto cambia según el foco
                          decoration: InputDecoration(
                            labelText: 'Repetir Contraseña',
                            labelStyle: TextStyle(
                              color: _confirmPasswordFocusNode.hasFocus
                                  ? brandColor // Reemplazado con la variable global brandColor
                                  : contrastColor, // Reemplazado con la variable global contrastColor
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: brandColor, // Reemplazado con la variable global brandColor
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
                                color: _confirmPasswordFocusNode.hasFocus
                                    ? brandColor // Reemplazado con la variable global brandColor
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
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _termsAccepted,
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
                            child: const Text(
                              "Aceptar términos y condiciones",
                              style: TextStyle(
                                color: brandColor, // Reemplazado con la variable global brandColor
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
                            backgroundColor: brandColor, // Reemplazado con la variable global brandColor
                          ),
                          child: const Text(
                            'Registrarse',
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
                            "¿Ya tienes una cuenta?",
                            style: TextStyle(
                              color: mutedColor, // Reemplazado con la variable global mutedColor
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginScreen()));
                            },
                            child: const Text(
                              'Ingresa aquí',
                              style: TextStyle(
                                color: brandColor, // Reemplazado con la variable global brandColor
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
