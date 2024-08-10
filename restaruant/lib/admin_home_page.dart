import 'package:flutter/material.dart';
import 'package:restaruant/Models/Empleado.dart';

class AdminHomePage extends StatelessWidget {
  final Empleado empleado;

  

  AdminHomePage({required this.empleado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido Administrador ${empleado.nombre}'),
      ),
      body: Center(
        child: Text('Contenido para Administrador'),
      ),
    );
  }
}
