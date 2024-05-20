import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart'; // Importa el servicio de API
import 'perfil.dart';

class CrearPerfil extends StatefulWidget {
  @override
  _CrearPerfilState createState() => _CrearPerfilState();
}

class _CrearPerfilState extends State<CrearPerfil> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController apodoController = TextEditingController();
  XFile? _imageFile;
  final ApiService apiService = ApiService(); // Instancia del servicio de API

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _saveProfile() async {
    final String nombre = nombreController.text;
    final int edad = int.tryParse(edadController.text) ?? 0;
    final String apodo = apodoController.text;
    final String imagePath = _imageFile?.path ?? '';

    if (nombre.isEmpty || edad == 0 || apodo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final Map<String, dynamic> proyectoData = {
      'nombre': nombre,
      'edad': edad,
      'apodo': apodo,
      'record': 0,
    };

    try {
      final response = await apiService.saveProyecto(proyectoData, imagePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil guardado con éxito')),
      );
      Navigator.pop(
        context,
        Perfil.fromJson(response), // Devuelve el perfil creado
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el perfil: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Perfil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Seleccionar Imagen'),
              ),
              SizedBox(height: 20),
              _imageFile != null
                  ? Image.file(File(_imageFile!.path))
                  : Icon(Icons.image, size: 100),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: edadController,
                decoration: InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: apodoController,
                decoration: InputDecoration(labelText: 'Apodo'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text('Crear Perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
