using DataModels;
using Proyecto_Programacion6.Permisos;
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
        // GET: Casaa

        
        public ActionResult Index()
        {
            List<SpReadCasasResult> lista = new List<SpReadCasasResult>();

            try
            {
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    lista= db.SpReadCasas().ToList();
                }
            }
            catch
            {
                ViewBag.Mensaje = "Ha ocurrido un error.";
            }
            
            return View(lista);
        }


        public ActionResult Crear()
        {

            return View();
        }
    }
}