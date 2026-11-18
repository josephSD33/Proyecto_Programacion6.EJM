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
    public class AccountController : Controller
    {
        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Login(UsuarioLogin usuario)
        {
            if (string.IsNullOrWhiteSpace(usuario.Email) ||
                string.IsNullOrWhiteSpace(usuario.Contrasena))
            {
                ViewBag.Error = "Debe ingresar el email y la clave";
                return View();
            }

            SpLoginResult user;

            using (var db = new PviProyectoFinalDB("MyDatabase"))
            {
                user = db.SpLogin(usuario.Email, usuario.Contrasena).FirstOrDefault();
            }

            if (user == null)
            {
                ViewBag.Error = "Los datos ingresados no son correctos";
                return View();
            }

            Session["IdPersona"] = user.Id_persona;
            Session["NombreCompleto"] = user.Nombre_completo;
            Session["EsEmpleado"] = user.Es_empleado == true;

            return RedirectToAction("Index", "Home");
        }

        // GET: Account/Logout
        public ActionResult Logout()
        {
            Session.Clear();
            Session.Abandon();
            return RedirectToAction("Login");
        }
    }
}
///hola