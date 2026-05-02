using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace Domain.Entities
{

    [DataContract]
    public class ProgramaPreDefinido
    {
        [DataMember]
        public string Nome { get; set; }
        [DataMember]
        public string Alimento { get; set; }
        [DataMember]
        public int Tempo { get; set; }
        [DataMember]
        public int Potencia { get; set; }
        [DataMember]
        public char Caractere { get; set; }
        [DataMember]
        public string Instrucoes { get; set; }
        [DataMember]
        public bool EhCustomizado { get; set; }

        public ProgramaPreDefinido() { }

        public ProgramaPreDefinido(string nome, string alimento, int tempo, int potencia, char caractere, string instrucoes, bool ehcustomizado)
        {
            Nome = nome;
            Alimento = alimento;
            Tempo = tempo;
            Potencia = potencia;
            Caractere = caractere;
            Instrucoes = instrucoes;
            EhCustomizado = ehcustomizado;
        }
    }

}
