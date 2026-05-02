using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Domain.Exceptions
{
    public class ErrorResponse
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string ExceptionType { get; set; }

    }
}
