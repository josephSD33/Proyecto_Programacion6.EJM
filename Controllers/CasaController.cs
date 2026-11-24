using DataModels;
using Proyecto_Programacion6.Permisos;
using ProyectoCondominio.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static DataModels.PviProyectoFinalDBStoredProcedures;

namespace Proyecto_Programacion6.Controllers
{
    public class CasaController : Controller
    {
        private bool EsEmpleado()
        {
            return Session["EsEmpleado"] != null && (bool)Session["EsEmpleado"];
        }

        // GET: Casa (lista de casas)
        public ActionResult Index()
        {
            if (!EsEmpleado())
            {
                return RedirectToAction("Gestionar", "Cobros");
            }

            List<SpReadCasasResult> lista = new List<SpReadCasasResult>();

            try
            {
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    lista = db.SpReadCasas().ToList();
                }
            }
            catch
            {
                ViewBag.Mensaje = "Ha ocurrido un error.";
            }

            return View(lista);
        }

    
        [HttpGet]
        public ActionResult Crear()
        {
            if (!EsEmpleado())
            {
                return RedirectToAction("Gestionar", "Cobros");
            }

            return View(new CasaModel());
        }

        
        [HttpPost]
        public JsonResult RetornaDuenos()
        {
            try
            {
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    var resultado = db.SpListarPersonasActivas()
                        .Select(p => new { Id = p.Id, Nombre = p.Nombre })
                        .ToList();
                    return Json(resultado);
                }
            }
            catch
            {
                return Json(new { error = "No se pudieron cargar los dueños." });
            }
        }

        
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Crear(CasaModel m)
        {
            if (!EsEmpleado())
            {
                return RedirectToAction("Gestionar", "Cobros");
            }

            try
            {
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    
                    db.SpInsertCasa(m.Nombre_casa, m.Metros_cuadrados, m.Numero_habitaciones,
                                    m.Numero_banos, m.NumeroPropietario, m.Fecha_construccion);
                }

                TempData["Exito"] = "La casa se registró correctamente.";
                return RedirectToAction("Exito");
            }
            catch (Exception)
            {
                ViewBag.Mensaje = "No se pudo guardar la casa.";
            }

            return View(m);
        }

        //pantalla con el mensaje de que todo salio bien
        public ActionResult Exito()
        {
            if (!EsEmpleado())
            {
                return RedirectToAction("Gestionar", "Cobros");
            }

            if (TempData["Exito"] == null)
            {
                return RedirectToAction("Index");
            }

            ViewBag.Mensaje = TempData["Exito"];
            return View();
        }
    }
}