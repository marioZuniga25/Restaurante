﻿// <auto-generated />
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using RestaurantAPIS;

#nullable disable

namespace RestaurantAPIS.Migrations
{
    [DbContext(typeof(RestaurantContext))]
    partial class RestaurantContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "8.0.7")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("RestaurantAPIS.Models.Empleado", b =>
                {
                    b.Property<int>("idEmpleado")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("idEmpleado"));

                    b.Property<string>("contrasenia")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("idRol")
                        .HasColumnType("int");

                    b.Property<string>("nombre")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("idEmpleado");

                    b.ToTable("Empleado", (string)null);
                });

            modelBuilder.Entity("RestaurantAPIS.Models.Mesa", b =>
                {
                    b.Property<int>("idMesa")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("idMesa"));

                    b.Property<int>("idEmpleado")
                        .HasColumnType("int");

                    b.Property<int>("status")
                        .HasColumnType("int");

                    b.HasKey("idMesa");

                    b.ToTable("Mesas", (string)null);
                });

            modelBuilder.Entity("RestaurantAPIS.Models.Pedido", b =>
                {
                    b.Property<int>("idPedido")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("idPedido"));

                    b.Property<int>("estatus")
                        .HasColumnType("int");

                    b.Property<int>("idMesa")
                        .HasColumnType("int");

                    b.HasKey("idPedido");

                    b.ToTable("Pedido", (string)null);
                });

            modelBuilder.Entity("RestaurantAPIS.Models.PedidoDetalle", b =>
                {
                    b.Property<int>("idDetalle")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("idDetalle"));

                    b.Property<int>("idPedido")
                        .HasColumnType("int");

                    b.Property<int>("idProducto")
                        .HasColumnType("int");

                    b.HasKey("idDetalle");

                    b.ToTable("PedidoDetalle", (string)null);
                });

            modelBuilder.Entity("RestaurantAPIS.Models.Producto", b =>
                {
                    b.Property<int>("idProducto")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("idProducto"));

                    b.Property<string>("descricion")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("idTopping")
                        .HasColumnType("int");

                    b.Property<string>("nombre")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("precio")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("idProducto");

                    b.ToTable("Producto", (string)null);
                });

            modelBuilder.Entity("RestaurantAPIS.Models.Rol", b =>
                {
                    b.Property<int>("idRol")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("idRol"));

                    b.Property<string>("nombre")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("idRol");

                    b.ToTable("Rol", (string)null);
                });

            modelBuilder.Entity("RestaurantAPIS.Models.Topping", b =>
                {
                    b.Property<int>("idTopping")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("idTopping"));

                    b.Property<string>("nombre")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("idTopping");

                    b.ToTable("Topping", (string)null);
                });
#pragma warning restore 612, 618
        }
    }
}
