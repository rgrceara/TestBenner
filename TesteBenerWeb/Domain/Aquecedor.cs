using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Domain
{
    public class Aquecedor
    {
        public int Tempo { get; private set; }
        public int Potencia { get; private set; }
        public string TempoExibido { get; private set; }


        private const int TEMPO_MAXIMO = 120;
        private const int TEMPO_MINIMO = 1;
        private const int POTENCIA_PADRAO = 10;
        


       public void Configurar(int segundos, int potencia, bool preprograma)
       {
           if (segundos < TEMPO_MINIMO || segundos > TEMPO_MAXIMO && !preprograma)
               throw new ArgumentException("Informe um tempo válido entre 1 segundo e 2 minutos.");

           if (potencia < 1 || potencia > 10 && !preprograma)
               throw new ArgumentException("Informe a potência entre 1 e 10");


           if (segundos >= 60 && !preprograma )
           {
               int minutos = segundos / 60;
               int restantes = segundos % 60;
               this.TempoExibido = minutos + ":" + restantes.ToString("D2");
           }
           else
           {
               this.TempoExibido = segundos.ToString();
           }
       }

       public string Iniciar()
       {
           return "Aquecimento iniciado. Tempo: " + Tempo + "s | Potência: " + Potencia;
       }


       public string GerarStringAquecimento(int tempo, int potencia, bool preprograma)
       {
           StringBuilder sb = new StringBuilder();

           for (int i = 0; i < tempo; i++)
           {
               sb.Append(new string('.', potencia));
               sb.Append(" "); 
           }

           sb.Append("Aquecimento concluído");
           return sb.ToString();
       }
    }
}
