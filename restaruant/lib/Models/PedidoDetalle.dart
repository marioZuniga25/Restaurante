class PedidoDetalle {
  int idDetalle;
  int idPedido;
  int idProducto;

  PedidoDetalle({required this.idDetalle, required this.idPedido, required this.idProducto});

  factory PedidoDetalle.fromJson(Map<String, dynamic> json) {
    return PedidoDetalle(
      idDetalle: json['idDetalle'],
      idPedido: json['idPedido'],
      idProducto: json['idProducto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDetalle': idDetalle,
      'idPedido': idPedido,
      'idProducto': idProducto,
    };
  }
}
