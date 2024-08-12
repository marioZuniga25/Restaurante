using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RestaurantAPIS.Models;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace RestaurantAPIS.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {


        private readonly RestaurantContext _context;
        public LoginController(RestaurantContext context)
        {
            _context = context;
        }

        [HttpGet("Listado")]
        public async Task<ActionResult<IEnumerable<Empleado>>> GetListadoEmpleados()
        {

            return await _context.Empleados.ToListAsync();

        }

        [HttpGet("Buscar")]
        public async Task<ActionResult<IEnumerable<Empleado>>> SearchEmpleado(string nameEmpleado)
        {
            

            var empleados = await _context.Empleados.Where(u => u.nombre.Equals(nameEmpleado)).ToListAsync();

            if (empleados.Count == 0)
            {
                return NotFound("Empleado no encontrado"); // O puedes usar NoContent() para una respuesta vacía
            }

            return Ok(empleados);
        }

        [HttpPost]
        [Route("AgregarUsuario")]
        public async Task<IActionResult> addUsuario([FromBody] Empleado request)
        {
            
            await _context.Empleados.AddAsync(request);
            await _context.SaveChangesAsync();
            return Ok(request);
        
        }

        [HttpDelete]
        [Route("EliminarUsuario/{id:int}")]
        public async Task<IActionResult> deleteUsuario(int id)
        {
            var usuarioEliminar = await _context.Empleados.FindAsync(id);

            if (usuarioEliminar == null)
            {
                return BadRequest("No se encontro la Materia Prima.");
            }
            _context.Empleados.Remove(usuarioEliminar);

            await _context.SaveChangesAsync();

            return Ok();

        }


        [HttpPut("ModificarEmpleado")]
        public async Task<IActionResult> updateEmpleado(int id, [FromBody] Empleado request)
        {
            var empleadoModificar = await _context.Empleados.FindAsync(id);

            if (empleadoModificar == null)
            {
                return BadRequest("No existe lel Empleado");
            }

            empleadoModificar.nombre= request.nombre;
            empleadoModificar.contrasenia = request.contrasenia;
            empleadoModificar.idRol = request.idRol;


            try
            {
                await _context.SaveChangesAsync();
            }
            catch
            {
                return NotFound();

            }

            return Ok();
        }



    }
}
