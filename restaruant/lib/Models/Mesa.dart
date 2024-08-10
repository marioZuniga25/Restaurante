import 'dart:convert';


class Mesa {
  final int idMesa;
  final int status;
  final int idEmpleado;

  
  Mesa({
    required this.idMesa,
    required this.status,
    required this.idEmpleado
  });

  
  factory Mesa.fromJson(Map<String, dynamic> json) {
    return Mesa(
      idMesa: json['idMesa'] as int,
      status: json['status'] as int,
      idEmpleado: json['idEmpleado'] as int
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'idMesa': idMesa,
      'status': status,
      'idEmpleado': idEmpleado
    };
  }
}


List<Mesa> parseMesa(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Mesa>((json) => Mesa.fromJson(json)).toList();
}
