import 'package:flutter/material.dart';
import 'package:api_perfil/perfil.dart';
import 'package:flutter/services.dart';
import 'usuario.dart';
import 'juego.dart';

class Inicio extends StatelessWidget {
  final Perfil perfil;

  Inicio({required this.perfil});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inicio',
          style: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 24,
            color: Color.fromARGB(255, 202, 120, 65),
          ),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Usuario(
                    perfil: perfil,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(
                  'http://192.168.1.4:3000/getImage/${perfil.image}',
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SnakeGame(perfil: perfil),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Jugar'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop(); // Cerrar la aplicación
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text('Salir del Juego'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Image.asset(
      'gif/serpiente.gif',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
