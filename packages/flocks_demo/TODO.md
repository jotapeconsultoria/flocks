# Pendências da demo

## A Roboto que o runtime do Flutter busca

O CanvasKit registra a **Roboto como fonte padrão do engine** na inicialização e
a baixa de `fonts.gstatic.com` — uma requisição de ~15 KB, a cada carregamento,
para um servidor do Google. A demo não usa Roboto em lugar nenhum: toda a escala
tipográfica é Poppins ou Space Grotesk, empacotadas no `flocks`.

Isso é do bootstrap JavaScript, antes de qualquer Dart nosso: nenhum teste em VM
o enxerga, e foi descoberto lendo a aba de rede de um navegador de verdade. A
irmã dele — o CanvasKit vindo do `www.gstatic.com` — já foi corrigida com
`--no-web-resources-cdn` no CI, com gate estático em
`test/architecture_test.dart`.

**Por que ainda não foi corrigido:** o caminho é `fontFallbackBaseUrl` na
configuração do loader, apontando para uma cópia das fontes de fallback servida
por nós. Isso significa vendorar a Roboto (Apache 2.0, redistribuível) e
reproduzir a estrutura de diretórios que o engine espera — sem contrato
documentado e sujeito a mudar entre versões do Flutter.

**O que isso não é:** não é o logo saindo da aba. É um download de fonte, não um
upload, e o gate de rede continua provando que nenhum byte do logo vai a lugar
nenhum. Por causa disso, a frase "esta página não contacta host nenhum" não está
escrita em lugar algum da demo — nem na tela, nem no README.

---

# Analytics — documentado, não implementado

O projeto PostHog ainda não existe, então **nada aqui está no código**. Este
arquivo fixa os nomes agora para que a instrumentação, quando chegar, não invente
um vocabulário novo — e para que a regra de privacidade abaixo entre junto com o
primeiro evento, e não depois do primeiro vazamento.

| Evento | Quando | Propriedades |
| --- | --- | --- |
| `demo opened` | a demo monta | os seis parâmetros do contrato de URL, como vieram |
| `demo brand changed` | a semente de cor muda | `seed` (hex) |
| `demo logo uploaded` | um logo é aceito | **só o fato.** Ver abaixo |
| `demo axis changed` | estilo, forma ou tipografia mudam | `axis`, `value` |
| `demo screen changed` | troca de tela | `screen` |
| `demo config exported` | o snippet Dart é copiado | os seis parâmetros |
| `demo link shared` | o link compartilhável é copiado | os seis parâmetros |

## A regra que não se negocia

`demo logo uploaded` registra **o fato, e nada mais**. Nunca a imagem, nunca os
bytes, nunca o nome do arquivo, nunca o tamanho, nunca o tipo MIME.

Isso não é excesso de zelo — é a mesma fronteira que
`test/no_network_test.dart` protege. A demo diz ao visitante, na tela, que o
logo dele não sai da aba. Um evento de analytics carregando `filename:
"logo-final-v3-aprovado.png"` desmente essa frase e sai por um caminho que o
gate de rede não vê, porque o cliente de analytics seria uma dependência
legítima com permissão para falar com o mundo.

Repare que o código já ajuda: o nome do arquivo **nunca chega ao estado da
demo** (`browser_web.dart` lê os bytes e descarta o resto, e o formato sai da
assinatura binária, não da extensão). Quem for instrumentar não vai encontrar o
nome do arquivo para registrar por engano — vai ter de ir buscá-lo de propósito.

## Ao implementar

Estender `test/architecture_test.dart` com a lista de dependências permitidas: um
cliente de analytics é, por definição, um caminho de rede, então o teste que hoje
exige ZERO requisições precisará distinguir o destino de telemetria de todo o
resto — e essa distinção é exatamente onde a fronteira do logo se perderia se
ninguém estivesse olhando.
