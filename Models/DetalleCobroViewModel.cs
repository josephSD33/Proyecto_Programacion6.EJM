using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using static DataModels.PviProyectoFinalDBStoredProcedures;

namespace Proyecto_Programacion6.Models
{
    public class DetalleCobroViewModel
    {
        public SpObtenerDetalleCobroResult Cobro { get; set; }
        public List<SpObtenerServiciosPorCobroResult> Servicios { get; set; }
        public List<SpObtenerBitacoraPorCobroResult> Bitacora { get; set; }

        public bool EsEmpleado { get; set; }
    }
}