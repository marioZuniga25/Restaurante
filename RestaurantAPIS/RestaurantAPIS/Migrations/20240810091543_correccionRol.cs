using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace RestaurantAPIS.Migrations
{
    /// <inheritdoc />
    public partial class correccionRol : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_MateriaPrima",
                table: "MateriaPrima");

            migrationBuilder.RenameTable(
                name: "MateriaPrima",
                newName: "Rol");

            migrationBuilder.AddPrimaryKey(
                name: "PK_Rol",
                table: "Rol",
                column: "idRol");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_Rol",
                table: "Rol");

            migrationBuilder.RenameTable(
                name: "Rol",
                newName: "MateriaPrima");

            migrationBuilder.AddPrimaryKey(
                name: "PK_MateriaPrima",
                table: "MateriaPrima",
                column: "idRol");
        }
    }
}
