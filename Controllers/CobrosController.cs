using DataModels;
using Proyecto_Programacion6.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static DataModels.PviProyectoFinalDBStoredProcedures;

namespace Proyecto_Programacion6.Controllers
{
    public class CobrosController : Controller
    {
        // GET: Cobros
        
        public ActionResult Gestionar(int? idCliente, int? mes, int? anno)
        {
            bool esEmpleado = Session["EsEmpleado"] != null && (bool)Session["EsEmpleado"];
            int? idPersona = Session["IdPersona"] as int?;


            List<SpListarCobrosResult> lista = new List<SpListarCobrosResult>().ToList();
            try
            {
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    if (esEmpleado)
                    {
                        lista = db.SpListarCobros(idCliente, mes, anno).ToList();
                        ViewBag.Clientes = new SelectList(
                            db.SpListarPersonasActivas().ToList(), "Id", "Nombre", idCliente);
                    }
                    else
                    {
                        lista = db.SpListarCobros(idPersona, null, null).ToList();
                    }
                }
            }
            catch
            {

            }
            ViewBag.EsEmpleado = esEmpleado;
            ViewBag.Titulo = esEmpleado ? "Gestionar cobros" : "Mis cobros";
            ViewBag.Mes = mes;
            ViewBag.Anno = anno;
            return View(lista);

        }

        public ActionResult Detalle(int id)
        {
            bool esEmpleado = Session["EsEmpleado"] != null && (bool)Session["EsEmpleado"];
            int? idPersona = Session["IdPersona"] as int?;

            string resultado = "";
            DetalleCobroViewModel modelo = new DetalleCobroViewModel();

            try
            {
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    var cobro = db.SpObtenerDetalleCobro(id).FirstOrDefault();

                    if (cobro == null)
                    {
                        resultado = "No se encontró el cobro.";
                    }
                    else if (!esEmpleado && cobro.IdPersona != idPersona)
                    {
                        resultado = "No tiene permisos para consultar este cobro.";
                    }
                    else
                    {
                        modelo.Cobro = cobro;
                        modelo.Servicios = db.SpObtenerServiciosPorCobro(id).ToList();
                        modelo.Bitacora = db.SpObtenerBitacoraPorCobro(id).ToList();
                        modelo.EsEmpleado = esEmpleado;

                        return PartialView("_DetalleCobro", modelo);
                    }
                }
            }
            catch (Exception ex)
            {
                resultado = "Ha ocurrido un error al cargar el detalle del cobro.";
            }

            ViewBag.resultado = resultado;

            return PartialView("_DetalleCobro", modelo);
        }



    }
}
