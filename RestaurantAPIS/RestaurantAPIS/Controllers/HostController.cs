using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RestaurantAPIS.Models;

namespace RestaurantAPIS.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HostController : ControllerBase
    {


        private readonly RestaurantContext _context;
        public HostController(RestaurantContext context)
        {
            _context = context;
        }



        [HttpGet("GetMesas")]
        public async Task<ActionResult<IEnumerable<Empleado>>> SearchEmpleado()
        {


            var mesas = await _context.Mesas.ToListAsync();

            

            return Ok(mesas);
        }

        

        [HttpGet("GetEmpleadoAsignado/{idMesa}")]
        public async Task<ActionResult<Empleado>> GetEmpleadoAsignado(int idMesa)
        {
            var mesa = await _context.Mesas.FindAsync(idMesa);

            if (mesa == null || mesa.idEmpleado == null)
                return NotFound();

            var empleado = await _context.Empleados.FindAsync(mesa.idEmpleado);

            return empleado ?? (ActionResult<Empleado>)NotFound();
        }

        [HttpGet("GetEmpleadosDisponibles")]
        public async Task<ActionResult<IEnumerable<Empleado>>> GetEmpleadosDisponibles()
        {
            var empleados = await _context.Empleados.Where(e => e.idRol.Equals(2)).ToListAsync();
            return empleados;
        }


        [HttpPost("AsignarMesa/{idMesa}")]
        public async Task<IActionResult> AsignarMesa(int idMesa, [FromBody] int idEmpleado)
        {
            var mesa = await _context.Mesas.FindAsync(idMesa);
            if (mesa == null)
                return NotFound();

            mesa.idEmpleado = idEmpleado;
            mesa.status = 2;

            await _context.SaveChangesAsync();

            return NoContent();
        }


    }
}
