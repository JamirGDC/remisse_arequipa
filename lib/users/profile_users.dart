import 'package:flutter/material.dart';

class ProfileUsers extends StatefulWidget {
  const ProfileUsers({Key? key}) : super(key: key);

  @override
  _ProfileUsersState createState() => _ProfileUsersState();
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
  final TextEditingController phoneController =
      TextEditingController(text: '+1 234 567 890');
  final TextEditingController addressController =
      TextEditingController(text: '123 Calle Principal, Ciudad');
  final TextEditingController documentController =
      TextEditingController(text: '12345678');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Users'),
      ),
      body: Container(
        color: Colors.orange, // Fondo naranja para todo el body
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Megan Fox',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto en blanco para contrastar con el fondo naranja
                ),
              ),
              const SizedBox(height: 16),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.orange, // Fondo naranja para el avatar
                backgroundImage: AssetImage('lib/assets/MeganProfile.jpg'),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white, // Fondo blanco para el contenedor
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          MediaQuery.of(context).size.height * 0.05),
                      topRight: Radius.circular(
                          MediaQuery.of(context).size.height * 0.05),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
                          const Divider(color: Colors.grey),
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
                          const Divider(color: Colors.grey),
                          buildEditableListTile(
                            context,
                            'Teléfono',
                            Icons.phone,
                            phoneController,
                            isEditingPhone,
                            () {
                              setState(() {
                                isEditingPhone = !isEditingPhone;
                              });
                            },
                          ),
                          const Divider(color: Colors.grey),
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
                          const Divider(color: Colors.grey),
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
                          const Divider(color: Colors.grey),
                          // Agrega más secciones si es necesario...
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
      leading: Icon(icon, color: Colors.black),
      title: isEditing
          ? Flexible(
              child: TextFormField(
                controller: controller,
                style: const TextStyle(color: Colors.black),
                maxLines: 1, // Limita el número de líneas para evitar desbordamiento
                autofocus: true,
                onFieldSubmitted: (_) {
                  setState(() {
                    isEditing = false;
                  });
                },
              ),
            )
          : Text(controller.text, style: const TextStyle(color: Colors.black)),
      trailing: FittedBox(
        fit: BoxFit.scaleDown,
        child: IconButton(
          icon: Icon(
            isEditing ? Icons.check : Icons.edit,
            color: Colors.black,
          ),
          onPressed: onEditPressed,
        ),
      ),
    );
  }
}






