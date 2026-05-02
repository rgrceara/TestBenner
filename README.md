# Desafio Micro-ondas - Teste Bener Web

Este projeto é uma aplicação de simulação de micro-ondas desenvolvida para gerenciar programas de aquecimento personalizados e padrões via interface web e backend robusto.

## 🛠️ Tecnologias e Ferramentas

*   **Linguagem:** C#.
*   **Framework Backend:** ASP.NET MVC 2.0 / .NET Framework 4.0.
*   **Frontend:** HTML, CSS3 e JavaScript puro (Vanilla JS).
*   **Data Handling:** JSON para persistência de programas customizados e logs.
*   **Testes:** MSTest com mocks manuais (compatibilidade .NET 4.0).

## 🚀 Instalação e Uso

### Pré-requisitos
*   Visual Studio 2010 ou superior.
*   Internet Information Services (IIS) ou IIS Express configurado.
*   Target Framework: .NET Framework 4.0 instalado no servidor/máquina de desenvolvimento.

### Passo a Passo
1.  **Clonar o Repositório:**
    ```bash git clone https://github.com/rgrceara/TestBenner.git
    ```

2.  **Configurar Permissões:**
    *   Certifique-se de que o usuário do processo do IIS possui permissões de **Escrita** na pasta `App_Data` para o funcionamento do log de erros e persistência de programas.

3.  **Restaurar Dependências:**
    *   As referências do projeto estão configuradas manualmente para compatibilidade com .NET 4.0.

4.  **Executar:**
    *   Abra o arquivo `.sln` no Visual Studio, defina o projeto `TesteBenerWeb` como inicial e pressione **F5**

5.  ** A senha do token se encontra no arquivo Web.Config para testes.

## 📝 Funcionalidades Principais
*   **Aquecimento Padrão:** Início rápido com incremento de 30 segundos.
*   **Programas Customizados:** Cadastro, edição e exclusão de programas com caracteres identificadores únicos.
*   **Observabilidade:** Log de erros do backend.

