import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChecklistPage extends StatefulWidget {
  @override
  _ChecklistPageState createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final DatabaseReference _questionsRef = FirebaseDatabase.instance.ref().child('questions');
  final Map<String, String> _responses = {}; // Cambiado a 'final' porque no se reasigna
  List<Map<String, dynamic>> _questions = [];

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

        if (questionData['isActive'] && key != null) {  // Filtra solo las preguntas activas y asegura que la clave no es nula
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

  void _saveChecklist() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Debe estar autenticado para guardar el cuestionario'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final DatabaseReference checklistRef = FirebaseDatabase.instance.ref().child('users/${user.uid}/checklists');

    String checklistId = checklistRef.push().key!;
    await checklistRef.child(checklistId).set({
      'createdAt': DateTime.now().toIso8601String(),
      'responses': _responses,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cuestionario guardado con éxito'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar el cuestionario: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checklist Diario'),
      ),
      body: _questions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: _questions.map((question) {
                return ListTile(
                  title: Text(question['text']),
                  trailing: DropdownButton<String>(
                    value: _responses[question['id']],
                    items: <String>['Bien', 'Mal', 'N/A', 'Sí', 'No'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _responses[question['id']] = newValue!; // Usando el operador ! para asegurar que newValue no es null
                      });
                    },
                  ),
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveChecklist,
        child: Icon(Icons.save),
      ),
    );
  }
}
