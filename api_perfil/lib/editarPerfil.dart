import 'package:flutter/material.dart';
import 'perfil.dart';
import 'api_service.dart'; // Importa el servicio de API

class EditarPerfil extends StatefulWidget {
  final Perfil perfil;

  const EditarPerfil({Key? key, required this.perfil}) : super(key: key);

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  late TextEditingController nombreController;
  late TextEditingController apodoController;
  late TextEditingController edadController;
  late TextEditingController recordController;

  final ApiService apiService = ApiService(); // Instancia del servicio de API

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.perfil.nombre);
    apodoController = TextEditingController(text: widget.perfil.apodo);
    edadController = TextEditingController(text: widget.perfil.edad.toString());
    recordController =
        TextEditingController(text: widget.perfil.record.toString());
  }

  Future<void> _updateProfile() async {
    final String nombre = nombreController.text;
    final String apodo = apodoController.text;
    final int edad = int.tryParse(edadController.text) ?? 0;
    final int record = int.tryParse(recordController.text) ?? 0;

    if (nombre.isEmpty || apodo.isEmpty || edad == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final Map<String, dynamic> updateData = {
      'nombre': nombre,
      'apodo': apodo,
      'edad': edad,
      'record': record,
    };

    try {
      await apiService.updateProyecto(widget.perfil.id, updateData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil actualizado con éxito')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el perfil: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: apodoController,
              decoration: InputDecoration(labelText: 'Apodo'),
            ),
            TextField(
              controller: edadController,
              decoration: InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: recordController,
              decoration: InputDecoration(labelText: 'Record'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
