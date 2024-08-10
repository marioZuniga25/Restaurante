import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Models/Pedido.dart';
import 'Models/PedidoDetalle.dart';
import 'Models/Producto.dart';
import 'dart:convert';

class CocinaPage extends StatefulWidget {
  @override
  _CocinaPageState createState() => _CocinaPageState();
}

class _CocinaPageState extends State<CocinaPage> {
  List<Pedido> pedidos = [];
  List<Producto> productos = [];
  int? selectedPedidoId; 

  @override
  void initState() {
    super.initState();
    fetchPedidos();
  }

  
  void fetchPedidos() async {
    final response = await http.get(
      Uri.parse('https://localhost:7186/api/Cocina/GetPedidos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        pedidos = jsonResponse.map((json) => Pedido.fromJson(json)).toList();
      });
    } else {
      print('Error al cargar los pedidos: ${response.statusCode}');
    }
  }


  void fetchPedidoDetalles(int idPedido) async {
    final response = await http.get(
      Uri.parse('https://localhost:7186/api/Cocina/GetPedidoDetalles?idPedido=$idPedido'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> detallesPedidoJson = jsonDecode(response.body);
      List<PedidoDetalle> detallesPedido = detallesPedidoJson.map((json) => PedidoDetalle.fromJson(json)).toList();

      
      List<Producto> productos = [];

      for (var detalle in detallesPedido) {
        final productoResponse = await http.get(
          Uri.parse('https://localhost:7186/api/Cocina/GetProducto?idProducto=${detalle.idProducto}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        if (productoResponse.statusCode == 200) {
          List<dynamic> productoJson = jsonDecode(productoResponse.body);
          if (productoJson.isNotEmpty) {
            productos.add(Producto.fromJson(productoJson[0]));
          }
        } else {
          print('Error al cargar el producto: ${productoResponse.statusCode}');
        }
      }

      setState(() {
        this.productos = productos;
        this.selectedPedidoId = idPedido; 
      });

      mostrarDetallesPedido();
    } else {
      print('Error al cargar los detalles del pedido: ${response.statusCode}');
    }
  }

  
  void mostrarDetallesPedido() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles del Pedido'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('Descripción: ${producto.descricion}\nPrecio: ${producto.precio}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedPedidoId != null) {
                  terminarPedido(selectedPedidoId!); 
                }
              },
              child: Text('Terminar Pedido'),
            ),
          ],
        );
      },
    );
  }

  
  void terminarPedido(int idPedido) async {
    final response = await http.post(
      Uri.parse('https://localhost:7186/api/Cocina/TerminarPedido?id=' + idPedido.toString() + '&status=2'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Navigator.pop(context); 
      fetchPedidos(); 
    } else {
      print('Error al terminar el pedido: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocina'),
      ),
      body: ListView.builder(
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          final pedido = pedidos[index];
          return ListTile(
            title: Text('Pedido ${pedido.idPedido}'),
            subtitle: Text('Mesa ${pedido.idMesa} - Estatus: ${pedido.estatus}'),
            onTap: () {
              fetchPedidoDetalles(pedido.idPedido);
            },
          );
        },
      ),
    );
  }
}
