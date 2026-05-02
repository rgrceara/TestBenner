using System;
using System.Collections.Generic;
using System.IO;
using Domain.Entities;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Linq;

namespace Infrastructure
{
    public class ProgramaRepository
    {
        private readonly string _caminhoArquivo;
        private static readonly object _lock = new object();
        private static List<ProgramaCustomizado> _programas = new List<ProgramaCustomizado>();

        public static List<ProgramaPreDefinido> GetProgramasIniciais()
        {
            return new List<ProgramaPreDefinido>
        {
            new ProgramaPreDefinido("Pipoca", "Pipoca (de micro-ondas)", 180, 7, '*', "Observar o barulho de estouros do milho, caso houver um intervalor de mais de 10 segundos entre um estouro e outro, interrompa o aquecimento.", false),
            new ProgramaPreDefinido("Leite", "Leite", 300, 5, '~', "Cuidado com o aquecimento de líquidos, o choque térmico aliado ao movimento do recipiente pode causar fervura imediata causando riscos de queimadura.", false),
            new ProgramaPreDefinido("Carne de boi", "Carne em pedaços ou fatias", 840, 4, '@', "Interrompa na metade e vire o conteúdo com a parte de baixo para cima para o descongelamento uniforme.", false),
            new ProgramaPreDefinido("Frango", "Frango (qualquer corte)", 480, 7, '^', "Interrompa na metade e vire o conteúdo com a parte de baixo para cima para o descongelamento uniforme.", false),
            new ProgramaPreDefinido("Feijão", "Feijão congelado", 480, 9, '#', "Deixe o recipiente destampado e em casos de plástico, cuidado ao retirar o recipiente pois o mesmo pode perder resistência em altas temperaturas.", false)
        };
        }


        public ProgramaRepository()
        {
            // Define o caminho para a pasta App_Data do projeto Web
            _caminhoArquivo = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "App_Data", "programas_customizados.json");
            
            // Garante que o diretório App_Data exista
            string pasta = Path.GetDirectoryName(_caminhoArquivo);
            if (!Directory.Exists(pasta)) Directory.CreateDirectory(pasta);
        }

        public List<ProgramaCustomizado> ListarTodos()
        {
            if (!File.Exists(_caminhoArquivo)) return new List<ProgramaCustomizado>();

            lock (_lock)
            {
                try
                {
                    string json = File.ReadAllText(_caminhoArquivo);
                    if (string.IsNullOrWhiteSpace(json)) return new List<ProgramaCustomizado>();

                    using (var ms = new MemoryStream(Encoding.UTF8.GetBytes(json)))
                    {
                        var serializer = new DataContractJsonSerializer(typeof(List<ProgramaCustomizado>));
                        var programas = (List<ProgramaCustomizado>)serializer.ReadObject(ms);

                        if (programas != null)
                        {
                            foreach (var p in programas)
                            {
                                p.EhCustomizado = true;
                            }
                        }

                        return programas ?? new List<ProgramaCustomizado>();
                    }
                }
                catch
                {
                    return new List<ProgramaCustomizado>();
                }
            }
        }

        public void Salvar(ProgramaCustomizado novoPrograma)
        {
            lock (_lock)
            {
                var lista = ListarTodos();
                lista.Add(novoPrograma);

                using (var ms = new MemoryStream())
                {
                    var serializer = new DataContractJsonSerializer(typeof(List<ProgramaCustomizado>));
                    serializer.WriteObject(ms, lista);

                    ms.Position = 0;
                    using (var sr = new StreamReader(ms))
                    {
                        string jsonLimpo = sr.ReadToEnd();
                        File.WriteAllText(_caminhoArquivo, jsonLimpo, Encoding.UTF8);
                    }
                }
            }
        }

        public void Atualizar(string nomeOriginal, ProgramaCustomizado programaAtualizado)
        {
            var lista = ListarTodos();

            lock (_lock)
            {
             
                int index = lista.FindIndex(x => x.Nome.Equals(nomeOriginal, StringComparison.OrdinalIgnoreCase));

                if (index != -1)
                {
                    programaAtualizado.EhCustomizado = true;
                    lista[index] = programaAtualizado;

                    using (var ms = new MemoryStream())
                    {
                        var serializer = new DataContractJsonSerializer(typeof(List<ProgramaCustomizado>));
                        serializer.WriteObject(ms, lista);

                        ms.Position = 0;
                        using (var sr = new StreamReader(ms))
                        {
                            string jsonLimpo = sr.ReadToEnd();
                            File.WriteAllText(_caminhoArquivo, jsonLimpo, Encoding.UTF8);
                        }
                    }
                }
                else
                {
                    throw new Exception("Programa original não encontrado para edição.");
                }
            }
        }


        public void Excluir(char caractere)
        {
            var lista = ListarTodos();

            lock (_lock)
            {
                
                int index = lista.FindIndex(x => x.Caractere == caractere);

                if (index != -1)
                {
                    lista.RemoveAt(index);

                    using (var ms = new MemoryStream())
                    {
                        var serializer = new DataContractJsonSerializer(typeof(List<ProgramaCustomizado>));
                        serializer.WriteObject(ms, lista);

                        
                        ms.Position = 0;
                        
                        using (var fileStream = new FileStream(_caminhoArquivo, FileMode.Create, FileAccess.Write))
                        {
                            ms.CopyTo(fileStream);
                        }
                    }
                }
                else
                {
                    throw new Exception("Programa não encontrado para exclusão.");
                }
            }
        }


    }

}
