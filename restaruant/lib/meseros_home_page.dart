import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaruant/Models/Empleado.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/mesa.dart';  
import 'agregar_orden.dart';  

class MeserosHomePage extends StatefulWidget {

  final Empleado empleado;

  MeserosHomePage({required this.empleado});

  @override
  _MeserosHomePageState createState() => _MeserosHomePageState();
}

class _MeserosHomePageState extends State<MeserosHomePage> {
  List<Mesa> _mesas = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMesas();
  }

  Future<void> _loadMesas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idEmpleado = prefs.getInt('idEmpleado') ?? 0; 

    final response = await http.get(
      Uri.parse('https://localhost:7186/api/Meseros/GetMesasMesero?idEmpleado=$idEmpleado'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        _mesas = jsonResponse.map((json) => Mesa.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'No se pudo cargar las mesas';
      });
    }
  }

  Color getColorFromStatus(int status) {
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

  String getStatusText(int status) {
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

  void _onMesaTap(Mesa mesa) {
    if (mesa.status == 0) {  
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PedidoPage(idMesa: mesa.idMesa)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Solo se pueden agregar pedidos a mesas libres')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meseros Home Page'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : ListView.builder(
              itemCount: _mesas.length,
              itemBuilder: (context, index) {
                Mesa mesa = _mesas[index];
                return GestureDetector(
                  onTap: () => _onMesaTap(mesa),
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(16.0),
                    color: getColorFromStatus(mesa.status),
                    child: Text(
                      'Mesa ${mesa.idMesa}: ${getStatusText(mesa.status)}',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
