namespace RestaurantAPIS.Models
{
    public class Producto
    {
        public int idProducto { get; set; }
        public string nombre { get; set; }
        public string descricion { get; set;}
        public string precio { get; set;}
        public int idTopping { get; set; }
    }
}
