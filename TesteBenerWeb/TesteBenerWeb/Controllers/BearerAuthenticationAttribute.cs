using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Configuration;

namespace TesteBenerWeb.Controllers
{
    public class BearerAuthenticationAttribute : ActionFilterAttribute
    {

        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (filterContext.HttpContext.Request.HttpMethod == "OPTIONS")
            {
                filterContext.HttpContext.Response.StatusCode = 200;
                filterContext.Result = new EmptyResult();
                return;
            }

            string tokenValido = ConfigurationManager.AppSettings["AuthTokenBearer"];

            var request = filterContext.HttpContext.Request;
            var authHeader = request.Headers["Authorization"];

            if (string.IsNullOrEmpty(authHeader) || !authHeader.StartsWith("Bearer ") || authHeader.Substring(7) != tokenValido)
            {
                filterContext.HttpContext.Response.StatusCode = 401;

                filterContext.HttpContext.Response.TrySkipIisCustomErrors = true;

                filterContext.Result = new JsonResult
                {
                    Data = new { success = false, message = "Token Inválido ou Ausente" },
                    JsonRequestBehavior = JsonRequestBehavior.AllowGet
                };
             
            }

        }
    }
}