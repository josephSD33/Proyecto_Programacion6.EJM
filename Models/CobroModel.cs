
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace Proyecto_Programacion6.Models
{
    public class CobroModel
    {
        public int Id_cobro { get; set; }

        [Range(1, int.MaxValue,
            ErrorMessage = "Seleccione un cliente.")]
        public int Id_cliente { get; set; }

        [Range(1, int.MaxValue,
            ErrorMessage = "Seleccione una casa.")]
        public int Id_casa { get; set; }

        [Range(2024, 2034)]
        public int Anno { get; set; }

        [Range(1, 12)]
        public int Mes { get; set; }

        public string Estado { get; set; }

        public List<int> ServiciosSeleccionados { get; set; }
            = new List<int>();

        public List<SelectListItem> ListaMeses { get; set; }
            = new List<SelectListItem>();

        public List<SelectListItem> ListaAnnos { get; set; }
            = new List<SelectListItem>();
    }
}
