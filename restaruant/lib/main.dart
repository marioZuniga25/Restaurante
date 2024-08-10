import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/Empleado.dart';  
import 'host_home_page.dart';
import 'admin_home_page.dart';
import 'corredor_home_page.dart';
import 'cocina_home_page.dart';
import 'caja_home_page.dart';
import 'meseros_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Louigi's",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(), 
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _EmpleadoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> saveUserToPreferences(Empleado user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('idEmpleado', user.idEmpleado);
  await prefs.setString('nombreEmpleado', user.nombre);
  await prefs.setInt('rol', user.idRol);
}


  Future<void> _login() async {
    final String empleado = _EmpleadoController.text;
    final String password = _passwordController.text;

    
    final response = await http.get(
      Uri.parse('https://localhost:7186/api/Login/Buscar?nameEmpleado='+empleado),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
    print(response.statusCode);
    print(response.body);


    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
        
        final empleadoList = jsonResponse.map((json) => Empleado.fromJson(json)).toList();
        final user = empleadoList.firstWhere(
          (emp) => emp.contrasenia == password,
          orElse: () => throw ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Empleado o contraseña incorrectos')),
      ),
        );

        print(user.nombre);
        await saveUserToPreferences(user);
        print("Rol: " + user.idRol.toString());


      

      switch (user.idRol) {
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HostHomePage(empleado: user)),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MeserosHomePage(empleado: user)),
          );
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CocinaPage()),
          );
          break;
        case 4:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CorredoresHomePage(empleado: user)),
          );
          break;
        case 5:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CajaHomePage(empleado: user)),
          );
          break;
        case 6:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHomePage(empleado: user)),
          );
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rol no reconocido')),
          );
          break;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Empleado o contraseña incorrectos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _EmpleadoController,
              decoration: const InputDecoration(
                labelText: 'Empleado',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}









