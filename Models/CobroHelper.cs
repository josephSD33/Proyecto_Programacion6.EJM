
using System;
using System.Collections.Generic;
using System.Linq;

namespace Proyecto_Programacion6.Models
{
    public static class CobroHelper
    {
        public static bool PeriodoFuturo(int mes, int anno)
        {
            DateTime hoy = DateTime.Today;

            return anno > hoy.Year ||
                (anno == hoy.Year && mes > hoy.Month);
        }

        public static bool TieneServicios(List<int> servicios)
        {
            return servicios != null &&
                   servicios.Count > 0;
        }

        public static decimal CalcularMonto(
            decimal precioCasa,
            decimal metrosCuadrados,
            IEnumerable<decimal> preciosServicios)
        {
            if (metrosCuadrados <= 0)
                throw new ArgumentException(
                    "Los metros cuadrados deben ser mayores a cero.");

            decimal totalServicios = preciosServicios.Sum();

            return Math.Round(
                precioCasa / metrosCuadrados + totalServicios, 2);
        }
    }
}
