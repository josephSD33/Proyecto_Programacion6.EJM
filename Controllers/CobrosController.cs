using DataModels;
using Proyecto_Programacion6.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using static DataModels.PviProyectoFinalDBStoredProcedures;

namespace Proyecto_Programacion6.Controllers
{
    public class CobrosController : Controller
    {
        private const string EstadoPendiente = "Pendiente";
        private const string EstadoPagado = "Pagado (ya se cobró)";
        private const string EstadoEliminado = "Eliminado";

        private bool EsEmpleado()
        {
            return Session["EsEmpleado"] is bool && (bool)Session["EsEmpleado"];
        }

        private int? IdSesion()
        {
            return Session["IdPersona"] == null ? (int?)null : Convert.ToInt32(Session["IdPersona"]);
        }

        private bool PeriodoFuturo(int mes, int anno)
        {
            return CobroHelper.PeriodoFuturo(mes, anno);
        }

        private string ValidarCobro(SpObtenerCobroBaseResult cobro)
        {
            if (cobro == null) return "No se encontró el cobro.";
            if (cobro.Estado != EstadoPendiente) return "Solo se pueden modificar cobros pendientes.";
            if (!PeriodoFuturo(cobro.Mes, cobro.Anno)) return "El periodo del cobro ya no se puede modificar.";
            return null;
        }

        private ActionResult Volver(string mensaje, string tipo = "danger")
        {
            TempData["Mensaje"] = mensaje;
            TempData["MensajeTipo"] = tipo;
            return RedirectToAction("Gestionar");
        }

        private string TextoBitacora(string accion, string detalle)
        {
            string texto = accion + " - " + detalle;
            return texto.Length > 255 ? texto.Substring(0, 255) : texto;
        }

        // RF-002: Consultar cobros.
        public ActionResult Gestionar(int? idCliente, int? mes, int? anno)
        {
            if (IdSesion() == null) return RedirectToAction("Index", "Authentication");

            bool esEmpleado = EsEmpleado();
            int? idPersona = IdSesion();
            var lista = new List<SpListarCobrosResult>();

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
            catch (Exception)
            {
                ViewBag.Mensaje = "Ocurrió un error al cargar los cobros.";
                ViewBag.MensajeTipo = "danger";
            }

            if (TempData["Mensaje"] != null && ViewBag.Mensaje == null)
            {
                ViewBag.Mensaje = TempData["Mensaje"];
                ViewBag.MensajeTipo = TempData["MensajeTipo"];
            }
            ViewBag.EsEmpleado = esEmpleado;
            ViewBag.Titulo = esEmpleado ? "Gestionar cobros" : "Mis cobros";
            ViewBag.Mes = mes;
            ViewBag.Anno = anno;
            return View(lista);
        }


        public ActionResult Detalle(int id)
        {
            bool esEmpleado = Session["EsEmpleado"] is bool
                && (bool)Session["EsEmpleado"];

            int? idPersona = Session["IdPersona"] as int?;

            if (idPersona == null)
                return new HttpStatusCodeResult(401);

            try
            {
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    var cobro = db.SpObtenerDetalleCobro(id)
                        .FirstOrDefault();

                    if (cobro == null)
                        return HttpNotFound();

                    if (!esEmpleado && cobro.IdPersona != idPersona)
                        return new HttpStatusCodeResult(403);

                    var modelo = new DetalleCobroViewModel
                    {
                        Cobro = cobro,

                        Servicios = db.SpObtenerServiciosPorCobro(id)
                            .ToList(),

                        Bitacora = db.SpObtenerBitacoraPorCobro(id)
                            .ToList(),

                        EsEmpleado = esEmpleado
                    };

                    return PartialView("_DetalleCobro", modelo);
                }
            }
            catch (Exception)
            {
                return new HttpStatusCodeResult(500);
            }
        }


        // RF-003: Crear cobro.
        // Las consultas de servicios se mantienen porque los SP actuales no aceptan una lista de IDs.
        public ActionResult Crear()
        {
            if (IdSesion() == null) return RedirectToAction("Index", "Authentication");

            try
            {
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    bool empleado = EsEmpleado();
                    int? usuario = IdSesion();
                    var clientes = db.SpListarPersonasActivas()
                        .Where(p => empleado || p.Id == usuario)
                        .OrderBy(p => p.Nombre).ToList();

                    ViewBag.Clientes = new SelectList(clientes, "Id", "Nombre",
                        empleado ? (int?)null : usuario);
                    ViewBag.Servicios = db.SpReadServicios()
                        .Where(s => s.Estado).OrderBy(s => s.Nombre).ToList();
                    ViewBag.EsEmpleado = empleado;
                }
            }
            catch (Exception)
            {
                return Volver("No se pudo cargar el formulario.");
            }
            return View();
        }

        [HttpPost]
        public JsonResult Crear(int? idPersona, int? idCasa, int? mes, int? anno, int[] servicios)
        {
            int? usuario = IdSesion();
            if (usuario == null)
                return Json(new { ok = false, mensaje = "Su sesión ha expirado." });

            if (!EsEmpleado()) idPersona = usuario;
            if (idPersona == null || idCasa == null || mes == null || anno == null ||
                servicios == null || servicios.Length == 0)
                return Json(new { ok = false, mensaje = "Complete todos los campos." });

            if (mes < 1 || mes > 12 || anno < 2024 || anno > 2034)
                return Json(new { ok = false, mensaje = "El mes o el año no es válido." });

            try
            {
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    var casa = db.SpObtenerCasaPorId(idCasa).FirstOrDefault();
                    if (casa == null || casa.IdPersona != idPersona)
                        return Json(new { ok = false, mensaje = "La casa no pertenece al cliente." });
                    if (casa.MetrosCuadrados <= 0)
                        return Json(new { ok = false, mensaje = "Los metros cuadrados no son válidos." });

                    var existe = db.SpExisteCobroPendiente(idCasa, mes, anno).FirstOrDefault();
                    if (existe != null && existe.Cantidad > 0)
                        return Json(new { ok = false, mensaje = "Ya existe un cobro pendiente para ese periodo." });

                    var seleccionados = db.SpReadServicios()
                        .Where(s => s.Estado && servicios.Contains(s.Id_servicio)).ToList();
                    if (seleccionados.Count != servicios.Length || servicios.Distinct().Count() != servicios.Length)
                        return Json(new { ok = false, mensaje = "Hay servicios no disponibles o repetidos." });

                    // Usar la misma fórmula en Crear y Editar.
                    decimal monto = CobroHelper.CalcularMonto(
                        casa.Precio, casa.MetrosCuadrados, seleccionados.Select(s => s.Precio));

                    using (var transaccion = db.BeginTransaction())
                    {
                        var resultado = db.SpInsertarCobro(idCasa, mes, anno, monto, null).FirstOrDefault();
                        if (resultado == null || resultado.Id_cobro_creado == null)
                            return Json(new { ok = false, mensaje = "No se pudo registrar el cobro." });

                        int idCobro = Convert.ToInt32(resultado.Id_cobro_creado.Value);
                        foreach (var servicio in seleccionados)
                            db.SpInsertarDetalleCobro(servicio.Id_servicio, idCobro);

                        db.SpInsertarBitacora(TextoBitacora("CREACION",
                        "Casa " + casa.NombreCasa + ", periodo " + mes + "/" + anno +
                        ", monto " + monto.ToString("N2")), idCobro, usuario);
                        transaccion.Commit();
                    }
                }
                return Json(new { ok = true, mensaje = "El cobro se registró correctamente." });
            }
            catch (Exception)
            {
                return Json(new { ok = false, mensaje = "Ocurrió un error al crear el cobro." });
            }
        }

        // Lista de casas para el dropdown de la vista Crear.
        [HttpGet]
        public JsonResult RetornaCasas(int? idPersona)
        {
            if (IdSesion() == null) return Json(new { error = "Sesión expirada" }, JsonRequestBehavior.AllowGet);
            if (!EsEmpleado()) idPersona = IdSesion();
            if (idPersona == null)
                return Json(new List<Dropdown>(), JsonRequestBehavior.AllowGet);

            var resultado = new List<Dropdown>();
            try
            {
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    resultado = db.SpListarCasasPorPersona(idPersona)
                        .Select(c => new Dropdown { id = c.IdCasa, value = c.NombreCasa })
                        .ToList();
                }
            }
            catch (Exception)
            {
                return Json(new { error = "No se pudieron cargar las casas" }, JsonRequestBehavior.AllowGet);
            }
            return Json(resultado, JsonRequestBehavior.AllowGet);
        }

        // RF-004: Modificar cobro.
        public ActionResult Editar(int id)
        {
            if (IdSesion() == null) return RedirectToAction("Index", "Authentication");
            if (!EsEmpleado()) return Volver("No tiene permisos para modificar cobros.");

            try
            {
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    var cobro = db.SpObtenerCobroBase(id).FirstOrDefault();
                    string error = ValidarCobro(cobro);
                    if (error != null) return Volver(error);

                    ViewBag.Cobro = cobro;
                    ViewBag.Servicios = db.SpReadServicios()
                        .Where(s => s.Estado).OrderBy(s => s.Nombre).ToList();
                    ViewBag.SeleccionadosIds = db.SpObtenerServiciosPorCobro(id)
                        .Select(s => s.IdServicio).ToList();
                }
            }
            catch (Exception)
            {
                return Volver("No se pudo cargar el cobro.");
            }
            return View();
        }

        [HttpPost]
        public JsonResult Editar(int idCobro, int[] servicios)
        {
            int? usuario = IdSesion();
            if (usuario == null) return Json(new { ok = false, mensaje = "Su sesión ha expirado." });
            if (!EsEmpleado()) return Json(new { ok = false, mensaje = "No tiene permisos." });
            if (servicios == null || servicios.Length == 0)
                return Json(new { ok = false, mensaje = "Seleccione al menos un servicio." });

            try
            {
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    var cobro = db.SpObtenerCobroBase(idCobro).FirstOrDefault();
                    string error = ValidarCobro(cobro);
                    if (error != null) return Json(new { ok = false, mensaje = error });
                    if (cobro.MetrosCuadrados <= 0)
                        return Json(new { ok = false, mensaje = "Los metros cuadrados no son válidos." });

                    var seleccionados = db.SpReadServicios()
                        .Where(s => s.Estado && servicios.Contains(s.Id_servicio)).ToList();
                    if (seleccionados.Count != servicios.Length || servicios.Distinct().Count() != servicios.Length)
                        return Json(new { ok = false, mensaje = "Hay servicios no disponibles o repetidos." });

                    decimal monto = CobroHelper.CalcularMonto(
                        cobro.PrecioCasa, cobro.MetrosCuadrados, seleccionados.Select(s => s.Precio));

                    using (var transaccion = db.BeginTransaction())
                    {
                        db.SpActualizarMontoCobro(idCobro, monto);
                        db.SpEliminarDetalleCobro(idCobro);
                        foreach (var servicio in seleccionados)
                            db.SpInsertarDetalleCobro(servicio.Id_servicio, idCobro);

                        db.SpInsertarBitacora(TextoBitacora("MODIFICACION",
                        "Casa " + cobro.NombreCasa + ", periodo " + cobro.Mes + "/" +
                        cobro.Anno + ", nuevo monto " + monto.ToString("N2")), idCobro, usuario);
                        transaccion.Commit();
                    }
                }
                return Json(new { ok = true, mensaje = "El cobro se modificó correctamente." });
            }
            catch (Exception)
            {
                return Json(new { ok = false, mensaje = "Ocurrió un error al modificar el cobro." });
            }
        }

        // RF-005: Eliminar cobro (cambio de estado, no borrado físico).
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Eliminar(int id)
        {
            int? usuario = IdSesion();
            if (usuario == null) return RedirectToAction("Index", "Authentication");
            if (!EsEmpleado()) return Volver("No tiene permisos para eliminar cobros.");

            try
            {
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    var cobro = db.SpObtenerCobroBase(id).FirstOrDefault();
                    string error = ValidarCobro(cobro);
                    if (error != null) return Volver(error);

                    using (var transaccion = db.BeginTransaction())
                    {
                        db.SpActualizarEstadoCobro(id, EstadoEliminado, null);
                        db.SpInsertarBitacora(TextoBitacora("CANCELADA",
                        "Se elimina el cobro de la casa " + cobro.NombreCasa +
                        ", periodo " + cobro.Mes + "/" + cobro.Anno), id, usuario);
                        transaccion.Commit();
                    }
                }
                return Volver("El cobro se eliminó correctamente.", "success");
            }
            catch (Exception)
            {
                return Volver("Ocurrió un error al eliminar el cobro.");
            }
        }

        // RF-006: Registrar pago.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Pagar(int id)
        {
            int? usuario = IdSesion();
            if (usuario == null) return RedirectToAction("Index", "Authentication");
            if (!EsEmpleado()) return Volver("No tiene permisos para registrar pagos.");

            try
            {
                using (var db = new PviProyectoFinalDB("MyDatabase"))
                {
                    var cobro = db.SpObtenerCobroBase(id).FirstOrDefault();
                    string error = ValidarCobro(cobro);
                    if (error != null) return Volver(error);

                    using (var transaccion = db.BeginTransaction())
                    {
                        db.SpActualizarEstadoCobro(id, EstadoPagado, DateTime.Today);
                        db.SpInsertarBitacora(TextoBitacora("PAGADO",
                        "Pago de la casa " + cobro.NombreCasa + ", periodo " +
                        cobro.Mes + "/" + cobro.Anno), id, usuario);
                        transaccion.Commit();
                    }
                }
                return Volver("El pago se registró correctamente.", "success");
            }
            catch (Exception)
            {
                return Volver("Ocurrió un error al registrar el pago.");
            }
        }
    }
}
