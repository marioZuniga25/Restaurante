using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RestaurantAPIS.Models;

namespace RestaurantAPIS.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CocinaController : ControllerBase
    {

        private readonly RestaurantContext _context;
        public CocinaController(RestaurantContext context)
        {
            _context = context;
        }

        [HttpGet("GetPedidos")]
        public async Task<ActionResult<IEnumerable<Producto>>> getPedidos()
        {


            var pedidos = await _context.Pedidos.Where(u => u.estatus.Equals(1)).ToListAsync();



            return Ok(pedidos);
        }



        [HttpPost("TerminarPedido")]
        public async Task<ActionResult> ModificarPedido(int id, int status, int idPedido)
        {

            
            var PedidoModificar = await _context.Pedidos.FindAsync(id);
            var mesaModificar = await _context.Mesas.FindAsync(PedidoModificar.idMesa);

            if (PedidoModificar == null)
            {
                return BadRequest("Pedido no encontrado");
            }


            mesaModificar.status = 4;
            PedidoModificar.estatus = status;


            await _context.SaveChangesAsync();

            return Ok();

        }


        [HttpGet("GetPedidoDetalles")]
        public async Task<ActionResult<IEnumerable<PedidoDetalle>>> SearchPedidoDetalles(int idPedido)
        {


            var pedidos = await _context.pedidoDetalles.Where(u => u.idPedido.Equals(idPedido)).ToListAsync();



            return Ok(pedidos);
        }

        [HttpGet("GetProducto")]
        public async Task<ActionResult<IEnumerable<Producto>>> Searchproducto(int idProducto)
        {


            var producto = await _context.Productos.Where(u => u.idProducto.Equals(idProducto)).ToListAsync();



            return Ok(producto);
        }


    }
}
