using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RestaurantAPIS.Migrations
{
    /// <inheritdoc />
    public partial class correccionMesa : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "idMesa",
                table: "Empleado");

            migrationBuilder.AddColumn<int>(
                name: "idEmpleado",
                table: "Mesa",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "idEmpleado",
                table: "Mesa");

            migrationBuilder.AddColumn<int>(
                name: "idMesa",
                table: "Empleado",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }
    }
}
