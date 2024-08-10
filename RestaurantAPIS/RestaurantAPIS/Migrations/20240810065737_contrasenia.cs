using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RestaurantAPIS.Migrations
{
    /// <inheritdoc />
    public partial class contrasenia : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "contrasenia",
                table: "Empleado",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "contrasenia",
                table: "Empleado");
        }
    }
}
