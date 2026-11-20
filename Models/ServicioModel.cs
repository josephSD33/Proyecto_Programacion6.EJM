using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Proyecto_Programacion6.Models
{
    public class ServicioModel
    {
        public int Id_servicio { get; set; }

        [Required]
        public string Nombre { get; set; }

        public string Descripcion { get; set; }

        [Required]
        public decimal Precio { get; set; }

        [Required]
        public int Id_categoria { get; set; }

        public string Categoria { get; set; }

        public bool Estado { get; set; }
    }
}
