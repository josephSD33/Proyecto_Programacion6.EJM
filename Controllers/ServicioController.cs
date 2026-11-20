using DataModels;
using Proyecto_Programacion6.Models;
using Proyecto_Programacion6.Permisos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static DataModels.PviProyectoFinalDBStoredProcedures;

namespace Proyecto_Programacion6.Controllers
{
    public class ServicioController : Controller
    {
        [ValidarSesion]
        public ActionResult Index()
        {
            List<SpReadServiciosResult> lista = new List<SpReadServiciosResult>();

            try
            {
                using (PviProyectoFinalDB db = new PviProyectoFinalDB("MyDatabase"))
                {
                    lista = db.SpReadServicios().ToList();
                }
            }
            catch (Exception ex)
            {
                ViewBag.Mensaje = "Ha ocurrido un error.";
            }

            return View(lista);
        }

        [ValidarSesion]
        public ActionResult Guardar(int id = 0)
        {
            ServicioModel model = new ServicioModel();

            try
            {
                if (id > 0)
                {
                    SpReadServicioByIdResult item = new SpReadServicioByIdResult();

                    using (PviProyectoFinalDB db = new PviProyectoFinalDB("MyDatabase"))
                    {
                        item = db.SpReadServicioById(id).ToList().FirstOrDefault();
                    }

                    if (item != null)
                    {
                        model.Id_servicio = item.Id_servicio;
                        model.Nombre = item.Nombre;
                        model.Descripcion = item.Descripcion;
                        model.Precio = item.Precio;
                        model.Id_categoria = item.Id_categoria;
                        model.Categoria = item.Categoria;
                        model.Estado = item.Estado;
                    }
                    else
                    {
                        ViewBag.resultado = "No se encontro el servicio";
                    }
                }
            }
            catch (Exception ex)
            {
                ViewBag.resultado = "No se ha cargado los datos";
            }

            return View(model);
        }

        [ValidarSesion]
        public ActionResult Inactivar(int id)
        {
            string resultado = "";

            try
            {
                using (PviProyectoFinalDB db = new PviProyectoFinalDB("MyDatabase"))
                {
                    db.SpInactivarServicio(id);
                    resultado = "Se ha guardado los datos";
                }
            }
            catch (Exception ex)
            {
                resultado = "No se ha guardado los datos";
            }

            TempData["resultado"] = resultado;

            return RedirectToAction("Index");
        }

        [HttpPost]
        [ValidarSesion]
        public ActionResult Guardar(ServicioModel m)
        {
            string resultado = "";

            try
            {
                if (m.Precio <= 0)
                {
                    resultado = "El precio debe ser mayor a 0";
                }
                else
                {
                    using (PviProyectoFinalDB db = new PviProyectoFinalDB("MyDatabase"))
                    {
                        if (m.Id_servicio > 0)
                        {
                            db.SpUpdateServicio(m.Id_servicio, m.Descripcion, m.Precio);
                            resultado = "Se ha guardado los datos";
                        }
                        else
                        {
                            db.SpInsertServicio(m.Nombre, m.Descripcion, m.Precio, m.Id_categoria);
                            resultado = "Se ha guardado los datos";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                resultado = "No se ha guardado los datos";
            }

            ViewBag.resultado = resultado;

            return View(m);
        }

        [ValidarSesion]
        public JsonResult ObtenerCategorias()
        {
            try
            {
                List<Dropdown> lista = new List<Dropdown>();

                using (PviProyectoFinalDB db = new PviProyectoFinalDB("MyDatabase"))
                {
                    lista = db.SpReadCategorias()
                        .Select(_ => new Dropdown
                        {
                            id = _.IdCategoria,
                            value = _.Nombre
                        }).ToList();
                }

                return Json(lista, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new List<Dropdown>(), JsonRequestBehavior.AllowGet);
            }
        }
        [ValidarSesion]
        public ActionResult MisServicios()
        {
            List<SpReadServiciosByClienteResult> lista = new List<SpReadServiciosByClienteResult>();

            try
            {
                if (Session["id_persona"] != null)
                {
                    using (PviProyectoFinalDB db = new PviProyectoFinalDB("MyDatabase"))
                    {
                        lista = db.SpReadServiciosByCliente(Convert.ToInt32(Session["id_persona"])).ToList();
                    }
                }
                else
                {
                    ViewBag.Mensaje = "No hay una sesión activa.";
                }
            }
            catch (Exception ex)
            {
                ViewBag.Mensaje = "Ha ocurrido un error.";
            }

            return View(lista);
        }
    }

}