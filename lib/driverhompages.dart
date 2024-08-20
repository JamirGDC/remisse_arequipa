import 'package:flutter/material.dart';
import 'package:remisse_arequipa/global.dart'; // Asegúrate de importar los colores globales
import 'package:remisse_arequipa/pages/checklist/checklistpage.dart'; // Importa la página del formulario

class DriverHomePage extends StatefulWidget {
  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  final String driverName = "Juan";
  bool isFichado = false; // Estado del switch

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Buenos días";
    } else if (hour < 18) {
      return "Buenas tardes";
    } else {
      return "Buenas noches";
    }
  }

  String getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${now.day} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final String today = getFormattedDate();

    return Scaffold(
      backgroundColor: neutralColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${getGreeting()}, $driverName',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: contrastColor,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Hoy, $today',
              style: const TextStyle(
                fontSize: 18.0,
                color: mutedColor,
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(
                color: neutralColor,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.access_time, color: brandColor),
                      SizedBox(width: 8.0),
                      Text(
                        '0h 00m',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: contrastColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Hoy',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: contrastColor,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isFichado ? 'Fichado' : 'Desfichado',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: contrastColor,
                        ),
                      ),
                      Transform.scale(
                        scale: 1.5,  // Escala el switch para hacerlo más grande
                        child: Switch(
                          value: isFichado,
                          onChanged: (bool value) {
                            setState(() {
                              isFichado = value;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isFichado
                                    ? 'Fichado con éxito'
                                    : 'Desfichado con éxito'),
                                backgroundColor: acentColor,
                              ),
                            );
                          },
                          activeColor: gradienteEndColor,
                          inactiveThumbColor: mutedColor,
                          inactiveTrackColor: mutedColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Última vez que se rellenó el formulario:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: contrastColor,
              ),
            ),
            const SizedBox(height: 4.0),
            const Text(
              'Fecha: 29-03-2024 Hora: 15:00 h',
              style: TextStyle(
                fontSize: 16.0,
                color: mutedColor,
              ),
            ),
            const SizedBox(height: 0.1),
            Expanded(
  child: ClipRRect(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    ),
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white, // Cambia el color si es necesario
      ),
      child: ChecklistPage(), // Aquí se muestra el formulario de ChecklistPage
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}


