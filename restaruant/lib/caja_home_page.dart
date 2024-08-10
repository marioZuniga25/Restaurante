
import 'package:flutter/material.dart';
import 'package:restaruant/Models/Empleado.dart';

class CajaHomePage extends StatelessWidget {
  final Empleado empleado;

  CajaHomePage({required this.empleado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido Caja ${empleado.nombre}'),
      ),
      body: Center(
        child: Text('Contenido para Caja'),
      ),
    );
  }
}