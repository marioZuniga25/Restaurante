import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Models/Empleado.dart';
import 'Models/Mesa.dart';

class HostHomePage extends StatefulWidget {
  final Empleado empleado;

  HostHomePage({required this.empleado});

  @override
  _HostHomePageState createState() => _HostHomePageState();
}

class _HostHomePageState extends State<HostHomePage> {
  List<Mesa> _mesas = [];

  @override
  void initState() {
    super.initState();
    _fetchMesas();
  }

  Future<void> _fetchMesas() async {
    final response = await http.get(
      Uri.parse('https://localhost:7186/api/Host/GetMesas'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        _mesas = jsonResponse.map((json) => Mesa.fromJson(json)).toList();
      });
    } else {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar las mesas')),
      );
    }
  }

  Color _getColorForStatus(int status) {
    switch (status) {
      case 0:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.brown;
      case 5:
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  String _getTextForStatus(int status) {
    switch (status) {
      case 0:
        return 'Mesa libre';
      case 2:
        return 'Asignada';
      case 3:
        return 'Pedido';
      case 4:
        return 'Comiendo';
      case 5:
        return 'Limpieza';
      default:
        return 'Desconocido'; 
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Host'),
      ),
      body: ListView.builder(
        itemCount: _mesas.length,
        itemBuilder: (context, index) {
          final mesa = _mesas[index];
          return Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: _getColorForStatus(mesa.status),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              'Mesa ${mesa.idMesa}\n${_getTextForStatus(mesa.status)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          );
        },
      ),
    );
  }
}