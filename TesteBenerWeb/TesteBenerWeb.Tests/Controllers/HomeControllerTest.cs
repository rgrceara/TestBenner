using System.Web.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using TesteBenerWeb.Controllers;
using System.Web;
using System.IO;
using System.Web.Routing;
using System;

namespace TesteBenerWeb.Tests
{
    [TestClass]
    public class HomeControllerTest
    {
        private HomeController _controller;

        [TestInitialize]
        public void Setup()
        {
            _controller = new HomeController();

            var context = new FakeHttpContext();

            _controller.ControllerContext = new ControllerContext(
                context,
                new RouteData(),
                _controller
            );
        }


        public class FakeServer : HttpServerUtilityBase
        {
            public override string MapPath(string path)
            {
                return Path.GetTempPath();
            }
        }

        public class FakeRequest : HttpRequestBase
        {
        }

        public class FakeHttpContext : HttpContextBase
        {
            private HttpServerUtilityBase _server = new FakeServer();
            private HttpRequestBase _request = new FakeRequest();

            public override HttpServerUtilityBase Server
            {
                get { return _server; }
            }

            public override HttpRequestBase Request
            {
                get { return _request; }
            }
        }


        private object GetProperty(object obj, string propName)
        {
            return obj.GetType().GetProperty(propName).GetValue(obj, null);
        }


        [TestMethod]
        public void Test_Iniciar_Aquecimento_Simples_30s()
        {
            string tempo = "";
            string potencia = "10";

            JsonResult result = _controller.Iniciar(tempo, potencia, false, false, false);

            object data = result.Data;

            Assert.AreEqual(true, GetProperty(data, "Sucesso"));
            Assert.AreEqual(30, GetProperty(data, "SegundosTotais"));
            Assert.AreEqual("Aquecimento iniciado", GetProperty(data, "Mensagem"));
        }

        [TestMethod]
        public void Test_Iniciar_Com_Potencia_Customizada()
        {
            string potencia = "5";

            JsonResult result = _controller.Iniciar("90", potencia, false, false, false);

            object data = result.Data;

            Assert.AreEqual(5, GetProperty(data, "PotenciaUtilizada"));
            Assert.AreEqual(90, GetProperty(data, "SegundosTotais"));
        }

        [TestMethod]
        public void Test_ValidarConexao_Deve_Retornar_Sucesso()
        {
            JsonResult result = _controller.ValidarConexao();

            object data = result.Data;

            Assert.AreEqual(true, GetProperty(data, "success"));
            Assert.AreEqual("Conectado à API", GetProperty(data, "message"));
        }

        [TestMethod]
        public void Test_About_Deve_Retornar_View()
        {
            ViewResult result = _controller.About() as ViewResult;

            Assert.IsNotNull(result);
        }
    }
}