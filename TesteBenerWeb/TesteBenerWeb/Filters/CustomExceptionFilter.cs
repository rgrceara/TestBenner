using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using Domain.Exceptions;
using System.IO;
using System.Web.Mvc;

namespace TesteBenerWeb.Filters
{
    public class CustomExceptionFilter : HandleErrorAttribute
    {
        public override void OnException(ExceptionContext filterContext)
        {
            if (filterContext.ExceptionHandled) return;

            var exception = filterContext.Exception;

            LogExceptionToFile(exception);

            if (filterContext.HttpContext.Request.IsAjaxRequest())
            {
                var statusCode = (exception is BusinessException) ? 400 : 500;

                filterContext.Result = new JsonResult
                {
                    Data = new
                    {
                        Success = false,
                        Message = exception.Message,
                        ExceptionType = exception.GetType().Name
                    },
                    JsonRequestBehavior = JsonRequestBehavior.AllowGet
                };

                filterContext.HttpContext.Response.StatusCode = statusCode;
                filterContext.ExceptionHandled = true;
            }
            else
            {
                base.OnException(filterContext);
            }
        }

        private void LogExceptionToFile(Exception ex)
        {
            string logPath = HttpContext.Current.Server.MapPath("~/App_Data/error_logs.txt");

            string logContent = "--------------------------------------------------\n" +
                                "Data: " + DateTime.Now.ToString() + "\n" +
                                "Exception: " + ex.Message + "\n" +
                                "Inner Exception: " + (ex.InnerException != null ? ex.InnerException.Message : "N/A") + "\n" +
                                "StackTrace: " + ex.StackTrace + "\n" +
                                "--------------------------------------------------\n";

            File.AppendAllText(logPath, logContent);
        }
        
    }
}