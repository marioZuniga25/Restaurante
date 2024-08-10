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

    }
}
