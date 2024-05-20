import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  XFile? _selectedImage;

  final ApiService apiService = ApiService(); // Instancia del servicio de API
  final ImagePicker _picker =
      ImagePicker(); // Instancia del selector de imágenes

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.perfil.nombre);
    apodoController = TextEditingController(text: widget.perfil.apodo);
    edadController = TextEditingController(text: widget.perfil.edad.toString());
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  Future<void> _updateProfile() async {
    final String nombre = nombreController.text;
    final String apodo = apodoController.text;
    final int edad = int.tryParse(edadController.text) ?? 0;

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
    };

    try {
      await apiService.updateProyecto(widget.perfil.id, updateData);

      // Si hay una imagen seleccionada, actualizarla
      if (_selectedImage != null) {
        await apiService.updateImage(widget.perfil.id, _selectedImage!.path);
      }

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

  Widget _buildProfileImage() {
    String imageUrl =
        'http://192.168.1.36:3000/getImage/${widget.perfil.image}';

    if (_selectedImage != null) {
      return Image.file(File(_selectedImage!.path), fit: BoxFit.cover);
    } else if (widget.perfil.image != null && widget.perfil.image.isNotEmpty) {
      return Image.network(imageUrl, fit: BoxFit.cover);
    } else {
      return Icon(Icons.image, size: 100, color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        backgroundColor: Color.fromARGB(255, 202, 120, 65),
      ),
      backgroundColor: Color.fromARGB(221, 32, 31, 31), // Color de fondo oscuro
      body: SingleChildScrollView(
        // Widget para agregar desplazamiento
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Seleccionar Imagen'),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 233, 167, 69),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 200,
                width: double.infinity,
                child: _buildProfileImage(),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              TextField(
                controller: apodoController,
                decoration: InputDecoration(
                  labelText: 'Apodo',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              TextField(
                controller: edadController,
                decoration: InputDecoration(
                  labelText: 'Edad',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Guardar Cambios'),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 233, 167, 69),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
