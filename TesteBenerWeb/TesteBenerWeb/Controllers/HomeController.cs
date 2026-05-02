using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Infrastructure;
using System.Web.Script.Serialization;
using Domain.Entities;
using System.Configuration;
using Domain.Exceptions;
using TesteBenerWeb.Filters;


namespace TesteBenerWeb.Controllers
{
    [CustomExceptionFilter]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {

            ProgramaRepository programasrepo = new ProgramaRepository();
            var programasCustomizados = programasrepo.ListarTodos();
            var programasIniciais = ProgramaRepository.GetProgramasIniciais();
            var programas = programasIniciais.Concat(programasCustomizados).ToList();
            var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            ViewData["ProgramasJson"] = serializer.Serialize(programas);
            ViewData["ProgramasJsonCustomizados"] = serializer.Serialize(programasCustomizados);

            return View();
        }

        public ActionResult About()
        {
            return View();
        }


        [HttpPost]
        [BearerAuthentication] 
        public JsonResult ValidarConexao()
        {
            return Json(new { success = true, message = "Conectado à API" });
        }


        [HttpPost]
        [BearerAuthentication]
        public JsonResult Iniciar(string tempo, string potencia, bool jaEstaAquecendo, bool preprograma, bool ehCustomizado)
        {
            
            try
            {
                int t = string.IsNullOrEmpty(tempo) ? 0 : int.Parse(tempo);
                int p = string.IsNullOrEmpty(potencia) ? 10 : int.Parse(potencia);
                bool pre = preprograma;

                if (ehCustomizado)
                {

                    int segundos = t % 100;

                    int minutos = t / 100;

                    t = (minutos * 60) + segundos;

                }

                if (preprograma && !jaEstaAquecendo && t >= 100 && !ehCustomizado)
                {
                    t = (t / 100) * 60;
                }

                if (t == 0 || jaEstaAquecendo && !preprograma) t += 30;

                var aquecedor = new Domain.Aquecedor();
                aquecedor.Configurar(t, p, pre);

                return Json(new
                {
                    Sucesso = true,
                    SegundosTotais = t,
                    PotenciaUtilizada = p,
                    TempoFormatado = aquecedor.TempoExibido,
                    Mensagem = "Aquecimento iniciado"
                });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, Mensagem = ex.Message });
            }
        }

        [HttpPost]
        [BearerAuthentication]
        public JsonResult SalvarPrograma()
        {
            try
            {

                string json;
                using (var reader = new System.IO.StreamReader(Request.InputStream))
                {
                    json = reader.ReadToEnd();
                }

                var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                var novo = serializer.Deserialize<ProgramaCustomizado>(json);

                if (novo == null || string.IsNullOrEmpty(novo.Caractere.ToString().Trim()))
                {
                    return Json(new { success = false, message = "Dados inválidos ou vazios." });
                }

                string caminhoArquivo = Server.MapPath("~/App_Data/programas_customizados.json");
                var fixos = ProgramaRepository.GetProgramasIniciais(); 

                if (novo.Caractere == '.' || fixos.Any(f => f.Caractere.ToString() == novo.Caractere.ToString()))
                {
                    return Json(new { success = false, message = "Caractere já utilizado por um programa padrão." });
                }

                List<ProgramaCustomizado> customizados = new List<ProgramaCustomizado>();
                if (System.IO.File.Exists(caminhoArquivo))
                {
                    string conteudo = System.IO.File.ReadAllText(caminhoArquivo);
                    customizados = new System.Web.Script.Serialization.JavaScriptSerializer()
                                        .Deserialize<List<ProgramaCustomizado>>(conteudo) ?? new List<ProgramaCustomizado>();
                }

                if (customizados.Any(c => c.Caractere == novo.Caractere))
                {
                    return Json(new { success = false, message = "Este caractere já foi cadastrado em outro programa customizado." });
                }

                var repo = new ProgramaRepository();
                repo.Salvar(novo);

                return Json(new { success = true });

            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Erro interno: " + ex.Message });
            }
        }

        [HttpGet]
        [BearerAuthentication]
        public JsonResult ListarProgramasCustomizados()
        {
            try
            {
                string caminhoArquivo = Server.MapPath("~/App_Data/programas_customizados.json");
                if (!System.IO.File.Exists(caminhoArquivo))
                {
                    return Json(new List<ProgramaCustomizado>(), JsonRequestBehavior.AllowGet);
                }

                string conteudo = System.IO.File.ReadAllText(caminhoArquivo);
                var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                var lista = serializer.Deserialize<List<ProgramaCustomizado>>(conteudo) ?? new List<ProgramaCustomizado>();

                return Json(lista, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                return Json(new { erro = true }, JsonRequestBehavior.AllowGet);
            }
        }

        public class EditarProgramaRequest
        {
            public string nomeOriginal { get; set; }
            public ProgramaCustomizado programa { get; set; }
        }



        [HttpPost]
        [BearerAuthentication]
        public JsonResult EditarPrograma()
        {
            var reader = new System.IO.StreamReader(Request.InputStream);
            var jsonString = reader.ReadToEnd();
            var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            var data = serializer.Deserialize<EditarProgramaRequest>(jsonString);

            var repo = new ProgramaRepository();
            var lista = repo.ListarTodos();
            var programaExistente = lista.FirstOrDefault(p => p.Nome.Equals(data.nomeOriginal, StringComparison.OrdinalIgnoreCase));

            if (programaExistente != null)
            {
                if (data.programa.Caractere != programaExistente.Caractere)
                {
                    return Json(new { success = false, message = "O caractere identificador não pode ser alterado." });
                }
            }

            repo.Atualizar(data.nomeOriginal, data.programa);
            return Json(new { success = true });
        }


        public class ExcluirProgramaRequest
        {
            public string nome { get; set; }
            public string caractere { get; set; }
        }

        [HttpPost]
        [BearerAuthentication]
        public JsonResult ExcluirPrograma() 
        {
            try
            {
                var reader = new System.IO.StreamReader(Request.InputStream);
                var jsonString = reader.ReadToEnd();

                var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                var data = serializer.Deserialize<ExcluirProgramaRequest>(jsonString);

                if (data == null || string.IsNullOrEmpty(data.caractere))
                {
                    return Json(new { success = false, message = "Caractere não informado ou inválido." });
                }
                
                char car = data.caractere[0];

                ProgramaRepository repo = new ProgramaRepository();
                repo.Excluir(car);

                return Json(new { success = true });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Erro ao excluir: " + ex.Message });
            }
        }

        [HttpPost]
        [BearerAuthentication]
        public JsonResult Cancelar()
        {
            return Json(new { success = true, message = "Aquecimento interrompido." });
        }
      
    }
}
