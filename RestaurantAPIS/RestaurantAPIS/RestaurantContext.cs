using Microsoft.AspNetCore.Mvc.ModelBinding;
using Microsoft.EntityFrameworkCore;
using RestaurantAPIS.Models;

namespace RestaurantAPIS
{
    public class RestaurantContext: DbContext 
    {
        public RestaurantContext(DbContextOptions<RestaurantContext> options) : base(options)
        { }

        public DbSet<Empleado> Empleados{ get; set; }
        public DbSet<Mesa> Mesas{ get; set; }
        public DbSet<Producto> Productos{ get; set; }
        public DbSet<Rol> Roles{ get; set; }
        public DbSet<Topping> Toppings{ get; set; }
        public DbSet<Pedido> Pedidos { get; set; }
        public DbSet<PedidoDetalle> pedidoDetalles { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {

            modelBuilder.Entity<Empleado>(empleado =>
            {
                empleado.ToTable("Empleado");
                empleado.HasKey(e => e.idEmpleado);
                empleado.Property(e => e.idEmpleado).ValueGeneratedOnAdd().UseIdentityColumn();
                empleado.Property(e => e.nombre).IsRequired();
                empleado.Property(e => e.idRol).IsRequired();

                //ciudad.Property(p => p.Nombre).IsRequired().HasMaxLength(150);

            });






            modelBuilder.Entity<Mesa>(mesa =>
            {
                mesa.ToTable("Mesa");
                mesa.HasKey(dv => dv.idMesa);
                mesa.Property(dv => dv.idMesa).ValueGeneratedOnAdd().UseIdentityColumn();
                mesa.Property(dv => dv.idEmpleado);
                mesa.Property(dv => dv.status).IsRequired();



                //Agregar datos iniciales
                //empleado.HasData(empleadoInit);
            });

            modelBuilder.Entity<Producto>(producto =>
            {
                producto.ToTable("Producto");
                producto.HasKey(i => i.idProducto);
                producto.Property(i => i.idProducto).ValueGeneratedOnAdd().UseIdentityColumn();
                producto.Property(i => i.nombre).IsRequired();
                producto.Property(i => i.precio);
                producto.Property(i => i.idTopping);

            });


            modelBuilder.Entity<Rol>(rol =>
            {
                rol.ToTable("Rol");
                rol.HasKey(i => i.idRol);
                rol.Property(i => i.idRol).ValueGeneratedOnAdd().UseIdentityColumn();
                rol.Property(i => i.nombre).IsRequired();

            });

            modelBuilder.Entity<Topping>(produccion =>
            {
                produccion.ToTable("Topping");
                produccion.HasKey(p => p.idTopping);
                produccion.Property(p => p.idTopping).ValueGeneratedOnAdd().UseIdentityColumn();
                produccion.Property(p => p.nombre).IsRequired();

            });




            modelBuilder.Entity<Pedido>(pedido =>
            {
                pedido.ToTable("Pedido");
                pedido.HasKey(e => e.idPedido);
                pedido.Property(e => e.idPedido).ValueGeneratedOnAdd().UseIdentityColumn();
                pedido.Property(e => e.idMesa).IsRequired();
                pedido.Property(e => e.estatus).IsRequired();

            });


            modelBuilder.Entity<PedidoDetalle>(pDetalle =>
            {
                pDetalle.ToTable("PedidoDetalle");
                pDetalle.HasKey(e => e.idDetalle);
                pDetalle.Property(e => e.idDetalle).ValueGeneratedOnAdd().UseIdentityColumn();
                pDetalle.Property(e => e.idPedido).IsRequired();
                pDetalle.Property(e => e.idProducto).IsRequired();

                //ciudad.Property(p => p.Nombre).IsRequired().HasMaxLength(150);

            });



        }
    }
}
