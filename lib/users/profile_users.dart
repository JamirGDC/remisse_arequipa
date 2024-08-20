import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:remisse_arequipa/global.dart'; // Importación del archivo de colores globales

class ProfileUsers extends StatefulWidget {
  const ProfileUsers({super.key});

  @override
  State<ProfileUsers> createState() => _ProfileUsersState();
}

class _ProfileUsersState extends State<ProfileUsers> {
  bool isEditingBirthday = false;
  bool isEditingEmail = false;
  bool isEditingPhone = false;
  bool isEditingAddress = false;
  bool isEditingDocument = false;

  final TextEditingController birthdayController =
      TextEditingController(text: '16 de mayo, 1986');
  final TextEditingController emailController =
      TextEditingController(text: 'meganfox@example.com');
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController =
      TextEditingController(text: '123 Calle Principal, Ciudad');
  final TextEditingController documentController =
      TextEditingController(text: '12345678');

  String fullPhoneNumber = ''; // Para almacenar el número completo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: brandColor, // Uso del color global brandColor
        title: const Text('Profile Users'),
      ),
      body: Container(
        color: brandColor, // Uso del color global brandColor
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 70.0),
                child: Text(
                  'Megan Fox',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: neutralColor, // Uso del color global neutralColor
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 80,
                backgroundColor: brandColor, // Uso del color global brandColor
                backgroundImage: AssetImage('lib/assets/MeganProfile.jpg'),
              ),
              const SizedBox(height: 70),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: neutralColor, // Uso del color global neutralColor
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          MediaQuery.of(context).size.height * 0.05),
                      topRight: Radius.circular(
                          MediaQuery.of(context).size.height * 0.05),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildEditableListTile(
                            context,
                            'Cumpleaños',
                            Icons.cake,
                            birthdayController,
                            isEditingBirthday,
                            () {
                              setState(() {
                                isEditingBirthday = !isEditingBirthday;
                              });
                            },
                          ),
                          const Divider(color: mutedColor), // Uso del color global mutedColor
                          buildEditableListTile(
                            context,
                            'Correo',
                            Icons.email,
                            emailController,
                            isEditingEmail,
                            () {
                              setState(() {
                                isEditingEmail = !isEditingEmail;
                              });
                            },
                          ),
                          const Divider(color: mutedColor), // Uso del color global mutedColor
                          // Implementación de IntlPhoneField para Teléfono
                          ListTile(
                            leading: const Icon(Icons.phone, color: contrastColor), // Uso del color global contrastColor
                            title: isEditingPhone
                                ? IntlPhoneField(
                                    controller: phoneController,
                                    decoration: InputDecoration(
                                      labelText: 'Número de Teléfono',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(
                                          color: gradienteEndColor, // Uso del color global gradienteEndColor
                                        ),
                                      ),
                                    ),
                                    initialCountryCode: 'PE',
                                    onChanged: (PhoneNumber phone) {
                                      setState(() {
                                        fullPhoneNumber = phone.completeNumber;
                                      });
                                    },
                                  )
                                : Text(fullPhoneNumber.isNotEmpty
                                    ? fullPhoneNumber
                                    : 'Sin número de teléfono',
                                    style: const TextStyle(color: contrastColor)), // Uso del color global contrastColor
                            trailing: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: IconButton(
                                icon: Icon(
                                  isEditingPhone ? Icons.check : Icons.edit,
                                  color: contrastColor, // Uso del color global contrastColor
                                ),
                                onPressed: () {
                                  setState(() {
                                    isEditingPhone = !isEditingPhone;
                                  });
                                },
                              ),
                            ),
                          ),
                          const Divider(color: mutedColor), // Uso del color global mutedColor
                          buildEditableListTile(
                            context,
                            'Domicilio',
                            Icons.home,
                            addressController,
                            isEditingAddress,
                            () {
                              setState(() {
                                isEditingAddress = !isEditingAddress;
                              });
                            },
                          ),
                          const Divider(color: mutedColor), // Uso del color global mutedColor
                          buildEditableListTile(
                            context,
                            'Documento de Identidad',
                            Icons.perm_identity,
                            documentController,
                            isEditingDocument,
                            () {
                              setState(() {
                                isEditingDocument = !isEditingDocument;
                              });
                            },
                          ),
                          const Divider(color: mutedColor), // Uso del color global mutedColor
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditableListTile(
    BuildContext context,
    String title,
    IconData icon,
    TextEditingController controller,
    bool isEditing,
    VoidCallback onEditPressed,
  ) {
    return ListTile(
      leading: Icon(icon, color: contrastColor), // Uso del color global contrastColor
      title: isEditing
          ? Flexible(
              child: TextFormField(
                controller: controller,
                style: const TextStyle(color: contrastColor), // Uso del color global contrastColor
                maxLines: 1, // Limita el número de líneas para evitar desbordamiento
                autofocus: true,
                onFieldSubmitted: (_) {
                  setState(() {
                    isEditing = false;
                  });
                },
              ),
            )
          : Text(controller.text, style: const TextStyle(color: contrastColor)), // Uso del color global contrastColor
      trailing: FittedBox(
        fit: BoxFit.scaleDown,
        child: IconButton(
          icon: Icon(
            isEditing ? Icons.check : Icons.edit,
            color: contrastColor, // Uso del color global contrastColor
          ),
          onPressed: onEditPressed,
        ),
      ),
    );
  }
}
