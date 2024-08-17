import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChecklistPage extends StatefulWidget {
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final DatabaseReference _questionsRef = FirebaseDatabase.instance.ref().child('questions');
  final Map<String, String> _responses = {}; // Usando String para almacenar las respuestas seleccionadas
  List<Map<String, dynamic>> _questions = [];
  final List<String> _options = ['Bien', 'Mal', 'N/A', 'Sí', 'No']; // Opciones del checklist
  bool _isSaving = false; // Variable para manejar el estado del botón

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    _questionsRef.once().then((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      List<Map<String, dynamic>> tempQuestions = [];

      dataSnapshot.children.forEach((data) {
        final String? key = data.key;
        final questionData = Map<String, dynamic>.from(data.value as Map);

        if (questionData['isActive'] && key != null) {
          tempQuestions.add({
            'id': key,
            'text': questionData['text'],
          });
          // Inicializa la respuesta como "N/A"
          _responses[key] = 'N/A';
        }
      });

      setState(() {
        _questions = tempQuestions;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar las preguntas: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  bool _validateResponses() {
    for (var response in _responses.values) {
      if (response == 'N/A') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, rellene todo el formulario antes de guardar.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }
    return true;
  }

  void _resetResponses() {
    setState(() {
      _responses.updateAll((key, value) => 'N/A');
    });
  }

  void _saveChecklist() async {
    if (_isSaving) return; // Evita guardar múltiples veces si ya está guardando

    if (!_validateResponses()) return; // Si la validación falla, no continúa con el guardado

    setState(() {
      _isSaving = true; // Desactiva el botón al iniciar la operación de guardado
    });

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe estar autenticado para guardar el cuestionario'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isSaving = false; // Reactiva el botón si no hay usuario autenticado
      });
      return;
    }

    final DatabaseReference checklistRef = FirebaseDatabase.instance.ref().child('users/${user.uid}/checklists');

    String checklistId = checklistRef.push().key!;
    await checklistRef.child(checklistId).set({
      'createdAt': DateTime.now().toIso8601String(),
      'responses': _responses,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuestionario guardado con éxito'),
          backgroundColor: Colors.green,
        ),
      );
      _resetResponses(); // Resetea las respuestas después de guardar con éxito
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar el cuestionario: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isSaving = false; // Reactiva el botón cuando la operación termine
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Formulario',
            style: TextStyle(
              fontSize: 18.0, // Tamaño de fuente más pequeño
              fontWeight: FontWeight.bold, // Negrita
            ),
          ),
        ),
      ),
      body: _questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: _questions.map((question) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color.fromARGB(255, 252, 252, 252)),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 3), // Sombra hacia abajo
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question['text'],
                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 10.0, // Espacio entre los radio buttons
                        children: _options.map((option) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: option,
                                groupValue: _responses[question['id']],
                                activeColor: const Color.fromARGB(255, 205, 87, 24), // Color personalizado
                                onChanged: (String? value) {
                                  setState(() {
                                    _responses[question['id']] = value!;
                                  });
                                },
                              ),
                              Text(option),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isSaving ? null : _saveChecklist, // Desactiva el botón si está guardando
        child: _isSaving ? CircularProgressIndicator() : const Icon(Icons.save),
      ),
    );
  }
}




