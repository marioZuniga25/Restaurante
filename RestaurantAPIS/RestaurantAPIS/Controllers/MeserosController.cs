using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RestaurantAPIS.Models;

namespace RestaurantAPIS.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MeserosController : ControllerBase
    {

        private readonly RestaurantContext _context;
        public MeserosController(RestaurantContext context)
        {
            _context = context;
        }



        [HttpGet("GetMesasMesero")]
        public async Task<ActionResult<IEnumerable<Mesa>>> SearchMesaEmpleado(int idEmpleado)
        {


            var mesas = await _context.Mesas.Where(u => u.idEmpleado.Equals(idEmpleado)).ToListAsync();



            return Ok(mesas);
        }

        [HttpGet("GetProductos")]
        public async Task<ActionResult<IEnumerable<Producto>>> getProductos()
        {


            var productos = await _context.Productos.ToListAsync();



            return Ok(productos);
        }


        [HttpPost("AgregarPedido")]
        public async Task<ActionResult<int>> AddPedido([FromBody] Pedido request)
        {
            if (request == null)
            {
                return BadRequest("El pedido no puede ser nulo.");
            }

            try
            {
                _context.Pedidos.Add(request);
                await _context.SaveChangesAsync();

                // Retorna el ID del pedido recién creado
                return Ok(request.idPedido);
            }
            catch (Exception ex)
            {
                // Maneja cualquier error
                return StatusCode(StatusCodes.Status500InternalServerError, $"Error al guardar el pedido: {ex.Message}");
            }
        }




        [HttpPost("AgregarDetallePedido")]
        public async Task<ActionResult> AddDetallesPedido([FromBody] List<PedidoDetalle> detallesPedido)
        {
            if (detallesPedido == null || !detallesPedido.Any())
            {
                return BadRequest("La lista de detalles del pedido no puede estar vacía.");
            }

            try
            {
                _context.pedidoDetalles.AddRange(detallesPedido);
                await _context.SaveChangesAsync();

                return Ok();
            }
            catch (Exception ex)
            {
                // Maneja cualquier error
                return StatusCode(StatusCodes.Status500InternalServerError, $"Error al guardar los detalles del pedido: {ex.Message}");
            }
        }



        [HttpPost("CambiaEstatus")]
        public async Task<ActionResult> ModificarProducto(int id, int status)
        {

            var mesaModificar = await _context.Mesas.FindAsync(id);

            if (mesaModificar == null)
            {
                return BadRequest("Usuario no encontrado");
            }

            
            mesaModificar.status= status;


            await _context.SaveChangesAsync();

            return Ok();

        }



        

    }
}
