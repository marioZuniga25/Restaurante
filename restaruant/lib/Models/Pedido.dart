class Pedido {
  int idPedido;
  int idMesa;
  int estatus;

  Pedido({required this.idPedido, required this.idMesa, required this.estatus});

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      idPedido: json['idPedido'],
      idMesa: json['idMesa'],
      estatus: json['estatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPedido': idPedido,
      'idMesa': idMesa,
      'estatus': estatus,
    };
  }
}
