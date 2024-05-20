import 'package:api_perfil/api_service.dart';
import 'package:api_perfil/editarPerfil.dart';
import 'package:api_perfil/perfil.dart';
import 'package:flutter/material.dart';

class Usuario extends StatelessWidget {
  final Perfil perfil;
  final ApiService apiService = ApiService();
  final BuildContext parentContext; // Nuevo parámetro

  Usuario(
      {required this.perfil,
      required this.parentContext}); // Actualizado el constructor

  @override
  Widget build(BuildContext context) {
    String imageUrl = 'http://192.168.1.4:3000/getImage/${perfil.image}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de ${perfil.nombre}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Perfil>(
          future: apiService.getProyecto(perfil.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('Perfil no disponible'));
            } else {
              final perfilActualizado = snapshot.data!;
              return _buildProfileDetail(perfilActualizado, imageUrl);
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileDetail(Perfil perfil, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Nombre: ${perfil.nombre}',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        Text(
          'Apodo: ${perfil.apodo}',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        Text(
          'Edad: ${perfil.edad}',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        Text(
          'Puntaje: ${perfil.record}',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                parentContext, // Usar el contexto del widget padre
                MaterialPageRoute(
                  builder: (context) => EditarPerfil(perfil: perfil),
                ),
              );
            },
            child: Text('Editar Perfil'),
          ),
        ),
      ],
    );
  }
}
