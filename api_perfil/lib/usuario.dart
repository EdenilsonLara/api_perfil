import 'package:flutter/material.dart';
import 'perfil.dart';
import 'editarPerfil.dart';

class Usuario extends StatelessWidget {
  final Perfil perfil;

  Usuario({required this.perfil});

  @override
  Widget build(BuildContext context) {
    String imageUrl = 'http://192.168.1.4:3000/getImage/${perfil.image}';

    return Container(
      color: Colors.black87, // Fondo oscuro
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Perfil de ${perfil.nombre}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 202, 120, 65),
            ),
          ),
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                ),
                SizedBox(height: 20),
                _buildProfileDetail('Nombre', perfil.nombre),
                _buildProfileDetail('Apodo', perfil.apodo),
                _buildProfileDetail('Edad', perfil.edad.toString()),
                _buildProfileDetail('Puntaje', perfil.record.toString()),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarPerfil(perfil: perfil),
                        ),
                      );
                    },
                    child: Text(
                      'Editar Perfil',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 202, 120, 65),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 202, 120, 65),
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 18, color: Colors.black), // Texto blanco
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
