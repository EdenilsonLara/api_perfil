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

  final ApiService apiService = ApiService(); // Instancia del servicio de API

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.perfil.nombre);
    apodoController = TextEditingController(text: widget.perfil.apodo);
    edadController = TextEditingController(text: widget.perfil.edad.toString());
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
        backgroundColor: Color.fromARGB(255, 202, 120, 65),
      ),
      backgroundColor: Color.fromARGB(221, 32, 31, 31), // Color de fondo oscuro
      body: SingleChildScrollView(
        // Widget para agregar desplazamiento
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                'Nombre',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Texto en color blanco
                ),
              ),
              TextField(
                controller: nombreController,
                style: TextStyle(color: Colors.white), // Texto en color blanco
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Apodo',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Texto en color blanco
                ),
              ),
              TextField(
                controller: apodoController,
                style: TextStyle(color: Colors.white), // Texto en color blanco
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Edad',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Texto en color blanco
                ),
              ),
              TextField(
                controller: edadController,
                style: TextStyle(color: Colors.white), // Texto en color blanco
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
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
