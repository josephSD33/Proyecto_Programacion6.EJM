using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace ProyectoCondominio.Models
{
    public class CasaModel
    {
        public int Id_casa { get; set; }

        [Required]
        public string Nombre_casa { get; set; }

        [Required]
        public int Metros_cuadrados { get; set; }

        [Required]
        public int Numero_habitaciones { get; set; }

        [Required]
        public int Numero_banos { get; set; }

        [Required]
        public int NumeroPropietario { get; set; }

        [Required]
        public DateTime Fecha_construccion { get; set; }

        public bool? Estado { get; set; }
    }
}
