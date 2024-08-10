import 'dart:convert';

class Empleado {
  final int idEmpleado;
  final String nombre;
  final String contrasenia;
  final int idRol;
  

  
  Empleado({
    required this.idEmpleado,
    required this.nombre,
    required this.contrasenia,
    required this.idRol,
  });

  
  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      idEmpleado: json['idEmpleado'] as int,
      nombre: json['nombre'] as String,
      contrasenia: json['contrasenia'] as String,
      idRol: json['idRol'] as int,
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'idEmpleado': idEmpleado,
      'nombre': nombre,
      'contrasenia': contrasenia,
      'idRol': idRol,
    };
  }
}


List<Empleado> parseEmpleados(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Empleado>((json) => Empleado.fromJson(json)).toList();
}
