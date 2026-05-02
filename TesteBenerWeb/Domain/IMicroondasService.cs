using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Domain
{
    public interface IMicroondasService
    {
        string IniciarAquecimento(int tempo, int potencia);
    }

}
