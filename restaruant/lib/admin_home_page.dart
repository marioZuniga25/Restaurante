import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Models/Empleado.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Empleado> empleados = [];
  List<int> roles = [1, 2, 3, 4, 5, 6]; 

  @override
  void initState() {
    super.initState();
    fetchEmpleados();
  }

  
  void fetchEmpleados() async {
    final response = await http.get(
      Uri.parse('https://localhost:7186/api/Login/Listado'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        empleados = jsonResponse.map((json) => Empleado.fromJson(json)).toList();
      });
    } else {
      print('Error al cargar los empleados: ${response.statusCode}');
    }
  }

  // Método para agregar un nuevo empleado
  void addEmpleado(Empleado empleado) async {
    final response = await http.post(
      Uri.parse('https://localhost:7186/api/Login/AgregarUsuario'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(empleado.toJson()),
    );

    if (response.statusCode == 200) {
      fetchEmpleados();
    } else {
      print('Error al agregar el empleado: ${response.statusCode}');
    }
  }

  // Método para modificar un empleado existente
  void updateEmpleado(Empleado empleado) async {
    final response = await http.put(
      Uri.parse('https://localhost:7186/api/Login/ModificarEmpleado?id=${empleado.idEmpleado}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(empleado.toJson()),
    );

    if (response.statusCode == 200) {
      fetchEmpleados();
    } else {
      print('Error al actualizar el empleado: ${response.statusCode}');
    }
  }

  // Método para eliminar un empleado
  void deleteEmpleado(int idEmpleado) async {
    final response = await http.delete(
      Uri.parse('https://localhost:7186/api/Login/EliminarUsuario/$idEmpleado'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      fetchEmpleados();
    } else {
      print('Error al eliminar el empleado: ${response.statusCode}');
    }
  }

  // Método para mostrar un formulario de empleado (para agregar o modificar)
  void showEmpleadoForm({Empleado? empleado}) {
    final _formKey = GlobalKey<FormState>();
    final nombreController = TextEditingController(text: empleado?.nombre ?? '');
    final contraseniaController = TextEditingController(text: empleado?.contrasenia ?? '');
    int? selectedRol = empleado?.idRol;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(empleado == null ? 'Agregar Empleado' : 'Modificar Empleado'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese un nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: contraseniaController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese una contraseña';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<int>(
                  value: selectedRol,
                  decoration: InputDecoration(labelText: 'ID Rol'),
                  items: roles.map((int rol) {
                    return DropdownMenuItem<int>(
                      value: rol,
                      child: Text('Rol $rol'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRol = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Seleccione un ID de rol';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Empleado newEmpleado = Empleado(
                    idEmpleado: empleado?.idEmpleado ?? 0,
                    nombre: nombreController.text,
                    contrasenia: contraseniaController.text,
                    idRol: selectedRol!,
                  );

                  if (empleado == null) {
                    addEmpleado(newEmpleado);
                  } else {
                    updateEmpleado(newEmpleado);
                  }

                  Navigator.pop(context);
                }
              },
              child: Text(empleado == null ? 'Agregar' : 'Modificar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrar Empleados'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showEmpleadoForm();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: empleados.length + 1,
        itemBuilder: (context, index) {
          if (index == empleados.length) {
            
            return ListTile(
              leading: Icon(Icons.add),
              title: Text('Agregar Nuevo Empleado'),
              onTap: () {
                showEmpleadoForm();
              },
            );
          } else {
            final empleado = empleados[index];
            return ListTile(
              title: Text(empleado.nombre),
              subtitle: Text('Rol: ${empleado.idRol}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEmpleadoForm(empleado: empleado);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteEmpleado(empleado.idEmpleado);
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
