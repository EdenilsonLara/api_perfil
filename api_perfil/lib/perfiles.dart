import 'package:api_perfil/inicio.dart';
import 'package:flutter/material.dart';
import 'crearPerfil.dart'; // Importar la vista de CrearPerfil
import 'perfil.dart';
import 'api_service.dart'; // Importa el servicio de API

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Perfil> perfiles = []; // Lista de perfiles
  bool _isLoading = true; // Variable para controlar el estado de carga
  bool _isAppBarVisible = false; // Controla la visibilidad de la AppBar
  final ApiService apiService = ApiService(); // Instancia del servicio de API

  @override
  void initState() {
    super.initState();
    _loadProfiles(); // Cargar perfiles al iniciar la aplicación
  }

  Future<void> _loadProfiles() async {
    try {
      final response = await apiService.getAllProyectos();
      print('Datos recibidos: $response');
      setState(() {
        perfiles = response;
        _isLoading = false;
        _isAppBarVisible = true;
      });
    } catch (e) {
      print('Error al cargar los perfiles: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los perfiles: $e')),
      );
      setState(() {
        _isLoading = false;
        _isAppBarVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100], // Color de fondo de la vista
      appBar: _isAppBarVisible
          ? AppBar(
              centerTitle: true, // Centra el título en la AppBar
              title: Text(
                'Snake Rewind',
                style: TextStyle(
                  fontSize: 32, // Tamaño de fuente más grande
                  color: Color.fromARGB(255, 202, 120,
                      65), // Color verde para que coincida con la serpiente
                  fontWeight: FontWeight.bold, // Texto en negrita
                  letterSpacing: 2.0, // Espacio adicional entre las letras
                  fontFamily:
                      'PressStart2P', // Fuente que recuerda a los juegos retro
                ),
              ),
              backgroundColor:
                  Colors.deepPurple, // Color de fondo de la barra de navegación
            )
          : null, // Si _isAppBarVisible es false, no muestra la AppBar
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading ? _buildLoadingIndicator() : _buildProfilesListView(),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildProfilesListView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text(
            'Selecciona un perfil para continuar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: perfiles.length,
            itemBuilder: (context, index) {
              final perfil = perfiles[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(perfil.nombre.isNotEmpty
                        ? perfil.nombre
                        : 'Nombre no disponible'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Apodo: ${perfil.apodo.isNotEmpty ? perfil.apodo : 'Apodo no disponible'}'),
                        Text('Puntaje: ${perfil.record}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Inicio(perfil: perfil),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                final nuevoPerfil = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrearPerfil()),
                );
                if (nuevoPerfil != null) {
                  setState(() {
                    perfiles.add(nuevoPerfil);
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Agregar Perfil'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
