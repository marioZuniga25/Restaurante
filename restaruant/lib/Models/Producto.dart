class Producto {
  int idProducto;
  String nombre;
  String descricion;
  String precio;
  int idTopping;

  Producto({
    required this.idProducto,
    required this.nombre,
    required this.descricion,
    required this.precio,
    required this.idTopping,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['idProducto'],
      nombre: json['nombre'],
      descricion: json['descricion'],
      precio: json['precio'],
      idTopping: json['idTopping'],
    );
  }
}
