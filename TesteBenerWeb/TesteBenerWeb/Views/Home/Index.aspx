<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Interface de Micro-ondas
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="modal fade" id="modalAutenticacao" tabindex="-1" role="dialog" data-backdrop="static">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        Autenticação Obrigatória</h5>
                </div>
                <div class="modal-body">
                    <p>
                        Por favor, insira o Token Bearer para habilitar a interface do Micro-ondas.</p>
                    <div class="form-group">
                        <label>
                            Token:</label>
                        <input type="password" id="tokenInput" class="form-control" placeholder="Bearer token...">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary btn-block" onclick="salvarConfiguracoes()">
                        Entrar e Validar</button>
                </div>
            </div>
        </div>
    </div>
    <div id="barraStatus" class="status-bar" style="background-color: #000; color: #fff;
        padding: 10px; display: flex; justify-content: space-between; align-items: center;">
        <div>
            <span id="apiStatusLabel">Status do Sistema: ● Verificando...</span>
        </div>
        <button type="button" class="btn btn-warning btn-sm" data-toggle="modal" data-target="#modalAutenticacao">
            <i class="fa fa-key"></i>Autenticar
        </button>
    </div>
    <div class="microondas-container">
        <div class="display-container">
            Tempo:
            <input type="text" id="tempo" name="tempo" placeholder="00:00" />
            Potência:
            <input type="text" id="potencia" name="potencia" value="10" />
        </div>
        <div class="teclado-grid">
            <% for (int i = 1; i <= 9; i++)
               { %>
            <button type="button" class="btn-num" onclick="addNumero(<%= i %>)">
                <%= i %></button>
            <% } %>
            <button type="button" class="btn-num" onclick="limpar()">
                C</button>
            <button type="button" class="btn-num" onclick="addNumero(0)">
                0</button>
        </div>
        <div class="acoes-container">
            <button type="button" id="btnIniciar" class="btn-iniciar" onclick="enviar()">
                INICIAR
            </button>
            <button type="button" id="btnPausaCancela" class="btn-pausa" onclick="pausarOuCancelar()">
                PAUSA / CANCELA
            </button>
        </div>
        <div class="programas-pre-definidos">
            <h3>
                Programas de Aquecimento</h3>
            <!-- Botões fixos (Padrão) -->
            <button type="button" class="btn-pre" onclick="selecionarPrograma('pipoca')">
                Pipoca</button>
            <button type="button" class="btn-pre" onclick="selecionarPrograma('leite')">
                Leite</button>
            <button type="button" class="btn-pre" onclick="selecionarPrograma('Carne de boi')">
                Carnes</button>
            <button type="button" class="btn-pre" onclick="selecionarPrograma('frango')">
                Frango</button>
            <button type="button" class="btn-pre" onclick="selecionarPrograma('feijão')">
                Feijão</button>
            <hr class="divisor-programas" />
            <!-- Onde os novos botões entrarão via JavaScript -->
            <div id="containerBotoesCustomizados">
            </div>
            <hr class="divisor-programas" />
            <div class="footer-novo-programa">
                <button type="button" class="btn-pre" onclick="abrirModal()">
                    + Novo Programa
                </button>
            </div>
        </div>
    </div>
    <div id="statusAquecimento" style="margin-top: 20px; font-family: monospace; color: #0f0;
        background: #000; padding: 10px;">
    </div>
    <div id="modalCadastro" class="modal">
        <div class="modal-content">
            <h3>
                Novo Programa</h3>
            <hr />
            <div class="form-group">
                <label>
                    Nome do Programa*</label>
                <input type="text" id="cadNome" class="form-control" placeholder="Ex: Macarrão ao molho" />
            </div>
            <div class="form-group">
                <label>
                    Alimento*</label>
                <input type="text" id="cadAlimento" class="form-control" placeholder="Ex: Macarrão" />
            </div>
            <div style="display: flex; gap: 10px;">
                <div class="form-group" style="flex: 1;">
                    <label>
                        Tempo (seg)*</label>
                    <input type="number" id="cadTempo" class="form-control" />
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>
                        Potência*</label>
                    <input type="number" id="cadPotencia" class="form-control" required min="1" max="10"
                        value="10" />
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>
                        Caractere*</label>
                    <input type="text" id="cadCaractere" class="form-control" required maxlength="1"
                        placeholder="#" />
                </div>
            </div>
            <div class="form-group">
                <label>
                    Instruções de Uso</label>
                <input type="text" id="cadInstrucao" class="form-control" placeholder="Instruções opcionais..." />
            </div>
            <hr />
            <h4>
                Meus Programas Salvos</h4>
            <div style="max-height: 200px; overflow-y: auto; margin-bottom: 20px;">
                <table class="table-grid" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="background: #eee; text-align: left;">
                            <th style="padding: 8px;">
                                Nome
                            </th>
                            <th style="padding: 8px;">
                                Tempo
                            </th>
                            <th style="padding: 8px; text-align: center;">
                                Ações
                            </th>
                        </tr>
                    </thead>
                    <tbody id="corpoGridProgramas">
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="fecharModal()">
                    Cancelar</button>
                <button type="button" class="btn-save" onclick="salvarNovoPrograma()">
                    Salvar Programa</button>
            </div>
        </div>
    </div>

<script type = "text/javascript">
var estaAquecendo = false;
var ehpreprograma = false;
var ehCustomizado = false;
var estaPausado = false;
var segundosRestantes = 0;
var potenciaAtual = 10;
var intervalId;
var programasPreDefinidos = JSON.parse('<%= ViewData["ProgramasJson"] %>');
var programasCustomizados = JSON.parse('<%= ViewData["ProgramasJsonCustomizados"] %>');
var caractereAquecimento = ".";
var nomeOriginalEdicao = null;
let token = localStorage.getItem('microondas_auth_token') || "";

$(document).ready(function() {
    $('#modalAutenticacao').modal({
        backdrop: 'static',
        keyboard: false
    });

    $('#modalAutenticacao').modal('show');

    if (token) {
        $('#tokenInput').val(token);
    }
});


document.getElementById('tempo').onfocus = function() {
    campoAtivo = this;
};
document.getElementById('potencia').onfocus = function() {
    campoAtivo = this;
};

document.addEventListener('DOMContentLoaded', carregarBotoesCustomizados);

function addNumero(num) {
    campoAtivo.value += num;
}

function limpar() {
    document.getElementById('tempo').value = "";
    document.getElementById('potencia').value = "10";
    document.getElementById('statusAquecimento').innerHTML = "";
    estaAquecendo = false;
    ehpreprograma = false;
    ehCustomizado = false;
}

function enviar() {

    if (estaPausado) {
        estaPausado = false;
        estaAquecendo = true;
        iniciarCronometro();
        return;
    }

    var campoTempo = document.getElementById('tempo');
    var campoPotencia = document.getElementById('potencia');


    var t = campoTempo.value.replace(/\D/g, '');
    var p = campoPotencia.value;

    $.ajax({
        url: '<%= Url.Action("Iniciar", "Home") %>',
        type: 'POST',
        headers: {
            "Authorization": "Bearer " + token
        },
        data: {
            tempo: t,
            potencia: p,
            jaEstaAquecendo: estaAquecendo,
            preprograma: ehpreprograma,
            ehCustomizado: ehCustomizado
        },
        success: function(data) {
            if (data.Sucesso) {
                segundosRestantes = parseInt(data.SegundosTotais);
                potenciaAtual = parseInt(data.PotenciaUtilizada);
                campoPotencia.value = data.PotenciaUtilizada;
                campoTempo.value = data.TempoFormatado;
                document.getElementById('tempo').value = formatarTempo(segundosRestantes);
                document.getElementById('statusAquecimento').innerHTML = "";
                estaAquecendo = true;
                setPainelBloqueado(true);
                iniciarCronometro();
                if (ehpreprograma) document.getElementById('btnIniciar').disabled = true;
            } else {
                alert(data.Mensagem);
                ehpreprograma = false;
                document.getElementById('btnIniciar').disabled = false;
            }
        }
    });
}

function iniciarCronometro() {

    clearInterval(intervalId);
    intervalId = setInterval(function() {
        if (segundosRestantes > 0 && !estaPausado) {
            segundosRestantes--;
            var progresso = caractereAquecimento.repeat(potenciaAtual) + " ";
            document.getElementById('statusAquecimento').innerHTML += progresso;
            document.getElementById('tempo').value = formatarTempo(segundosRestantes);
        } else if (segundosRestantes <= 0) {
            clearInterval(intervalId);

            setTimeout(function() {
                finalizar();
            }, 1);
        }
    }, 1000);
}

function pausarOuCancelar() {

    if (estaAquecendo && !estaPausado) {
        estaPausado = true;
        document.getElementById('statusAquecimento').innerHTML += " Aquecimento pausado. ";
        document.getElementById('btnIniciar').disabled = false;
    } else if (estaPausado) {
        cancelarLimparTudo();
    } else {
        limparCampos();
    }
}

function cancelarLimparTudo() {

    clearInterval(intervalId);
    estaAquecendo = false;
    estaPausado = false;
    document.getElementById('statusAquecimento').innerHTML = "";
    document.getElementById('tempo').value = "";
    document.getElementById('potencia').value = "10";
    setPainelBloqueado(false);
    ehpreprograma = false;
    ehCustomizado = false;
    Cancelar();
}



function finalizar() {

    clearInterval(intervalId);
    estaAquecendo = false;
    estaPausado = false;
    document.getElementById('statusAquecimento').innerHTML += " Aquecimento concluído";
    document.getElementById('tempo').value = "";
    setPainelBloqueado(false);
    document.getElementById('btnIniciar').disabled = false;
    alert("Aquecimento Concluido!");
}

function limparCampos() {

    clearInterval(intervalId);
    estaAquecendo = false;
    estaPausado = false;
    segundosRestantes = 0;
    document.getElementById('tempo').value = "";
    document.getElementById('potencia').value = "10";
    document.getElementById('statusAquecimento').innerHTML = "";
    setPainelBloqueado(false);
    ehpreprograma = false;
    ehCustomizado = false;
    document.getElementById('btnIniciar').disabled = false;
}


function setPainelBloqueado(status) {

    document.getElementById('tempo').disabled = status;
    document.getElementById('potencia').disabled = status;

    var botoes = document.querySelectorAll('.btn-num');
    for (var i = 0; i < botoes.length; i++) {
        botoes[i].disabled = status;
    }

    var botoes2 = document.querySelectorAll('.btn-pre');
    for (var p = 0; p < botoes2.length; p++) {
        botoes2[p].disabled = status;
    }
}


function formatarTempo(segundos) {
    var min = Math.floor(segundos / 60);
    var seg = segundos % 60;

    var segFormatado = seg < 10 ? "0" + seg : seg;

    return min + ":" + segFormatado;
}



function selecionarPrograma(nome) {
    var prog = null;

    $.each(programasPreDefinidos, function(i, item) {
        if (item.Nome.toLowerCase() === nome.toLowerCase()) {
            prog = item;
            return false;
        }
    });

    if (prog) {
        document.getElementById('tempo').value = formatarTempo(prog.Tempo); //Tempo em minutos
        document.getElementById('potencia').value = prog.Potencia;

        document.getElementById('tempo').readOnly = true;
        document.getElementById('potencia').readOnly = true;

        caractereAquecimento = prog.Caractere;

        alert("Instruções: " + prog.Instrucoes);
        setPainelBloqueado(true);
        document.getElementById('tempo').disabled = status;
        ehpreprograma = true;
    } else {
        console.error("Programa não encontrado: " + nome);
    }
}

function abrirModal() {


    nomeOriginalEdicao = null;
    document.querySelector('#modalCadastro h3').innerText = "Novo Programa";

    document.getElementById('cadNome').value = "";
    document.getElementById('cadAlimento').value = "";
    document.getElementById('cadTempo').value = "";
    document.getElementById('cadPotencia').value = "10";
    document.getElementById('cadCaractere').value = "";
    document.getElementById('cadInstrucao').value = "";

    document.getElementById('modalCadastro').style.display = 'block';
    atualizarGrid();
}



function fecharModal() {

    document.getElementById('modalCadastro').style.display = 'none';
}

function salvarNovoPrograma() {

    const nome = document.getElementById('cadNome');
    const alimento = document.getElementById('cadAlimento');
    const tempo = document.getElementById('cadTempo');
    const potencia = document.getElementById('cadPotencia');
    const caractere = document.getElementById('cadCaractere');

    const campos = [nome, alimento, tempo, potencia, caractere];
    let erro = false;

    campos.forEach(campo => {
        if (campo.value.trim() === "") {
            campo.style.borderColor = "red";
            erro = true;
        } else {
            campo.style.borderColor = "#ccc";
        }
    });

    if (erro) {
        alert("Por favor, preencha todos os campos obrigatórios (*).");
        return;
    }

    const tempoVal = parseInt(tempo.value);
    const potenciaVal = parseInt(potencia.value);


    if (potenciaVal < 1 || potenciaVal > 10) {
        alert("A potência deve ser entre 1 e 10.");
        potencia.focus();
        return;
    }

    enviarDadosParaServidor(
        nome.value,
        alimento.value,
        tempoVal,
        potenciaVal,
        caractere.value,
        document.getElementById('cadInstrucao').value
    );
}

function renderizarBotoes() {
    var container = document.getElementById('containerBotoes');
    programasTotais.forEach(p => {
        var btn = document.createElement('button');
        btn.innerText = p.Nome;
        btn.onclick = () => selecionarPrograma(p.Nome);

        if (p.EhCustomizado) {
            btn.style.fontStyle = 'italic';
        }

        container.appendChild(btn);
    });
}


function enviarDadosParaServidor() {

    var programaInput = {
        Nome: document.getElementById('cadNome').value,
        Alimento: document.getElementById('cadAlimento').value,
        Tempo: parseInt(document.getElementById('cadTempo').value),
        Potencia: parseInt(document.getElementById('cadPotencia').value),
        Caractere: document.getElementById('cadCaractere').value,
        Instrucoes: document.getElementById('cadInstrucao').value
    };

    var url = '';
    var dadosJson = '';

    if (nomeOriginalEdicao) {

        url = '/Home/EditarPrograma';

        dadosJson = JSON.stringify({
            nomeOriginal: nomeOriginalEdicao,
            programa: programaInput
        });
    } else {

        url = '/Home/SalvarPrograma';

        dadosJson = JSON.stringify(programaInput);
    }

    $.ajax({
        url: url,
        type: 'POST',
        headers: {
            "Authorization": "Bearer " + token
        },
        contentType: 'application/json; charset=utf-8',
        data: dadosJson,
        success: function(res) {
            if (res.success) {
                alert("Operação realizada com sucesso!");
                location.reload();
            } else {
                alert(res.message);
            }
        },
        error: function() {
            alert("Erro ao conectar com o servidor.");
        }
    });
}


function carregarBotoesCustomizados() {
    const container = document.getElementById('containerBotoesCustomizados');
    if (!container) return;

    container.innerHTML = "";

    fetch('/Home/ListarProgramasCustomizados', {
            method: 'GET',
            headers: {
                'Authorization': 'Bearer ' + token,
                'Content-Type': 'application/json'
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Falha na autenticação ou erro no servidor: ' + response.status);
            }
            return response.json();
        })
        .then(programas => {
            programas.forEach(prog => {
                const btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'btn-pre btn-custom-novo';

                btn.style.fontStyle = 'italic';
                btn.style.fontWeight = 'normal';
                btn.innerHTML = prog.Nome;

                btn.onclick = () => {
                    document.getElementById('tempo').value = prog.Tempo;
                    document.getElementById('potencia').value = prog.Potencia;

                    caractereAtual = prog.Caractere;
                    ehCustomizado = true;
                    selecionarPrograma(prog.Nome);
                };

                container.appendChild(btn);
            });
        })
        .catch(err => console.error("Erro ao listar programas:", err));
}




function atualizarGrid() {
    var corpo = document.getElementById('corpoGridProgramas');
    if (!corpo) return;

    corpo.innerHTML = '';


    programasCustomizados.forEach(function(p) {
        var tr = document.createElement('tr');

        var acoes = p.EhCustomizado ?
            '<button type="button" class="btn-edit" onclick="editarPrograma(\'' + p.Caractere + '\')">✏️</button>' +
            '<button type="button" class="btn-delete" onclick="excluirPrograma(\'' + p.Nome + '\', \'' + p.Caractere + '\')">🗑️</button>' :
            '<span style="color: #999; font-size: 11px;">Padrão (Bloqueado)</span>';

        tr.innerHTML =
            '<td>' + (p.EhCustomizado ? '<i>' + p.Nome + '</i>' : p.Nome) + '</td>' +
            '<td>' + p.Tempo + 's</td>' +
            '<td style="text-align: center;">' + acoes + '</td>';

        corpo.appendChild(tr);
    });
}

function excluirPrograma(nome, caractere) {
    if (confirm("Tem certeza que deseja excluir o programa '" + nome + "'?")) {
        $.ajax({
            url: '/Home/ExcluirPrograma',
            type: 'POST',
            headers: {
                "Authorization": "Bearer " + token
            },
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify({
                nome: nome,
                caractere: caractere
            }),
            success: function(res) {
                if (res.success) {
                    alert("Programa removido!");
                    location.reload();
                } else {
                    alert(res.message);
                }
            },
            error: function() {
                alert("Erro ao conectar com o servidor.");
            }
        });
    }
}


function Cancelar() {
    $.ajax({
        url: '/Home/Cancelar',
        type: 'POST',
        headers: {
            "Authorization": "Bearer " + token
        },
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify({}),
        success: function(res) {
            if (res.success) {
                alert("Operação Cancelada!");
            } else {
                alert(res.message);
            }
        },
        error: function() {
            alert("Erro ao conectar com o servidor.");
        }
    });
}


function editarPrograma(caractere) {

    var programa = programasCustomizados.find(function(p) {
        return p.Caractere === caractere;
    });
    if (programa) {

        document.getElementById('cadNome').value = programa.Nome;
        document.getElementById('cadAlimento').value = programa.Alimento;
        document.getElementById('cadTempo').value = programa.Tempo;
        document.getElementById('cadPotencia').value = programa.Potencia;
        document.getElementById('cadCaractere').value = programa.Caractere;
        document.getElementById('cadInstrucao').value = programa.Instrucoes;

        nomeOriginalEdicao = programa.Nome;

        document.getElementById('cadNome').readOnly = true;
        document.getElementById('cadCaractere').readOnly = true;

        document.getElementById('modalCadastro').style.display = 'block';
    }
}


function verificarStatusAPI() {

    const tokenAtual = token;

    $.ajax({
        url: '/Home/ValidarConexao',
        type: 'POST',
        headers: {
            "Authorization": "Bearer " + tokenAtual
        },
        success: function(res) {
            // Se o C# retornar um objeto com Success = true
            if (res.Success || res.success) {
                atualizarStatusUI(true, "API Online");
            } else {
                atualizarStatusUI(false, "Token Inválido");
            }
        },
        error: function() {
            atualizarStatusUI(false, "Erro de Conexão (401/500)");
        }
    });
}


function atualizarStatusUI(online, mensagem) {
    const label = document.getElementById('apiStatusLabel');
    if (!label) return;

    if (online) {
        label.innerHTML = `Status do Sistema: <span style="color: #00ff00;">● ${mensagem}</span>`;
        apiAutenticada = true;
        setInterfaceLock(false);
    } else {
        label.innerHTML = `Status do Sistema: <span style="color: #ff4444;">● ${mensagem}</span>`;
        apiAutenticada = false;
        setInterfaceLock(true);
    }
}

function setInterfaceLock(locked) {

    const elementos = document.querySelectorAll('button, input');

    elementos.forEach(el => {

        const estaNaModal = el.closest('#modalAutenticacao');

        const eBotaoAbrirModal = el.getAttribute('data-target') === '#modalAutenticacao' ||
            el.innerText.trim() === 'Autenticar';

        if (estaNaModal || eBotaoAbrirModal) {
            el.disabled = false;
        } else {
            el.disabled = locked;
        }
    });


    const painel = document.querySelector('.microwave-card') || document.body;
    if (painel && !painel.contains(document.activeElement)) {
        painel.style.opacity = locked ? "0.6" : "1";

        if (painel.classList.contains('microwave-card')) {
            painel.style.pointerEvents = locked ? "none" : "auto";
        }
    }
}


async function salvarConfiguracoes() {
    const input = document.getElementById('tokenInput');
    const novoToken = input.value;

    if (novoToken.trim() === "") {
        alert("O token é obrigatório.");
        return;
    }

    const tokenHash = await gerarHashSHA256(novoToken);
    localStorage.setItem('microondas_auth_token_hash', tokenHash);

    token = novoToken;

    localStorage.setItem('microondas_auth_token', token);

    $('#modalAutenticacao').modal('hide');
    verificarStatusAPI();
    carregarBotoesCustomizados();
}


$(document).ready(function() {
    setInterfaceLock(true);
    verificarStatusAPI();
});


window.onload = function() {
    if (typeof $().modal === 'function') {
        $('#modalAutenticacao').modal('show');
    } else {
        console.error("Bootstrap não carregado corretamente.");
    }
};


async function gerarHashSHA256(texto) {
        const msgUint8 = new TextEncoder().encode(texto);
        const hashBuffer = await crypto.subtle.digest('SHA-256', msgUint8);
        const hashArray = Array.from(new Uint8Array(hashBuffer));
        const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
        return hashHex;
    }

</script>
</asp:Content>
