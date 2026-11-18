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

            try
            {
                
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    var cobro = db.SpObtenerDetalleCobro(id).FirstOrDefault();

                    if (cobro == null || (!esEmpleado && cobro.IdPersona != idPersona))
                    {
                        return new HttpStatusCodeResult(403);
                    }

                    var modelo = new DetalleCobroViewModel
                    {
                        
                        Cobro = cobro,
                        Servicios = db.SpObtenerServiciosPorCobro(id).ToList(),
                        Bitacora = db.SpObtenerBitacoraPorCobro(id).ToList(),
                        EsEmpleado = esEmpleado
                    };
                    return PartialView("_DetalleCobro", modelo);
                }
            }
            catch(Exception ex) 
            {
                    return new HttpStatusCodeResult(500);
            }
        }        



    }
}
