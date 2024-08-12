import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Models/Producto.dart';
import 'Models/Pedido.dart';
import 'Models/PedidoDetalle.dart';
import 'dart:convert';

class PedidoPage extends StatefulWidget {
  final int idMesa;

  PedidoPage({required this.idMesa});

  @override
  _PedidoPageState createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  List<Producto> productosDisponibles = []; 
  List<PedidoDetalle> detallesPedido = []; 

  @override
  void initState() {
    super.initState();
    fetchProductosDisponibles(); 
  }

  
  void fetchProductosDisponibles() async {
    final response = await http.get(
      Uri.parse('https://localhost:7186/api/Meseros/GetProductos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        productosDisponibles = jsonResponse.map((json) => Producto.fromJson(json)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los productos: ${response.statusCode}')),
      );
    }
  }

  
  void agregarProductoAlPedido(Producto producto) {
    setState(() {
      detallesPedido.add(PedidoDetalle(idDetalle: 0, idPedido: 0, idProducto: producto.idProducto));
    });
    guardarPedidoEnSharedPreferences(); 
    }

  
  void guardarPedidoEnSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Pedido pedido = Pedido(idPedido: 0, idMesa: widget.idMesa, estatus: 1);
    prefs.setString('pedido', jsonEncode(pedido.toJson()));
    List<String> detallesJson = detallesPedido.map((detalle) => jsonEncode(detalle.toJson())).toList();
    prefs.setStringList('detallesPedido', detallesJson);
  }

  
  Future<void> guardarPedidoEnServidor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pedidoJson = prefs.getString('pedido');
    List<String>? detallesJson = prefs.getStringList('detallesPedido');

    if (pedidoJson == null || detallesJson == null || detallesJson.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay detalles de pedido para guardar.')),
      );
      return;
    }

    Pedido pedido = Pedido.fromJson(jsonDecode(pedidoJson));
    List<PedidoDetalle> detallesPedido = detallesJson.map((detalle) => PedidoDetalle.fromJson(jsonDecode(detalle))).toList();

    
    final responsePedido = await http.post(
      Uri.parse('https://localhost:7186/api/Meseros/AgregarPedido'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(pedido.toJson()),
    );

    if (responsePedido.statusCode == 200) {
      int idPedido = jsonDecode(responsePedido.body);

      
      detallesPedido = detallesPedido.map((detalle) {
        detalle.idPedido = idPedido;
        return detalle;
      }).toList();

      
      final responseDetalles = await http.post(
        Uri.parse('https://localhost:7186/api/Meseros/AgregarDetallePedido'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(detallesPedido.map((detalle) => detalle.toJson()).toList()),
      );

      if (responseDetalles.statusCode == 200) {
        
        final responseMesa = await http.post(
          Uri.parse('https://localhost:7186/api/Meseros/CambiaEstatus?id='+widget.idMesa.toString()+'&status=3'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          
        );

        if (responseMesa.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pedido guardado correctamente')),
          );
          Navigator.pop(context); 
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al cambiar el estatus de la mesa: ${responseMesa.statusCode}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar detalles del pedido: ${responseDetalles.statusCode}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el pedido: ${responsePedido.statusCode}')),
      );
    }
  }

  
  void abrirCatalogoProductos() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: productosDisponibles.length,
          itemBuilder: (context, index) {
            final producto = productosDisponibles[index];
            return ListTile(
              title: Text(producto.nombre),
              subtitle: Text('Precio: ${producto.precio}'),
              onTap: () {
                agregarProductoAlPedido(producto);
                Navigator.pop(context); 
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido para Mesa ${widget.idMesa}'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: abrirCatalogoProductos,
            child: Text('Agregar Producto'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: detallesPedido.length,
              itemBuilder: (context, index) {
                final detalle = detallesPedido[index];
                final producto = productosDisponibles.firstWhere((prod) => prod.idProducto == detalle.idProducto);
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('Precio: ${producto.precio}'),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: guardarPedidoEnServidor,
            child: Text('Guardar Pedido'),
          ),
        ],
      ),
    );
  }
}
