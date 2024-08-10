
import 'package:flutter/material.dart';
import 'package:restaruant/Models/Empleado.dart';

class CorredoresHomePage extends StatelessWidget {
  final Empleado empleado;

  CorredoresHomePage({required this.empleado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido Corredor ${empleado.nombre}'),
      ),
      body: Center(
        child: Text('Contenido para Corredores'),
      ),
    );
  }
}